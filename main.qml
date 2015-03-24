import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 640
    height: 600
    title: "Pics, man, pics!"

    Text {

        id: caption
        text: "Here be some pictures!"
        y: 5
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
    }

    Image {
        id: currentImage
        source: "data/pic2.jpg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
    }
}
