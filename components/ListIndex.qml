import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: listIndex 
    property var items: {
        return ["A", "B", "C", "D"]
    }


    Keys.onUpPressed: { 
        navSound.play()
        event.accepted = true            
        listView.decrementCurrentIndex();
    }      

    Keys.onDownPressed:     { 
        navSound.play()
        event.accepted = true
        listView.incrementCurrentIndex(); 
    }    

    DropShadow {
        anchors.fill: background
        horizontalOffset: 0
        verticalOffset: 4
        radius: 12.0
        samples: 18
        opacity: 0.4
        color: "#30000000"
        source: background
    }

    Rectangle {
        id: background
        color: white
        anchors.fill: parent
        radius: 8
    }

    ListView {
        id: listView 
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 30
        anchors.horizontalCenter: parent.horizontalCenter
        model: items.length
        delegate: itemDelegate
        currentIndex: 0
        orientation: ListView.Vertical
        spacing: 4
        snapMode: ListView.SnapOneItem
        highlightMoveDuration: 0


    }

    Component {
        id: itemDelegate
        Item {
            width: 30
            height: 32
            property var selected: {
                ListView.isCurrentItem && listIndex.activeFocus
            }
            /** Selection Rect */
            Rectangle{
                id: listSelection
                width:parent.width
                height:parent.height
                color: gamesColor
                visible: selected
                opacity:1
                x: 0
                radius: 8
            }
            Text {
                text:items[index]
                color: selected ? "#ffffff" : "#333333"
                font.family: globalFonts.sans
                font.pixelSize: 18
                font.letterSpacing: -0.3
                font.bold: true
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }
        }
    }
}
