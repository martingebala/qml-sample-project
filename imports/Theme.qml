pragma Singleton

import QtQuick 2.13

QtObject {
    id: root

    readonly property color accentColor: "#2196F3"
    readonly property color backgroundColor: "#F8F8F8"

    readonly property QtObject font: QtObject {
        readonly property string family: "Roboto"
        readonly property int small: 16
        readonly property int medium: 18
        readonly property int large: 20
    }
    readonly property QtObject spacing: QtObject {
        readonly property int small: 5
        readonly property int medium: 10
        readonly property int large: 20
    }
    readonly property QtObject measure: QtObject {
        readonly property int height: 80
        readonly property int marks: 11
        readonly property int resolution: 6
        readonly property int handleSize: 30
        readonly property int indicatorSize: 10
    }
}
