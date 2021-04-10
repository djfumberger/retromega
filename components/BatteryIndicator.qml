import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
Item {
    width: 26
    height: 14

    property var lightStyle : false

    property var percent: {
        api.device ? api.device.batteryPercent : 0
    }

    Image {
        id: iconImage
        source: lightStyle ? "../assets/images/battery.png" : "../assets/images/battery-dark.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    Rectangle {
        anchors.leftMargin: 2
        anchors.topMargin: 3
        anchors.top: parent.top
        anchors.left: parent.left
        color: lightStyle ? "#ffffff" : "#000000"
        radius: 2
        width: Math.max(percent * 17.6, 2)
        height: 8
    }
}
