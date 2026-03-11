import QtQuick
import QtQuick.Controls
import "../theme"

CheckBox {
    id: root

    property color checkColor: Theme.checkBox

    indicator: Rectangle {
        x: root.leftPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        implicitWidth: 20
        implicitHeight: 20
        radius: Theme.radius
        color: "transparent"
        border.color: root.checked ? Theme.primary : Theme.textMuted
        border.width: 2

        Rectangle {
            width: 14
            height: 14
            radius: 7
            color: root.checkColor
            anchors.centerIn: parent
            scale: root.checked ? 1 : 0

            Behavior on scale {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.5
                }
            }
            
            ColorAnimation {
                duration: 150
            }
        }
    }

    contentItem: Text {
        x: root.indicator.width + 10
        y: root.topPadding + (root.availableHeight - height) / 2
        leftPadding: 35
        text: root.text
        color: root.checked ? Theme.primary : "white"
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        scale: root.checked ? 1.05 : 0.95

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
            }
        }
    }

    implicitHeight: 35
    spacing: 10
}