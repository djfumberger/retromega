import QtQuick 2.12
import QtGraphicalEffects 1.12
Item {
    property var title: "Title"
    property var mode: "title"
    property var itemColor: "#00000"
    property var selected: {
        return collectionSortMode == mode
    }
    property var currentSortOrder: {
        return (collectionSortDirection == 0 ? "ascending" : "descending")
    }
    property var showSortOrder: {
        return (collectionSortMode == "title" || collectionSortMode == "release") 
    }

    height: 42
    focus: true

    Keys.onPressed: {              
    

        // Back to Home            
        if (api.keys.isAccept(event)) {
            event.accepted = true;
            setCollectionSortMode(mode);
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
        id: title_text
        anchors.leftMargin: 0
        anchors.left: parent.left
        text: title
        color: parent.activeFocus ? "#ffffff" : "#000000"
        font.pixelSize: 16
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
    }

    Image {
        source:  "../assets/images/" + (parent.activeFocus ? "sort-order-" + currentSortOrder + "-inverted.png" : "sort-order-" + currentSortOrder + ".png")
        anchors.leftMargin: 6
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: title_text.right
        visible: selected && showSortOrder
        opacity: 0.3
    }

}