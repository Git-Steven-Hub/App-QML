import QtQuick
import QtQuick.Controls
import "../theme"

Button {
    id: root
    property color baseColor: Theme.secondary

    contentItem: Text {
        text: root.text
        font: root.font
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    
    background: Rectangle {
        color: root.hovered  ? Qt.darker(root.baseColor, 1.2) :
                root.pressed ? Qt.lighter(root.baseColor, 1.2) : 
                                root.baseColor

        radius: Theme.radiusLarge

        border.color: root.hovered ? root.baseColor : "transparent"
        border.width: root.hovered ? 2 : 0

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 120 }
        }
    }
    scale: pressed ? 0.97 : hovered ? 1.03 : 1.0
    Behavior on scale { 
        NumberAnimation { duration: 100 }
    }
}