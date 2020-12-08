#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QTimer>
#include <QVariant>

#include <chrono>
#include <optional>

namespace linear_stage {

/// Waypoints are named positions
/// For simplicity we directly use a QVariantMap with two entries: name and position
QVariantMap make_waypoint(const QString& name, double position);

class LinearStage : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantMap status READ status NOTIFY statusChanged)

public:
    LinearStage(QObject* parent);

    QVariantMap status() const {
        return {
            {QString("position"), QVariant::fromValue(m_position)},
            {QString("waypoints"), m_waypoints},
            {QString("target"), QVariant::fromValue(m_target)}
        };
    }

Q_SIGNALS:
    // We usually use `snake_case` in our c++ code, but to keep in line with the default naming
    // scheme of QML properties we use `cameCase` here.
    void statusChanged();

public Q_SLOTS:
    // We use C++ naming style for slots to indicate we're calling into the backend from QML
    void start_moving_to(double position, double speed);
    void add_waypoint(const QString& name, double position);
    void stop();

    /// Waypoints is a QVariantList of Waypoints (see make_waypoint)
    void set_waypoints(QVariantList waypoints);

private:
    using Clock = std::chrono::steady_clock;
    using TimePoint = Clock::time_point;

    void update();

    QTimer m_timer;
    TimePoint m_last_update_time = Clock::now();
    double m_position = 0.0;
    double m_target = 0.0;
    double m_speed = 0.0;
    QVariantList m_waypoints;
};
} // namespace linear_stage
