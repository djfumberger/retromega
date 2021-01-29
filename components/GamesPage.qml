import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {

    property var showSort : false
    property var showAllItems : false
    property alias currentIndex: gameList.currentIndex

    property var footerTitle: {
        return gameList.footerTitle
    }
    
    property var systemColor: {
        systemColors[currentCollection.shortName] || "#000000" 
    }

    property var headerTitle: {
        return (showAllItems) ? "All " + currentCollection.name : currentCollection.name
    }
    
    property var collectionSortTitle: {
        var title = "Title"
        switch (collectionSortMode) {
            case "title": {
                title = "By Title"
                break
            }
            case "lastPlayed": {
                title = "By Last Played"
                break
            }
            case "rating": {
                title = "By Rating"
                break
            }   
            case "favorites": {
                title = "By Favorites"
                break
            }               
            case "release": {
                title = "By Release Date"
                break
            }                        
            case "playCount": {
                title = "By Play Count"
                break
            }                        
            case "playTime": {
                title = "By Play Time"
                break
            }                        
            default: {
                title = "By"
                break
            }
        }

        if (collectionFilterMode == "favorites" && !showAllItems) {
            return "Favorites, " + title 
        }  else {
            return title
        }
    }

    property var onShow: function() {
        currentIndex = 0
    }

    Component.onCompleted: {
        onShow()
    }

    width: layoutScreen.width                
    height: layoutScreen.height                

    Keys.onPressed: {           

        // Show / Hide Sort
        if (api.keys.isPageDown(event)) {
            event.accepted = true;
            showSort = !showSort
            return;
        }  

        // Back to Home            
        if (api.keys.isCancel(event)) {
            event.accepted = true
            if (showSort) {
                showSort = false
                backSound.play()
            } else if (showAllItems) {
                gameList.currentIndex = -1
                showAllItems = false
                backSound.play()
            } else {
                gameList.currentIndex = -1
                navigate('HomePage');
            }
            return
        }  

        event.accepted = false
    }

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

        CustomBorder {
            color: theme.background
            leftMargin: 22
            rightMargin: 22
            width: parent.width
            height: parent.height
            lBorderwidth: 0
            rBorderwidth: 0
            tBorderwidth: 1
            bBorderwidth: 0
            borderColor: "#e3e3e3"
        }

        Text {
            text: footerTitle
            anchors.right: parent.right
            anchors.rightMargin: 32
            color: "#9B9B9B"//theme.title
            font.pixelSize: 18
            font.letterSpacing: -0.3
            font.bold: true              
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight   
            height: 20    
        }

        ButtonLegend {
            id: button_legend_start
            title: "Start"
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

        ButtonLegend {
            id: button_legend_details
            title: "Favorite"
            key: "X"
            width: 75
            visible: collectionFilterMode == "all"
            anchors.left: button_legend_back.right
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter
        }

        // ButtonLegend {
        //     id: button_legend_grid
        //     title: "Grid"
        //     key: "X"
        //     width: 55
        //     anchors.left: collectionFilterMode == "all" ? button_legend_details.right : button_legend_back.right
        //     anchors.leftMargin: 24
        //     anchors.verticalCenter: parent.verticalCenter
        // }

    }        


    /**
    * Header
    */
    Rectangle {
        id: header
        color: theme.background
        width: 640
        height: 55
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.top: parent.top
        clip:true

        CustomBorder {
            leftMargin: 22
            rightMargin: 22
            width: parent.width 
            height: parent.height
            lBorderwidth: 0
            rBorderwidth: 0
            tBorderwidth: 0
            bBorderwidth: 1
            color: theme.background
            borderColor: "#e3e3e3"
        }

        Text{
            text: headerTitle
            anchors.left: parent.left
            anchors.leftMargin: 32
            color: systemColor//theme.title
            font.pixelSize: 18
            font.letterSpacing: -0.3
            font.bold: true              
            anchors.verticalCenter: parent.verticalCenter
            width:300       
            elide: Text.ElideRight       
        }


        Text {
            id: header_time
            text: collectionSortTitle
            anchors.right: legend.left
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.rightMargin: 8
            color: "#9B9B9B"
            font.pixelSize: 18
            font.letterSpacing: -0.3
            font.bold: true              
        }   


        // Text {
        //     id: header_time
        //     text: Qt.formatTime(new Date(), "hh:mm")   
        //     anchors.right: parent.right
        //     anchors.top: parent.top
        //     anchors.topMargin: 16
        //     anchors.rightMargin: 32
        //     color: "#9B9B9B"
        //     font.pixelSize: 18
        //     font.letterSpacing: -0.3
        //     font.bold: true              
        // }   
        Rectangle{
	    	id: legend
	        height:24
	        width:32
	        color:"#444"
	        radius:8
	        anchors.top: parent.top
            anchors.topMargin: 15
	        //anchors.right: header_time.left  
            anchors.right: parent.right
	        anchors.leftMargin: 0
            //anchors.rightMargin: 5
            anchors.rightMargin: 32
	        Text{
	             text: "ZR"
	             color:"white"         
	             font.pixelSize: 14
	             font.letterSpacing: -0.3
	             font.bold: true              
	             anchors.verticalCenter: parent.verticalCenter
	             anchors.horizontalCenter: parent.horizontalCenter
	        }
        }

    }

    property var emptyModel: {
        return {  title: "No Favorites",
                favorite: true 
            }
    }

    ListModel {
        id: emptyListModel
        ListElement { 
            isEmptyRow: true
            emptyTitle: "No Favorites"
        }
    }

    property var gamesItems: {
        if (showAllItems) {
            return currentCollectionGamesSorted
        } else if (collectionFilterMode == "favorites" && currentCollectionGamesSortedFiltered.count == 0) {
            return emptyListModel
        } else {
            return currentCollectionGamesSortedFiltered
        }
    }

    function onSeeAllEvent() {
        showAllItems = true
    }
    FocusScope {
        id: listFocus
        focus: currentPage === "GamesPage" && !showSort ? true : false ;
        width: parent.width
        height: parent.height
        anchors.top: header.bottom
        anchors.bottom: footer.top
        
        GamesList {
            id: gameList
            defaultIndex: collectionListIndex
            width: parent.width
            height: parent.height 
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            gamesColor: systemColor            
            items:  gamesItems
            showSeeAll: collectionFilterMode == "favorites" && !showAllItems
            hideFavoriteIcon: collectionFilterMode == "favorites" && !showAllItems
            onSeeAll: onSeeAllEvent
            focus: true
        }
    }

    SortModal {
        active: showSort
        sortColor: systemColor
    }
}
