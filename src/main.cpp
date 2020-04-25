#include "logic.h"
#include "moveslist.h"
#include "p2pclient.h"
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <iostream>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Logic logic;
    P2PClient client;
    client.setMask("255.255.255.255");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("logic", &logic);
    engine.rootContext()->setContextProperty("client", &client);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
