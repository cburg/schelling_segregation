import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

Row {
    id: rowContainer


    property alias settingLabel: settingLabel.text
    property alias settingValue: settingSlider.value
    property alias settingMinValue: settingSlider.minimumValue
    property alias settingMaxValue: settingSlider.maximumValue
    property alias settingStepSize: settingSlider.stepSize

    Label {
        id: settingLabel
        width: 140
        text: ""
    }

    Slider {
        id: settingSlider
        width: rowContainer.width - (settingLabel.width + settingField.width)

        updateValueWhileDragging: true
    }

    TextField {
        id: settingField
        width: 55
        validator: DoubleValidator {}

        maximumLength: 6

        text: "" + settingSlider.value

        onEditingFinished: {
            if (acceptableInput) {
                var newValue = parseFloat(text);

                if (newValue > settingSlider.maximumValue) {
                    settingSlider.value = settingSlider.maximumValue;
                } else if (newValue < settingSlider.minimumValue) {
                    settingSlider.value = settingSlider.minimumValue;
                } else {
                    settingSlider.value = newValue;
                }
            }
        }
    }
}


