import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls
import "../theme"

Dialog {
    anchors.centerIn: parent
    id: dialog
    padding: 20
    visible: false

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
        if (visible) {
            scaleAnimation.start()
            fadeAnimation.start()
        }

        for (let i = 0; i < notesListColumn.children.length; i++) {
            let child = notesListColumn.children[i]
            if (child.checked !== undefined) {
                child.checked = false
            }
        }
        textPersonalized.text = ""
    }

    onClosed: {
        for (let i = 0; i < notesListColumn.children.length; i++) {
            let child = notesListColumn.children[i]
            if (child.checked !== undefined) {
                child.checked = false
            }
        }
    }

    NumberAnimation {
        id: scaleAnimation
        target: dialog
        property: "scale"
        from: 0.8
        to: 1
        duration: 200
        easing.type: Easing.OutBack
    }
    
    NumberAnimation {
        id: fadeAnimation
        target: dialog
        property: "opacity"
        from: 0
        to: 1
        duration: 150
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

            AppInput {
                id: textPersonalized
                placeholderText: "Especifícaciones personalizadas"
                inputWidth: 250
            }
        }

        Rectangle {
        height: 1
        Layout.fillWidth: true
        color: Qt.rgba(1, 1, 1, 0.2)
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            AppButton {
                text: "Agregar notas"
                implicitWidth: 125
                onClicked: {
                    let notesList = []

                    for (let i = 0; i < notesListColumn.children.length; i++) {
                        let child = notesListColumn.children[i]
                        if (child.checked && child.noteText) {
                            notesList.push(child.noteText)
                        }
                    }

                    if (textPersonalized.text.trim() !== "") {
                        let text = textPersonalized.text.trim().toLowerCase()
                        notesList.push(text.replace(/\b\w/g, l => l.toUpperCase()))
                    }

                    if (notesList.length === 0) {
                        warningDialog.open()
                        return
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

            Item { Layout.fillWidth: true }

            AppButton {
                text: "Sin notas"
                implicitWidth: 100
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

    AlertDialog {
        id: warningDialog
        dialogType: "warning"
        titleText: "¡Atención!"
        messageText: "Seleccioná al menos una nota"
        buttonText: "Aceptar"
    }
}