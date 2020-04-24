#include "logic.h"
#include "moveslist.h"
#include "chatworker.h"
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <iostream>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Logic logic;
    chatWorker client;
    client.setMask("255.255.255.255");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("logic", &logic);
    engine.rootContext()->setContextProperty("client", &client);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
