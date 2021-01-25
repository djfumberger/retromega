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

    property var activeSortImage : {
        var image = "selection"
        if (showSortOrder) {
            image = "sort-order-" + currentSortOrder
        } 
        return "../assets/images/" + image + (activeFocus ? "-inverted.png" : ".png")
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
        source: activeSortImage
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

}