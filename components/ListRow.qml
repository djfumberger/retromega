import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
	property var title : "Row"
	property var selected : false
	property var favorite : false
	property var rowColor : theme.listRowColor
	property var emptyStyle : false
	ListSelection {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.fill: parent
		width:parent.width
		height:parent.height
		//visible: parent.parent.ListView.isCurrentItem ? true : false
		visible: selected
		tintColor: rowColor
	}

	Text {
		text:title
		color: selected ? theme.listTextSelected : theme.listText
		opacity: emptyStyle ? 0.3 : 1.0
		font.family: globalFonts.sans
		font.pixelSize: 18
		font.letterSpacing: -0.3
		font.bold: true
		// the size of the whole text box,
		// a bit taller than the text size for a nice padding
		width: parent.width - (favorite ? 24 : 12)
		height: parent.height
		// align the text vertically in the middle of the text area
		verticalAlignment: Text.AlignVCenter
		// if the text is too long, end it with ellipsis (three dots)
		elide: Text.ElideRight
	}

	Image {              
		width: 12
		visible: favorite
		fillMode: Image.PreserveAspectFit
		source: "../assets/icons/favorite.svg"
		asynchronous: true    
		anchors {
			right: parent.right
			verticalCenter: parent.verticalCenter
			rightMargin: 6
			leftMargin: -16
		}
	}    

}