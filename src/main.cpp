#include "linear_stage/linear_stage.hpp"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char** argv) {
    auto app = QApplication(argc, argv);
    auto engine = QQmlApplicationEngine();

    auto stage = new linear_stage::LinearStage(&engine);
    stage->set_waypoints({
        linear_stage::make_waypoint("Waypoint 1", 1.0),
        linear_stage::make_waypoint("Waypoint 2", 2.0),
        linear_stage::make_waypoint("Waypoint 3", 3.0),
        linear_stage::make_waypoint("Waypoint 4", 4.0),
    });
    engine.rootContext()->setContextProperty("linear_stage", stage);

    engine.load(QUrl(QString("qrc:/Main.qml")));
    return app.exec();
}
