import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: cell

    width: 100
    height: 100

    property bool happy: true
    property int type: 0 // initialize to blank
    property int row: 0
    property int col: 0
    property int idx: 0

    x: col * width;
    y: row * height;

    visible: {if (type == 0) {return false} else {return true}}

    color: {
        switch(type) {
            case 0: return "darkgrey";
            case 1: return "red";
            case 2: return "blue";
            case 3: return "green";
            case 4: return "purple";
            case 5: return "yellow";
            default: return "black";
        }
    }

    // Add a black dot in the middle to indicate that a cell is unhappy in
    // its current location.
    Rectangle {
        width: parent.width / 2;
        height: parent.height / 2;
        radius: height > width ? width : height;

        anchors.centerIn: parent

        color: {
            if (parent.happy) {
                return "transparent";
            } else {
                return "black"
            }
        }
    }
}

