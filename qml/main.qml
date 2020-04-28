import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.14


ApplicationWindow {
    id: root
    title: qsTr("Chess")
    visible: true
    minimumWidth: logic.boardSize * squareSize
    minimumHeight: logic.boardSize * squareSize+squareSize

    property int squareSize: 70
    property var players: ["127.0.0.1", "192.168.10.1", "192.168.11.2"];
    property bool aiEnabled
    property bool iAmHost
    property bool inLobby
    property string currentOpponent
    property var prevMoveCount: 1

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
                screen.push(newHotseatGameScreen);
                console.log("Play with bot: ", aiEnabled)
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
                        enabled: (!root.inLobby&&(side==true)&&root.aiEnabled)||
                                 ((root.inLobby)&&(((side==true)&&iAmHost)||
                                                   ((side!=true)&&!iAmHost)))||
                                 (!root.inLobby&&!root.aiEnabled)
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
                            var fromX = startX / squareSize;
                            var fromY = startY / squareSize;
                            var toX   = (parent.x + mouseX) / squareSize;
                            var toY   = (parent.y + mouseY) / squareSize;
                            var l = logic;
                            var r = root;
                            var c = client;

                            var whiteTurn = l.isWhiteTurn();

                            if (!logic.move(fromX, fromY, toX, toY))
                            {
                                parent.x = startX;
                                parent.y = startY;
                            }
                            if(!whiteTurn && r.aiEnabled)
                                    l.doAiTurn();

                            if(r.inLobby)
                            {
                                var move = Math.floor(fromX).toString()+ Math.floor(fromY).toString()+  Math.floor(toX).toString()+  Math.floor(toY).toString();
                                c.sendMove(r.currentOpponent,move);
                                console.log("sent move "+move);
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
                ColumnLayout{
                    Layout.alignment: Qt.AlignBottom|Qt.AlignHCenter
                    Loader {sourceComponent: sliderHistory}
                    RowLayout{
                        Layout.alignment: Qt.AlignBottom|Qt.AlignHCenter
                        Loader {sourceComponent: buttonNewGame}
                        Loader {sourceComponent: buttonLoadGame}
                        Loader {sourceComponent: buttonBack}
                    }

                }
            }
    }

    Component {
        id: sliderHistory
        Slider {
            id: hSlider
            enabled: !logic.getSteps() === 0
            width: root.width*0.8
            from: 1
            value: 1
            to: logic.getSteps()
            snapMode: Slider.SnapAlways
            onMoved: {
                if(prevMoveCount != Math.floor(valueAt(position))){
                    if(prevMoveCount - Math.floor(valueAt(position)) > 0){
                        logic.prev();
                    }else{
                        logic.next();
                    }
                    prevMoveCount = Math.floor(valueAt(position))
                }
            }

            SequentialAnimation{
                id: ani
                running: true
                NumberAnimation{
                    to: logic.getSteps()
                    duration: 500*logic.getSteps()
                    target: hSlider
                    property: 'value'
                    from: 1
                }
                ScriptAction{
                    script: {
                        sliderTimer.stop();
                    }
                }
            }
            Timer{
                id: sliderTimer
                interval: 500;
                running: true;
                repeat: true;
                onTriggered: {
                    if(prevMoveCount != Math.floor(valueAt(hSlider.position))){
                        if(prevMoveCount - Math.floor(valueAt(hSlider.position)) > 0){
                            logic.prev();
                        }else{
                            logic.next();
                        }
                        prevMoveCount = Math.floor(valueAt(hSlider.position))
                        }
                }
            }
        }
    }

    Component
    {
        id: playersList
        ColumnLayout
        {
            Label{
                text: "Nickname"
                font.pointSize: 11
                Layout.alignment: Qt.AlignCenter
            }
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
                    onTextChanged:
                    {
                        if(!disconnectButton.enabled)
                            loginButton.enabled = acceptableInput
                    }
                }
            }
            RowLayout{
                Button {
                    id:loginButton
                    text: "Host"
                    enabled: nickname.acceptableInput
                    onClicked: {
                        if(nickname.acceptableInput)
                        {
                            client.login(nickname.text)
                            console.log(nickname.text)
                            enabled = false
                            disconnectButton.enabled=true;
                        }
                    }

                }
                Button {
                    id:disconnectButton
                    text: "Disconnect"
                    enabled: false
                    onClicked: {
                        client.disconnect()
                        client.clearPeers()
                        enabled = false
                        if(nickname.acceptableInput)
                            loginButton.enabled=true;
                    }
                }
                Layout.alignment:Qt.AlignHCenter
            }

            Label{
                text: "Lobbies"
                font.pointSize: 11
                Layout.alignment: Qt.AlignCenter
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


                            width: parent.width; height: 40
                            Text {
                                id:userText
                                text: username
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: playerModel.currentIndex = index
                            }
                        }
                    }
                    highlight: Rectangle {
                        color: 'cyan'
                    }
                    focus: true
                }
            }

            Button {
                text: "Connect"
                enabled: nickname.acceptableInput
                onClicked: {
                    root.aiEnabled = false;
                    root.iAmHost = false;
                    root.inLobby = true;
                    client.setUserName(nickname.text);
                    var hostname = client.get(playerModel.currentIndex).username;
                    hostname = hostname.substring(0, hostname.indexOf('('));
                    console.log("Connecting to:"+hostname);
                    client.sendHostResponse(hostname);
                    currentOpponent = hostname;
                    logic.clear();
                    logic.newGame();
                    screen.pop(null);
                    screen.push(newGameScreen);
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

    Connections {
        target: client
        onReceivedHostResponse: {
            root.aiEnabled = false;
            root.iAmHost = true;
            root.inLobby = true;
            currentOpponent = responder;
            console.log(responder+ " connected to your game");
            logic.clear();
            logic.newGame();
            screen.pop(null);
            screen.push(newGameScreen);
        }
    }

    Connections {
        target: client
        onReceivedOpponentMove: {
            console.log("NEW MOVE"+ move);
            var fromX = parseInt(move.charAt(0));
            var fromY = parseInt(move.charAt(1));
            var toX = parseInt(move.charAt(2));
            var toY = parseInt(move.charAt(3));
            console.log("received new move: " +fromX+" "+fromY+" "+toX+" "+toY);
            logic.move(fromX, fromY, toX, toY)
        }
    }

}
