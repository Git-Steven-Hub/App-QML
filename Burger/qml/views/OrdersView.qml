import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material 2.12
import "../theme"
import "../components"

Item {
    id: root
    anchors.fill: parent

    property int currentCategory: 1

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
                            model: CategoriesModel
                            
                            AppButton {
                                text: model.categoryIcon + " " + model.categoryName
                                Layout.fillWidth: true
                                Layout.preferredHeight: 60
                                font.pixelSize: 15
                                baseColor: root.currentCategory === model.categoryId
                                    ? Theme.primary 
                                    : Theme.buttonSecondary
                                
                                onClicked: {
                                    root.currentCategory = model.categoryId
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
                                model: ProductsModel

                                delegate: Item {
                                    // Oculto los items para que el Flow no los reserve
                                    visible: model.productCategoryId === root.currentCategory

                                    // Con esto calculo el ancho según las columnas
                                    width: Math.floor((gridProductos.width - (gridProductos.columns - 1) * gridProductos.spacing) / gridProductos.columns)

                                    ProductCard {
                                        id: card
                                        width: parent.width

                                        productId: model.productId
                                        productCategoryId: model.productCategoryId
                                        productCategoryName: model.productCategoryName
                                        productName: model.productName
                                        productPrice: model.productPrice
                                        productImage: model.productIcon
                                        accentColor: Theme.primary

                                        onClicked: {
                                            notesDialog.productId = productId
                                            notesDialog.productName = productName
                                            notesDialog.productPrice = productPrice
                                            notesDialog.productCategoryId = productCategoryId
                                            notesDialog.productCategoryName = productCategoryName
                                            notesDialog.currentNotes = CategoriesModel.get_category_notes(productCategoryId)

                                            notesDialog.open()
                                        }
                                    }

                                    implicitHeight: card.implicitHeight
                                }
                            }
                        }
                    }
                }
                NotesDialog {
                    id: notesDialog
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