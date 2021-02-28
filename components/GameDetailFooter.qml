import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0

Item {
    height: 55
    width: parent.width

    /**
    * Footer
    */
    Rectangle {
        id: footer
        color: theme.background
        width: parent.width
        height: 55
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0 
        anchors.bottom: parent.bottom
        clip:true


            Rectangle {
                anchors.leftMargin: 22
                anchors.rightMargin: 22
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#e3e3e3"
                anchors.top: parent.top
                height: 1
            }
            
        ButtonLegend {
            id: button_legend_start
            title: "Select"
            key: "A"
            width: 55
            anchors.left: parent.left
            anchors.leftMargin: 32
            anchors.verticalCenter: parent.verticalCenter
        }

        ButtonLegend {
            id: button_legend_back
            title: "Back"
            key: "B"
            width: 55
            anchors.left: button_legend_start.right
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter
        }

    }     
}