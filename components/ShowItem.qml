import QtQuick 2.12
import QtGraphicalEffects 1.12
Item {
    property var title: "Title"
    property var value: "all"
    property var itemColor: "#00000"
    property var selected: {
        return collectionFilterMode == value
    }
    height: 42
    focus: true

    Keys.onPressed: {              

        // Back to Home            
        if (api.keys.isAccept(event)) {
            event.accepted = true;
            setCollectionFilterMode(value);
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
        source: "../assets/images/selection.png"
        width: 18
        height: 18
        visible: selected
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.left: parent.left
        text: title
        color: parent.activeFocus ? "#ffffff" : "#000000"
        font.pixelSize: 16
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

}