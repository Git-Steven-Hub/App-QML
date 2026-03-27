import QtQuick
import QtQuick.Controls
import "../theme"

Button {
    id: root

    property bool active: false
    property string iconText: ""

    hoverEnabled: true
    font.pixelSize: 13
    font.weight: Font.Medium
    implicitHeight: 40
    scale: root.active ? 0.97 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: 120
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    background: Rectangle {
        radius: 10

        color: root.active
            ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15)
            : root.hovered
                ? Qt.lighter(Theme.surfaceAlt, 1.15)
                : Theme.surfaceAlt

        border.color: root.active 
            ? Theme.primary 
            : root.hovered 
                ? Qt.rgba(1, 1, 1, 0.15) 
                : "transparent" 
        border.width: root.active 
            ? 1 
            : (root.hovered ? 1 : 0)

        Behavior on color {
            ColorAnimation { duration: 120 }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    Rectangle {
        visible: root.active
        width: 3
        radius: 2
        color: Theme.primary

        anchors {
            left: parent.left
            leftMargin: 4
            verticalCenter: parent.verticalCenter
        }

        height: parent.height * 0.5
    }

    contentItem: Row {
        spacing: 12
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 10

        Text {
            text: root.iconText
            font.pixelSize: 14
            opacity: root.active ? 1 : 0.75
        }

        Text {
            text: root.text
            font: root.font
            color: root.active ? "white" : "#DDDDDD"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}