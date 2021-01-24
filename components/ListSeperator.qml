import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    anchors.left: parent.left
    anchors.right: parent.right
    height: 8

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: "#000000"
        opacity: 0.1
    }
}