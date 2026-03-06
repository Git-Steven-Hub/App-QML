import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../theme"

Dialog {
    id: dialog

    property string productId
    property string productName
    property real productPrice

    Column {
        spacing: 10

        CheckBox {
            id: sinCebolla
            text: "Sin cebolla"
        }

        AppButton {
            text: "Agregar"
            
            onClicked: {
                let notes = ""

            if (sinCebolla.checked)
                notes = "Sin cebolla"

            CartModel.addProduct(
                dialog.productId,
                dialog.productName,
                dialog.productPrice,
                notes
            )
            dialog.close()
            }
        }
    }
}