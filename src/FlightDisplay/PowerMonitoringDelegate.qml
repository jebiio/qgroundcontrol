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
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0

Column{
    height: 120
    anchors.left: parent.left

    // property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle


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
            // property var        factGroup:     _activeVehicle.getFactGroup("krisoStatus")
            // property string     factGroupName: "KrisoVoltage"
            

            Repeater {
                // model : _activeVehicle.factGroupNames
                model   :       _activeVehicle.getFactGroup("kriso").factNames
                // property var factGroup:     _activeVehicle.getFactGroup(modelData)
                // property string factGroupName: modelData
                property Fact fact : _activeVehicle.getFactGroup("kriso").getFact(modelData)

                Text{text: modelData }
                // Text{text: fact.value.enumOrValueString }
                // FactLabel { fact:fact }
            }


            // Text{text: "16.2" +"v"
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "90" +"%"
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "Ch2 : "
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "16.2" +"v"
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "90" +"%"
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "Ch3 : "
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "16.2" +"v"
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "90" +"%"
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "Ch4 : "
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "16.2" +"v"
            // font.pixelSize : 13
            // color: "white" }

            // Text{text: "90" +"%"
            // font.pixelSize : 13
            // color: "white" }            
    }
}


