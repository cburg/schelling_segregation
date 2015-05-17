var cellList;

var neighborhoodDistance = 1;   // Max distance away from target cell that
                                // neighbors can be. Horizontal and vertical
                                // distances are both counted.

var percentNeighborsSame = 0.60; // Percentage of neighbors that are the
                                 // same type as the target cell. Blank
                                 // cells are not counted.

var numTypes = 3;


function index(row, col) {
    return row * d.size + col;
}


// Clears the board, then refills it with the given percentages of
// each type of cell (allowing for more than just 2 types). The
// relative amounts are specified as percentages (0 --> 1.0). The
// first item in the percentage array represents the percentage of
// blank spaces. The remaining percentages are applied to the
// remaining available spaces. If the
function reset_board(size, type_percentages) {
    // Clamp size
    if (size < 10) {
        size = 10;
    }

    // Check parameter
    if (!Array.isArray(type_percentages) || type_percentages.length === 0) {
        type_percentages = [1.0];
    }

    // Make sure that the percentages only add up to 100%
    var sum_percent = 0.0;
    for (var i = 1; i < type_percentages.length; i++) {
        sum_percent += type_percentages[i];
    }

    if (sum_percent > 1.0) {
        type_percentages = [1.0];
    }


    // Delete all cells in the board
    clear_board();


    // Fill up the counts for each type of cell
    var num_cell_type = new Array(type_percentages.length);

    num_cell_type[0] = (d.numCells) * type_percentages[0];
    var num_non_blank = (d.numCells) - num_cell_type[0];
    for (var i = 0; i < num_cell_type.length; i++)  {
        num_cell_type[i] = num_non_blank * type_percentages[i];
    }


    // Fill up the board with new cells
    cellList = new Array(d.numCells);
    for (var i = 0; i < d.numCells; i++) {
        // Create a new cell
        var newCell = d.cellComponent.createObject(cellGrid);
        newCell.width = Qt.binding(function() {return d.cellWidth});
        newCell.height = Qt.binding(function() {return d.cellWidth});
        var row = Math.floor(i / d.size);
        var col = i % d.size;
        newCell.row = row;
        newCell.col = col;

        newCell.type = 0;
        newCell.happy = true;

        cellList[i] = newCell;
    }

    // Set the cells to have the relative numbers of each type
    for (var type = 1; type < num_cell_type.length; type++) {
        for (var i = 0; i < num_cell_type[type]; i++) {
            var index = Math.floor(Math.random() * d.numCells);
            // Not the most efficient way, but it works...
            if (cellList[index].type === 0) {
                cellList[index].type = type;
            } else {
                i--;
            }
        }
    }
}


// Set the parameters used during each update step.
function set_update_parameters(neighborhood_distance, percent_neighbors_same) {
    neighborhoodDistance = neighborhood_distance;
    percentNeighborsSame = percent_neighbors_same;
}


// Clears all elements from the board.
function clear_board() {
    if (!Array.isArray(cellList)) {
        return;
    }

    while (cellList.length > 0) {
        var removedCell = cellList.pop();
        if (removedCell) {
            removedCell.destroy();
        }
    }
}


function full_step() {
    var num_unhappy = mark_unhappy();
    move_unhappy();
    return num_unhappy;
}


function mark_unhappy() {
    var num_unhappy = 0;

    for (var i = 0; i < d.numCells; i++) {

        var cur_cell = cellList[i];

        var num_neighbor_type = new Array(numTypes);
        for (var type = 0; type < numTypes; type++) {
            num_neighbor_type[type] = 0;
        }

        var cur_row = cur_cell.row
        var cur_col = cur_cell.col;

        // Count blue and red neighbors
        for (var row = -neighborhoodDistance; row <= neighborhoodDistance; row++) {
            for (var col = -neighborhoodDistance; col <= neighborhoodDistance; col++) {
                var neighbor_row = cur_row + row;
                var neighbor_col = cur_col + col;

                // Make sure we're in bounds
                if (neighbor_row >= 0 && neighbor_row < d.size &&
                    neighbor_col >= 0 && neighbor_col < d.size) {

                    // Make sure we don't count the current cell
                    if (neighbor_col != cur_col || neighbor_row != cur_row) {

                        var idx = neighbor_row * d.size + neighbor_col;
                        var cell = cellList[idx];
                        if (cell) {
                            num_neighbor_type[cell.type]++;
                        }
                    }
                }
            }
        }

        // Calculate percentage of neighbors
        var num_neighbors = 0;
        for (var type = 1; type < numTypes; type++) {
            num_neighbors += num_neighbor_type[type];
        }

        var percent_same = num_neighbor_type[cur_cell.type] / num_neighbors;
        if (cur_cell.type > 0 && percent_same < percentNeighborsSame) {
            cur_cell.happy = false;
            num_unhappy++;
        }
    }

    return num_unhappy;
}


function move_unhappy() {
    for (var i = 0; i < d.numCells; i++) {

        var cur_cell = cellList[i];

        if (!cur_cell.happy) {
            // Find random cell
            var rand_idx = Math.floor(Math.random() * d.numCells);
            var rand_cell = cellList[rand_idx];

            if (rand_cell.type != 0) {
                i--;
            } else {
                cellList[rand_idx].type = cur_cell.type;
                cellList[rand_idx].happy = true;
                cur_cell.type = 0;
                cur_cell.happy = true;
            }
        }
    }
}
