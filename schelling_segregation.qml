import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

Rectangle {
    id: mainWindow
    width: 850
    height: 400
    color: "darkgrey"

    RowLayout {
        anchors.fill: mainWindow

        Panel {
            id: gridPanel
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            /*// Efficient grid initialization
            // Slow grid updates
            CellGrid {
                id: board
                width: gridPanel.interiorWidth
                height: gridPanel.interiorHeight
                anchors.centerIn: gridPanel
            }/**/


            /*// Sometimes efficient grid initialization
            // Efficient grid update
            CppCellGridModel {
                id: board
                width: gridPanel.interiorWidth
                height: gridPanel.interiorHeight
                anchors.centerIn: gridPanel
            }
            /**/

            // Sometimes efficient grid initialization
            // Efficient grid update
            CppCellGridCanvas {
                id: board
                width: gridPanel.interiorWidth
                height: gridPanel.interiorHeight
                anchors.centerIn: gridPanel
            }
            /**/

            /*// *Very* slow grid creation
            // *Very* slow grid updates
            CppCellGrid {
                id: board
                width: gridPanel.interiorWidth
                height: gridPanel.interiorHeight
                anchors.centerIn: gridPanel
            }
            /**/
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: gridPanel.right
            anchors.right: parent.right

            spacing: 0

            Panel {
                id: settingsPanel
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: settingsColumn.height + borderWidth


                ColumnLayout {
                    id: settingsColumn

                    width: settingsPanel.interiorWidth;

                    anchors.centerIn: settingsPanel;

                    SettingSlider {
                        id: gridSize

                        Layout.preferredWidth: settingsColumn.width
                        settingMinValue: 10.0
                        settingMaxValue: 150.0
                        settingStepSize: 1.0
                        settingLabel: "Grid Size (W x H):"
                        settingValue: 30.0
                    }

                    SettingSlider {
                        id: redPopSize

                        Layout.preferredWidth: settingsColumn.width
                        settingMinValue: 0.0
                        settingMaxValue: 100.0
                        settingStepSize: 0.5
                        settingLabel: "Red Pop. (%):"
                        settingValue: 50.0
                    }

                    SettingSlider {
                        id: sameNeighbors

                        Layout.preferredWidth: settingsColumn.width
                        settingMinValue: 0.0
                        settingMaxValue: 100.0
                        settingStepSize: 0.5
                        settingLabel: "Same Neighbors (%):"
                        settingValue: 50.0
                    }

                    SettingSlider {
                        id: blankSpaces

                        Layout.preferredWidth: settingsColumn.width
                        settingMinValue: 0.0
                        settingMaxValue: 100.0
                        settingStepSize: 1.0
                        settingLabel: "Empty Spaces (%):"
                        settingValue: 20.0
                    }


                    SettingSlider {
                        id: delaySlider

                        Layout.preferredWidth: settingsColumn.width
                        settingMinValue: 0.0
                        settingMaxValue: 500.0
                        settingStepSize: 1.0
                        settingLabel: "Step delay (ms):"
                        settingValue: 100.0
                    }
                }
            }

            Panel {
                id: buttonPanel
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: buttonRow.height + borderWidth

                Layout.fillWidth: true

                RowLayout {
                    id: buttonRow
                    width: buttonPanel.interiorWidth
                    anchors.centerIn: buttonPanel;


                    Button {
                        id: resetButton
                        Layout.alignment: Qt.AlignCenter
                        text: "Reset"
                        onClicked: {
                            stepTimer.stop();

                            var board_width = gridSize.settingValue;

                            var blank_percent = blankSpaces.settingValue / 100.0;
                            var red_percent = redPopSize.settingValue / 100.0;
                            var blue_percent = 1.0 - red_percent;

                            var percentages = [blank_percent, red_percent, blue_percent];

                            board.resetBoard(board_width, percentages);
                            board.setUpdateParameters(1, sameNeighbors.settingValue / 100.0);

                            boardStatistics.numCells = board.numCells
                            boardStatistics.numUnhappyCells = -1 // init to -1 since we don't know yet
                            boardStatistics.numSteps = 0

                        }
                    }

                    Button {
                        id: startButton
                        Layout.alignment: Qt.AlignCenter
                        text: "Start"
                        onClicked: {
                            stepTimer.start();
                        }
                    }

                    Button {
                        id: stopButton
                        Layout.alignment: Qt.AlignCenter
                        text: "Stop"
                        onClicked: {
                            stepTimer.stop();
                        }
                    }

                    Button {
                        id: stepButton
                        Layout.alignment: Qt.AlignCenter
                        text: "Step"
                        onClicked: mainWindow.incrementHalfStep()
                    }
                }
            }
            // There doesn't seem to be a good way to force the statistics panel to the
            // bottom through alignment means, so we're going to just add an invisible
            // item to expand the space. The spacing between items was set to 0 to make
            // the height calculation as painless as possible.
            Item {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height - (statisticsPanel.height + buttonPanel.height + settingsPanel.height)
            }

            Panel {
                id: statisticsPanel
                Layout.preferredWidth: parent.width
                Layout.preferredHeight:statisticsRow.height + borderWidth

                Layout.alignment: Qt.AlignBaseline

                RowLayout {
                    id: statisticsRow

                    width: statisticsPanel.interiorWidth

                    anchors.centerIn: statisticsPanel

                    Layout.fillWidth: true

                    Text {
                        id: percentUnhappyText

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                        text: boardStatistics.numUnhappyCells + "/" + boardStatistics.numCells + " (" +
                              (100 * boardStatistics.numUnhappyCells / boardStatistics.numCells).toFixed(2) +
                              " %)"
                    }

                    Text {
                        id: completedText

                        Layout.alignment: Qt.AlignCenter

                        text: boardStatistics.numUnhappyCells == 0 ? "Complete: All cells are happy!" : ""

                        color: "green"
                    }

                    Text {
                        id: stepCountText

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                        text: "Step: " + boardStatistics.numSteps.toFixed(1)


                    }
                }
            }
        }
    }

    QtObject {
        id: boardStatistics

        property int numCells: 0
        property int numUnhappyCells: -1
        property bool prevStepMark: false
        property real numSteps: 0

    }


    function incrementHalfStep() {
        if (boardStatistics.prevStepMark == false) {
            boardStatistics.numUnhappyCells = board.markUnhappy();
            boardStatistics.numSteps += 0.5;
            boardStatistics.prevStepMark = true;
            //console.log("Done marking");
        } else {
            board.moveUnhappy();
            boardStatistics.numSteps += 0.5;
            boardStatistics.prevStepMark = false;
            if (boardStatistics.numUnhappyCells == 0) {
                stepTimer.stop();
            }
            //console.log("Done moving");
        }
    }

    Timer {
        id: stepTimer
        interval: delaySlider.settingValue
        repeat: true
        onTriggered: mainWindow.incrementHalfStep()
    }
}

