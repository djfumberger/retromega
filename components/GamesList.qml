import QtQuick 2.12
import QtGraphicalEffects 1.12

Item { 
    id: listContent
    
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
    property var boxImageWidth : 1
    property var boxImageHeight : 1
    property var hideFavoriteIcon : false
    property var defaultIndex: 0
    property var launchingGame : false
    property var items : []
    property var focusSeeAll : false
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

    function update_image_size(width, height, container_size) {
      var fill = 0.65
      if (width > height) {
        fill = 0.75
      }
      boxImageWidth = size_image(width, height, container_size * fill).width
      boxImageHeight = size_image(width, height, container_size * fill).height
    }

    function size_image(width, height, max_width) {
        var imageHeight = (height / width) * max_width
        return { height: imageHeight, width: max_width }
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
            anchors.right: parent.right
            anchors.top: header.top
            anchors.bottom: parent.bottom
            z: 2001

            Rectangle {
                id: game_background_overlay
                visible: true
                color: "transparent"
                opacity: 1.0
                anchors.fill: game_background
                width: parent.width
                height: parent.height           
            }

            Item {
                id: game_box_art_container
                width: boxImageWidth
                height: boxImageHeight
                anchors.horizontalCenter: parent.horizontalCenter
                y: ((parent.height - boxImageHeight) / 2) + ((boxImageWidth > boxImageHeight) ? 0 : 0)
                visible: (selectedGame != null && selectedGame.assets.boxFront)

                Image {
                    source: "../assets/images/cover-shadow.png"
                    width: (371 / 200) * parent.width
                    height: (371 / 200) * parent.height
                    fillMode: Image.PreserveAspectFill
                                      anchors.horizontalCenter: parent.horizontalCenter
                  anchors.verticalCenter: parent.verticalCenter

                }

                Image {
                  anchors.horizontalCenter: parent.horizontalCenter
                  anchors.verticalCenter: parent.verticalCenter
                  property bool rounded: true
                  id: game_box_art
                  smooth: true
                  property bool adapt: true
                  width: parent.width
                  height: parent.height
                  fillMode: Image.PreserveAspectCrop
                  source: selectedGame ? selectedGame.assets.boxFront : ""
                  asynchronous: false
                  cache: false
                  sourceSize: { width: 320; height: 320 }
                  onStatusChanged: {
                    if (status == Image.Ready) {
                      update_image_size(game_box_art.implicitWidth, game_box_art.implicitHeight, 320);
                    }
                  }

                  layer.enabled: rounded
                  layer.effect: OpacityMask {
                      maskSource: Item {
                          width: game_box_art.width
                          height: game_box_art.height
                          Rectangle {
                              anchors.centerIn: parent
                              width: game_box_art.adapt ? game_box_art.width : Math.min(game_box_art.width, game_box_art.height)
                              height: game_box_art.adapt ? game_box_art.height : width
                              radius: 6
                          }
                      }
                  }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
