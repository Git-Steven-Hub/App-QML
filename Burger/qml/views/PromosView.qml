import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"
import "../components"

Item {
    id: root
    anchors.fill: parent

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
                ProductGrid {
                    id: productGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    productsModel: PromosModel
                    categoriesModel: CategoriesModel
                    currentCategory: 1
                    enableNotes: false
                    accentColor: Theme.secondary

                    onProductClicked: (product) => {
                        CartModel.addProduct(
                            product.productId,
                            product.productCategoryId,
                            product.productCategoryName,
                            product.productName,
                            "Sin notas",
                            product.productPrice
                        )
                    }
                }
            }
        }

        // Panel Derecho
        CartSummary {
            id: cartSummary
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            Layout.minimumWidth: 300

            onConfirmOrder: (data) => {
                confirmDialog.clientData = data
                confirmDialog.open()
            }
        }
    }

    ConfirmDialog {
        id: confirmDialog
        titleText: "Datos del pedido"
        anchors.centerIn: parent
        modal: true
        width: Math.min(460, parent.width * 0.75)
        height: Math.min(580, parent.height * 0.85)

        onConfirmWithData: (data) => {
            CartModel.confirmOrder(data.name, data.phone, data.method)
            SalesModel.load_orders()

            cartSummary.resetInputs()
        }
    }
}