import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

AnimatedPage {

        RowLayout {
            anchors.fill: parent
            spacing: 0

                //  PANEL IZQUIERDO  //
            Rectangle {
                Layout.preferredWidth: 180
                Layout.fillHeight: true
                color: Theme.primary

                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    Label {
                        text: "🍔"
                        font.pixelSize: 48
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        text: "Burger App"
                        color: "white"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        text: "Sistema de ventas"
                        color: "#DCE3FF"
                        font.pixelSize: Theme.fontSmall
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

                //  PANEL DERECHO  //
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.background

                ColumnLayout {
                    anchors.centerIn: parent
                    width: 280
                    spacing: Theme.spacing * 1.2

                    Label {
                        text: "Iniciar sesión"
                        font.pixelSize: Theme.fontTintle
                        font.weight: Font.DemiBold
                        color: Theme.textPrimary
                        Layout.alignment: Qt.AlignHCenter
                    }

                    AppInput {
                        placeholderText: "Usuario"
                        Layout.fillWidth: true
                    }

                    AppInput {
                        placeholderText: "Contraseña"
                        echoMode: TextInput.Password
                        Layout.fillWidth: true
                    }

                    AppButton {
                        text: "Ingresar"
                        Layout.fillWidth: true
                        height: 42
                        onClicked: stack.push(Qt.resolvedUrl("HomeView.qml"))
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacing

                        AppButton {
                            text: "Admin"
                            flat: true
                            Layout.fillWidth: true
                        }

                        AppButton {
                            text: "Salir"
                            flat: true
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }