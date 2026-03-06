import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material 2.12
import "../theme"
import "../components"

Item {
    id: root
    width: parent ? parent.width : 1024
    height: parent ? parent.height : 768

    property string currentView: "OrdersView"

    //Timer para usarlo pronto
    property string currentTime: "00:00"
    property string closeTimeRemaining: "Cierra en 0h 0m"
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            currentTime = Qt.formatDateTime(now, "hh:mm");

            var close = new Date(now);
            close.setHours(21, 0 , 0, 0);
            
            var diffMs = close.getTime() - now.getTime();
            
            if (diffMs > 0) {
                var hours = Math.floor(diffMs / (1000 * 60 * 60));
                var minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 *60));
                closeTimeRemaining = "Cierra en " + hours + "h " + minutes + "m";
            } else {
                closeTimeRemaining = "Turno cerrado";
            }
        }
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        //Izquierda Menú
        Rectangle {
            SplitView.preferredWidth: 190
            SplitView.minimumWidth: 190
            SplitView.maximumWidth: 220
            color: Theme.surface
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    text: "TITULO"
                    font.pixelSize: 22
                    font.bold: true
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Rectangle {
                    height: 1
                    Layout.fillWidth: true
                    color: Qt.rgba(1, 1, 1, 0.2)
                }
                
                Repeater {
                    model: [
                        { view: "OrdersView", label: "Pedidos", icon: "🔨" },
                        { view: "PromosView", label: "Promos", icon: "🔨" },
                        { view: "SalesView", label: "Pedidos en curso", icon: "🔨" },
                        { view: "Menú", label: "Menú", icon: "🔨" },
                        { view: "Estadísticas", label: "Estadísticas", icon: "🔨" },
                        { view: "Perfil", label: "Perfil", icon: "🔨" }
                    ]

                    AppButton {
                        text: modelData.icon + " " + modelData.label
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        baseColor: root.currentView === modelData.view ? Theme.primary : Theme.surfaceAlt
                        
                        onClicked: {
                            root.currentView = modelData.view
                        }
                    }
                }

                Rectangle {
                    height: 1
                    Layout.fillWidth: true
                    color: Qt.rgba(1, 1, 1, 0.2)
                }

                AppButton {
                    text: "Cerrar sesión"
                    Layout.fillWidth: true
                    baseColor: Theme.buttonDanger
                    onClicked: {
                        if (window.stackView) {
                            window.stackView.replace(Qt.resolvedUrl("LoginView.qml"))
                        }
                    }
                }
            }
        }

        Item {
            SplitView.fillWidth: true

            Loader {
                id: contentLoader
                anchors.fill: parent
                asynchronous: true
                opacity: 0
                scale: 0.97
                source: currentView + ".qml"

                Behavior on opacity { 
                    NumberAnimation { 
                        duration: 240
                        easing.type: Easing.OutQuad
                    } 
                }
                Behavior on scale { 
                    NumberAnimation { 
                    duration: 320
                    easing.type: Easing.OutBack
                    }
                }

                onStatusChanged: {
                    if (status === Loader.Ready) {
                        opacity = 1
                        scale = 1
                    }
                    else {
                        opacity = 0
                        scale = 0.96
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.surface
                visible: contentLoader.status === Loader.Loading

                BusyIndicator {
                    anchors.centerIn: parent
                    running: parent.visible
                    scale: 1.4
                }
            }
        }
    }
}