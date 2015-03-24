import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Prototype 1.0

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 1024
    height: 680
    title: "Pics, man, pics!"

    RowLayout {

        id: mainRow

        Column {

            id: currentImageColumn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: currentImage.width + 10

            Row {

                id: previousNextButtonsRow
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: previousImage; text: 'Previous'
                }
                Button {
                    id: nextImage; text: 'Next'
                    onClicked: {
                        imageChanges.change()
                        currentImage.source = imageChanges.current_image
                    }
                }
            }

            Image {

                id: currentImage
                width: 600
                source: imageChanges.change()
                asynchronous: true
                fillMode: Image.PreserveAspectFit
            }
        }

        Button {
            id: selectUnselect
            text: 'Select'
        }

        Column {
        }
    }

    ImageChanges {
        id: imageChanges
    }
}
