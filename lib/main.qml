import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import CurrentPicture 1.0
import Selection 1.0

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 1024
    height: 768
    title: "Choose Pictures"
    Component.onCompleted: selection.link_current_to_selection(currentPicture)

    function moveToFirst() {
        currentPicture.move_to_first()
        currentPictureImage.source = currentPicture.current_picture()
        updateNextAndPreviousButtons()
    }

    function moveToPrevious() {
        currentPicture.move_to_previous()
        currentPictureImage.source = currentPicture.current_picture()
        updateNextAndPreviousButtons()
    }

    function moveToNext() {
        currentPicture.move_to_next()
        currentPictureImage.source = currentPicture.current_picture()
        updateNextAndPreviousButtons()
    }

    function moveToLast() {
        currentPicture.move_to_last()
        currentPictureImage.source = currentPicture.current_picture()
        updateNextAndPreviousButtons()
    }

    function updateNextAndPreviousButtons() {

        firstPictureButton.enabled = currentPicture.has_previous()
        previousPictureButton.enabled = currentPicture.has_previous()
        nextPictureButton.enabled = currentPicture.has_next()
        lastPictureButton.enabled = currentPicture.has_next()
    }

    function selectCurrentPicture() {
        selection.select_current()
    }

    function setDirectoryFromUrl(url) {
        setDirectory(urlToPath(url))
    }

    function setDirectory(path) {
        chosenDirectory.text = path
        currentPicture.use_directory(path)
        currentPictureImage.source = currentPicture.current_picture()
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
        Keys.onRightPressed: selectButton.clicked()
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
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: selectButton.left

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

                id: currentPictureImage
                anchors.top: navigationButtonRow.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                sourceSize.width: 1024
                sourceSize.height: 680
                fillMode: Image.PreserveAspectFit
            }
        }

        Button {
            id: selectButton
            text: "Select"
            anchors.right: selectedPicturesScrollView.left
            onClicked: mainWindow.selectCurrentPicture()
        }

        ScrollView {

            id: selectedPicturesScrollView
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 256
            frameVisible: true

            ListView {
                id: selectedPicturesView
                spacing: 5
                model: selection.model
                delegate: Image {
                    source: picturePath
                    sourceSize.width: 256
                    sourceSize.height: 256
                    fillMode: Image.PreserveAspectFit
                }
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
            return "Image files (" + currentPicture.allowed_extensions() + ")"
        }
    }

    CurrentPicture {

        id: currentPicture
    }

    Selection {
        id: selection
    }
}
