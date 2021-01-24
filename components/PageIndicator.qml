import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: pageIndicator
    Row {
        spacing: 10
        Repeater {
            model: pageIndicator.pageCount
            Rectangle {
                width: 4
                height: 4
                radius: 2
                color: pageIndicator.currentIndex == index ? "white" : "#20ffffff"
            }
        }
    }
    width:  pageIndicator.pageCount * (4 + 10)
    property var currentIndex: 0
    property int pageCount: 10

}