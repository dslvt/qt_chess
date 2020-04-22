import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.14
import './qml'

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 720
    height: 1280
    title: qsTr("Menu")

    StackView {
        id: stack
        anchors.fill: parent
    }

    Component{
        id: mainView
        ColumnLayout{
            height: 300
            anchors.verticalCenterOffset: -317
            anchors.horizontalCenterOffset: 0
            anchors.rightMargin: 0
            anchors.bottomMargin: 508
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent

            //width: parent.width
            clip: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Layout.alignment: Qt.AlignCenter
            spacing: 0

            Label{
                text: "Chess"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 64
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            }

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
                onClicked:{
                    stack.push(window)
                }

            }
            Button{
                Layout.alignment: Qt.AlignCenter
                text: "View previous matches"
                Layout.fillHeight: false
                Layout.fillWidth: false
                Layout.preferredWidth: -1
                topPadding: 8
                autoRepeat: false
            }
        }
    }

    Component{
        id: window
        Window{
           width: parent.width
           height: parent.height
           onExitToMainMenu: stack.pop()
        }
    }

    Component.onCompleted: stack.push(mainView)
}
