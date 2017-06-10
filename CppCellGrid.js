var cellList;

function create_cells() {
    // Clear the board first
    clear_board();

    var cpp_cells = cppgrid.cells

    // Fill up the board with new cells
    cellList = new Array(d.numCells);

    for (var i = 0; i < d.numCells; i++) {
        // Create a new cell
        var row = Math.floor(i / d.size);
        var col = i % d.size;
        var newCell = d.cellComponent.incubateObject(cellGrid,
           {
               width: Qt.binding(function() {return d.cellWidth}),
               height: Qt.binding(function() {return d.cellWidth}),
               row: row,
               col: col,
               idx: i,
               type: Qt.binding(function() {return cppgrid.cells[this.idx].type}),
               happy: Qt.binding(function() {return !cppgrid.cells[this.idx].unhappy})

           });

        cellList[i] = newCell;
    }
}


// Clears all elements from the board.
function clear_board() {
    if (!Array.isArray(cellList)) {
        return;
    }

    while (cellList.length > 0) {
        var removedCell = cellList.pop();
        if (removedCell) {
            removedCell.object.destroy();
        }
    }
}
