#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>

#include "cellgrid.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQuickView view;

    CellGrid cppgrid;

    qmlRegisterType<CellGrid>("CellGridSG", 1, 0, "CellGridSG");

    view.engine()->rootContext()->setContextProperty("cppgrid", &cppgrid);
    view.setSource(QUrl("qrc:/schelling_segregation.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();

}
