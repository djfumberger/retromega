import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {

  property var tintColor : "red"
  property var icon      : "icon-fav"

  id: icon_a
  width: 46
  focus: true
  height: 46
  states: [ State{
              name: "inactive"; when: !icon_a.focus
              PropertyChanges { target: icon_a; scale: 1.0; opacity: 0.8}
            },
            State{
              name: "active"; when: icon_a.focus
              PropertyChanges { target: icon_a; scale: 1.2; opacity: 1.0}
            }
  ]

  transitions: Transition {
      NumberAnimation { properties: "scale, opacity"; easing.type: Easing.InOutCubic; duration: 225  }
  }

  Rectangle {
    id: icon_a_content
    color: parent.focus ? tintColor : "#ffffff"
    width: parent.width
    height: parent.height
    radius: 23            
  }

  DropShadow {
    visible: true
    anchors.fill: icon_a_content
    horizontalOffset: 0
    verticalOffset: parent.focus ? 5 : 2
    radius: parent.focus ? 8 : 2.0
    samples: parent.focus ? 8 : 2
    color: parent.focus ? "#50000000" : "#30000000"
    source: icon_a_content
  } 

  Image {
    id: icon_image
    source: "../assets/images/" + icon + ".png"
    anchors.horizontalCenter: parent.horizontalCenter            
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: 23
  }

  ColorOverlay {
    anchors.fill: icon_image
    source: icon_image
    color:  parent.focus ? "#ffffff" : tintColor  // make image like it lays under red glass 
  }


}
    