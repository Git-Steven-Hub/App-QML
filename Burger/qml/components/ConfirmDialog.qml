import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../theme"

Dialog {
    id: dialog
    anchors.centerIn: parent
    modal: true
    padding: 20
    visible: false

    background: Rectangle {
        color: Theme.surface
        radius: Theme.radius
        border.width: 2
        border.color: "white"
    }

    property string titleText: "Título"

    property var clientData: null

    property string clientName: ""
    property string clientPhone: ""
    property string paymentMethod: ""
    property real total: 0

    signal confirm()
    signal cancel()
    signal confirmWithData(var clientData)

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 12

        Text {
            text: dialog.titleText
            font.pixelSize: 18
            font.bold: true
            color: Theme.accent
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Cliente: " + dialog.clientName
            color: "white"
            font.pixelSize: 14
        }

        Text {
            text: "Teléfono: " + dialog.clientPhone
            color: "white"
            font.pixelSize: 14
        }

        Text {
            text: "Pago: " + dialog.paymentMethod
            color: "white"
            font.pixelSize: 14
        }

                Rectangle {
            height: 1
            Layout.fillWidth: true
            color: Qt.rgba(1, 1, 1, 0.2)
        }

        ListView {
            Layout.preferredHeight: 150
            Layout.fillWidth: true
            model: CartModel

            delegate: Text {
                text: notes && notes !== "Sin notas" ? Name + " x" + Quantity + " - $" + Price + " (Con nota)" : Name + " x" + Quantity + " - $" + Price
                color: "white"
                font.pixelSize: 12
            }
        }

        Text {
            text: "TOTAL: $" + dialog.total.toFixed(2)
            font.pixelSize: 18
            font.bold: true
            color: Theme.accent
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: Qt.rgba(1, 1, 1, 0.2)
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            AppButton {
                text: "Confirmar"
                baseColor: Theme.accent
                onClicked: {
                    dialog.confirmWithData(dialog.clientData)
                    dialog.close()
                }
            }

            AppButton {
                text: "Cancelar"
                baseColor: Theme.buttonDanger
                onClicked: {
                    dialog.cancel()
                    dialog.close()
                }
            }
        }
    }
}