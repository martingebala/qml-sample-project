// This is using the Qt 5.13, but feel free to use different versions if it's more convenient
import QtQuick 2.13
import QtQuick.Controls 2.13

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "Linear Stage"

   Text {
       text: JSON.stringify(linear_stage.status, null, 2)
       Component.onCompleted: {
           linear_stage.start_moving_to(100, 10);
           linear_stage.set_waypoints([
                  {name: "QML Waypoint 1", position: 10.0 },
                  {name: "QML Waypoint 2", position: 20.0 },
           ]);
       }
    }
}
