import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Prototype 1.0

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 640
    height: 600
    title: "Pics, man, pics!"

    ColumnLayout {

        Text {
            id: caption
            text: "Here be some pictures!"
            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 12
        }

        Image {
            id: currentImage
            source: ""
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            asynchronous: true
        }

        Button {
            text: 'Change'
            onClicked: currentImage.source = imageChanges.change()
        }
    }

    ImageChanges {
        id: imageChanges
    }
}
