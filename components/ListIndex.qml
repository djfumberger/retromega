import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {

    property var alpha: bool = true
    property var reversed: bool = false

    id: listIndex 
    property var active: false
    property var listItems: []
    property var items: {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    property var itemIndexes: []

    property var onIndexChanged: function (collectionIndex, index, indexValue) {

    }
 
    onActiveChanged: {
        if (!active) {
            return
        }

        var keyItems = []
        var keyItemIndexes = []

        // For alpha sorted lists, show an index based on available letters
        if (alpha) {

            // Populate items
            var lastKey = ""

            // Faster to convert to var array than go through the model.
            const varray = listItems

            for (var i = 0; i < varray.count; i++) {
                var title = varray.get(i).title
                var firstChar = title.charAt(0).toUpperCase()

                // Don't split out numbers
                if (parseInt(firstChar) == firstChar) {
                    firstChar = "0"
                }

                if (firstChar != lastKey) {
                    keyItems.push(firstChar)
                    keyItemIndexes.push(i)
                    lastKey = firstChar
                }
            }

            if (reversed) {
                keyItems.reverse()
            }

        // For any other sort order, just show 10 dots.
        } else {
            var maxIndex = listItems.count - 1
            for (var i = 0; i < 9; i++) {
                keyItems.push("•")                
                keyItemIndexes.push( Math.min(Math.floor((i / 9) * maxIndex), maxIndex))                
            }
            keyItems.push("•")      
            keyItemIndexes.push(maxIndex)
        }

        items = keyItems
        itemIndexes = keyItemIndexes
    }


    function updateIndex() {
        onIndexChanged(itemIndexes[listView.currentIndex])      
    }

    
    Keys.onPressed: {                                            

        // Next page
        if (api.keys.isNextPage(event)) {
            event.accepted = true
            navSound.play()
            listView.currentIndex = Math.min(listView.currentIndex + 8, items.length - 1)
            updateIndex()
            return
        }  
        
        // Prev Page
        if (api.keys.isPrevPage(event)) {
            event.accepted = true
            listView.currentIndex = Math.max(listView.currentIndex - 8, 0)
            navSound.play()
            updateIndex()
            return;
        }  

        event.accepted = false
    }     

    Keys.onUpPressed: { 
        navSound.play()
        event.accepted = true            
        listView.decrementCurrentIndex();
        updateIndex()
    }      

    Keys.onDownPressed:     { 
        navSound.play()
        event.accepted = true
        listView.incrementCurrentIndex(); 
        updateIndex()
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
        clip: true
    }

    Component {
        id: itemDelegate
        Item {
            width: 30
            height: 30
            property var selected: {
                ListView.isCurrentItem && listIndex.activeFocus
            }
            /** Selection Rect */
            Rectangle{
                id: listSelection
                width:parent.width - 4
                height:parent.height - 4
                color: gamesColor
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 2
                anchors.topMargin: 2
                visible: selected
                opacity:1
                x: 0
                radius: 6
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
