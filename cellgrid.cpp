#include "cellgrid.h"

#include <cstdlib>
#include <time.h>
#include <cstdio>



Cell::Cell(int type, bool unhappy) {
    _type = type;
    _unhappy = unhappy;
}


Cell::~Cell() {

}


CellGrid::CellGrid()
{

}

CellGrid::~CellGrid()
{
    while(_cells.length() > 0) {
        delete(_cells.takeLast());
    }
}



// Begin API


void CellGrid::clearBoard() {
    while(_cells.length() > 0) {
        delete(_cells.takeLast());
    }
}


void CellGrid::resetBoard(int size, QList<double> type_percentages) {

    // Param checks!
    if (size < 10) {
        size = 10;
    }

    if (type_percentages.length() == 0) {
        type_percentages.append(1.0);
    }


    // Make sure the percentages only add up to 100% (just a sanity check)
    double sum_percent = 0.0;
    for (int i = 1; i < type_percentages.length(); i++) {
        sum_percent += type_percentages[i];
    }

    if (sum_percent > 1.0) {
        type_percentages.clear();
        type_percentages.append(1.0);
    }



    // Set some convenience variables
    _size = size;
    _numTypes = type_percentages.length();
    _numCells = size * size;


    // Make sure we clear the board first
    clearBoard();


    // Calculate the counts for each type of cell
    QList<int> num_cell_type;
    // Add in count of the number of blank cells
    num_cell_type.append(_numCells * type_percentages[0]);

    // Add in the counts for the rest of the cell types.
    int num_non_blank = _numCells - num_cell_type[0];
    for (int i = 1; i < _numTypes; i++) {
        num_cell_type.append(num_non_blank * type_percentages[i]);
    }


    // Fill up our cell list with new cells
    for (int i = 0; i < _numCells; i++) {
        _cells.append(new Cell(0, false));
    }


    // Randomly assign cells types making sure that the final count for
    // each type matches what was calculated above. Yes I know that this
    // isn't the fastest way, but it's simple and works.

    // We start by looping over each possible type except for the empty
    // cell type.  Then we loop over the count for that type randomly
    // picking an index until we land on an empty cell. Then we set
    // that empty cell to have the new type.
    std::srand(time(NULL));
    for (int type = 1; type < _numTypes; type++) {
        for (int i = 0; i < num_cell_type[type]; i++) {
            int index = std::rand() % _numCells;
            if (((Cell*)_cells[index])->type() == 0) {
                ((Cell*)_cells[index])->setType(type);
            } else {
                i--;
            }
        }
    }

    printf("Board is ready!!!\n");
    fflush(stdout);

    emit boardReady();
    emit cellsChanged();
}


void CellGrid::setUpdateParameters(int neighborhood_distance, double percent_neighbors_same) {
    if (neighborhood_distance < 1) {
        neighborhood_distance = 1;
    }

    if (percent_neighbors_same > 100.0) {
        percent_neighbors_same = 100.0;
    } else if (percent_neighbors_same < 0.0) {
        percent_neighbors_same = 0.0;
    }

    neighborhoodDistance = neighborhood_distance;
    percentNeighborsSame = percent_neighbors_same;
    numTypes = _numTypes;

}


int CellGrid::fullStep() {
    int num_unhappy = markUnhappy();
    moveUnhappy();
    return num_unhappy;
}


int CellGrid::markUnhappy() {

    int num_unhappy = 0;

    for (int i = 0; i < _cells.size(); i++) {

        Cell *cur_cell = (Cell*)_cells[i];
        int num_neighbor_type[_numTypes];
        for (int type = 0; type < _numTypes; type++) {
            num_neighbor_type[type] = 0;
        }

        int cur_row = i / _size;//cur_cell->row();
        int cur_col = i % _size;//cur_cell->col();

        // Count the neighbors' types
        for (int row = -neighborhoodDistance; row <= neighborhoodDistance; row++) {
            for (int col = -neighborhoodDistance; col <= neighborhoodDistance; col++) {
                int neighbor_row = cur_row + row;
                int neighbor_col = cur_col + col;

                // Make sure we're in the grid
                if (neighbor_row >= 0 && neighbor_row < _size &&
                    neighbor_col >= 0 && neighbor_col < _size) {


                    // We don't want to count the current cell, only it's neighbors
                    if (neighbor_col != cur_col || neighbor_row != cur_row) {

                        int idx = neighbor_row * _size + neighbor_col;
                        Cell *neighbor = (Cell*)_cells[idx];
                        if (neighbor) {
                            num_neighbor_type[neighbor->type()]++;
                        }
                    }
                }
            }
        }

        // Calculate the percentage of neighbors
        int num_neighbors = 0;
        for (int type = 1; type < numTypes; type++) {
            num_neighbors += num_neighbor_type[type];
        }


        double percent_same = 1.0;
        if (num_neighbors != 0) {
            percent_same = (double)num_neighbor_type[cur_cell->type()] / (double)num_neighbors;
        }

        if (cur_cell->type() > 0 && percent_same < percentNeighborsSame) {
            cur_cell->setUnhappy(true);
            num_unhappy++;
        }
    }

    emit cellsChanged();

    return num_unhappy;
}


void CellGrid::moveUnhappy() {

    std::srand(time(NULL));
    for (int i = 0; i < _cells.size(); i++) {
        Cell *cur_cell = (Cell*)_cells[i];
        if (cur_cell->unhappy()) {
            int rand_idx = std::rand() % _cells.size();
            Cell *rand_cell = (Cell*)_cells[rand_idx];

            if (rand_cell->type() != 0) {
                i--;
            } else {
                rand_cell->setType(cur_cell->type());
                rand_cell->setUnhappy(false);
                cur_cell->setType(0);
                cur_cell->setUnhappy(false);
            }
        }
    }

    emit cellsChanged();

}

// End API





// Private
int index(int row, int col) {
    if (row < 0) {
        row = 0;
    }

    if (col < 0) {
        col = 0;
    }



    return -1;
}
