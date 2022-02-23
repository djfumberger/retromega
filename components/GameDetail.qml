import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15

Item { 
    id: gameDetail
    property var active: false
    property var game: null
    property var showFullDescription: false
    property var pauseScreenshotVideo: false
    //visible: active

    onGameChanged: {
        //console.log(game.assets.video)
    }

    property var mainGenre: {
        if (game.genreList.lenght == 0) { return null }
        var g = game.genreList[0]
        var s = g.split(',')
        return s[0]
    }
    
    property var players: {
        if (!game) { return null }
        if (game.players > 0) {
            return game.players + " Player" + (game.players > 1 ? "s" : "")
        } else {
            return null
        }
    }

    property var playerGenre : {
        return [players, mainGenre].filter(v => { return v != null }).join(" • ")
    }

    property var releaseDate: {
        if (!game) { return "" }
        return (game.releaseYear)  ? "Released " + game.releaseYear : ""
    }

    property var developedBy: {
        if (!game) { return "" }
        return "Developed By " + game.developer
    }

    property var textColor: {
        return theme.bodyText// "#333333"
    }

    property var margin: {
        return 32
    }

    property var introDescription: {
        if (!game) { return "" }    
        return game.description.replace("\n"," ")
    }

    property var gameIsFavorite: {
        if (game) {
            return game.modelData.favorite
        } else {
            return false
        }
    }
    property var gameScreenshot: {
        if (game) {
            return game.assets.screenshot
        } else {
            return null
        }
    }
    property var gameVideo: {
        if (game) {
            return game.assets.video
        } else {
            return null
        }
    }
        property var textScroll: 10

    Keys.onPressed: {     
         if (api.keys.isFilters(event)) {
            setCurrentTheme(currentTheme == 'light' ? 'dark' : 'light')
            event.accepted = true;
            return true;
        }
                                
        if (event.key == '1048586') {
            pauseScreenshotVideo = !pauseScreenshotVideo
        }
        if (api.keys.isCancel(event) && active) {
            event.accepted = true
            showGameDetail(false)
        }
    }

    /** 
    * Background
    */
    Rectangle {
        color: theme.background
        anchors.fill: parent
        opacity: 1.0    
    }

    // Content
    FocusScope {
        id: gameDetailContent
        anchors.fill: parent
        anchors.bottom: footer.top
        clip: true
        focus: active && !showFullDescription
        

        /** 
         * Header
         */
        Item {
            id: gameDetailHeader
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: margin
            anchors.rightMargin: margin
            anchors.topMargin: 35
            height: 225


            Text {
                id: title
                width: (parent.width / 2) - margin - 20
                wrapMode: Text.WordWrap
                anchors.left: parent.left
                anchors.top: parent.top
                maximumLineCount: 2
                text: game ? game.title : "No Game"
                lineHeight: 1.1
                color: textColor
                font.pixelSize: 24
                font.letterSpacing: -0.35
                font.bold: true
            }

            /** 
             * Title
             */
            ColumnLayout {
                anchors.left: parent.left
                anchors.top: title.bottom 
                spacing: 8
                anchors.topMargin: 4
                width: (parent.width / 2) - margin  

                Text {
                    text: playerGenre
                    color: textColor
                    opacity: 0.5
                    font.pixelSize: 18
                    font.letterSpacing: -0.35
                    font.bold: true
                    width: parent.width
                    anchors.left: parent.left
                    anchors.right: parent.right
                    wrapMode: Text.WordWrap
                    maximumLineCount: 4                    
                }

                Text {
                    text: releaseDate
                    color: textColor
                    opacity: 0.5
                    font.pixelSize: 18
                    font.letterSpacing: -0.35
                    font.bold: true 
                }   

                // Text {
                //     text: developedBy
                //     color: textColor
                //     opacity: 0.5
                //     font.pixelSize: 18
                //     font.letterSpacing: -0.35
                //     font.bold: true
                // }   

            }

            /** 
             * Buttons
             */
            RowLayout {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                spacing: 10
                ActionButton {
                    id: actionPlay
                    title: "Play"
                    icon: "play"
                    focus: true
                    height: 40
                    width: 120
                    textColor: gameDetail.textColor
                    KeyNavigation.right: actionFavorite   
                    KeyNavigation.down: gameDetailText
                    Keys.onPressed: {           
                        // Start Game           
                        if (api.keys.isAccept(event)) {
                            startGame(game.modelData, currentGameDetailIndex)
                        }
                    }

                }
                ActionButton {
                    id: actionFavorite
                    textColor: gameDetail.textColor
                    KeyNavigation.left: actionPlay  
                    KeyNavigation.down: gameDetailText   
                    title: gameIsFavorite ? "Unfavorite" : "Favorite"
                    icon: gameIsFavorite ? "favorite-on" : "favorite-off"
                    focus: false
                    height: 40
                    width: 120

                    Keys.onPressed: {    
                         
                        // Favorite          
                        if (api.keys.isAccept(event)) {                            
                            game.modelData.favorite = !game.modelData.favorite
                            event.accepted = true;
                        }
                    }

                }
            }

            /**
             * Screenshot
             */
            GameScreenshot {
                height: 210
                width: 280
                anchors.right: parent.right
                anchors.top: parent.top                 
                screenshot: gameScreenshot
                video: gameVideo
                active: gameDetail.active
                pauseVideo: showFullDescription || pauseScreenshotVideo
            }

        }        

        /**
         * Detail Text
         */
        Item {
            id: gameDetailText
            anchors.top: gameDetailHeader.bottom
            //anchors.topMargin: 20
            anchors.topMargin: 24
            anchors.leftMargin: margin
            anchors.rightMargin: margin
            anchors.left: parent.left
            anchors.right: parent.right
            //height: 100
            visible: introDescription.length > 0 
            height: 127

            // Rectangle {
            //     anchors.fill: parent
            //     anchors.leftMargin: -15
            //     anchors.rightMargin: -15
            //     anchors.bottomMargin: -15
            //     radius: 8
            //     color: "#000000"
            //     opacity: parent.activeFocus ? 0.1 : 0.0
            // }

            Keys.onPressed: {           
                // Back to Home            
                if (api.keys.isAccept(event)) {
                    showFullDescription = true
                    event.accepted = true;
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                anchors.top: parent.top
                color: theme.separator
            }

            // Rectangle {
            //     anchors.left: parent.left
            //     anchors.right: parent.right
            //     height: 1
            //     anchors.bottom: parent.bottom
            //     anchors.bottomMargin: -12
            //     color: textColor
            //     opacity: 0.1
            // }

            Text {
                text: introDescription
                anchors.top: parent.top
                anchors.topMargin: 18
                anchors.leftMargin: parent.left
                anchors.rightMargin: parent.right
                wrapMode: Text.WordWrap
                //color: parent.activeFocus ? "#50000000" : textColor
                color: textColor
                font.pixelSize: 18
                font.letterSpacing: -0.1
                font.bold: true  
                lineHeight: 1.2 
                elide: Text.ElideRight
                width: parent.width
                maximumLineCount: 4
            }

            Rectangle {
                id: moreButton
                color: parent.activeFocus ? systemColor : theme.background
                width: 54
                height: 24
                visible: true
                anchors.right: parent.right
                anchors.rightMargin: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                radius: 4

                Text {
                    font.pixelSize: 13
                    font.letterSpacing: -0.1
                    font.bold: true  
                    text: "MORE"
                    color: parent.parent.activeFocus ? "white" : systemColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            DropShadow {
                anchors.fill: moreButton
                horizontalOffset: -6
                verticalOffset: 3
                radius: 10.0
                samples: 10
                color: theme.background
                source: moreButton
            }
        }

        // Item {
        //     anchors.top: gameDetailText.bottom  
        //     anchors.topMargin: 30
        //     anchors.left: parent.left
        //     anchors.right: parent.right
        //     anchors.leftMargin: margin
        //      Text {
        //         text: "More by " + game.developer
        //         wrapMode: Text.WordWrap
        //         color: textColor
        //         opacity: parent.activeFocus ? 1.0 : 1.0
        //         font.pixelSize: 18
        //         font.letterSpacing: -0.1
        //         font.bold: true  
        //         lineHeight: 1.0
        //         width: parent.width
        //         maximumLineCount: 1
        //     }
        // }
    }

    
    GameDetailFooter {
        id: footer
        anchors.bottom: parent.bottom
        visible: !showFullDescription
    }


    Item {  
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        visible: showFullDescription
        //height: 280
        //height: 392
        height: 480
        focus: showFullDescription

        property var scrollMoveAmount : 100
        Keys.onDownPressed: {
            var maxHeight =  textElement.paintedHeight - (480 - 50 - 50)

            textScroll = Math.max(Math.min(textScroll + scrollMoveAmount, maxHeight), 10)
        }

        Keys.onUpPressed: {
            textScroll = Math.max(textScroll - scrollMoveAmount, 10)
        }

        Keys.onPressed: {           
            // Back to Home            
            if (api.keys.isCancel(event)) {
                if (showFullDescription) {
                    showFullDescription = false
                    event.accepted = true
                }
            }
        }



        Rectangle {
            color: theme.background
            anchors.fill: parent
            opacity: 1.0
        }

        Image {
            id: boxart
            source: gameScreenshot 
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        FastBlur {
            id: blurOne
            anchors.fill: parent
            source: gameDetailContent
            radius: 80
            opacity: 0.5
        }

        // FastBlur {
        //     id: blurTwo
        //     anchors.fill: blurOne
        //     source: blurOne
        //     radius: 125
        //     opacity: 0.5
        // }

        Text {
            id: textElement
            text: game.description
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top            
            anchors.leftMargin: 50
            anchors.rightMargin: 50
            anchors.topMargin: 50 - textScroll
            font.pixelSize: 18
            font.letterSpacing: -0.35
            font.bold: true
            wrapMode: Text.WordWrap
            maximumLineCount: 2000
            lineHeight: 1.2
            color: theme.bodyText
            Behavior on anchors.topMargin {
                PropertyAnimation { easing.type: Easing.OutCubic; duration: 200  }
            }                
        }
        
    }
}