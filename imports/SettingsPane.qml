import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// Reusable pane for use in grid
// provides a visible pane title
Pane {
    id: root
    property string title
    default property alias items: content.data

    horizontalPadding: Theme.spacing.large
    verticalPadding: Theme.spacing.large

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: 240

    background: Rectangle {
        radius: root.horizontalPadding
        color: "white"
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        Label {
            Layout.fillWidth: true
            Layout.bottomMargin: Theme.spacing.large

            visible: text
            text: root.title
            font.pixelSize: Theme.font.small
            elide: Qt.ElideRight
        }
    }
}
