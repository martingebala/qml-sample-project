import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// Measure is a visualisation of the linear stage,
// presents actual position and allows setting new
// target using slider
Control {
    id: root
    horizontalPadding: Theme.spacing.large
    verticalPadding: Theme.spacing.large
    implicitHeight: Theme.measure.height

    property int resolution: Theme.measure.resolution
    property int marks: Theme.measure.marks
    property real position: 0
    readonly property int dashes: resolution * (marks-1) + 1
    readonly property real target: linear_stage.status.target

    signal released(var value)

    Rectangle {
        // shows the actual stage position
        id: positionIndicator
        x: control.leftPadding + root.leftPadding + (control.availableWidth * root.position/100) - width / 2
        y: (root.height / 2) - (height / 2)
        width: Theme.measure.indicatorSize
        height: width
        radius: width / 2
        color: accentColor
    }

    Label {
        // show value while moving slider
        id: valueLabel
        x: control.leftPadding + root.leftPadding + (control.availableWidth * control.position) - width / 2
        text: (control.position * 100).toFixed(2)
        visible: control.pressed
    }

    contentItem: Slider {
        // allows setting the target stage position
        id: control
        from: 0
        to: 100
        value: target

        leftPadding: width / (dashes * 2)
        rightPadding: leftPadding
        topInset: height / 2

        handle: Rectangle {
            x: control.leftPadding + control.visualPosition * (control.availableWidth) - width/2
            y: (control.height / 2) - (height / 2)
            width: Theme.measure.handleSize
            height: width
            opacity: 0.3
            radius: width / 2
            color: accentColor
        }

        background: RowLayout {
            spacing: 0
            Repeater {
                model: dashes
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Rectangle {
                        readonly property bool isMark: !(index % resolution)
                        width: 1
                        height: parent.height * (isMark ? 1 : 0.5)
                        color: "gray"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        onPressedChanged: {
            if (!pressed) {
                root.released(value)
            }
        }
    }
}
