#ifndef CELLGRID_H
#define CELLGRID_H

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





class CellGrid : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> cells READ cells NOTIFY cellsChanged)


signals:
    void boardReady();
    void cellsChanged();

public:
    CellGrid();
    ~CellGrid();

    // Begin API
    Q_INVOKABLE void clearBoard();
    Q_INVOKABLE void resetBoard(int size, QList<double> type_percentages);
    Q_INVOKABLE void setUpdateParameters(int neighborhood_distance, double percent_neighbors_same);

    Q_INVOKABLE int fullStep();
    Q_INVOKABLE int markUnhappy();
    Q_INVOKABLE void moveUnhappy();
    // End API

    QList<QObject*> &cells() {
        return _cells;
    }



private:

    QList<QObject*> _cells;
    int _size;
    int _length;
    int _width;
    int _numCells;
    int _numTypes;

    int index(int row, int col);

    int neighborhoodDistance;
    double percentNeighborsSame;
    int numTypes;

};

#endif // CELLGRID_H
