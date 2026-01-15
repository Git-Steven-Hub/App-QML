import QtQuick
import QtQuick.Controls
import "theme"
import "views"

ApplicationWindow {
    id: app
    width: 550
    height: 500
    visible: true
    title: "Burger App"
    color: Theme.background
    
    property bool loading: false

    StackView {
        id: stack
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: Theme.background
            z: -1
        }

        initialItem: LoginView {}
    }

    Rectangle {
        anchors.fill: parent
        visible: app.loading
        z: 1000
        color: "#80000000"

        MouseArea {
            anchors.fill: parent
            enabled: app.loading
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: app.loading
            width: 42
            height: 42
        }
    }
}