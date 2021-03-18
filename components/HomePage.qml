import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: homepage  
    width: parent.width
    height: parent.height

    property var currentView: {
        switch (currentHomeIndex) {
        case 0: 
            return systemsListView
        case 1:
            return favoriteView
        case 2: 
            return recentsView
        case 3:
            return appsView
        default: 
            return ""
        }
    }

    property var currentContentView: {
        switch (currentHomeIndex) {
        case 0: 
            return systemsListView
        case 1:
            return favoritesLoader.item
        case 2: 
            return recentsLoader.item
        case 3:
            return appsLoader.item
        default: 
            return null
        }
    }

    property var footerTitle: {
        return currentContentView.footerTitle
    }

    Keys.onPressed: {                                            

        // Prev
        if (api.keys.isPageUp(event)) {
            event.accepted = true
            setHomeIndex(Math.max(currentHomeIndex - 1,0))
            navSound.play()
            return
        }  
        
        // Next
        if (api.keys.isPageDown(event)) {
            event.accepted = true;
            setHomeIndex(Math.min(currentHomeIndex + 1,3))
            navSound.play();
            return;
        }  

    }  

    Rectangle {
        id: rect
        anchors.fill: parent
        color: currentHomeIndex == 0 ? "#FEFEFE" : "transparent"
    }

    HeaderHome {
        id: header
        z: 1
        light: (currentHomeIndex == 0 && currentPage === "HomePage")
    }

    Footer {
        id: footer
        title: footerTitle
        light: (currentHomeIndex == 0 && currentPage === "HomePage")
        anchors.bottom: homepage.bottom
        visible: true
        z: (currentHomeIndex == 0) ? 1 : 0
    }


    FocusScope {
        id: mainFocus
        focus: currentPage === "HomePage" && !isShowingGameDetail ? true : false ;

        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: footer.top
        }

        Keys.onPressed: {                                            
            // Back to Home            
            if (api.keys.isCancel(event)) {
                if (currentContentView && currentContentView.showIndex) {
                    currentContentView.showIndex = false
                } else {
                    header.focused_link.forceActiveFocus()
                }
                event.accepted = true;                    
            } else {
                event.accepted = false;                
            }
        }

        Rectangle {
            id: main
            color: "transparent"
            anchors {
                fill: parent
            }
                        
            Rectangle {
                id: main_content
                color: "transparent"
                anchors {
                    fill: parent
                }

                // Systems        
                SystemsListLarge {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: parent.width
                    visible: currentHomeIndex == 0
                    focus: currentHomeIndex == 0
                    headerFocused: header.anyFocused
                    id: systemsListView
                }
                
                // Favourites
                Component {
                    id: favoriteView                    
                    GamesList {
                        id: favoritesContentView
                        width: parent.width
                        height: parent.height
                        items: allFavorites   
                        indexItems: allFavorites   
                        sortMode: "title"
                        focus: true && !isShowingGameDetail
                        hideFavoriteIcon: true
                    }
                }

                Loader  {
                    id: favoritesLoader
                    focus: currentHomeIndex == 1
                    active: opacity !== 0
                    opacity: focus ? 1 : 0
                    anchors.fill: parent
                    sourceComponent: favoriteView
                    asynchronous: false
                }                

                // Recents
                Component {
                    id: recentsView                    
                    GamesList {
                        id: recentsContentView
                        width: parent.width
                        height: parent.height
                        items: allRecentlyPlayed      
                        indexItems: allRecentlyPlayed
                        sortMode: "recent"
                        focus: true  && !isShowingGameDetail
                    }
                }

                Loader  {
                    id: recentsLoader
                    focus: currentHomeIndex == 2
                    active: opacity !== 0
                    opacity: focus ? 1 : 0
                    anchors.fill: parent
                    sourceComponent: recentsView
                    asynchronous: false
                }  

                // Apps
                Component {
                    id: appsView                    
                    GamesList {
                        id: appsContentView
                        width: parent.width
                        height: parent.height
                        items: androidCollection.games      
                        indexItems: androidCollection.games
                        sortMode: "title"
                        visible: currentHomeIndex == 3
                        focus: currentHomeIndex == 3 && !isShowingGameDetail
                    }          
                }

                Loader  {
                    id: appsLoader
                    focus: currentHomeIndex == 3
                    active: opacity !== 0
                    opacity: focus ? 1 : 0
                    anchors.fill: parent
                    sourceComponent: appsView
                    asynchronous: false
                }  

            } 
        }  
    }
}