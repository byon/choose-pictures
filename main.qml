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
            text: imageChanges.current_image
            font.pointSize: 12
        }

        MouseArea {

            width: currentImage.width
            height: currentImage.width

            Image {
                id: currentImage
                width: mainWindow.width - 5
                height: 500
                source: imageChanges.change()
                asynchronous: true
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                imageChanges.change()
                currentImage.source = imageChanges.current_image
            }
        }
    }

    ImageChanges {
        id: imageChanges
    }
}
