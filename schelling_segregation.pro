TEMPLATE = app

QT += qml quick widgets declarative

SOURCES += main.cpp \
    cellgrid.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \ 
    cellgrid.h
