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

            TextField {
                id: client_name
                placeholderText: "Nombre del cliente"
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
            }

            TextField {
                id: client_phone
                placeholderText: "Telefono"
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
            }

            ComboBox {
                id: payment_method
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                model: ["Efectivo", "Transferencia", "Tarjeta"]
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: Qt.rgba(1, 1, 1, 0.2)
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
                            text: Name
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
                CartModel.confirmOrder(client_name.text, client_phone.text, payment_method.currentText)
                SalesModel.load_orders()
            }
        }
    }
}