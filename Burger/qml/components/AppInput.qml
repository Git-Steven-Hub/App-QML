import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: root
    spacing: 4
    width: parent ? parent.width : 250

    property alias text: field.text
    property alias placeholderText: field.placeholderText

    TextField {
        id: field
        width: parent.width
        placeholderTextColor: "#888"
    }
}