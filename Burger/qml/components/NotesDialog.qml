import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../theme"

Dialog {
    anchors.centerIn: parent
    id: dialog

    property string productId
    property string productName
    property real productPrice
    property int productCategoryId
    property string productCategoryName

    onOpened: {
        carneExtra.checked = false
        mayonesaAjo.checked = false
        sinCebolla.checked = false
        sinMayonesaAjo.checked = false
        extraHuevo.checked = false
        aceitunasVerdes.checked = false
    }

    StackLayout {
        currentIndex: {
            if (productCategoryName === "Hamburguesas") return 0
            if (productCategoryName === "Pizzas") return 1
            return 0
        }

        Column {
            visible: productCategoryName === "Hamburguesas"
            spacing: 10

            Text {
                text: "Notas para: Hamburguesa " + dialog.productName
                font.bold: true
                color: Theme.primary
            }

            CheckBox {
                id: carneExtra
                text: "Medallón extra"
            }

            CheckBox {
                id: mayonesaAjo
                text: "Con mayonesa de ajo"
            }

            CheckBox {
                id: sinCebolla
                text: "Sin cebolla"
            }

            CheckBox {
                id: sinMayonesaAjo
                text: "Sin mayonesa de ajo"
            }

            AppButton {
                text: "Agregar"
                
                onClicked: {
                    let notesList = []

                    if (carneExtra.checked)
                        notesList.push("Medallón extra")

                    if (mayonesaAjo.checked)
                        notesList.push("Con mayonesa de ajo")
                    
                    if (sinCebolla.checked)
                        notesList.push("Sin cebolla")
                    
                    if (sinMayonesaAjo.checked)
                        notesList.push("Sin mayonesa de ajo")
                    
                    let notes = notesList.join(", ")

                    CartModel.addProduct(
                        dialog.productId,
                        dialog.productCategoryId,
                        dialog.productCategoryName,
                        dialog.productName,
                        notes,
                        dialog.productPrice
                    )
                    dialog.close()
                }
            }

            AppButton {
                text: "Sin notas"
                baseColor: Theme.buttonSecondary

                onClicked: {
                    CartModel.addProduct(
                        dialog.productId,
                        dialog.productCategoryId,
                        dialog.productCategoryName,
                        dialog.productName,
                        "Sin notas",
                        dialog.productPrice
                    )
                    dialog.close()
                }
            }
        }
        
        Column {
            visible: productCategoryName === "Pizzas"
            spacing: 10

            Text {
                text: "Notas para: Pizza " + dialog.productName
                font.bold: true
                color: Theme.primary
            }

            CheckBox {
                id: extraHuevo
                text: "Huevo extra"
            }

            CheckBox {
                id: aceitunasVerdes
                text: "Con aceitunas verdes"
            }

            AppButton {
                text: "Agregar"
                
                onClicked: {
                    let notesList = []
                
                if (extraHuevo.checked)
                    notesList.push("Con huevo extra")
                
                if (aceitunasVerdes.checked)
                    notesList.push("Con acietunas verdes")
                
                let notes = notesList.join(", ")

                CartModel.addProduct(
                    dialog.productId,
                    dialog.productCategoryId,
                    dialog.productCategoryName,
                    dialog.productName,
                    notes,
                    dialog.productPrice
                )
                dialog.close()
                }
            }
            AppButton {
                text: "Sin notas"
                baseColor: Theme.buttonSecondary

                onClicked: {
                    CartModel.addProduct(
                        dialog.productId,
                        dialog.productCategoryId,
                        dialog.productCategoryName,
                        dialog.productName,
                        "Sin notas",
                        dialog.productPrice
                    )
                    dialog.close()
                }
            }
        }
    }
}