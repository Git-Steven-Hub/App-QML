import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.85

        AppCard {
            Layout.fillWidth: true

            AppInput {
                id: user
                placeholderText: "Usuario"
            }
        }

        AppCard {
            Layout.fillWidth: true

            AppButton {
                text: "Prueba"
                Layout.fillWidth: true
            }
        }
    }
}