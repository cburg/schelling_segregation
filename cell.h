#ifndef CELL_H
#define CELL_H

#include <QObject>

class Cell : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int type READ type NOTIFY typeChanged)
    Q_PROPERTY(bool unhappy READ unhappy NOTIFY unhappyChanged)

public:
    Cell(int type, bool unhappy);
    ~Cell();

    int type() {
        return _type;
    }

    bool unhappy() {
        return _unhappy;
    }

    void setType(int type) {
        _type = type;
        emit typeChanged();
    }

    void setUnhappy(bool unhappy) {
        _unhappy = unhappy;
        emit unhappyChanged();
    }

    int row() {
        return _row;
    }

    int col() {
        return _col;
    }

signals:
    void typeChanged();
    void unhappyChanged();

private:
    int _type;
    bool _unhappy;
    int _row;
    int _col;

};

#endif // CELL_H
