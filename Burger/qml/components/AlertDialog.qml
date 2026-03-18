import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../theme"

Dialog {
    id: dialog
    anchors.centerIn: parent
    modal: true
    padding: 20
    
    property string dialogType: "warning"
    property string titleText: "Título"
    property string messageText: "Mensaje"
    property string buttonText: "Aceptar"

    property color typeColor: {
        if (dialogType === "warning") return Theme.buttonDanger
        if (dialogType === "success") return Theme.accent
        return Theme.primary
    }

    property string typeIcon: {
        if (dialogType === "warning") return "⚠️"
        if (dialogType === "success") return "✅"
        return "ℹ️"
    }

    background: Rectangle {
        color: Theme.surface
        radius: Theme.radius
        border.width: 2
        border.color: dialog.typeColor
    }

    signal acceptedSignal()

    enter: Transition {
            NumberAnimation {
                property: "scale"
                from: 0.5
                to: 1.0
                duration: 180
                easing.type: Easing.OutBack
            }
        }

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 16

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12

            Text {
                text: dialog.titleText
                font.pixelSize: 18
                font.bold: true
                color: Theme.accent
            }

            Text {
                text: dialog.typeIcon
                font.pixelSize: 32
            }
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            text: dialog.messageText
            font.pixelSize: 14
            color: "white"
            wrapMode: Text.WordWrap
            Layout.preferredWidth: 280
        }

        AppButton {
            text: dialog.buttonText
            Layout.alignment: Qt.AlignHCenter
            baseColor: dialog.typeColor

            onClicked: {
                dialog.acceptedSignal()
                dialog.close()
            }
        }
    }
}