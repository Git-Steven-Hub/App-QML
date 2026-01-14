import QtQuick
import QtQuick.Controls
import "../theme"

Button {
    id: root

    property color baseColor: Theme.primary
    property bool loading: false

    enabled: !loading

    transform: Scale {
        id: pressScale
        origin.x: root.width / 2
        origin.y: root.height / 2
        xScale: root.down && !loading ? 0.97 : 1
        yScale: root.down && !loading ? 0.97 : 1
        
        Behavior on xScale {
            NumberAnimation { duration: 80 }
        }

        Behavior on yScale {
            NumberAnimation { duration: 80 }
        }
    }

    background: Rectangle {
        radius: Theme.radius
        color: loading
            ? Qt.darker(baseColor, 1.3)
            : root.down
                ? Qt.darker(baseColor, 1.2)
                : root.hovered
                    ? Qt.lighter(baseColor, 1.2)
                    : baseColor

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }
}