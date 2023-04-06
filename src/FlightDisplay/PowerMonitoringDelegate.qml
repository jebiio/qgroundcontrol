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
    height: expanded ? 120 : 0
    radius:  0.5   


    Behavior on height {
        NumberAnimation { duration:  200 }
    }

    Column{
    anchors.left: parent.left
    
    
        Row {
            anchors.margins:   ScreenTools.defaultFontPixelWidth * 10
            anchors.left:       parent.left
            spacing: 10

            QGCLabel {
                text: qsTr("Voltage")
                color:      qgcPal.text
            }         

            QGCLabel {
                text: qsTr("Remaining")
                color:      qgcPal.text
            }     
        }

        GridLayout{
                anchors.margins:   ScreenTools.defaultFontPixelWidth * 2
                anchors.left:       parent.left
                columns:            3
                columnSpacing:      ScreenTools.defaultFontPixelWidth * 2
                rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.25


                Text{text: "Ch1 : "
                font.pixelSize : 13
                color: "white" }

                Text{text: "16.2" +"v"
                font.pixelSize : 13
                color: "white" }

                Text{text: "90" +"%"
                font.pixelSize : 13
                color: "white" }

                Text{text: "Ch2 : "
                font.pixelSize : 13
                color: "white" }

                Text{text: "16.2" +"v"
                font.pixelSize : 13
                color: "white" }

                Text{text: "90" +"%"
                font.pixelSize : 13
                color: "white" }

                Text{text: "Ch3 : "
                font.pixelSize : 13
                color: "white" }

                Text{text: "16.2" +"v"
                font.pixelSize : 13
                color: "white" }

                Text{text: "90" +"%"
                font.pixelSize : 13
                color: "white" }

                Text{text: "Ch4 : "
                font.pixelSize : 13
                color: "white" }

                Text{text: "16.2" +"v"
                font.pixelSize : 13
                color: "white" }

                Text{text: "90" +"%"
                font.pixelSize : 13
                color: "white" }            
        }
    }

}

