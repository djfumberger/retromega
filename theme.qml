import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtMultimedia 5.9
import SortFilterProxyModel 0.2

import 'components' as Components

FocusScope {
    id: root

    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    Component.onCompleted: {
        currentHomeIndex = api.memory.get('homeIndex') ?? 0
        currentCollectionIndex = api.memory.get('currentCollectionIndex') ?? 0
        currentPage = api.memory.get('currentPage') ?? 'HomePage'
        collectionListIndex = api.memory.get('collectionListIndex') ?? 0
        collectionSortMode = api.memory.get('collectionSortMode') ?? "sortBy"
        collectionSortDirection =  api.memory.get('collectionSortDirection') ?? 0
        collectionFilterMode =  api.memory.get('collectionFilterMode') ?? "all"
        collectionShowAllItems =  api.memory.get('collectionShowAllItems') ?? false
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

    // Collection list index
    property var collectionShowAllItems : false
    function setCollectionShowAllItems(show) {
        api.memory.set('collectionShowAllItems', show)
        collectionShowAllItems = show
    }

    // Games index
    property var currentGameIndex: 0
    property var currentGame: {return currentCollection.games.get(currentGameIndex)}

    // Main homepage index
    property var currentHomeIndex: 0

    // Collection sort mode
    // Collection list index
    property var collectionSortMode : "sortBy"
    property var collectionSortDirection : 0
    property var collectionFilterMode : "all"
    property var currentTheme : "dark"

    function setCollectionSortMode(sortMode) {
        api.memory.set('collectionSortMode', sortMode)

        var direction = collectionSortDirection == 0 ? 1 : 0
        if (collectionSortMode != sortMode || sortMode == "lastPlayed" || sortMode == "rating")  {

            switch (sortMode) {
                case "sortBy": {
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

    function setCurrentTheme(theme) {
        currentTheme = theme
    }

    property var currentGameDetail : null
    property var currentGameDetailIndex : 0
    property var isShowingGameDetail : false
    function showGameDetail(game, index) {
        if (game) {
            forwardSound.play()
            currentGameDetail = game
            currentGameDetailIndex = index
            isShowingGameDetail = true
        } else {
            backSound.play()
            isShowingGameDetail = false
        }
    }

    // When the game is launching
    property var launchingGame : false
    function startGame(game, index) {
        currentGameIndex = index
        setCollectionListIndex(index)
        launchSound.play()
        launchingGame = true
        delay(400, function() {
            game.launch()
        })
    }

    property var systemColor: {
        if (currentPage === 'GamesPage') {
            return systemColors[currentCollection.shortName] || "#000000"
        } else {
            if (currentTheme == 'dark') {
                return "#ffffff"
            } else {
                return "#000000"
            }
        }
    }

    property var lightTheme : {
        "background"         : "#F3F3F3",
        "text"               : "#70000000",
        "title"              : "#444",
        "footerText"         : "#9B9B9B",
        "navBorder"          : "#20000000",
        "separator"          : "#10000000",
        "headerText"         : "#9B9B9B",
        "headerLinkText"     : "#60000000",
        "headerLinkActive"   : "#ffffff",
        "headerLinkSelected" : "#000000",
        "bodyText"           : "#333333",
        "buttonSelected"     : "#000000",
        "buttonUnselected"   : "#ffffff",
        "listRowColor"       : "#333333",
        "listText"           : "#333333",
        "listTextSelected"   : "#ffffff",
    }

    property var darkTheme : {
        "background"         : "#181818",
        "text"               : "#70ffffff",
        "title"              : "#fff",
        "footerText"         : "#70ffffff",
        "headerText"         : "#70ffffff",
        "navBorder"          : "#15ffffff",
        "separator"          : "#15ffffff",
        "headerLinkText"     : "#60ffffff",
        "headerLinkActive"   : "#ffffff",
        "headerLinkSelected" : "#ffffff",
        "bodyText"           : "#60ffffff",
        "buttonSelected"     : "#ffffff",
        "buttonUnselected"   : "#2F2F2F",
        "listRowColor"       : "#333333",
        "listText"           : "#60ffffff",
        "listTextSelected"   : "#ffffff",
    }

    property var theme : {
        return (currentTheme == "light") ? lightTheme : darkTheme
    }

    property var systemColorsDefault : {
        "gg"       : "#011DA9",
        "gamegear" : "#FFAA22",
        "snes"     : "#AA6AFF",
        "ngp"     : "#AA6AFF",
        "genesis"  : "#DF535B",
        "neogeo"   : "#1499DE",
        "android"  : "#5BFF92",
        "mastersystem"  : "#2F34C2",
        "neogeocd"  : "#EFC323",
        "gb"        : "#1DA1DC",
        "gba"      : "#342692",
        "gbc1"      : "#EE60A5",
        "gbc"      : "#7B4CCC",
        "pcengine" : "#FF955B",
        "tg16"     : "#FF955B",
        "nes"      : "#C85173",
        "n64"      : "#FF5B5B",
        "nds"      : "#EFC323",
        "psx"      : "#F0CC40",
        "sega32x"      : "#6935E9",
        "segacd"      : "#C85173",
        "saturn"      : "#0D4CFB",
        "dreamcast"   : "#2387FF",
        "psp"         : "#4E0B9C",
        "default"     : "#2387FF",
        "system"      : "#000000",
        "saturn"      : "#2387FF",
        "atari2600"      : "#1DA1DC",
        "atari7800"      : "#FF5B5B",
        "atarilynx"      : "#AA6AFF",
    }

    property var systemColorsDark: {
        "nds"      : "#E7C13A",
        "system"   : "#333333"
    }

    property var systemColors: {
        var c = systemColorsDefault
        for(var key in systemColorsDark) {
            c[key] = systemColorsDark[key]
        }
        return c
        //return systemColorsDefault + systemColorsDark
    }

    property var systemCompanies: {
        "dreamcast"  : "Sega",
        "gg"         : "Sega",
        "gamegear"   : "Sega",
        "genesis"    : "Sega",
        "megadrive"  : "Sega",
        "segacd"  : "Sega",
        "megacd"  : "Sega",
        "mastersystem"  : "Sega",
        "sega32x"  : "Sega",
        "saturn"   : "Sega",
        "neogeo"   : "SNK",
        "neogeocd" : "SNK",
        "ngp"      : "SNK",
        "gb"       : "Nintendo",
        "gba"      : "Nintendo",
        "gbc"      : "Nintendo",
        "snes"     : "Nintendo",
        "nes"      : "Nintendo",
        "n64"      : "Nintendo",
        "nds"      : "Nintendo",
        "pcengine" : "NEC",
        "tg16"     : "NEC",
        "psx"      : "Sony",
        "psp"      : "Sony",
        "atari2600": "Atari",
        "atari7800": "Atari",
        "atarilynx": "Atari"
    }

    property var layoutScreen : {
        "width": parent.width,
        "height": parent.height,
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
        "height": parent.height - layoutHeader.height - layoutHeader.height,
        "background": "transparent",

    }

    function navigate(page){
        setCurrentPage(page)
        if (page == 'HomePage') {
            backSound.play()
        } else {
            forwardSound.play()
        }
        if (page == 'GamesPage') {
           gamesPage.onShow()
        }
    }

    function checkToggleTheme() {
        if (api.keys.isFilters(event)) {
            setCurrentTheme(currentTheme == 'light' ? 'dark' : 'light')
            event.accepted = true;
            return true;
        }
        return false;
    }

    Keys.onPressed: {
        checkToggleTheme()
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



        // Home Page
        Components.HomePage {
            visible: currentPage === 'HomePage' ? 1 : 0 ;
        }

        // Games Page
        Components.GamesPage {
            id: gamesPage
            visible: currentPage === 'GamesPage' ? 1 : 0 ;
            opacity: 1.0
            transitions: Transition {
                NumberAnimation { properties: "opacity"; easing.type: Easing.InCubic; duration: 200  }
            }


        }

        // Game Detail
        Component {
            id: gameDetail
            Components.GameDetail {
                //visible: isShowingGameDetail
                id: gameDetailContentView
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                opacity: 1.0
                active: isShowingGameDetail
                game: currentGameDetail

                transitions: Transition {
                    NumberAnimation { properties: "opacity"; easing.type: Easing.OutCubic; duration: 1600  }
                }

            }

        }

        Loader  {
            id: gameDetailLoader
            focus: isShowingGameDetail
            active:  isShowingGameDetail
            anchors.fill: parent
            sourceComponent: gameDetail
            asynchronous: false
        }

    }

    /**
        Loading Game Overlay
    */
    Rectangle {
        id: loading_overlay
        opacity: 0.0
        color: "#000000"
        anchors {
            fill: parent
        }
        states: [

            State{
                name: "default"; when: !launchingGame
                PropertyChanges { target: loading_overlay; opacity: 0.0}
            },

            State{
                name: "active"; when: launchingGame
                PropertyChanges { target: loading_overlay; opacity: 1.0}
            }

        ]

        transitions: Transition {
            NumberAnimation { properties: "opacity"; easing.type: Easing.Out; duration: 350  }
        }
        z: 2002
    }
}