#include <QApplication>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <src/gameengine.hpp>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

  #ifdef QT_DEBUG
    engine.rootContext()->setContextProperty("debug", true);
  #else
    engine.rootContext()->setContextProperty("debug", false);
  #endif

    engine.rootContext()->setContextProperty("GameEngine", new GameEngine);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

