import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: Theme.spacing

        // Header
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

        // Content
        AppCard {
            Layout.fillHeight: true

            Text {
                text: "Pedido actual"
                font.pixelSize: Theme.font
                font.weight: Font.DemiBold
                color: Theme.textPrimary
            }
        }

        // Actions
        Row {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Button {
                text: "Nueva venta"
                Layout.fillWidth: true
            }

            Button {
                text: "Cerrar turno"
                Layout.fillWidth: true
            }
        }
    }
}