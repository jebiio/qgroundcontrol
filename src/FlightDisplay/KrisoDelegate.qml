/*************************************************************************
 *
 * Copyright (c) 2013-2019, Klaralvdalens Datakonsult AB (KDAB)
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Airmap        1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

Rectangle{
    id: _root
    clip: true
    color : "#383636"
    property bool expanded: true
    height: expanded ? krisoLoader.height : 0
    radius:  0.5   

    Behavior on height {
        NumberAnimation { duration:  200 }
    }


    Loader{
        id :                krisoLoader
        // anchors.left:       parent.left
        visible:            true
        source:             getDelegate(model.team)      
        // visible:            true 
    }

    function getDelegate(teamName){
        switch(teamName) {
            case "  Vessel Status" :    return "qrc:/qml/VesselStatusDelegate.qml"; break;
            case "  Power Monitoring" : return  "qrc:/qml/PowerMonitoringDelegate.qml"; break;
            default     : return "qrc:/qml/NameDelegate.qml"; break;
        }
    }       
}


