import QtQuick

Item {
    id: page
    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    transformOrigin: Item.Center
    scale: 0.85
    opacity: 0

    default property alias content: container.data

    Item {
        id: container
        anchors.fill: parent
    }

    Component.onCompleted: enterAnim.start()

    ParallelAnimation {
        id: enterAnim
        NumberAnimation {
            target: page
            property: "opacity"
            to: 1
            duration: 220
        }
        NumberAnimation {
            target: page
            property: "scale"
            to: 1
            duration: 420
            easing.type: Easing.OutBack
        }
    }
}
