import QtQuick
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    color: Theme.surface

    function resetInputs() {
        client_name.text = ""
        client_phone.text = ""
        payment_method.currentIndex = 0
        isDelivery = false
    }

    property bool isDelivery: false
        property real deliveryFee: (ConfigModel ? (ConfigModel.deliveryFee ? ConfigModel.deliveryFee : 0) : 0)

    signal confirmOrder(var data)
    
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
                Layout.alignment: Qt.AlignHCenter
                model: ["Efectivo", "Transferencia", "Tarjeta"]
            }

            Text {
                text: "TIPO DE ENTREGA"
                font.pixelSize: 16
                color: Theme.divider
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                spacing: 12
                Layout.fillWidth: true

                AppButton {
                    text: "Retira en local"
                    baseColor: !root.isDelivery ? Theme.primary : Theme.surfaceAlt
                    Layout.fillWidth: true
                    
                    onClicked: {
                        root.isDelivery = false
                    }
                }

                AppButton {
                    text: "Delivery"
                    baseColor: root.isDelivery ? Theme.primary : Theme.surfaceAlt
                    Layout.fillWidth: true

                    onClicked: {
                        root.isDelivery = true
                    }
                }
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
                            text: name + (notes && notes !== "Sin notas" ? " (Con nota)" : "") 
                            color: "white"
                            font.bold: true
                            font.pixelSize: 12
                        }

                        Text {
                            text: "x" + quantity + " - $" + price
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
                    text: "Subtotal:"
                    color: Theme.accent
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: "$" + (CartModel ? CartModel.total : 0).toFixed(2)
                    color: Theme.success
                    font.bold: true
                }
            }
            
            RowLayout {
                spacing: 8
            
                Text {
                    text: "Delivery:"
                    color: Theme.success
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: "+ $" + root.deliveryFee.toFixed(2)
                    color: Theme.success
                    font.bold: true
                }
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: Qt.rgba(1, 1, 1, 0.2)
            }

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
                    text: "$" + (CartModel ? (CartModel.total + (root.isDelivery ? root.deliveryFee : 0)) : 0).toFixed(2)
                    color: Theme.accent
                    font.bold: true
                    font.pixelSize: 18
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

                let data = {
                    name: name,
                    phone: phone,
                    method: payment_method.currentText,
                    isDelivery: root.isDelivery,
                    deliveryFee: root.isDelivery ? root.deliveryFee : 0,
                    total: CartModel.total + (root.isDelivery ? root.deliveryFee : 0)
                }

                root.confirmOrder(data)
            }
        }
    }
}