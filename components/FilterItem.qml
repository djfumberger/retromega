import QtQuick 2.12
import QtGraphicalEffects 1.12
Item {
    property var title: "Title"
    property var filter: "all"
    property var itemColor: "#00000"
    property var selected: {
        return collectionFilterMode == filter
    }
    height: 42
    focus: true

    Keys.onPressed: {              

        // Back to Home            
        if (api.keys.isAccept(event)) {
            event.accepted = true;
            setCollectionFilterMode(filter);
            return;
        }  
        event.accepted = false;
    }

    ListSelection {
        anchors.fill: parent
        tintColor: itemColor
        visible: parent.activeFocus
    }
    
    Image {
        source: "../assets/images/" + (parent.activeFocus ? "selection-inverted.png" : "selection.png")
        visible: selected
        anchors.rightMargin: 24
        anchors.verticalCenterOffset: 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
    }

    Text {
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.left: parent.left
        text: title
        color: parent.activeFocus ? "#ffffff" : "#000000"
        font.pixelSize: 16
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

}