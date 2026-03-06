import QtQuick
import QtQuick.Layouts
import "../theme"
import "../components"

Item {
    width: parent ? parent.width : 1024
    height: parent ? parent.height : 768

    RowLayout {
        anchors.fill: parent
        spacing: 0

        //Contenido izquierda
        Rectangle {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            color: Theme.secondary
            
            Item {
                anchors.fill: parent

                ColumnLayout {
                    anchors.centerIn: parent
                    opacity: 1

                    Text {
                        id: titleText
                        Layout.alignment: Qt.AlignHCenter
                        text: "🍔 Burger App"
                        color: "white"
                        font.pixelSize: 36
                        opacity: 1
                    }
                }
            }
        }

        //Contenido derecha
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.background

            Item {
                anchors.fill: parent

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 16
                    opacity: 1
                    Behavior on opacity {
                        NumberAnimation { 
                            duration: 200
                        }
                    }

                    AppInput {
                        placeholderText: "Usuario"
                        inputWidth: 250
                        Layout.alignment: Qt.AlignCenter
                    }

                    AppInput {
                        placeholderText: "Contraseña"
                        inputWidth: 250
                        echoMode: TextInput.Password
                        Layout.alignment: Qt.AlignCenter
                    }

                    AppButton {
                        id: buttonApp
                        Layout.alignment: Qt.AlignHCenter
                        text: "Ingresar"
                        baseColor: Theme.buttonPrimary
                        opacity: 1
                        implicitWidth: 250
                        
                        onClicked: {
                            if (window.stackView) {
                            window.stackView.replace(Qt.resolvedUrl("HomeView.qml"))
                            }
                        }
                    }

                    RowLayout {
                        spacing: Theme.padding * 2

                        AppButton {
                            Layout.alignment: Qt.AlignVCenter
                            text: "Admin"
                            implicitWidth: 100
                            baseColor: Theme.buttonSecondary
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        AppButton {
                            Layout.alignment: Qt.AlignVCenter
                            text: "Cerrar"
                            implicitWidth: 100
                            baseColor: Theme.buttonSecondary
                            
                            onClicked: {
                                Qt.quit()
                            }
                        }
                    }
                }
            }
        }
    }
}