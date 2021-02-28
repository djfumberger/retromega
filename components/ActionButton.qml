import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
Item {
    property var title: "Button"
    property var icon: "play"
    property var textColor: "#000000"
    Rectangle {
        id: buttonBackground
        anchors.fill: parent
        color: parent.activeFocus ? systemColor : "#ffffff"
        radius: 6
    }

    DropShadow {
        anchors.fill: buttonBackground
        horizontalOffset: 0
        verticalOffset: 6
        radius: 12.0
        samples: 10
        color: parent.activeFocus ? "#40000000" : "#20000000"
        source: buttonBackground
    }

    Text { 
        text: title
        font.bold: true
        font.pixelSize: 14
        visible: parent.activeFocus
        opacity: 0.5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: iconImage
        source: "../assets/images/icon-" + icon + ".png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ColorOverlay {
        anchors.fill: iconImage
        source: iconImage
        color: parent.activeFocus ? "#ffffff" : systemColor// "#333333"
    }    
}