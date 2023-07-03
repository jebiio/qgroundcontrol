import QtQuick 2.15
import QtQuick.Controls 2.15

RadioButton {
    property bool isPressed: false

    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.isPressed = !parent.isPressed;
            parent.checked = parent.isPressed;
        }
    }
}