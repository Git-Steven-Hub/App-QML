import QtQuick
import QtQuick.Controls
import "../theme"

Button {
    id: root

    property bool active: false
    property string iconSource: ""

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
            ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.18)
            : root.hovered
                ? Qt.lighter(Theme.surfaceAlt, 1.12)
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
        Behavior on radius {
            NumberAnimation {
                duration: 120
            }
        }
    }

    Rectangle {
        visible: root.active
        width: 4
        radius: 2
        color: Theme.primary

        anchors {
            left: parent.left
            leftMargin: 4
            verticalCenter: parent.verticalCenter
        }

        height: parent.height * 0.6
    }
    Rectangle {
        anchors.bottom: parent.bottom
        height: 40
        width: parent.width
        gradient: Gradient {
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 1; color: Theme.surface }
        }
    }

    contentItem: Row {
        spacing: 12
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        Image {
            source: root.iconSource
            width: 18
            height: 18
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            opacity: root.active ? 1 : 0.7
        }

        Text {
            text: root.text
            font: root.font
            color: root.active ? "white" : "#DDDDDD"
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
        }
    }
}