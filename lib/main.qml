import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

import CopyPictures 1.0
import CurrentPicture 1.0
import Selection 1.0

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 1024
    height: 768
    title: "Choose Pictures"
    Component.onCompleted: initialize()

    function initialize() {

        selection.link_current_to_selection(currentPicture)
        setDirectory(currentPicture.default_directory())
    }

    function moveToFirst() {
        moveTo(currentPicture.move_to_first)
    }

    function moveToPrevious() {
        moveTo(currentPicture.move_to_previous)
    }

    function moveToNext() {
        moveTo(currentPicture.move_to_next)
    }

    function moveToLast() {
        moveTo(currentPicture.move_to_last)
    }

    function moveToPicture(picturePath) {
        var mover = function() {currentPicture.move_to_picture(picturePath)};
        moveTo(mover)
    }

    function moveTo(mover) {
        mover()
        currentPictureImage.source = currentPicture.current_picture()
        updateButtons()
        updateSelectedPictureView()
    }

    function updateButtons() {

        firstPictureButton.enabled = currentPicture.has_previous()
        previousPictureButton.enabled = currentPicture.has_previous()
        nextPictureButton.enabled = currentPicture.has_next()
        lastPictureButton.enabled = currentPicture.has_next()

        updateCopyButton()

        selectButton.enabled = currentPicture.current_picture() != ''
        updateSelectionButtonText()
    }

    function selectOrRemoveCurrentPicture() {
        var select = !selection.is_selected(currentPicture.current_picture())
        updateSelectionForCurrentPicture(select)
    }

    function updateSelectionForCurrentPicture(select) {
        if (currentPicture.current_picture() == '') {
            return
        }

        if (select) {
            selection.select_current()
            updateSelectedPictureView()
        }
        else {
            selection.remove_current()
        }
        updateSelectionButtonText()
        updateCopyButton()
    }

    function updateSelectedPictureView() {
        var current = currentPicture.current_picture()
        var selectionIndex = selection.get_selection_index(current)
        if (selectionIndex >= 0) {
            selectedPicturesView.positionViewAtIndex(selectionIndex,
                                                     ListView.Center)
        }
    }

    function updateSelectionButtonText() {
        if (selection.is_selected(currentPicture.current_picture())) {
            selectButton.text = "Remove"
            return
        }
        selectButton.text = "Select"
    }

    function updateCopyButton() {

        copyButton.enabled = selectedPicturesView.count > 0
    }

    function copyPicturesTo(url) {
        copyPictures.copy_pictures(mainWindow, selection.get_selected(),
                                   urlToPath(url))
    }

    function forceCopyPicturesTo(url) {
        copyPictures.force_copy_pictures(mainWindow, selection.get_selected(),
                                         urlToPath(url))
    }

    function showError(error) {
        copyErrorDialog.text = error
        copyErrorDialog.open()
    }

    function ask_overwrite_permission() {
        copyWarningDialog.open()
    }

    function setDirectoryFromUrl(url) {
        setDirectory(urlToPath(url))
    }

    function setDirectory(path) {
        chosenDirectory.text = path
        currentPicture.use_directory(path)
        currentPictureImage.source = currentPicture.current_picture()
        updateButtons()
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
            onClicked: sourceDirectoryDialog.open()
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
        Keys.onRightPressed: updateSelectionForCurrentPicture(true)
        Keys.onLeftPressed: updateSelectionForCurrentPicture(false)
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
            anchors.right: selectedPicturesColumn.left
            onClicked: mainWindow.selectOrRemoveCurrentPicture()
            enabled: false
        }

        ColumnLayout {
            id: selectedPicturesColumn
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            ScrollView {

                id: selectedPicturesScrollView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: copyButton.top
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn
                frameVisible: true

                ListView {
                    id: selectedPicturesView
                    spacing: 5
                    model: selection.model
                    delegate: MouseArea {

                        width: selectedPicture.paintedWidth
                        height: selectedPicture.paintedHeight
                        onClicked: mainWindow.moveToPicture(picturePath)

                        Image {
                            id: selectedPicture
                            source: picturePath
                            sourceSize.width: 256
                            sourceSize.height: 256
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            Button {
                id: copyButton
                text: "Copy"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: targetDirectoryDialog.open()
                enabled: false
            }
        }
    }

    FileDialog {
        id: sourceDirectoryDialog
        title: "Please choose a directory"
        nameFilters: [ imageFilters(), "All files (*)" ]
        selectFolder: true
        onAccepted: {
            mainWindow.setDirectoryFromUrl(sourceDirectoryDialog.fileUrl)
        }

        function imageFilters() {
            return "Image files (" + currentPicture.allowed_extensions() + ")"
        }
    }

    FileDialog {
        id: targetDirectoryDialog
        title: "Please choose a directory"
        selectFolder: true
        onAccepted: {
            mainWindow.copyPicturesTo(targetDirectoryDialog.fileUrl)
        }
    }

    MessageDialog {
        id: copyErrorDialog
        title: "Picture copying failed"
    }

    MessageDialog {
        id: copyWarningDialog
        title: "Proceed with copying?"
        text: "Some/all pictures in folder will be overwritten. Proceed?"
        icon: StandardIcon.Question
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: mainWindow.forceCopyPicturesTo(targetDirectoryDialog.fileUrl)
    }

    CurrentPicture {

        id: currentPicture
    }

    Selection {
        id: selection
    }

    CopyPictures {
        id: copyPictures
    }
}
