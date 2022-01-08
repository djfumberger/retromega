import QtQuick 2.12

Item {
  property var title: ""
  property var light: false
  property var lightActive: false
  anchors {
    left: parent.left
    right: parent.right
  }
  height: 55  
  Rectangle {
    id: footer
    //color: light ? "#60000000" : "transparent"
    color: theme.background
    height: parent.height  
    anchors {
      left: parent.left
      right: parent.right
      leftMargin: 0
      rightMargin: 0
    }
    clip:true


    Rectangle {
        anchors.leftMargin: 22
        anchors.rightMargin: 22
        anchors.left: parent.left
        anchors.right: parent.right
        color: lightActive ? "#20ffffff" : theme.navBorder
        anchors.top: parent.top
        height: 1
    }


    // CustomBorder {
    //   leftMargin: 22
    //   rightMargin: 22
    //   width: parent.width 
    //   height: parent.height
    //   lBorderwidth: 0
    //   rBorderwidth: 0
    //   tBorderwidth: 1
    //   bBorderwidth: 0
    //   color: wrapperCSS.background
    //   borderColor: "#e3e3e3"
    // }

    Text{
      text: title
      anchors.right: parent.right
      anchors.rightMargin: 32
      color: theme.footerText
      font.pixelSize: 18
      font.letterSpacing: -0.3
      font.bold: true              
      anchors.verticalCenter: parent.verticalCenter
      elide: Text.ElideRight   
      height: 20    
    }

 
    ButtonLegend {
      id: button_legend_a
      title: "Select"
      key: "A"
      width: 40
      lightText: lightActive
      anchors.left: parent.left
      //anchors.left: button_legend_x.right
      anchors.leftMargin: 32
      anchors.verticalCenter: parent.verticalCenter
    }      

   ButtonLegend {
      id: button_legend_b
      title: "Menu"
      key: "B"
      width: 55
      lightText: lightActive
      anchors.left: button_legend_a.right
      anchors.leftMargin: 39
      anchors.verticalCenter: parent.verticalCenter
    }

    ButtonLegend {
      id: button_legend_x
      title: "Theme"
      key: "X"
      width: 55
      lightText: lightActive
      anchors.left: button_legend_b.right
      anchors.leftMargin: 24
      anchors.verticalCenter: parent.verticalCenter
    }

  }
}