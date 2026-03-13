import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    color: Theme.surface

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12
        
        Text {
            width: implicitWidth
            text: "RESUMEN DEL PEDIDO"
            font.pixelSize: 16
            font.bold: true
            color: Theme.divider
            Layout.alignment: Qt.AlignHCenter
        }
        
        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: Qt.rgba(1, 1, 1, 0.2)
        }

        Text {
            text: "DATOS DEL CLIENTE"
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 16
            font.bold: true
            color: Theme.divider
            width: implicitWidth
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            AppInput {
                id: client_name
                placeholderText: "Nombre del cliente"
                Layout.alignment: Qt.AlignHCenter
                inputWidth: 200
            }

            AppInput {
                id: client_phone
                placeholderText: "Telefono"
                Layout.alignment: Qt.AlignHCenter
                inputWidth: 200
                validator: IntValidator { }
            }

            CustomComboBox {
                id: payment_method
                Layout.preferredWidth: 200
                model: ["Efectivo", "Transferencia", "Tarjeta"]
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: Qt.rgba(1, 1, 1, 0.2)
        }
        
        Text {
            width: implicitWidth
            text: "ITEMS"
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 16
            font.bold: true
            color: Theme.divider
        }

        //Listado de los items
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: CartModel
            spacing: 10
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                width: ListView.view.width
                height: 50
                color: Qt.rgba(1, 1, 1, 0.1)
                radius: Theme.radius

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Column {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: Name + (notes && notes !== "Sin notas" ? " (Con nota)" : "") 
                            color: "white"
                            font.bold: true
                            font.pixelSize: 12
                        }

                        Text {
                            text: "x" + Quantity + " - $" + Price
                            color: Theme.textMuted
                            font.pixelSize: 10
                        }
                    }

                    Rectangle {
                        width: 30
                        height: 30
                        color: Theme.buttonDanger
                        radius: Theme.radius

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: "white"
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                CartModel.removeProduct(index)
                            }
                        }
                    }
                }
            }
        }
        
        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: Qt.rgba(1, 1, 1, 0.2)
        }
        
        //Total del pedido
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            
            RowLayout {
                spacing: 8
                
                Text {
                    text: "TOTAL:"
                    color: Theme.accent
                    font.bold: true
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }
                
                Text {
                    text: "$" + CartModel.total.toFixed(2)
                    color: Theme.accent
                    font.bold: true
                    font.pixelSize: 16
                }
            }
        }
        
        //Botón para confirmar
        AppButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            baseColor: Theme.accent
            text: "Aceptar Pedido"
            font.bold: true
            font.pixelSize: 14

            onClicked: {
                if (CartModel.rowCount() === 0) {
                    return
                }

                let name = client_name.text.trim() !== "" ? client_name.text : "Sin datos"
                let phone = client_phone.text.trim() !== "" ? client_phone.text : "Sin datos"

                confirmDialog.clientName = name
                confirmDialog.clientPhone = phone
                confirmDialog.paymentMethod = payment_method.currentText
                confirmDialog.total = CartModel.total
                confirmDialog.clientData = { name: name, phone: phone, method: payment_method.currentText }
                confirmDialog.open()
            }
        }
    }

    ConfirmDialog {
        id: confirmDialog
        titleText: "Datos del pedido"

        onConfirmWithData: (data) => {
            CartModel.confirmOrder(data.name, data.phone, data.method)
            SalesModel.load_orders()
            client_name.text = ""
            client_phone.text = ""
        }
    }
}