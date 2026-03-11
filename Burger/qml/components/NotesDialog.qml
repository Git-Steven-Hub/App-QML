import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../theme"

Dialog {
    anchors.centerIn: parent
    id: dialog
    padding: 20

    property string productId
    property string productName
    property real productPrice
    property int productCategoryId
    property string productCategoryName
    property variant currentNotes: []

    background: Rectangle {
        color: Theme.background
        radius: Theme.radius
    }

    onOpened: {
        for (let i = 0; i < notesListColumn.children.length; i++) {
            let child = notesListColumn.children[i]
            if (child.checked !== undefined) {
                child.checked = false
            }
        }
    }


    Column {
        id: notesColumn
        spacing: 8

        Text {
            text: "Notas: " + dialog.productCategoryName + " " + dialog.productName
            font.pixelSize: 16
            font.bold: true
            color: "white"
            Layout.bottomMargin: 10
        }

        Column {
            id: notesListColumn
            spacing: 8
                
            Repeater {
                model: currentNotes
                
                AppCheckBox {
                    id: noteCheck
                    text: modelData
                    property string noteText: modelData
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            AppButton {
                text: "Agregar notas"
                onClicked: {
                    let notesList = []
                    for (let i = 0; i < notesListColumn.children.length; i++) {
                        let child = notesListColumn.children[i]
                        if (child.checked && child.noteText) {
                            notesList.push(child.noteText)
                        }
                    }
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