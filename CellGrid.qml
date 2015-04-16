import QtQuick 2.0
import "CellGrid.js" as CellGrid

Rectangle {
    id: cellGrid
    width: 100
    height: 100

    color: "darkgrey"

    readonly property int numCells: d.numCells

    QtObject {
        id: d
        property int size: 10
        property int numCells: size * size
        property double cellWidth: cellGrid.width / size
        property variant cellComponent: Qt.createComponent("Cell.qml");
    }

    // Gets the cell at the specified index
    function get(index) {
        if (index >= 0 && index < d.numCells) {
            return CellGrid.cellList[index];
        } else {
            return null;
        }
    }

    // Resets the board with the specified parameters. We do not want to
    // allow these to be specified individually.
    //
    // type_percentages is an array holding all percentages (including
    // the percentage of blank spaces). This allows us to easily add
    // many more "players" to our grid.
    function resetBoard(size, type_percentages) {
        if (size < 10) {
            size = 10;
        }

        d.size = size;
        CellGrid.reset_board(size, type_percentages);
        console.log("Done resetting the board");
    }

    // Updates the neighborhood distance (number of cells away that we can count as
    // being a neighbor).
    function setUpdateParameters(neighborhood_distance, percent_neighbors_same) {
        return CellGrid.set_update_parameters(neighborhood_distance, percent_neighbors_same);
    }

    function fullStep() {
        return CellGrid.full_step();
    }

    function markUnhappy() {
        return CellGrid.mark_unhappy();
    }

    function moveUnhappy() {
        return CellGrid.move_unhappy();
    }
}

