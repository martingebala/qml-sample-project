import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

ApplicationWindow {
    id: appWindow
    visible: true
    width: 640
    height: 600

    title: "Linear Stage"
    color: Theme.backgroundColor
    locale: Qt.locale("pl_PL")

    property color accentColor: Theme.accentColor

    property alias speed: speedControl.value
    property real stagePostition: linear_stage.status.position
    readonly property bool busy: stagePostition !== linear_stage.status.target
    readonly property real currentAccuracy: getAccuracyFromIndex(bar.currentIndex)

    header: Measure {
        position: stagePostition
        onReleased: moveStage(value)
    }

    GridLayout {
        id: grid
        columnSpacing: Theme.spacing.medium
        rowSpacing: columnSpacing
        columns: 2
        anchors {
            margins: Theme.spacing.large
            left: parent.left
            right: parent.right
        }

        SettingsPane {
            title: qsTr("Current position")
            TextField {
                Layout.alignment: Qt.AlignHCenter
                text: linear_stage.status.position.toFixed(2).toLocaleString(appWindow.locale)
                enabled: !busy

                onActiveFocusChanged: selectAll()
                validator: DoubleValidator {
                    bottom: 0.0
                    top: 100.0
                    decimals: 2
                    locale: appWindow.locale.name
                }

                onAccepted: {
                    grid.forceActiveFocus()
                    moveStage(Number.fromLocaleString(appWindow.locale, text))
                }
            }
        }

        SettingsPane {
            title: qsTr("Accuracy")
            TabBar {
                id: bar
                Layout.alignment: Qt.AlignHCenter
                Repeater {
                    model: 4 // 4 levels of accuracy
                    TabButton {
                        text: getAccuracyFromIndex(modelData)
                        width: implicitWidth
                    }
                }
            }
        }

        SettingsPane {
            title: qsTr("Stepper")
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacing.small
                Button {
                    text: "- " + currentAccuracy
                    onClicked: moveStage(stagePostition - currentAccuracy)
                    enabled: !busy && stagePostition - currentAccuracy >= 0
                }
                Button {
                    text: "+ " + currentAccuracy
                    onClicked: moveStage(stagePostition + currentAccuracy)
                    enabled: !busy && stagePostition + currentAccuracy <= 100
                }
            }
        }

        SettingsPane {
            title: "Movement speed"
            SpinBox {
                id: speedControl
                Layout.alignment: Qt.AlignHCenter
                value: 20
                from: 1
                to: 100
            }
        }

        SettingsPane {
            title: "Presets"
            Layout.columnSpan: grid.columns
            Flow {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Theme.spacing.small
                Repeater {
                    model: linear_stage.status.waypoints
                    delegate: Button {
                        text: modelData.name
                        font.pixelSize: 12
                        enabled: !busy
                        onClicked: moveStage(modelData.position)
                    }
                }
            }

            Row {
                spacing: Theme.spacing.small
                TextField {
                    id: waypointName
                }
                Button {
                    text: "Add new..."
                    onClicked: {
                        linear_stage.add_waypoint(waypointName.text, stagePostition)
                        waypointName.clear()
                    }
                    enabled: !busy && waypointName.text
                }
            }
        }
    }

    function getAccuracyFromIndex(index) {
        // return one step by accuracy index (0.01,0.1 etc.)
        return 0.01 * Math.pow(10, index)
    }

    function moveStage(value) {
        console.log("Start moving to " + value + " with speed " + speed)
        linear_stage.start_moving_to(value, speed);
    }
}
