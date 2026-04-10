import QtQuick
import QtQuick.Layouts
import "../theme"
import "../components"

Item {
    id: root
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 250
                color: Theme.surface
                radius: Theme.radius
                Layout.margins: 12

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16

                    Text {
                        text: "Usuario: " + (AuthModel ? (AuthModel.currentUsername ? AuthModel.currentUsername : "Cargando...") : "Cargando...")
                        color: Theme.textSecondary
                        font.pixelSize: 24
                        font.bold: true
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: "Rol: " + (AuthModel ? (AuthModel.currentUserRole ? AuthModel.currentUserRole : "Cargando...") : "Cargando...")
                        color: Theme.textSecondary
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: Qt.rgba(1, 1, 1, 0.2)
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: Theme.surface
                radius: Theme.radius
                Layout.margins: 12
                visible: AuthModel && AuthModel.isAdmin

                ColumnLayout {
                    id: adminPanel
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "Panel de Administración"
                        font.pixelSize: 18
                        font.bold: true
                        color: "white"
                    }

                    AppInput {
                        id: nameInput
                        placeholderText: "Nombre del local"
                        text: ConfigModel ? ConfigModel.businessName : ""
                    }

                    AppInput {
                        id: timeInput
                        placeholderText: "Horario de cierre (HH:MM)"
                        text: ConfigModel ? ConfigModel.closeTime : ""
                    }

                    AppInput {
                        id: deliveryFeeInput
                        placeholderText: "Costo delivery"
                        text: ConfigModel ? ConfigModel.deliveryFee : ""
                    }

                    AppButton {
                        text: "Guardar cambios"
                        baseColor: Theme.success
                        Layout.fillWidth: true

                        onClicked: {
                            ConfigModel.save_info( nameInput.text, timeInput.text, deliveryFeeInput.text )
                        }
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
                baseColor: Theme.buttonDanger
                Layout.fillWidth: true
                Layout.margins: 12

                onClicked: {
                    AuthModel.logout()
                    if (window.stackView) {
                        window.stackView.replace(Qt.resolvedUrl("LoginView.qml"))
                    }
                }
            }
        }
    }
}