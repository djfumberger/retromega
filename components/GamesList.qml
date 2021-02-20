import QtQuick 2.12
import QtGraphicalEffects 1.12

Item { 
    id: listContent

    property var context : "default"
    
    property var listIdentifier: {
        return gameView
    }

    property var footerTitle: {
        if (items.count > 0) {
            return (gameView.currentIndex + 1) + " of " + items.count
        } else if (items.count > 0) {
            return items.count
        } else {
            return "No Games"
        }
    }

    property var gamesColor : "#000000"
    property var selectedGame: {
        return gameView.currentIndex >= 0 ? items.get(gameView.currentIndex) : items.get(0)
    } 
    property var viewType : 'list'
    property alias currentIndex : gameView.currentIndex
    property alias box_art : game_box_art
    property var hideFavoriteIcon : false
    property var defaultIndex: 0
    property var launchingGame : false
    property var items : []
    property var indexItems : []
    property var showIndex : false
    property var focusSeeAll : false
    property var maintainFocusTop : false
    property var selectSeeAll : {
        if (showSeeAll) {
            if (focusSeeAll) {
                return true
            } else {
                if (items.count == 1 && !items.get(0).modelData) {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }

    property var showSeeAll : false
    property var onSeeAll : { }
    property var onIndexChanged : function(title, index, total) {
        
    }

    onShowIndexChanged: {
        if (showIndex) {
            maintainFocusTop = true
        } else {
            maintainFocusTop = false 
            listContent.focus = true
        }
    }

    Keys.onRightPressed: {
        showIndex = false
    }

    Keys.onLeftPressed: {
        showIndex = true
    }

    Keys.onPressed: {
        // Show / Hide Index
        if (api.keys.isPageUp(event)) {
            event.accepted = true;
            showIndex = !showIndex
            return;
        }  
        if (api.keys.isAccept(event) && showIndex) {
            event.accepted = true;
            showIndex = false;
            return
        }
    }
    
    function isLastRow(currentIndex) {
        if (currentIndex == items.count - 1) {
            return true
        } else {
            return false
        }
    }

    function rowHeight(index) {
        if (isLastRow(index) && showSeeAll) {
            return 42 + 46
        } else {
            return 42
        }
    }

    function updatedIndex() {
        onIndexChanged(gameView.currentIndex, items.count)
    }

    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }


    Rectangle {
        id: mainListContent
        color: "transparent"
        width: parent.width                
        height: parent.height               
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    

        ListIndex {
            id: listIndex
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 30
            focus: showIndex
            active: showIndex
            listItems: indexItems // Faster to avoid using sortproxymodel 
            anchors.topMargin: 16
            anchors.bottomMargin: 16
            anchors.leftMargin: -50
            onIndexChanged: function (index, indexValue) {
                gameView.currentIndex = index
            }
            transitions:[ 
                Transition {
                    NumberAnimation { properties: "anchors.leftMargin"; easing.type: Easing.OutCubic; duration: 350  }
                }
            ]            
        }

        /**
        * -----
        * Games List
        * ----
        */
        Rectangle {
            id: games
            visible: true
            color: "transparent"
            width: parent.width / 2
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            clip: true
             

            states: [ 
                State{
                    name: "hidden"; when: !showIndex
                    PropertyChanges { target: listIndex; anchors.leftMargin: -50}
                    PropertyChanges { target: games; anchors.leftMargin: 0}
                },

                State{
                    name: "active"; when: showIndex
                    PropertyChanges { target: listIndex; anchors.leftMargin: 24}
                    PropertyChanges { target: games; anchors.leftMargin: 32}
                }
            ]    

            transitions:[ 
                Transition {
                    NumberAnimation { properties: "anchors.leftMargin"; easing.type: Easing.OutCubic; duration: 350  }
                }
            ]     

            ListView {
              id: gameView
              model: items
              delegate: gameViewDelegate
              height: parent.width
              width: parent.height
              anchors.left: parent.left
              anchors.bottom: parent.bottom
              anchors.margins: 32    
              anchors.bottomMargin: 12
              anchors.topMargin: 12
              anchors.top: parent.top
              currentIndex: defaultIndex
              snapMode: ListView.SnapOneItem
              preferredHighlightBegin: 0; preferredHighlightEnd: 0
              highlightRangeMode: maintainFocusTop ? ListView.ApplyRange : ListView.NoHighlightRange

              highlightMoveDuration: 0
              focus: listContent.activeFocus
                Keys.onUpPressed: { 
                    if (focusSeeAll) {
                        focusSeeAll = false
                    } else if (gameView.currentIndex == 0) {
                        event.accepted = false
                    } else {
                        decrementCurrentIndex();
                        event.accepted = true
                    }
                    navSound.play(); 
                }      

                Keys.onDownPressed:     { 
                    if (gameView.currentIndex == items.count - 1 && showSeeAll) {
                        focusSeeAll = true
                    } else {
                        incrementCurrentIndex(); 
                        event.accepted = true
                    }
                    navSound.play(); 
                }

              move: Transition {
                 NumberAnimation { properties: "x,y,contentY"; duration: 100 }
              }
              moveDisplaced: Transition {
                 NumberAnimation { properties: "x,y"; duration: 100 }
              }
            } 

            Component.onCompleted: { 
                gameView.positionViewAtIndex(defaultIndex, ListView.Center)
                delay(50, function() {
                    gameView.positionViewAtIndex(defaultIndex, ListView.Center)
                })
                //currentIndex = currentCollectionIndex
            }
            
            Component {
                id: gameViewDelegate

                Item {
                  id: gameViewDelegateContainer
                  width: games.width - 12 - 12 - 12
                  height: rowHeight(index)
                  
                  Keys.onPressed: {                                            
                        //Launch game
                        if (api.keys.isCancel(event)) {
                            if (showSeeAll) {
                                focusSeeAll = false
                            }
                        }
                        if (api.keys.isAccept(event)) {
                            event.accepted = true;

                            if (selectSeeAll) {                                
                                focusSeeAll = false
                                navSound.play()
                                //gameView.currentIndex = 0
                                onSeeAll()
                            } else {
                                currentGameIndex = index
                                launchSound.play()
                                launchingGame = true

                                setCollectionListIndex(index)

                                delay(400, function() {
                                    modelData.launch()
                                })                  
                            }                            
                            return;
                        }

                        // Details
                        if (api.keys.isDetails(event) && !hideFavoriteIcon) {
                            modelData.favorite = !modelData.favorite
                            event.accepted = true
                            navSound.play()                       
                            return
                        }

                        //Next page
                        if (api.keys.isNextPage(event)) {
                           event.accepted = true
                           navSound.play()
                           gameView.currentIndex = Math.min(gameView.currentIndex + 10, items.count - 1)
                           return
                        }  
                        
                        //Prev collection
                        if (api.keys.isPrevPage(event)) {
                            event.accepted = true;
                            gameView.currentIndex = Math.max(gameView.currentIndex - 10, 0);
                            navSound.play();
                            return;
                        }  

                        event.accepted = false
                  }  

                  ListRow {
                    title: modelData ? modelData.title : emptyTitle
                    //title: modelData.title
                    selected: parent.ListView.isCurrentItem && gameView.activeFocus && !selectSeeAll && modelData ? true : false
                    width: parent.width
                    emptyStyle: modelData ? false : true
                    height: 42
                    rowColor: gamesColor
                    favorite: modelData.favorite && !hideFavoriteIcon
                  }

                  Item {
                      id: see_all
                      width: parent.width
                      height: 42
                      visible: isLastRow(index) && showSeeAll
                      anchors.top: parent.top
                      anchors.topMargin: 48 
                      Rectangle {
                          width: parent.width
                          anchors.top: parent.top
                          height: 1
                          color: "black"
                          opacity: 0.1
                      }
                      ListRow {
                          title: "See All"
                          selected: selectSeeAll
                          width: parent.width
                          anchors.bottom: parent.bottom
                          height: 42
                          rowColor: gamesColor
                          favorite: false
                      }
                  }

                }
            }

        }

        /**
         Loading Overlay
        */
        Rectangle {
            id: loading_overlay
            opacity: 0.0
            color: "#000000"
            anchors {
                fill: parent
                bottomMargin: -100
                topMargin: -100
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

        Rectangle {
            id: game_detail
            visible: true
            color: "transparent"
            width: 320
            height: parent.height
            anchors.rightMargin: 0
            anchors.right: parent.right
            anchors.top: header.top
            anchors.bottom: parent.bottom
            z: 2001

            states: [ 
                State{
                    name: "indexHidden"; when: !showIndex
                    PropertyChanges { target: game_detail; anchors.rightMargin: 0}
                },

                State{
                    name: "indexActive"; when: showIndex
                    PropertyChanges { target: game_detail; anchors.rightMargin: -16}
                }
            ]    

            transitions:[ 
                Transition {
                    NumberAnimation { properties: "anchors.rightMargin"; easing.type: Easing.OutCubic; duration: 350  }
                }
            ]   

            BoxArt {
                id: game_box_art
                asset: selectedGame && gameView.currentIndex >= 0 && !focusSeeAll ? selectedGame.assets.boxFront : ""
                context: currentCollection.shortName + listContent.context
             }

        }
    }
}
