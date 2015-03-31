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

    function moveToFirst() {
        choosePictures.first_picture()
        currentPicture.source = choosePictures.current_picture()
        updateNextAndPreviousButtons()
    }

    function moveToPrevious() {
        choosePictures.previous_picture()
        currentPicture.source = choosePictures.current_picture()
        updateNextAndPreviousButtons()
    }

    function moveToNext() {
        choosePictures.next_picture()
        currentPicture.source = choosePictures.current_picture()
        updateNextAndPreviousButtons()
    }

    function moveToLast() {
        choosePictures.last_picture()
        currentPicture.source = choosePictures.current_picture()
        updateNextAndPreviousButtons()
    }

    function updateNextAndPreviousButtons() {

        firstPictureButton.enabled = choosePictures.has_previous()
        previousPictureButton.enabled = choosePictures.has_previous()
        nextPictureButton.enabled = choosePictures.has_next()
        lastPictureButton.enabled = choosePictures.has_next()
    }

    function setDirectoryFromUrl(url) {
        setDirectory(urlToPath(url))
    }

    function setDirectory(path) {
        chosenDirectory.text = path
        choosePictures.use_directory(path)
        currentPicture.source = choosePictures.current_picture()
        updateNextAndPreviousButtons()
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

        Keys.onDownPressed: nextPictureButton.clicked()
        Keys.onUpPressed: previousPictureButton.clicked()
        Keys.onPressed: {
            if (event.key === Qt.Key_Home) {
                firstPictureButton.clicked()
                event.accepted.true
            }
            else if (event.key === Qt.Key_End) {
                lastPictureButton.clicked()
                event.accepted.true
            }
        }

        ColumnLayout {

            id: currentPictureColumn
            anchors.fill: parent

            Row {

                id: navigationButtonRow
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: firstPictureButton
                    text: 'First'
                    onClicked: mainWindow.moveToFirst()
                    enabled: false
                }

                Button {
                    id: previousPictureButton
                    text: 'Previous'
                    onClicked: mainWindow.moveToPrevious()
                    enabled: false
                }

                Button {
                    id: nextPictureButton
                    text: 'Next'
                    onClicked: mainWindow.moveToNext()
                    enabled: false
                }

                Button {
                    id: lastPictureButton
                    text: 'Last'
                    onClicked: mainWindow.moveToLast()
                    enabled: false
                }
            }

            Image {

                id: currentPicture
                anchors.top: navigationButtonRow.bottom
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
