import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../theme"

Rectangle {
    id: root
    
    property string productId: ""
    property string productCategoryId: ""
    property string productCategoryName: ""
    property string productName: "Producto"
    property real productPrice: 0
    property string productImage: ""
    property color accentColor: Theme.primary
    
    signal clicked()
    
    implicitWidth: 120
    color: Theme.surfaceAlt
    radius: Theme.radius
    border.width: mouseArea.containsMouse ? 2 : 0
    border.color: mouseArea.containsMouse ? Qt.lighter(root.accentColor, 1.2) : "transparent"
    scale: mouseArea.pressed ? 0.97 : 1.0

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: mouseArea.pressed
                    ? "#80000000"
                    : (mouseArea.containsMouse ? "#A0000000" : "#60000000")

        shadowBlur: mouseArea.pressed
                    ? 3
                    : (mouseArea.containsMouse ? 18 : 8)

        shadowVerticalOffset: mouseArea.pressed
                            ? 1
                            : (mouseArea.containsMouse ? 10 : 4)
                            
        brightness: mouseArea.pressed ? -0.06 : 0.0

        Behavior on brightness {
            NumberAnimation {
                duration: 80
            }
        }

        Behavior on shadowBlur {
            NumberAnimation { duration: 150 }
        }

        Behavior on shadowVerticalOffset {
            NumberAnimation { duration: 150 }
        }
    }
    
    Behavior on border.width {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }
    Behavior on border.color {
        ColorAnimation {
            duration: 180
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 80
            easing.type: Easing.OutQuad
        }
    }

    ColumnLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 6
        
        //Foto(proximamente) del producto
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Qt.darker(Theme.surfaceAlt, 1.1)
            radius: Theme.radius
            
            Text {
                anchors.centerIn: parent
                text: root.productImage
                font.pixelSize: 70
                scale: mouseArea.containsMouse ? 1.08 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 220
                        easing.type: Easing.OutBack
                        easing.overshoot: 5
                    }
                }
                
                opacity: mouseArea.pressed ? 0.85 : 1.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 80
                    }
                }
            }
            Rectangle {
                id: pressedOverlay
                anchors.fill: parent
                color: "black"
                opacity: mouseArea.pressed ? 0.12 : 0.0
                radius: parent.radius

                Behavior on opacity { 
                    NumberAnimation { 
                        duration: 80 
                    } 
                }
            }
        }
        
        //Nombre del producto
        Text {
            text: root.productName
            color: "white"
            font.pixelSize: 12
            font.bold: true
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
        
        //Precio del producto
        Text {
            text: "$" + root.productPrice
            color: root.accentColor
            font.pixelSize: 14
            font.bold: true
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            root.clicked()
        }
    }

    //Calculo la altura de la tarjeta
    implicitHeight: content.implicitHeight + 20
}