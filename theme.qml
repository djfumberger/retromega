import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtMultimedia 5.9
import SortFilterProxyModel 0.2

import 'components' as Components

FocusScope {
    id: root  
    
    Component.onCompleted: { 
        currentHomeIndex = api.memory.get('homeIndex') ?? 0
        currentCollectionIndex = api.memory.get('currentCollectionIndex') ?? 0
        currentPage = api.memory.get('currentPage') ?? 'HomePage'
        collectionListIndex = api.memory.get('collectionListIndex') ?? 0
        collectionSortMode = api.memory.get('collectionSortMode') ?? "title"
        collectionSortDirection =  api.memory.get('collectionSortDirection') ?? 0
        collectionFilterMode =  api.memory.get('collectionFilterMode') ?? "all"
        startSound.play()
    }
  
    // Collection index
    property var currentCollectionIndex : 0
    property var currentCollection: {
        return allSystems.get(currentCollectionIndex)
    }
  
    function setCollectionIndex(index) {
        //setCollectionListIndex(0)
        api.memory.set('currentCollectionIndex', index)
        currentCollectionIndex = index
    }

    // Collection list index
    property var collectionListIndex : 0
    function setCollectionListIndex(index) {
        api.memory.set('collectionListIndex', index)
        collectionListIndex = index
    }

    // Games index
    property var currentGameIndex: 0
    property var currentGame: {return currentCollection.games.get(currentGameIndex)}
  
    // Main homepage index
    property var currentHomeIndex: 0

    // Collection sort mode
    // Collection list index
    property var collectionSortMode : "title"
    property var collectionSortDirection : 0
    property var collectionFilterMode : "all"

    function setCollectionSortMode(sortMode) {
        api.memory.set('collectionSortMode', sortMode)
        
        var direction = collectionSortDirection == 0 ? 1 : 0
        if (collectionSortMode != sortMode || sortMode == "lastPlayed" || sortMode == "rating")  { 
        
            switch (sortMode) {
                case "title": {
                    direction = 0
                    break
                }
                case "lastPlayed": {
                    direction = 1
                    break
                }
                case "rating": {
                    direction = 1
                    break
                }
                case "release": {
                    direction = 0
                    break
                }
            }
        }

        collectionSortDirection = direction
        collectionSortMode = sortMode        
        api.memory.set('collectionSortDirection', direction)
    }

    function setCollectionFilterMode(filterMode) {
        api.memory.set('collectionFilterMode', filterMode)
        collectionFilterMode = filterMode        
    }

    function setHomeIndex(index) {
        setCollectionListIndex(0)
        api.memory.set('homeIndex', index)
        currentHomeIndex = index
    }
  
    property var androidCollection: {
        return api.collections.get(0)
    }
  
    property var currentPage : 'HomePage';
    function setCurrentPage(page) {
        api.memory.set('currentPage', page)
        currentPage = page
    }

    property var theme : {
        "background": "#F3F3F3",
        "text":"#70000000",
        "title":"#444"
    } 
    
    property var systemColors : {
        "gg"       : "#011DA9",
        "gamegear" : "#011DA9",
        "snes"     : "#AA6AFF",
        "ngp"     : "#AA6AFF",
        "genesis"  : "#DF535B",
        "neogeo"   : "#1499DE",
        "android"  : "#5BFF92",
        "gb"        : "#7B4CCC",
        "gba"      : "#6935E9",
        "gbc"      : "#EE60A5",
        "pcengine" : "#FF955B",
        "nes"      : "#C85173",
        "n64"      : "#FF5B5B",
        "psx"      : "#F0CC40",
        "sega32x"      : "#6935E9",
        "segacd"      : "#C85173"
    }
    
    property var systemCompanies: {
        "gg"         : "Sega",
        "gamegear"   : "Sega",
        "genesis"    : "Sega",
        "megadrive"  : "Sega",
        "segacd"  : "Sega",
        "megacd"  : "Sega",
        "sega32x"  : "Sega",
        "neogeo"   : "SNK",
        "ngp"      : "SNK",
        "gba"      : "Nintendo",
        "gbc"      : "Nintendo",
        "snes"     : "Nintendo",
        "nes"      : "Nintendo",
        "n64"      : "Nintendo",
        "pcengine"      : "NEC",
        "psx"      : "Sony",
    }

    property var layoutScreen : {
        "width": 640,
        "height": 480,
        "background": theme.background,      
    }


    property var layoutHeader : {
        "width": layoutScreen.width,
        "height": 55,
        "background": "transparent",
    }


    property var layoutFooter : {
        "width": layoutScreen.width,
        "height": 55,
        "background": "transparent",
        
    }    

    property var layoutContainer : {
        "width": layoutScreen.width,
        "height": layoutScreen.height - layoutHeader.height - layoutHeader.height,
        "background": "transparent",
        
    }   
 
    function navigate(page){
        setCurrentPage(page)
        if (page == 'HomePage') {
            backSound.play()
        } else {
            forwardSound.play()
        }
    }
  
    //Sounds
    SoundEffect {
        id: backSound
        source: "assets/sound/sound-back.wav"
        volume: 0.5
    }   

    //Sounds
    SoundEffect {
        id: forwardSound
        source: "assets/sound/sound-forward.wav"
        volume: 0.5
    }   

    SoundEffect {
        id: navSound
        source: "assets/sound/sound-click2.wav"
        volume: 1.0
    }   

    SoundEffect {
        id: launchSound
        source: "assets/sound/sound-launch.wav"
        volume: 0.35
    }      

    SoundEffect {
        id: startSound
        source: "assets/sound/sound-start.wav"
        volume: 0.35
    }           
    
    property int lastPlayedMaximum: {
        if (allLastPlayed.count >= 50) {
            return 50
        } else {
            return allLastPlayed.count
        }
    }

    SortFilterProxyModel {
        id: allSystems
        sourceModel: api.collections
        filters: ValueFilter { roleName: "name"; value: "Android"; inverted: true; }
    }

    SortFilterProxyModel {
        id: allFavorites
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }

    SortFilterProxyModel {
        id: allRecentlyPlayed
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "lastPlayed"; value: ""; inverted: true; }
        sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
        id: filterLastPlayed
        sourceModel: allRecentlyPlayed
        filters: IndexFilter { maximumIndex: lastPlayedMaximum }
    }

    SortFilterProxyModel {
        id: currentFavorites
        sourceModel: currentCollection.games
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }

    SortFilterProxyModel {
        id: currentCollectionGamesSortedFiltered
        sourceModel: currentCollection.games
        sorters: RoleSorter { roleName: collectionSortMode; sortOrder: collectionSortDirection == 0 ? Qt.AscendingOrder : Qt.DescendingOrder }
        filters: ValueFilter { roleName: "favorite"; value: true; inverted: false; enabled: collectionFilterMode == "favorites" }
    }

    SortFilterProxyModel {
        id: currentCollectionGamesSorted
        sourceModel: currentCollection.games
        sorters: RoleSorter { roleName: collectionSortMode; sortOrder: collectionSortDirection == 0 ? Qt.AscendingOrder : Qt.DescendingOrder }
    }

    // Primary UI
    Rectangle {
        id: app
        color: theme.background
        width: layoutScreen.width
        height: layoutScreen.height
        anchors.top: parent.top

        Components.HomePage {
            visible: currentPage === 'HomePage' ? 1 : 0 ;
        }

        Components.GamesPage {
            visible: currentPage === 'GamesPage' ? 1 : 0 ;
        }  
    }   
}