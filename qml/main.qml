import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: root
    title: qsTr("Chess")
    visible: true
    minimumWidth: logic.boardSize * squareSize + squareSize * 4
    minimumHeight: logic.boardSize * squareSize

    property int squareSize: 70
    property var players: ["127.0.0.1", "192.168.10.1", "192.168.11.2"];

    property var images: [
        [
            {'imgPath' : "/images/white_pawn.png"},
            {'imgPath' : "/images/white_rook.png"},
            {'imgPath' : "/images/white_bishop.png"},
            {'imgPath' : "/images/white_knight.png"},
            {'imgPath' : "/images/white_queen.png"},
            {'imgPath' : "/images/white_king.png"}
        ],

        [
            {'imgPath' : "/images/black_pawn.png"},
            {'imgPath' : "/images/black_rook.png"},
            {'imgPath' : "/images/black_bishop.png"},
            {'imgPath' : "/images/black_knight.png"},
            {'imgPath' : "/images/black_queen.png"},
            {'imgPath' : "/images/black_king.png"}
        ]
    ]
    //color: "#A1A0CE"
    color: "#FFFFFF"

    Component {
        id: gameBoard
        Item {
            Image {
                id: board
                source: "/images/chess_board.jpg"
                height: logic.boardSize * squareSize
                width: logic.boardSize * squareSize
            }
        }
    }

    Component {
        id: buttonLoadGame

        Button {
            text: "Load Game"
            onClicked: {
                console.log("Load Game");
                screen.pop(null);
                screen.push(loadGameScreen);
            }
        }
    }

    Component {
        id: buttonNewGame

        Button {
            text: "Play with bot"
            onClicked: {
                console.log("Play with bot");
                logic.clear();
                logic.newGame();
                screen.pop(null);
                screen.push(newGameScreen);
            }
        }
    }

    Component {
        id: buttonHotseat

        Button {
            text: "New Game"
            onClicked: {
                console.log("New game");
                logic.clear();
                logic.newGame();
                screen.pop(null);
                screen.push(newHotseatGameScreen);
            }
        }
    }



    Component{
        id: buttonRefreshList

        Button {
            Layout.alignment: Qt.AlignCenter
            text: "Refresh List"
            onClicked: {
                console.log("Refresh List");
            }
        }
    }


    Component {
        id: buttonSaveGame

        Button {
            text: "Save game"
            onClicked: {
                console.log("Save game");
                logic.saveGame();
            }
        }
    }

    Component {
        id: buttonEndGame

        Button {
            text: "End game"
            onClicked: {
                console.log("End game");
                logic.clear();
                screen.pop()
            }
        }
    }

    Component {
        id: buttonBack

        Button {
            x: logic.boardSize * squareSize
            width: root.width - x
            height: squareSize
            text: "Back"
            onClicked: {
                console.log("Back");
                screen.pop()
            }
        }
    }


    Component{
        id: buttonPrev
        Button {
            id: prev
            text: "Prev"
            onClicked: {
                logic.prev();
                console.log("Prev");
            }
        }
    }

    Component{
        id: buttonNext
        Button {
            id: next
            text: "Next"
            onClicked: {
                logic.next();
                console.log("Next");
            }
        }
    }

    Component {
        id: chessPlacement
        Item {
            Repeater {
                model: logic
                Image {
                    height: squareSize
                    width : squareSize

                    x: squareSize * positionX
                    y: squareSize * positionY

                    source: images[(side == true) ? 0 : 1][type].imgPath

                    MouseArea {
                        anchors.fill: parent
                        drag.target: parent
                        property int startX: 0
                        property int startY: 0
                        onPressed: {
                            console.log("On press: ", parent.x, parent.y);
                            startX = parent.x;
                            startY = parent.y;
                        }
                        onReleased: {
                            var  fromX = startX / squareSize;
                            var fromY = startY / squareSize;
                            var toX   = (parent.x + mouseX) / squareSize;
                            var toY   = (parent.y + mouseY) / squareSize;
                            var l = logic;
                            var result = l.isWhiteTurn();

                            if (!logic.move(fromX, fromY, toX, toY))
                            {
                                parent.x = startX;
                                parent.y = startY;
                            }
                            if(result)
                            {
                                console.log("White made their turn");
                                l.doAiTurn();
                            }

                        }
                    }
                }
            }
        }
    }

    Component {
        id: chessHotseatPlacement

        Item {
            Repeater {
                model: logic
                Image {
                    height: squareSize
                    width : squareSize

                    x: squareSize * positionX
                    y: squareSize * positionY

                    source: images[(side == true) ? 0 : 1][type].imgPath

                    MouseArea {
                        anchors.fill: parent
                        drag.target: parent
                        property int startX: 0
                        property int startY: 0
                        onPressed: {
                            console.log("On press: ", parent.x, parent.y);
                            startX = parent.x;
                            startY = parent.y;
                        }
                        onReleased: {
                            var  fromX = startX / squareSize;
                            var fromY = startY / squareSize;
                            var toX   = (parent.x + mouseX) / squareSize;
                            var toY   = (parent.y + mouseY) / squareSize;
                            if (!logic.move(fromX, fromY, toX, toY))
                            {
                                parent.x = startX;
                                parent.y = startY;
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: newGameScreen

        Item {
            ColumnLayout{
                anchors.fill: parent

                Loader {
                    id: board
                    sourceComponent: gameBoard
                }
                Loader {sourceComponent: chessPlacement}

                RowLayout{
                    Layout.alignment: Qt.AlignBottom

                    Loader {sourceComponent: buttonSaveGame}
                    Loader {sourceComponent: buttonEndGame}
                }
            }
        }
    }

    Component {
        id: newHotseatGameScreen

        Item {
            ColumnLayout{
                anchors.fill: parent

                Loader {
                    id: board
                    sourceComponent: gameBoard
                }
                Loader {sourceComponent: chessHotseatPlacement}

                RowLayout{
                    Layout.alignment: Qt.AlignBottom

                    Loader {sourceComponent: buttonSaveGame}
                    Loader {sourceComponent: buttonEndGame}

                }
            }
        }
    }

    Component {
        id: loadGameScreen

        Item {
            Component {
                id: itemDelegate
                Text {
                    text:  logic.gameName(index)
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:  {
                                logic.clear();
                                logic.newGame();
                                logic.selectGame(index);
                                screen.replace(historyScreen);
                        }
                        onHoveredChanged: {
                                font.underline = font.underline == true ? false : true;
                                font.bold = font.bold == true ? false : true;
                        }
                    }
                }
            }
            ListView {
                height: 200
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 10
                model: logic.gamesSaved
                delegate: itemDelegate

                header: Text {text: "Click to choose"}
                Loader {sourceComponent: buttonBack}
            }
        }
    }

    Component {
        id: historyScreen

        Item {
            ColumnLayout{
                anchors.fill: parent
                Loader {
                    id: board
                    sourceComponent: gameBoard
                }
                Loader {sourceComponent: chessPlacement}

                RowLayout{
                    Layout.alignment: Qt.AlignBottom
                    Loader {sourceComponent: buttonNewGame}
                    Loader {sourceComponent: buttonLoadGame}
                    Loader {sourceComponent: buttonPrev}
                    Loader {sourceComponent: buttonNext}
                }
            }
        }
    }

    Component{
        id: playersList
        Item{
            anchors.top:parent.top
            anchors.left: parent.left
            anchors.leftMargin: 100
            anchors.topMargin:  100
            Component{
                id: textDelegat
                Text {
                    text: root.players[index]
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:  {
                            console.log("itme");
                        }
                        onHoveredChanged: {
                            font.underline = font.underline == true ? false : true;
                            font.bold = font.bold == true ? false : true;
                        }
                    }
                }
            }


            ListView{
                height: 400

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 140
                anchors.topMargin: 600
                model: root.players
                delegate: textDelegat
            }
        }
    }

    Component{
        id: mainMenu
        ColumnLayout{
            height: 600
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

            Loader {
                sourceComponent: buttonHotseat
                Layout.alignment: Qt.AlignCenter

            }
            Loader {
                sourceComponent: buttonNewGame
                Layout.alignment: Qt.AlignCenter
            }

            Loader {
                sourceComponent: buttonLoadGame
                Layout.alignment: Qt.AlignCenter
            }

            Loader{
                sourceComponent: buttonRefreshList
                Layout.alignment: Qt.AlignCenter
            }

            Loader{
                sourceComponent: playersList
                Layout.alignment: Qt.AlignCenter | Qt.AlignBottom
            }

        }
    }

    StackView {
        id: screen
        anchors.fill: parent
        initialItem: mainMenu
    }
}
