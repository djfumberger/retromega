import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: gamesPage
    anchors.leftMargin: 200 
    
    property var showSort : false
    property alias currentIndex: gameList.currentIndex
    property alias showIndex: gameList.showIndex

    property var footerTitle: {
        return gameList.footerTitle
    }
    
    property var systemColor: {
        systemColors[currentCollection.shortName] || "#000000" 
    }

    property var headerTitle: {
        return (collectionShowAllItems) ? "All " + currentCollection.name : currentCollection.name
    }
    
    property var showIndex: false
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

        if (collectionFilterMode == "favorites" && !collectionShowAllItems) {
            return "Favorites, " + title 
        }  else {
            return title
        }
    }

    property var onShow: function() {
        currentIndex = collectionListIndex
    }

    property var isFavoritesList: {
        return (collectionFilterMode == "favorites" && !collectionShowAllItems)
    } 

    function onSeeAllEvent() {        
        setCollectionListIndex(0)
        setCollectionShowAllItems(true)    
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
            showIndex = false
            showSort = !showSort
            return;
        }  

        // Back to Home            
        if (api.keys.isCancel(event)) {
            event.accepted = true
            if (showIndex == true) {
                showIndex = false
            } else if (showSort) {
                showSort = false
                backSound.play()
            } else if (collectionShowAllItems) {
                showIndex = false                
                gameList.currentIndex = -1
                gameList.box_art.initialLoad = true
                setCollectionShowAllItems(false)
                backSound.play()
            } else {
                showIndex = false
                gameList.currentIndex = -1
                gameList.box_art.initialLoad = true
                navigate('HomePage');
            }
            return
        }  

        event.accepted = false
    }

    Rectangle {
        id: background
        color: theme.background
        anchors.fill: parent
    }
    
    Rectangle {
        id: footer
        color: "transparent"
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
            visible: collectionFilterMode == "all" || collectionShowAllItems
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
        color: "transparent"
        width: 640
        height: 55
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.top: parent.top
        clip:true

        Rectangle {
            anchors.leftMargin: 22
            anchors.rightMargin: 22
            anchors.left: parent.left
            anchors.right: parent.right
            color: "#e3e3e3"
            anchors.bottom: parent.bottom
            height: 1
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
        if (collectionShowAllItems) {
            return currentCollectionGamesSorted
        } else if (collectionFilterMode == "favorites" && currentCollectionGamesSortedFiltered.count == 0) {
            return emptyListModel
        } else {
            return currentCollectionGamesSortedFiltered
        }
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
            indexItems: gamesPage.isFavoritesList ? currentFavorites : currentCollection.games
            context: collectionShowAllItems ? "all" : "default"
            showSeeAll: gamesPage.isFavoritesList
            hideFavoriteIcon: gamesPage.isFavoritesList
            onSeeAll: onSeeAllEvent
            sortMode: collectionSortMode
            sortDirection: collectionSortDirection
            focus: true
        }
    }

    SortModal {
        active: showSort
        sortColor: systemColor
    }
}
