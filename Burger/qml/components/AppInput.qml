import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: root
    spacing: 10

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property alias echoMode: field.echoMode
    property real inputWidth: 100

    TextField {
        id: field
        Layout.preferredWidth: root.inputWidth
        placeholderTextColor: Theme.textPrimary
        color: Theme.textPrimary
        leftPadding: 12
        rightPadding: 12
        topPadding: 8
        bottomPadding: 8
        implicitHeight: 35
    
        background: Rectangle {
            color: "white"
            radius: Theme.radius
            border.color: Theme.divider
            border.width: 1
        }
    }
}