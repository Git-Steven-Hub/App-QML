import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: root
    spacing: 4

    property int preferredWidth: 250

    Layout.preferredWidth: preferredWidth

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property alias echoMode: field.echoMode
    
    TextField {
        id: field
        Layout.fillWidth: true
        placeholderTextColor: "#888"
    
        background: Rectangle {
            color: "white"
            radius: Theme.radius
        }
    }
}