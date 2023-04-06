/*************************************************************************
 *
 * Copyright (c) 2013-2019, Klaralvdalens Datakonsult AB (KDAB)
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

import QtQuick          2.0
import QtQuick          2.5
import QtQuick.Controls 1.3

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QtQuick.Layouts          1.2

Rectangle{
    id: _root
    clip: true
    color : "#383636"
    property bool expanded: false
    height: expanded ? 100 : 0
    radius:  0.5   


    Behavior on height {
        NumberAnimation { duration:  200 }
    }

    Column {
        id : status
        // anchors.fill: parent
        anchors.left: parent.left
        anchors.margins: ScreenTools.defaultFontPixelWidth
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        // spacing:                ScreenTools.defaultFontPixelWidth * 2

        Text {
            id: sailing_mode
            color : "white"
            text: model.name
            font.pixelSize: 13
            Layout.alignment:   Qt.AlignHCenter
        }

        Column{
            // anchors.left:           parent.left
            // anchors.leftMargin:     ScreenTools.defaultFontPixelWidth
            anchors.margins:   ScreenTools.defaultFontPixelWidth * 2
            anchors.left:       parent.left
            anchors.top:        sailing_mode.bottom
            anchors.verticalCenter: parent.verticalCenter
            spacing:                ScreenTools.defaultFontPixelWidth 

            QGCButton {
                id: setupbtn
                text: "Setup Control Values"
                backRadius:     4
                heightFactor:   0.3333
                Layout.alignment:   Qt.AlignHCenter
            }

            QGCButton {
                text: "Logging Start"
                backRadius:     4
                heightFactor:   0.3333
                width: setupbtn.width
                Layout.alignment:   Qt.AlignHCenter
            }
        }


    }

}

