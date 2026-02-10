import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material 2.12
import "./theme"

ApplicationWindow {
    id: window
    width: 1280
    height: 800
    minimumWidth: 1024
    minimumHeight: 700
    visible: true
    title: "Burger App"
    color: Theme.background
    opacity: 0.0


    Behavior on opacity {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    property alias stackView: stackView

    Component.onCompleted: {
        opacity = 1.0
        stackView.push(Qt.resolvedUrl("views/LoginView.qml"))
    }
    Material.theme: Material.Dark
    ////////////////////////NO TOCAR EL CODIGO DE ARRIBA////////////////////////

    StackView {
        id: stackView
        anchors.fill: parent
    }
}