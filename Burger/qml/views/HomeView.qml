import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

AnimatedPage {

    AppCard {
        width: parent.width
        height: parent.height
        radius: 0

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacing

            //  HEADER  //
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                radius: Theme.radius
                color: Theme.primary

                Text {
                    anchors.centerIn: parent
                    text: "Burger App"
                    color: "white"
                    font.pixelSize: Theme.fontTintle
                    font.weight: Font.Medium
                }
            }

            //  CONTENIDO  //
            AppCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.surface

                Text {
                    text: "Pedido actual"
                    font.pixelSize: Theme.font
                    font.weight: Font.DemiBold
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                }
            }

            //  ACCIONES  //
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing

                AppButton {
                    text: "Nueva venta"
                    Layout.fillWidth: true
                }

                AppButton {
                    text: "Cerrar turno"
                    Layout.fillWidth: true
                    onClicked: stack.push(Qt.resolvedUrl("LoginView.qml"))
                }
            }
        }
    }
}