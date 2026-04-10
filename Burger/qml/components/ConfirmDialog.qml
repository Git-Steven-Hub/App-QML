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
    property bool isDelivery: false
        property real deliveryFee: 0

    property real total: 0

    onClientDataChanged: {
        if (clientData) {
            clientName = clientData.name || ""
            clientPhone = clientData.phone || ""
            paymentMethod = clientData.method || ""
            isDelivery = clientData.isDelivery || false
            deliveryFee = clientData.deliveryFee || 0
            total = clientData.total || 0
        }
    }

    signal confirm()
    signal cancel()
    signal confirmWithData(var clientData)

    enter: Transition {
        NumberAnimation {
            property: "scale"
            from: 0.8
            to: 1.0
            duration: 180
            easing.type: Easing.OutBack
        }

        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 180
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 14

        Text {
            text: dialog.titleText
            font.pixelSize: 35
            font.bold: true
            color: Theme.accent
            Layout.alignment: Qt.AlignHCenter
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 20
            rowSpacing: 8

            Text {
                text: "Cliente:"
                color: Theme.textMuted
                font.pixelSize: 14
            }

            Text {
                text: dialog.clientName
                color: "white"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Text {
                text: "Teléfono:"
                color: Theme.textMuted
                font.pixelSize: 14
            }

            Text {
                text: dialog.clientPhone
                color: "white"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Text {
                text: "Pago:"
                color: Theme.textMuted
                font.pixelSize: 14
            }

            Text {
                text: dialog.paymentMethod
                color: "white"
                font.pixelSize: 14
                Layout.fillWidth: true
            }
            
            Text {
                text: "Entrega:"
                color: Theme.textMuted
                font.pixelSize: 14
            }

            Text {
                text: dialog.isDelivery ? "Delivery (+ $" + dialog.deliveryFee.toFixed(2) + ")" : "Retira en local"
                color: dialog.isDelivery ? Theme.success : "white"
                font.pixelSize: 14
                font.bold: dialog.isDelivery
                Layout.fillWidth: true
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: Qt.rgba(1, 1, 1, 0.2)
        }

        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 140
            Layout.maximumHeight: 220
            model: CartModel
            clip: true
            spacing: 8

            boundsBehavior: Flickable.StopAtBounds

            delegate: Row {
                width: ListView.view.width
                spacing: 12

                Text {
                    text: name + (notes && notes !== "Sin notas" ? " (nota)" : "")
                    color: "white"
                    font.pixelSize: 13
                    width: parent.width * 0.55
                    elide: Text.ElideRight
                }
                
                Text {
                    text: "x" + quantity
                    color: Theme.textMuted
                    width: 60
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    text: "$" + price
                    color: Theme.accent
                    font.bold: true
                    width: 80
                    horizontalAlignment: Text.AlignRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Qt.rgba(1, 1, 1, 0.25)
        }

        Text {
            text: "TOTAL: $" + dialog.total.toFixed(2)
            font.pixelSize: 20
            font.bold: true
            color: Theme.accent
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24

            AppButton {
                text: "Confirmar"
                baseColor: Theme.accent
                Layout.preferredWidth: 140
                Layout.preferredHeight: 48
                font.pixelSize: 15

                onClicked: {
                    dialog.confirmWithData(dialog.clientData)
                    dialog.close()
                }
            }

            AppButton {
                text: "Cancelar"
                baseColor: Theme.buttonDanger
                Layout.preferredWidth: 140
                Layout.preferredHeight: 48
                font.pixelSize: 15

                onClicked: {
                    dialog.cancel()
                    dialog.close()
                }
            }
        }
    }
}