import QtQuick
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: card

    radius: Theme.radiusLarge
    color: Theme.card

    // Soporte layout
    Layout.fillWidth: true

    implicitHeight: contentItem.implicitHeight + padding * 2

    // Api del componente
    default property alias content: contentItem.data
    property int padding: Theme.padding

    ColumnLayout {
        id: contentItem
        anchors.fill: parent
        anchors.margins: card.padding
        spacing: Theme.spacing
    }
}