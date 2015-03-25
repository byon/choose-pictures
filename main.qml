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
        anchors.fill: parent

        ColumnLayout {

            id: currentImageColumn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Layout.preferredWidth: 3 * (parent.width / 4)

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
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: previousNextButtonsRow.bottom
                anchors.bottom: parent.bottom
                Layout.maximumWidth: 1024
                Layout.maximumHeight: 680
                source: imageChanges.change()
                asynchronous: true
                fillMode: Image.PreserveAspectFit
            }
        }

        Button {
            id: selectUnselect
            text: 'Select'
            anchors.left: currentImageColumn.right
            onClicked: {
                selectedImagesModel.append( {
                    "imagePath": imageChanges.current_image } )
            }
        }

        ScrollView {

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: selectUnselect.right
            frameVisible: true
            highlightOnFocus: true

            ListView {
                id: selectedImagesView
                spacing: 5
                model: selectedImagesModel
                delegate: Image {
                    source: imagePath
                    anchors.left: parent.left
                    anchors.right: parent.right
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }

    ImageChanges {
        id: imageChanges
    }

    ListModel {
        id: selectedImagesModel
    }
}
