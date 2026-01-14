import QtQuick
import QtQuick.Controls
import "theme"
import "views"

ApplicationWindow {
    id: app
    width: 500
    height: 700
    visible: true
    title: "Burger App"
    color: Theme.background
    
    property bool loading: false

    StackView {
        id: stack
        anchors.fill: parent

        initialItem: LoginView {}

        replaceEnter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "x"
                    from: stack.width
                    to: 0
                    duration: 260
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }
        }

        replaceExit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "x"
                    from: 0
                    to: -stack.width
                    duration: 220
                    easing.type: Easing.InCubic
                }
                NumberAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 160
                }
            }
        }
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