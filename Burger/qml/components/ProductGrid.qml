import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../theme"
import "../components"

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: Theme.surface
    radius: Theme.radius

    property var productsModel: null
    property var categoriesModel: null
    property int currentCategory: 1
    property bool enableNotes: true
    property color accentColor: Theme.primary

    signal productClicked(var product)
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Theme.surfaceAlt
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Repeater {
                    model: root.categoriesModel

                    delegate: AppButton {
                        text: model.categoryIcon + " " + model.categoryName
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        font.pixelSize: 15

                        baseColor: root.currentCategory === model.categoryId ? Theme.primary : Theme.buttonSecondary

                        onClicked: {
                            root.currentCategory = model.categoryId
                        }
                    }
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                    model: root.productsModel

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
                                root.productClicked({
                                    productId: productId,
                                    productCategoryId: productCategoryId,
                                    productCategoryName: productCategoryName,
                                    productName: productName,
                                    productPrice: productPrice
                                })
                            }
                        }

                        implicitHeight: card.implicitHeight
                    }
                }
            }
        }
    }
}