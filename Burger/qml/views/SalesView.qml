import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import "../theme"
import "../components"

Item {
    id: root
    anchors.fill: parent

    Component.onCompleted: {
        detailsOpen = false
    }

    property int selectedIndex: -1
    property var selectedOrder: null
    property bool detailsOpen: false
    property string currentFilter: "Todos"

    //Función para devolver los estados
    function statusColor(status) {
        if (status === "En curso") return Theme.warning

        if (status === "Completado") return Theme.success

        if (status === "Cancelado") return Theme.buttonDanger
    
        return Theme.surfaceAlt
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            enabled: !root.detailsOpen

            //Resumen arriba
            Text {
                text: "VENTAS DEL DÍA"
                font.pixelSize: 40
                color: "white"
                font.bold: true
                Layout.alignment: Qt.AlignCenter
            }

            Text {
                id: totalText
                text: "Total del día: $" + SalesProxy.totalFiltered
                font.pixelSize: 20
                color: Theme.accent
                font.bold: true
                Layout.alignment: Qt.AlignCenter
                scale: 1

                Behavior on text {
                    SequentialAnimation {
                        NumberAnimation { 
                            target: totalText 
                            property: "scale"
                            to: 1.1
                            duration: 100 
                        }

                        NumberAnimation {
                            target: totalText
                            property: "scale"
                            to: 1.0
                            duration: 100
                        }
                    }
                }
            }

            RowLayout {
                spacing: 16
                Layout.fillWidth: true
                Layout.preferredHeight: 80

                Repeater {
                    model: ["Todos", "En curso", "Completado", "Cancelado"]

                    AppButton {
                        Layout.fillWidth: true
                        implicitHeight: 65
                        opacity: root.detailsOpen ? 0.6 : 1

                        text: {
                            if (modelData === "Todos")
                                return modelData + " (" + SalesModel.totalCount + ")"

                            if (modelData === "En curso")
                                return modelData + " (" + SalesModel.enCursoCount + ")"

                            if (modelData === "Completado")
                                return modelData + " (" + SalesModel.completadoCount + ")"

                            if (modelData === "Cancelado")
                                return modelData + " (" + SalesModel.canceladoCount + ")"   
                        }
                        baseColor: root.currentFilter === modelData ? Theme.primary : Theme.surfaceAlt

                        onClicked: {
                            root.currentFilter = modelData
                            SalesProxy.setStatusFilter(modelData)
                        }
                    }
                }
            }

            //Lista de pedidos con sus respectivos estados
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                ListView {
                    id: ordersList
                    anchors.fill: parent
                    model: SalesProxy
                    spacing: 10
                    clip: true
                    opacity: root.detailsOpen ? 0.6 : 1
                    
                    boundsBehavior: Flickable.StopAtBounds

                    add: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 200
                        }
                    }

                    remove: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 200
                        }
                    }

                    delegate: Item {
                        property bool hovered: false
                        
                        opacity: 1
                        width: ListView.view.width
                        height: 75

                        layer.enabled: true
                        layer.smooth: true

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.radiusSmall
                            color: hovered ? Qt.darker(Theme.surfaceAlt, 1.05) : Theme.surfaceAlt

                            Behavior on color {
                                ColorAnimation {
                                    duration: 120
                                }
                            }
                        }

                        Rectangle {
                            width: 10
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            color: root.statusColor(Status)
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 12
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text { 
                                    text: "Pedido #" + orderId
                                    color: "white"
                                    font.bold: true
                                }

                                Text {
                                    text: "Hora: " + Time
                                    color: Theme.textMuted
                                    font.pixelSize: 12
                                }
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: "$" + Total
                                color: Theme.accent
                                font.bold: true
                                Layout.preferredWidth: 80
                            }
                        }
                    
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.hovered = true
                            onExited: parent.hovered = false
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.selectedIndex = index
                                root.selectedOrder = {
                                    orderId: orderId,
                                    time: Time,
                                    clientName: ClientName || "Sin nombre",
                                    clientPhone: ClientPhone || "Sin teléfono",
                                    clientPayment: PaymentMethod,
                                    total: Total,
                                    status: Status
                                }

                                OrderItemsModel.load_items(orderId)
                                root.detailsOpen = true
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: ordersList.count === 0
                    text: "No hay pedidos en esta categoría"
                    color: Theme.textMuted
                    font.pixelSize: 16
                }
            }
        }
    }

    //Panel de info, para aceptar y cancelar el pedido
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 1)
        opacity: root.detailsOpen ? 0.35 : 0
        visible: opacity > 0
        z: 5

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.detailsOpen = false
                root.selectedOrder = null
            }
        }
    }

    Item {
        id: panelContainer
        width: 360
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        x: root.detailsOpen ? parent.width - width : parent.width
        opacity: root.detailsOpen ? 1 : 0
        z: 10

        Behavior on x {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation { 
                duration: 200 
            }
        }

        Rectangle {
            id: detailsPanel
            anchors.fill: parent
            color: Theme.surface
        }

        MultiEffect {
            anchors.fill: detailsPanel
            source: detailsPanel
            shadowEnabled: true
            shadowColor: "#80000000"
            shadowBlur: 0.8
            shadowHorizontalOffset: -8
            shadowVerticalOffset: 0
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            Text {
                text: root.selectedOrder ? "Pedido #" + root.selectedOrder.orderId : ""
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 20
                font.bold: true
                color: "white"
            }

            Text {
                text: root.selectedOrder ? "Hora: " + root.selectedOrder.time : ""
                Layout.alignment: Qt.AlignHCenter
                color: Theme.textSecondary
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.surfaceAlt
            }

            Text {
                text: "Datos del cliente"
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 20
                font.bold: true
                color: "white"
                visible: root.selectedOrder !== null
            }

            RowLayout {
                Layout.fillWidth: true
                visible: root.selectedOrder !== null
                spacing: 80

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    RowLayout {

                        Text {
                            text: "Cliente:"
                            font.pixelSize: 12
                            color: "white"
                            Layout.column: 0
                        }

                        Text {
                            text: root.selectedOrder ? root.selectedOrder.clientName || "Sin datos" : ""
                            font.pixelSize: 12
                            color: "white"
                            Layout.column: 1
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {

                        Text {
                            text: "Teléfono:"
                            font.pixelSize: 12
                            color: "white"
                            Layout.column: 0
                        }

                        Text {
                            text: root.selectedOrder ? root.selectedOrder.clientPhone || "Sin datos" : ""
                            font.pixelSize: 12
                            color: "white"
                            Layout.column: 1
                            Layout.fillWidth: true
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    RowLayout {

                        Text {
                            text: "Forma de pago:"
                            font.pixelSize: 12
                            color: "white"
                            Layout.column: 2
                        }

                        Text {
                            text: root.selectedOrder ? root.selectedOrder.clientPayment : ""
                            font.pixelSize: 12
                            color: "white"
                            Layout.column: 3
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {

                        Text {
                            text: "Entrega:"
                            font.pixelSize: 12
                            color: "white"
                        }

                        Text {
                            text: "Retira en local"
                            font.pixelSize: 12
                            color: "white"
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.surfaceAlt
            }

            Text {
                text: "   SECCIÓN              PRODUCTO                  CANTIDAD           PRECIO"
                color: Theme.textMuted
                Layout.preferredWidth: 80
                font.pixelSize: 10
                font.bold: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.surfaceAlt
            }

            ListView {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                model: OrderItemsModel
                clip: true

                boundsBehavior: Flickable.StopAtBounds

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 40
                    color: Qt.rgba(1, 1, 1, 0.05)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6

                        Text {
                            text: model.categoryName
                            color: Theme.textMuted
                            font.pixelSize: 10
                            font.bold: true
                            Layout.preferredWidth: 80
                        }

                        Text {
                            text: model.Name
                            color: Theme.textMuted
                            font.bold: true
                            font.pixelSize: 14
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "x" + model.Quantity
                            color: Theme.textMuted
                            Layout.preferredWidth: 80
                        }
                        
                        Text {
                            text: "$" + model.UnitPrice
                            color: Theme.accent
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.surfaceAlt
            }

            Text {
                text: root.selectedOrder ? "Total del pedido $" + root.selectedOrder.total : ""
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 18
                font.bold: true
                color: Theme.accent
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                visible: root.selectedOrder && root.selectedOrder.status === "En curso"

                AppButton {
                    text: "Completar"
                    baseColor: Theme.success
                    Layout.fillWidth: true

                    onClicked: {
                        SalesProxy.sourceModel.completeOrder(root.selectedOrder.orderId)
                        root.detailsOpen = false
                        root.selectedOrder = null
                    }
                }
                
                AppButton {
                    text: "Cancelar"
                    baseColor: Theme.buttonDanger
                    Layout.fillWidth: true

                    onClicked: {
                        SalesProxy.sourceModel.cancelOrder(root.selectedOrder.orderId)
                        root.detailsOpen = false
                        root.selectedOrder = null
                    }
                }
            }

        AppButton {
                text: "Cerrar"
                baseColor: Theme.surfaceAlt
                Layout.fillWidth: true
                onClicked: root.detailsOpen = false
            }
        }
    }
}