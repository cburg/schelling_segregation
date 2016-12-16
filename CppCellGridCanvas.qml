import QtQuick 2.0


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

    Canvas {
        id: cellCanvas
        anchors.fill: parent;

        onPaint: {

            var ctx = getContext("2d");

            for (var i = 0; i < d.numCells; i++) {
                var x = Math.floor(i / d.size) * d.cellWidth;
                var y = (i % d.size) * d.cellWidth;

                var type = cppgrid.cells[i].type;

                if (type === 1) {
                    ctx.fillStyle = "red"
                } else if (type === 2) {
                    ctx.fillStyle = "blue"
                } else {
                    ctx.fillStyle = "darkgrey"
                }

                // TODO: Fix borders between cells
                ctx.fillRect(x, y, x + d.cellWidth, y + d.cellWidth);
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
        cellCanvas.requestPaint();
        //CellGridJs.create_cells();

    }

    // Updates the neighborhood distance (number of cells away that we can count as
    // being a neighbor).
    function setUpdateParameters(neighborhood_distance, percent_neighbors_same) {
        console.log("Setting update parameters");
        var ret =  cppgrid.setUpdateParameters(neighborhood_distance, percent_neighbors_same);
        return ret
    }

    function fullStep() {
        return cppgrid.fullStep();
    }

    function markUnhappy() {
        //console.log("Marking unhappy cells");
        var ret = cppgrid.markUnhappy();
        cellCanvas.requestPaint();
        return ret;
    }

    function moveUnhappy() {
        var ret = cppgrid.moveUnhappy();
        cellCanvas.requestPaint();
        return ret;
    }

}

