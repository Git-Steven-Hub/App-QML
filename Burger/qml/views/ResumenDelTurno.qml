import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material 2.12
import "../theme"
import "../components"

Item {
    Rectangle {
        anchors.fill: parent
        color: "white"
    }
    Component.onCompleted: {
        console.log("Resumen del turno cargado")
    }
}