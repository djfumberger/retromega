import QtQuick 2.12
import QtGraphicalEffects 1.12

ListView {
    property var footerTitle: {
        return (currentIndex + 1) + " of " + allSystems.count
    }

    property var headerFocused: false
    
    function letterSpacing(str) {
        return str == 'NES' ? 1.0 : -1.0

    }
    id: systemsListView
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    model: allSystems
    delegate: systemsDelegate  
    orientation: ListView.Horizontal
    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: 320 - 220
    preferredHighlightEnd: 320 + 220
    snapMode: ListView.SnapToItem
    highlightMoveDuration: 225
    highlightMoveVelocity: -1
    keyNavigationWraps: false
    spacing: 30
    currentIndex: currentCollectionIndex     


    Keys.onLeftPressed: {  
        decrementCurrentIndex(); navSound.play(); 
    } 

    Keys.onRightPressed: {  
        incrementCurrentIndex(); navSound.play();  
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

    
    Component.onDestruction: {
        setCollectionIndex(systemsListView.currentIndex)
    }

    Component.onCompleted: { 
        positionViewAtIndex(currentCollectionIndex, ListView.Center)
        delay(50, function() {
            systemsListView.positionViewAtIndex(currentCollectionIndex, ListView.Center)
        })
        //currentIndex = currentCollectionIndex
    }
    Component {
        id: systemsDelegate
    
    
        Item {
            id: home_item_container
            width: 440
            height: 270
            scale: 0.8
            Keys.onPressed: {
                if (api.keys.isAccept(event)) {
                    event.accepted = true;
                    
                    //We update the collection we want to browse
                    setCollectionListIndex(0)
                    setCollectionIndex(systemsListView.currentIndex)

                    //We change Pages
                    navigate('GamesPage');
                    
                    return;
                }      
                if (api.keys.isNextPage(event)) {
                    event.accepted = true
                    navSound.play()
                    systemsListView.currentIndex = systemsListView.currentIndex + 1
                    
                    return
                }  
                
                if (api.keys.isPrevPage(event)) {
                    event.accepted = true;
                    decrementCurrentIndex()
                    return;
                }  
                    
            }                          

            Image {
                source: "../assets/images/homescreen-tile-shadow.png"
                width: (512 / 256) * parent.width
                height: (512 / 256) * parent.height
                fillMode: Image.PreserveAspectFill
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

            }
            
            Rectangle {
                id: systemsListView_item
                width: parent.width
                height: parent.height       
                color:"transparent"    

                states: [

                    State{
                        name: "inactive"; when: !(home_item_container.ListView.isCurrentItem && !headerFocused)
                        PropertyChanges { target: home_item_container; scale: 0.8; opacity: 1.0}
                    },

                    State {
                        name: "active"; when: home_item_container.ListView.isCurrentItem && !headerFocused
                        PropertyChanges { target: home_item_container; scale: 1.0; opacity: 1.0}
                    }
                ]

                transitions: Transition {
                    NumberAnimation { properties: "scale, opacity"; easing.type: Easing.InOutCubic; duration: 225  }
                }

                Rectangle {

                    id: tile_content
                    anchors.top: systemsListView_item.top
                    anchors.left: systemsListView_item.left
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    width: parent.width
                    height: parent.height
                    color: systemColors[modelData.shortName] ?? "#000000"
                    clip: false
                    visible: false
                                                                                       
                }
                    
                Image {
                    id: tile_mask
                    source: "../assets/images/homescreen-tile.png"
                    smooth: true        
                    width: parent.width
                    height: parent.height
                    visible: false
                    sourceSize: Qt.size(parent.width, parent.height)                          
                }    

                OpacityMask {
                    id: mask
                    anchors.fill: tile_content
                    source: tile_content
                    maskSource: tile_mask
                }
                    
                DropShadow {
                    anchors.fill: mask
                    horizontalOffset: 0
                    verticalOffset: 4
                    radius: 12.0
                    samples: 16
                    opacity: 0.4
                    color: systemColors[modelData.shortName]
                    source: mask
                }   


                Image {
                    id: device
                    source: "../assets/images/devices/"+modelData.shortName+".png"
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.bottomMargin: -40

                    states: [

                        State{
                            name: "inactiveRight"; when: !(home_item_container.ListView.isCurrentItem) && currentIndex < index
                            PropertyChanges { target: device; anchors.rightMargin: -160.0; opacity: 1.0}
                        },

                        State{
                            name: "inactiveLeft"; when: !(home_item_container.ListView.isCurrentItem) && currentIndex > index
                            PropertyChanges { target: device; anchors.rightMargin: 40.0; opacity: 1.0}
                        },

                        State {
                            name: "active"; when: home_item_container.ListView.isCurrentItem
                            PropertyChanges { target: device; anchors.rightMargin: -60.0; opacity: 1.0}
                        }
                     
                    ]

                    transitions: Transition {
                        NumberAnimation { properties: "scale, opacity, anchors.rightMargin"; easing.type: Easing.InOutCubic; duration: 225  }
                    }
                    
                }                

                Text {
                    id: title
                    text: modelData.name
                    font.pixelSize: 36
                    font.letterSpacing: letterSpacing(modelData.name)
                    font.bold: true       
                    color: "#ffffff"    
                    width: 300
                    wrapMode: Text.WordWrap
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    visible: true
                    lineHeight: 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.verticalCenterOffset: -5
                }                                         

                DropShadow {
                    anchors.fill: title
                    source: title
                    verticalOffset: 10
                    color: "#20000000"
                    radius: 20
                    samples: 10
                }
                
                Text {
                    text: modelData.games.count + " games"
                    //anchors.bottom: parent.bottom
                    //anchors.bottomMargin: 20
                    font.pixelSize: 14
                    font.letterSpacing: -0.3
                    font.bold: true       
                    color: "#ffffff"   
                    opacity: 0.7    
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: -27
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.bottom: title.bottom
                }    

                Text {
                    text: systemCompanies[modelData.shortName].toUpperCase()
                    //anchors.bottom: parent.bottom
                    //anchors.bottomMargin: 20
                    font.pixelSize: 12
                    font.letterSpacing: 1.3
                    font.bold: true       
                    color: "#ffffff"   
                    opacity: 0.7    
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: -1
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.bottom: title.top
                }    

            
                // Image {
                //     id: tile_logo
                //     source: "../assets/images/logos/"+modelData.shortName+".png"
                //     anchors.verticalCenter: parent.verticalCenter
                //     anchors.horizontalCenter: parent.horizontalCenter
                // }  
            }

            Text {
                id: subtitle
                text: modelData.name
                //anchors.bottom: parent.bottom
                //anchors.bottomMargin: -30
                font.pixelSize: 14
                font.letterSpacing: -0.3
                font.bold: true       
                color: "#4F4F4F"    
                visible: false   
            }    

            Text {
                text: modelData.games.count + " games"
                //anchors.bottom: parent.bottom
                //anchors.bottomMargin: 20
                font.pixelSize: 14
                font.letterSpacing: -0.3
                font.bold: true       
                color: "#ffffff"   
                opacity: 0.7    
                visible: false
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.bottomMargin: -30
            }    
            
            // DropShadow {
            //     anchors.fill: systems__item
            //     horizontalOffset: 3
            //     verticalOffset: 3
            //     radius: 8.0
            //     samples: 17
            //     color: "#80000000"
            //     source: systems__item
            // }                        

        }
    }      
    

}