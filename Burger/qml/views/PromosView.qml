import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material 2.12
import "../theme"
import "../components"
import "../data" as Data

Item {
    id: root
    anchors.fill: parent

    property string currentCategory: "Hamburguesas"
    property var categories: Data.ProductsData.categories
    property var allProducts: Data.ProductsData.allProducts

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Panel Izquierdo
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.background
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                
                // Categorías
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: Theme.surface
                    radius: Theme.radius
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8
                        
                        Repeater {
                            model: root.categories
                            
                            AppButton {
                                text: modelData.icon + " " + modelData.name
                                Layout.fillWidth: true
                                Layout.preferredHeight: 60
                                font.pixelSize: 15
                                baseColor: root.currentCategory === modelData.name 
                                    ? Theme.primary 
                                    : Theme.buttonSecondary
                                
                                onClicked: {
                                    root.currentCategory = modelData.name
                                }
                            }
                        }
                    }
                }
                
                // Grid de productos
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.surface
                    radius: Theme.radius
                    
                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 12
                        contentWidth: width
                        contentHeight: gridProductos.implicitHeight
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        
                        ScrollBar.vertical: ScrollBar { 
                            policy: ScrollBar.AsNeeded
                             visible: false 
                        }
                        
                        Flow {
                            id: gridProductos
                            width: parent.width
                            spacing: 16
                            property int columns: 4

                            Repeater {
                                model: root.allProducts.length

                                delegate: Item {
                                    // Oculto los items para que el Flow no los reserve
                                    visible: root.allProducts[index].category === root.currentCategory

                                    // Con esto calculo el ancho según las columnas
                                    width: Math.floor((gridProductos.width - (gridProductos.columns - 1) * gridProductos.spacing) / gridProductos.columns)

                                    ProductCard {
                                        id: card
                                        width: parent.width

                                        productId: root.allProducts[index].id
                                        productName: root.allProducts[index].name
                                        productPrice: root.allProducts[index].price
                                        productImage: root.allProducts[index].image
                                        accentColor: Theme.primary

                                        onClicked: {
                                            root.addToCart(root.allProducts[index])
                                        }
                                    }

                                    implicitHeight: card.implicitHeight
                                }
                            }
                        }
                    }
                }
            }
        }

        // Panel Derecho
        CartSummary {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            Layout.minimumWidth: 300
        }
    }
}