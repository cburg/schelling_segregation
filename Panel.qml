import QtQuick 2.0
import QtGraphicalEffects 1.0


// The panel is purely eye-candy. The item container will always be larger than the actual rectangle
// portion. The reason for it to be larger is to ensure that the shadow is always visible. The
// outer Item container could be made the same size as the interior rectangle
Item {
    id: panelContainer
    width: 150
    height: 150

    readonly property int interiorWidth: centerRect.width - (centerRect.interiorBorderWidth)
    readonly property int interiorHeight: centerRect.height - (centerRect.interiorBorderWidth)
    // borderWidth is the thickness between the interior width and the edge of the panelContainer
    // It's use is primarily to facilitate positioning and sizing elements that are children of
    // the Panel element. We cannot simply use anchors.fill
    readonly property int borderWidth: width - interiorWidth

    property color color: "white"

    Rectangle {
        id: centerRect

        width: parent.width - (2 * (shadow.radius + shadow.horizontalOffset))
        height: parent.height - (2 * (shadow.radius + shadow.verticalOffset))
        anchors.centerIn: parent

        // Interior border width
        property int interiorBorderWidth: shadow.radius
        color: parent.color
    }


    // The DropShadow must be a sibling to the source object it is being applied to. If the drop
    // shadow is added as a child element to centerRect, then horrible artifacting will ensue.
    // I should note that using a rectangular glow would also work in place of the DropShadow.
    DropShadow {
        id: shadow
        anchors.fill: source
        source: centerRect
        radius: 15
        samples: 32
        spread: 0.01
        transparentBorder: true
        color: "#A0000000";
        horizontalOffset: radius / 3
        verticalOffset: radius / 3
    }
}

