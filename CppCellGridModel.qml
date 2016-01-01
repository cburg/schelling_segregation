import QtQuick 2.0

// CppCellGridModel uses a GridView with a C++ model as the backend.
// Unfortunately, the setup time for the grid is quite slow.


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

    GridView {
        anchors.fill: parent
        anchors.centerIn: parent
        cellWidth: d.cellWidth
        cellHeight: d.cellWidth
        model: cppgrid.cells;
        delegate: Component {
            Cell {
                width: d.cellWidth
                height: d.cellWidth
                happy: !model.modelData.unhappy;
                type: model.modelData.type;
            }
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
        cppgrid.resetBoard(size, type_percentages);
    }

    // Updates the neighborhood distance (number of cells away that we can count as
    // being a neighbor).
    function setUpdateParameters(neighborhood_distance, percent_neighbors_same) {
        console.log("Setting update parameters");
        return cppgrid.setUpdateParameters(neighborhood_distance, percent_neighbors_same);
    }

    function fullStep() {
        return cppgrid.fullStep();
    }

    function markUnhappy() {
        console.log("Marking unhappy cells");
        return cppgrid.markUnhappy();
    }

    function moveUnhappy() {
        return cppgrid.moveUnhappy();
    }

}

