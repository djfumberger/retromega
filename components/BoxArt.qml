import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    property var asset: string
    property var initialLoad: true
    property var loadingError: false
    property var loadingImage: true
    
    property var wasInitialLoad: true
    property var emptyAsset: {
        return (asset == "" || asset == null)
    }

    onVisibleChanged: {
        if (!wasInitialLoad) {
            game_box_art_previous.source = ""
        } 
    }

    onAssetChanged: {
        if (emptyAsset) {
            game_box_art_previous.source = ""
        }
    }

    function update_image_size(width, height, container_size) {
        var fill = (width > height) ? 0.75 : 0.65
        box_art.width  = size_image(width, height, container_size * fill).width
        box_art.height = size_image(width, height, container_size * fill).height
    }

    function size_image(width, height, max_width) {
        var imageHeight = (height / width) * max_width
        return { height: imageHeight, width: max_width }
    }

    id: box_art
    width: 1
    height: 1
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    visible: (emptyAsset || loadingError || initialLoad == true) ? false : true

    Image {
        id: game_box_shadow
        source: "../assets/images/cover-shadow.png"
        width: (371 / 200) * parent.width
        height: (371 / 200) * parent.height
        fillMode: Image.PreserveAspectFill
                            anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Item {
        property bool rounded: true
        id: box_art_container
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        Image {
            anchors.fill: parent
            id: game_box_art_previous
            smooth: true
            fillMode: Image.PreserveAspectCrop
            asynchronous: false
        }

        Image {
            anchors.fill: parent
            id: game_box_art
            smooth: true
            property bool adapt: true
            fillMode: Image.PreserveAspectCrop
            source: asset
            asynchronous: initialLoad ? false : true
            sourceSize: { width: 320; height: 320 }
            onStatusChanged: {
                
                if (status == Image.Null || status == Image.Error) {
                    box_art.loadingError = true
                }

                if (status == Image.Loading) {
                    loadingImage = true
                    opacity = 0
                    if (game_box_art_previous.source == "") {
                        game_box_shadow.opacity = 0
                    }
                }
                
                if (status == Image.Ready) {
                    update_image_size(game_box_art.implicitWidth, game_box_art.implicitHeight, 320);
                    game_box_art_previous.source = source 
                    game_box_shadow.opacity = 1.0
                    opacity = 1.0
                    box_art.wasInitialLoad = box_art.initialLoad
                    box_art.loadingError = false
                    box_art.initialLoad = false
                    box_art.loadingImage = false                    
                }
            }
        }

        layer.enabled: rounded
        layer.effect: OpacityMask {
            maskSource: Item {
                width: game_box_art.width
                height: game_box_art.height
                Rectangle {
                    anchors.centerIn: parent
                    width: game_box_art.adapt ? game_box_art.width : Math.min(game_box_art.width, game_box_art.height)
                    height: game_box_art.adapt ? game_box_art.height : width
                    radius: 6
                }
            }
        }
    }
}