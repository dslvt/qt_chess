import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    id: page
    width: 600
    height: 1200
    property var data: [{
            "x": 0,
            "y": 0,
            "color": "#E2B87E",
            "image": ''
        }, {
            "x": 0,
            "y": 1,
            "color": "#8F5636",
            "image": 'king_b.svg'
        }]

    Grid {
        id: gridView
        x: 60
        width: page.width * 0.8
        height: page.width * 0.8
        transformOrigin: Item.Center
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.centerIn: page
        rows: 8
        columns: 8
        Repeater {
            model: 2
            Rectangle {
                property var inx: index
                width: gridView.width / 8
                height: gridView.width / 8
                color: page.data[inx]["color"]
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log(parent.inx)
                    }
                }

                Image {
                    source: "assets/svg/" + page.data[inx]['image']
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                }
            }
        }
    }
}
