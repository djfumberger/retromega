import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15

Item { 
    id: gameDetail
    property var active: false
    property var game: null
    property var showFullDescription: false
    visible: active

    onGameChanged: {
        console.log(game.assets.video)
    }

    property var mainGenre: {
        var g = game.genreList[0]
        var s = g.split(',')
        return s[0]
    }
    property var players: {
        return game.players + " Player" + (game.players > 1 ? "s" : "") + ", "
    }
    property var releaseDate: {
        return "Released " + game.releaseYear
    }
    property var developedBy: {
        return "Developed By " + game.developer
    }

    property var textColor: {
        return "#333333"
    }
    property var margin: {
        return 32
    }
    property var introDescription: {
        return game.description.replace("\n"," ")
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
                text: game.title
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
                width: (parent.width / 2) - margin - 20

                Text {
                    text: players + mainGenre
                    color: textColor
                    opacity: 0.5
                    font.pixelSize: 18
                    font.letterSpacing: -0.35
                    font.bold: true
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
                        // Back to Home     
                        
                        if (api.keys.isAccept(event)) {
                            console.log("play")      
                            
                            var g = gamesItems.get(gameList.currentIndex)
                            console.log(g.modelData) 
                            g.modelData.launch()
                        }
                    }

                }
                ActionButton {
                    id: actionFavorite
                    textColor: gameDetail.textColor
                    KeyNavigation.left: actionPlay  
                    KeyNavigation.down: gameDetailText   
                    title: game.modelData.favorite ? "Unfavorite" : "Favorite"
                    icon: game.modelData.favorite ? "favorite-on" : "favorite-off"
                    focus: false
                    height: 40
                    width: 120

                    Keys.onPressed: {    
                         
                        // Back to Home            
                        if (api.keys.isAccept(event)) {
                            
                            game.modelData.favorite = !game.modelData.favorite
                            event.accepted = true;
                            console.log("fav")      
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
                screenshot: game.assets.screenshot
                video: game.assets.video
                active: gameDetail.active
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
            height: 127

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
                color: textColor
                opacity: 0.1
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
                color: parent.activeFocus ? "#50000000" : textColor
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
            source: game.assets.screenshot  
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
            text: game.description
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top            
            anchors.leftMargin: 50
            anchors.rightMargin: 50
            anchors.topMargin: 50
            font.pixelSize: 18
            font.letterSpacing: -0.35
            font.bold: true
            wrapMode: Text.WordWrap
            maximumLineCount: 2000
            lineHeight: 1.2
        }
        
    }
}