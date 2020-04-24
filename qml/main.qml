import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: root
    title: qsTr("Chess")
    visible: true
    minimumWidth: logic.boardSize * squareSize
    minimumHeight: logic.boardSize * squareSize+squareSize

    property int squareSize: 70
    property var players: ["127.0.0.1", "192.168.10.1", "192.168.11.2"];
    property bool aiEnabled

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
                root.aiEnabled = true;
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
            text: "Hot seat"
            onClicked: {
                root.aiEnabled = false;
                console.log("Hot seat");
                logic.clear();
                logic.newGame();
                screen.pop(null);
                screen.push(newGameScreen);
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
                            var r = root;
                            var result = l.isWhiteTurn();

                            if (!logic.move(fromX, fromY, toX, toY))
                            {
                                parent.x = startX;
                                parent.y = startY;
                            }
                            if(result)
                            {
                                console.log("White made their turn");
                                if(r.aiEnabled)
                                    l.doAiTurn();
                            }

                        }
                    }
                }
            }
        }
    }

    Component {
        id: newGameScreen

            ColumnLayout{

                Loader {id: board; sourceComponent: gameBoard;}
                Loader {sourceComponent: chessPlacement;}
                RowLayout{
                    Loader {sourceComponent: buttonSaveGame}
                    Loader {sourceComponent: buttonEndGame}
                    Layout.alignment: Qt.AlignBottom|Qt.AlignHCenter
                }
            }
    }

    Component {
        id: loadGameScreen

        ColumnLayout {
            spacing: 0
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
            Label{
                text: "Tap to choose"
                font.pointSize: 24
                Layout.alignment: Qt.AlignCenter
            }

            Rectangle {
                height: 200
                width: 200
                color: "white"
                ListView {
                    anchors.fill: parent
                    height: 200
                    model: logic.gamesSaved
                    delegate: itemDelegate
                }
                Layout.alignment: Qt.AlignCenter
            }

            Loader {sourceComponent: buttonBack; Layout.alignment: Qt.AlignCenter}
        }
    }

    Component {
        id: historyScreen

            ColumnLayout{
                Loader {id: board;sourceComponent: gameBoard}
                Loader {sourceComponent: chessPlacement}
                RowLayout{
                    Layout.alignment: Qt.AlignBottom|Qt.AlignHCenter
                    Loader {sourceComponent: buttonBack}
                    Loader {sourceComponent: buttonPrev}
                    Loader {sourceComponent: buttonNext}
                }
            }

    }

    Component
    {
        id: playersList
        ColumnLayout
        {
            Rectangle {
                width:180
                height:30
                radius: 10

                TextInput {
                    id:nickname
                    anchors.fill:parent
                    horizontalAlignment:TextInput.AlignHCenter
                    verticalAlignment:TextInput.AlignVCenter
                    validator: RegExpValidator { regExp: /[a-zA-Z]+/ }
                }
            }
            RowLayout{
                Button {
                    id:loginButton
                    text: "Login"
                    onClicked: {
                        client.login(nickname.text)
                        console.log(nickname.text)
                        enabled = false
                        disconnectButton.enabled=true;
                    }
                }
                Button {
                    id:disconnectButton
                    text: "Disconnect"
                    enabled: false
                    onClicked: {
                        client.disconnect()
                        enabled = false
                        loginButton.enabled=true;
                    }
                }
                Layout.alignment:Qt.AlignHCenter
            }


            Rectangle {
                width: 180; height: 200
                radius: 10
                ListView {
                    id:playerModel
                    model: client
                    anchors.fill:parent
                    clip:true
                    delegate: Component {
                        Item {

                            width: 180; height: 40
                            Column {
                                Text {
                                    text: '<b>Username:</b> ' + username }
                            }
                        }
                    }
                    highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                    focus: true
                }
            }

            Button {
                text: "Refresh List"
                onClicked: {
                    playerModel.forceLayout()
                    console.log(client.rowCount());
                    console.log("Refresh List");
                }

                Layout.alignment:Qt.AlignHCenter|Qt.AlignBottom
            }
        }

   }

    Component{
        id: mainMenu
        ColumnLayout{
            Label{
                text: "Chess"
                font.pointSize: 32
                Layout.alignment:Qt.AlignHCenter
            }

            Loader {sourceComponent: buttonHotseat;Layout.alignment:Qt.AlignHCenter}
            Loader {sourceComponent: buttonNewGame;Layout.alignment:Qt.AlignHCenter}
            Loader {sourceComponent: buttonLoadGame;Layout.alignment:Qt.AlignHCenter}
            Loader {sourceComponent: playersList;Layout.alignment:Qt.AlignHCenter}

        }
    }

    StackView {
        id: screen
        anchors.fill: parent
        initialItem: mainMenu
    }
}
