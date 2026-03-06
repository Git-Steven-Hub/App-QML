import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import "../theme"

Button {
    id: root

    property color baseColor: Theme.buttonPrimary
    property color textColor: "white"
    property bool elevated: true

    font.pixelSize: 14
    font.weight: Font.Medium

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    contentItem: Text {
        text: root.text
        font: root.font
        color: root.enabled ? root.textColor : Theme.textMuted
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: Theme.radiusLarge

        color: !root.enabled
            ? Qt.darker(root.baseColor, 1.4)
            : root.pressed
                ? Qt.darker(root.baseColor, 1.3)
                : root.hovered
                    ? Qt.lighter(root.baseColor, 1.1)
                    : root.baseColor

        border.color: root.hovered ? Qt.lighter(root.baseColor, 1.4) : "transparent"
        border.width: root.hovered ? 1 : 0

        layer.enabled: root.elevated
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#66000000"
            shadowBlur: 12
            shadowVerticalOffset: 4
        }

        Behavior on color { 
            ColorAnimation { 
                duration: 150
            } 
        }
    }

    scale: pressed ? 0.97 : hovered ? 1.02 : 1.0

    Behavior on scale { 
        NumberAnimation { 
            duration: 90
        }
    }
}