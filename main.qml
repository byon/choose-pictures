import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 320
    height: 400
    title: "Hello, world!"

    Text {

        id: helloText
        text: "Hello world again!"
        y: 20
        anchors.horizontalCenter: mainWindow.horizontalCenter
        font.pointSize: 14
        font.bold: true
    }
}
