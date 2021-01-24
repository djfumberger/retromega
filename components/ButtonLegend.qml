import QtQuick 2.12

Item {
	property var title : "Title"
	property var key : "X"
	property var lightText : false
	//property alias leftMargin : legend_container.leftMargin

	Rectangle {
		id: legend_container
	    anchors.verticalCenter: parent.verticalCenter
	    anchors.left: parent.left
	    anchors.leftMargin: 0
	    //anchors.leftMargin: 70
	    Rectangle{
	    	id: legend
	        height:20
	        width:20
	        color:"#444"
	        radius:20
	        anchors.verticalCenter: parent.verticalCenter
	        anchors.left: parent.left  
	        anchors.leftMargin: 0
	        Text{
	             text: key
	             color:"white"         
	             font.pixelSize: 14
	             font.letterSpacing: -0.3
	             font.bold: true              
	             anchors.verticalCenter: parent.verticalCenter
	             anchors.horizontalCenter: parent.horizontalCenter
	        }
	        Text{
	        	 id: legend_title
	             text: title
	             color: lightText ? "#70ffffff" : theme.text                      
	             font.pixelSize: 14
	             font.letterSpacing: -0.3
	             font.bold: true              
	             anchors.verticalCenter: parent.verticalCenter
	             anchors.left: parent.right
	             anchors.leftMargin: 4
	             
	        }
	    }
	}
}