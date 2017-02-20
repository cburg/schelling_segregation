#ifndef CELLGRID_H
#define CELLGRID_H

#include <QObject>
#include <QQuickItem>
#include "cell.h"

class CellGrid : public QQuickItem
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

    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *);

    QList<QObject*> &cells() {
        return _cells;
    }



private:

    QList<QObject*> _cells;
    QList<int> _freeCells;
    int _size;
    int _length;
    int _width;
    int _numCells;
    int _numTypes;
    int _numUnhappy;
    int _neighborhoodDistance;
    double _percentNeighborsSame;

    int index(int row, int col);


};

#endif // CELLGRID_H
