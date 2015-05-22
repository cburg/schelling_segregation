#include <QApplication>
#include <QQmlApplicationEngine>

#include <cstdio>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    printf("Setting up QML engine\n");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/schelling_segregation.qml")));

    printf("Running QML application\n");
    return app.exec();
    printf("Done Running QML Application\n");
}
