import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 1024
    height: 768
    title: "Choose Pictures"

    RowLayout {
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

    FileDialog {
        id: fileDialog
        title: "Please choose a directory"
        nameFilters: [ "Image files (*.jpg *.jpeg *.png) *.JPG *.JPEG *.PNG",
                       "All files (*)" ]
        selectFolder: true
        onAccepted: {
            chosenDirectory.text = fileDialog.fileUrl
        }
    }
}
