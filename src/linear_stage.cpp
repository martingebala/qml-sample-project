#include "linear_stage/linear_stage.hpp"

#include <cmath>

namespace linear_stage {

using namespace std::chrono_literals;

QVariantMap make_waypoint(const QString& name, double position) {
    return {
        {QString("name"), QVariant::fromValue(name)},
        {QString("position"), QVariant::fromValue(position)},
    };
}

LinearStage::LinearStage(QObject* parent) : QObject(parent) {
    // We emulate the behavior of real hardware where we would poll the current position.
    // The exact value would vary but 20 milliseconds is a good representation of a real device.
    connect(&m_timer, &QTimer::timeout, this, &LinearStage::update);
    m_timer.start(20ms);
}

void LinearStage::start_moving_to(double position, double speed) {
    m_speed = speed;
    m_target = position;
}

void LinearStage::stop() { m_target = m_position; }

void LinearStage::set_waypoints(QVariantList waypoints) {
    m_waypoints = std::move(waypoints);
    Q_EMIT statusChanged();
}

void LinearStage::update() {
    const auto now = Clock::now();

    using namespace std::chrono;
    const auto dt = duration_cast<duration<double>>(now - m_last_update_time);
    m_last_update_time = now;

    if (m_position == m_target || dt == 0.0s) {
        return;
    }

    const auto delta = m_target - m_position;
    const auto step = m_speed * dt.count();
    if (std::abs(delta) < step) {
        m_position = m_target;
    } else {
        m_position += std::copysign(step, delta);
    }
    Q_EMIT statusChanged();
}

} // namespace linear_stage
