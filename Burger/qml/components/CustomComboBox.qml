import QtQuick
import QtQuick.Controls
import "../theme"

ComboBox {
    id: root

    width: 200
    height: 40

    //Botón principal
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        radius: Theme.radius
        color: root.down || root.popup.visible ? Theme.surface : Theme.background
        border.width: 1
        border.color: root.activeFocus ? Theme.primary : Theme.divider

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "white"
            opacity: root.hovered ? 0.07 : 0
        }
    }

    contentItem: Text {
        leftPadding: 12
        rightPadding: 36
        text: root.displayText
        font.pixelSize: 13
        color: "white"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    //Flechita
    indicator: Canvas {
        id: arrowCanvas
        x: root.width - width - 12
        y: (root.height - height) / 2
        width: 12
        height: 8

        Connections {
            target: root
            function onDownChanged() { arrowCanvas.requestPaint() }
            function onPopupChanged() { arrowCanvas.requestPaint() }
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.moveTo(0, 0)
            ctx.lineTo(width, 0)
            ctx.lineTo(width / 2, height)
            ctx.closePath()
            ctx.fillStyle = (root.down || root.popup.visible) ? Theme.primary : Theme.divider
            ctx.fill()
        }
    }

    //Contenido
    popup: Popup {
        y: root.height + 6
        width: root.width
        padding: 8
        height: Math.min(contentItem.implicitHeight + 16, 280)

        background: Rectangle {
            radius: Theme.radius
            color: Theme.background
            border.width: 1
            border.color: Theme.divider
        }

        contentItem: ListView {
            id: listView
            clip: true
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex
            spacing: 4

            ScrollIndicator.vertical: ScrollIndicator {}

            delegate: ItemDelegate {
                id: delegateItem
                width: ListView.view.width - 12
                height: 42
                padding: 0
                anchors.horizontalCenter: parent.horizontalCenter

                background: Rectangle {
                    color: delegateItem.highlighted ? Theme.primary :
                           delegateItem.hovered ? Qt.rgba(1, 1, 1, 0.12) : "transparent"
                    radius: Theme.radius * 0.6
                }

                contentItem: Text {
                    leftPadding: 16
                    rightPadding: 16
                    text: modelData ?? model.text ?? ""
                    color: delegateItem.highlighted ? "#FFFFFF" : "#FFFFFF"
                    font.pixelSize: 13
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    hoverEnabled: true
}