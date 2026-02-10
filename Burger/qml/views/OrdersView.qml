import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material 2.12
import "../theme"
import "../components"

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Theme.surface

        Flickable {
            anchors.fill: parent
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: contentColumn
                width: parent.width
                anchors.margins: 24
                spacing: 20

                Text {
                    text: "RESUMEN DEL TURNO"
                    font.pixelSize: 24
                    color: Theme.divider
                    font.bold: true
                    Layout.alignment: Qt.AlignLeft
                }

                RowLayout {
                    spacing: 20
                    Layout.fillWidth: true
                    id: rowLayoutTarjetas

                    Repeater {
                        model: [
                            { title: "Pedidos Hoy", value: "42", accent: Theme.primary, icon: "📦" },
                            { title: "En curso", value: "5", accent: Theme.secondary, icon: "⏳" },
                            { title: "Ventas", value: "$1.2K", accent: "#4ACF50", icon: "💰" },
                            { title: "Tiempo Avg", value: "4 min", accent: "#FF9800", icon: "⏱" }
                        ]
                    
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 140
                            color: Qt.darker(Theme.surface, 1.15)
                            radius: 20 
                            border.color: modelData.accent
                            border.width: 2
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                blurEnabled: true
                                blur: 0.4
                                shadowEnabled: true
                                shadowColor: "#60000000"
                                shadowHorizontalOffset: 6
                                shadowVerticalOffset: 6
                                shadowBlur: 1.0
                            }
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 20
                                spacing: 16
                                
                                Text { 
                                    text: modelData.icon
                                    font.pixelSize: 40
                                    color: modelData.accent
                                }

                            Column {
                                spacing: 4
                                Layout.fillWidth: true
                                Text { 
                                    text: modelData.title
                                    color: modelData.accent
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                Text { 
                                    text: modelData.value
                                    color: "white"
                                    font.pixelSize: 36
                                    font.bold: true
                                }
                            }
                        }
                    }
                }
            }
                Text {
                    text: "ACCIONES RAPIDAS"
                    font.pixelSize: 26
                    color: Theme.divider
                    font.bold: true
                    Layout.alignment: Qt.AlignLeft
                }
                GridLayout {
                    columns: 2
                    rowSpacing: 24
                    columnSpacing: 24
                    Layout.fillWidth: true
                    id: gridAcciones

                    AppButton { 
                        text: "➕ Nuevo Pedido"
                        Layout.preferredHeight: 140
                        Layout.fillWidth: true
                        baseColor: Theme.primary
                        font.pixelSize: 22
                    }
                    AppButton {
                        text: "⏳ En Curso"
                        Layout.preferredHeight: 140
                        Layout.fillWidth: true
                        baseColor: Qt.darker(Theme.primary, 1.1)
                        font.pixelSize: 22
                    }
                }
                Text {
                    text: "VER PEDIDOS"
                    Layout.alignment: Qt.AlignLeft
                    font.pixelSize: 22
                    color: Theme.divider
                    font.bold: true
                }
                GridLayout {
                    columns: 2
                    Layout.fillWidth: true
                    id: gridVerPedidos
                    
                    AppButton { 
                        text: "✓ Completados"
                        Layout.preferredHeight: 100
                        Layout.fillWidth: true
                        baseColor: Theme.secondary
                    }
                    AppButton {
                        text: "📋 Todos"
                        Layout.preferredHeight: 100
                        Layout.fillWidth: true
                        baseColor: Theme.secondary
                    }
                }
                Text {
                    text: "HERRAMIENTAS"
                    Layout.alignment: Qt.AlignLeft
                    font.pixelSize: 22
                    color: Theme.divider
                    font.bold: true
                }
                GridLayout {
                    columns: 4
                    Layout.fillWidth: true
                    id: gridHerramientas
                    
                    AppButton { 
                        text: "📊 Est."
                        Layout.preferredHeight: 100
                        Layout.fillWidth: true
                        baseColor: Theme.buttonTertiary
                    }
                    AppButton {
                        text: "Menú"
                        Layout.preferredHeight: 100
                        Layout.fillWidth: true
                        baseColor: Theme.buttonTertiary
                    }
                    AppButton {
                        text: "Arq."
                        Layout.preferredHeight: 100
                        Layout.fillWidth: true
                        baseColor: Theme.buttonTertiary
                    }
                    AppButton {
                        text: "Perfil"
                        Layout.preferredHeight: 100
                        Layout.fillWidth: true
                        baseColor: Theme.buttonTertiary
                    }
                }
            }
        }
    }

    Component.onCompleted: {
    Qt.callLater(() => {
        console.log("OrdersView cargado, alto content:", contentColumn.implicitHeight)
        console.log("Alto de RowLayout tarjetas:", rowLayoutTarjetas.implicitHeight)  // ← agrega id al RowLayout
        console.log("Alto de Grid Acciones:", gridAcciones.implicitHeight)
        console.log("Alto de Grid Ver Pedidos:", gridVerPedidos.implicitHeight)
        console.log("Alto de Grid Herramientas:", gridHerramientas.implicitHeight)
        })
    }
}