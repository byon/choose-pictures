import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import ChoosePictures 1.0

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 1024
    height: 768
    title: "Choose Pictures"

    function moveToPrevious() {
        choosePictures.previous_picture()
        currentPicture.source = choosePictures.current_picture()
    }

    function moveToNext() {
        choosePictures.next_picture()
        currentPicture.source = choosePictures.current_picture()
    }

    function setDirectoryFromUrl(url) {
        setDirectory(urlToPath(url))
    }

    function setDirectory(path) {
        chosenDirectory.text = path
        choosePictures.use_directory(path)
        currentPicture.source = choosePictures.current_picture()
    }

    function urlToPath(url) {
        var path = url.toString()
        return decodeURIComponent(path.replace(/^\w+:\/{2}/, ""))
    }

    RowLayout {

        id: directoryRow
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        height: 30

        Label {
            id: directoryLabel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            verticalAlignment: Text.AlignVCenter
            text: "Directory "
            font.bold: true
        }

        TextArea {
            id: chosenDirectory
            anchors.left: directoryLabel.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: browseButton.left
            text: "<choose directory by pressing browse>"
            activeFocusOnPress: false
            readOnly: true
        }
        Button {
            id: browseButton
            text: "Browse"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            onClicked: fileDialog.open()
        }
    }

    RowLayout {

        id: pictureRow
        anchors.left: parent.left
        anchors.top: directoryRow.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        focus:true

        Keys.onDownPressed: nextPicture.clicked()
        Keys.onUpPressed: previousPicture.clicked()

        ColumnLayout {

            id: currentPictureColumn
            anchors.fill: parent

            Row {

                id: previousNextButtonRow
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: previousPicture
                    text: 'Previous'
                    onClicked: mainWindow.moveToPrevious()
                }

                Button {
                    id: nextPicture
                    text: 'Next'
                    onClicked: mainWindow.moveToNext()
                }
            }

            Image {

                id: currentPicture
                anchors.top: previousNextButtonRow.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                sourceSize.width: 1024
                sourceSize.height: 680
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a directory"
        nameFilters: [ imageFilters(), "All files (*)" ]
        selectFolder: true
        onAccepted: mainWindow.setDirectoryFromUrl(fileDialog.fileUrl)

        function imageFilters() {
            return "Image files (" + choosePictures.allowed_extensions() + ")"
        }
    }

    ChoosePictures {

        id: choosePictures
    }
}
