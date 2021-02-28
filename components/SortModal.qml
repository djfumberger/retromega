import QtQuick 2.12
import QtGraphicalEffects 1.12
Item {
    id: sortModal
    property var active: false
    property var sortColor: "#000000"

    states: [ 
        State{
            name: "hidden"; when: !active
            PropertyChanges { target: modalContent; anchors.verticalCenterOffset: 480}
        },

        State{
            name: "active"; when: active
            PropertyChanges { target: modalContent; anchors.verticalCenterOffset: 0}
        }

    ]

    transitions:[ 
         Transition {
            NumberAnimation { properties: "anchors.verticalCenterOffset"; easing.type: Easing.OutCubic; duration: 350  }
        },
         Transition {
            NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 250  }
        }   
    ]

    anchors.fill: parent
    Rectangle {
        id: modalDim
        anchors.fill: parent
        color: "black"
        opacity: 0.5
        transitions: Transition {
                            NumberAnimation { properties: "opacity"; easing.type: Easing.Out; duration: 250  }
                    }   

        states: [ 

            State{
                name: "hidden"; when: !active
                PropertyChanges { target: modalDim; opacity: 0 }
            },

            State{
                name: "active"; when: active
                PropertyChanges { target: modalDim; opacity: 0.65 }
            }

        ]
    }

    FocusScope {
        id: modalContent
        anchors.verticalCenterOffset: 480
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.75
        height: 300
        focus: active
        Item {
            anchors.fill: parent

            Rectangle {
                id: modal
                color: "white"
                radius: 12
                anchors.fill: parent
            }
            
            Column {
                id: columns
                spacing: 0
                anchors.fill: parent
                anchors.leftMargin: 30
                anchors.topMargin: 20
                anchors.rightMargin: 20
                anchors.bottomMargin: 20
                SortItem {
                    title: "By Title"
                    width: parent.width
                    mode: "title"
                    itemColor: sortColor
                    KeyNavigation.down: by_last_played
                }

                SortItem {
                    id: by_last_played
                    title: "By Last Played"
                    width: parent.width
                    mode: "lastPlayed"
                    itemColor: sortColor
                    KeyNavigation.down: by_rating
                }

                SortItem {
                    id: by_rating
                    title: "By Highest Rated"
                    width: parent.width
                    mode: "rating"
                    itemColor: sortColor
                    KeyNavigation.down: by_release_year
                }

                SortItem {
                    id: by_release_year
                    title: "By Release Date"
                    width: parent.width
                    mode: "release"
                    itemColor: sortColor
                    KeyNavigation.down: show_all
                }

                // SortItem {
                //     id: by_play_count
                //     title: "By Favorites"
                //     width: parent.width
                //     mode: "favorite"
                //     itemColor: sortColor
                //     KeyNavigation.down: by_play_time
                // }    

                // SortItem {
                //     id: by_play_count
                //     title: "By Play Count"
                //     width: parent.width
                //     mode: "playCount"
                //     itemColor: sortColor
                //     KeyNavigation.down: by_play_time
                // }    

                // SortItem {
                //     id: by_play_time
                //     title: "By Play Time"
                //     width: parent.width
                //     mode: "playTime"
                //     itemColor: sortColor
                //     KeyNavigation.down: show_all                    
                // } 

                ListSeperator {

                }

                FilterItem {
                    id: show_all
                    title: "Show All"
                    KeyNavigation.down: show_favorites_only
                    width: parent.width
                    filter: "all"
                    itemColor: sortColor
                } 

                FilterItem {
                    id: show_favorites_only
                    title: "Favorites Only"
                    width: parent.width
                    filter: "favorites"
                    itemColor: sortColor
                }                 
            }
        }
    }
}