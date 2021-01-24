import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
	property var tintColor : "#333333"

	// DropShadow {
	// 	anchors.fill: list_selection
	// 	horizontalOffset: 0
	// 	verticalOffset: 4
	// 	radius: 12.0
	// 	samples: 18
	// 	opacity: 0.4
	// 	color: "#30000000"
	// 	source: list_selection
	// }

	/** Selection Rect */
	Rectangle{
		id: list_selection
		width:parent.width + 12
		height:parent.height
		color: tintColor
		opacity:1
		x: -12
		radius: 8
	}

}