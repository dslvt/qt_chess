import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.14

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 720
    height: 1280
    title: qsTr("Menu")

    ColumnLayout{
        width: parent.width
        height: parent.height
        clip: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Layout.alignment: Qt.AlignCenter
        spacing: 0
        TextField {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            horizontalAlignment: Text.AlignLeft
            placeholderText: "Match ID"
        }
    Button{
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        text: "Find match"
        Layout.rowSpan: 1
        transformOrigin: Item.Center
        Layout.fillHeight: false
        Layout.fillWidth: false
    }
    Button{
        Layout.alignment: Qt.AlignCenter
        text: "Play with bot"
    }
    Button{
        Layout.alignment: Qt.AlignCenter
        text: "View previous matches"
    }
    }
}
