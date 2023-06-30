/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Layouts  1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

RowLayout {
    id:         _root
    spacing:    0

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property var    _vehicleInAir:      _activeVehicle ? _activeVehicle.flying || _activeVehicle.landing : false
    property bool   _vtolInFWDFlight:   _activeVehicle ? _activeVehicle.vtolInFwdFlight : false
    property bool   _armed:             _activeVehicle ? _activeVehicle.armed : false
    property real   _margins:           ScreenTools.defaultFontPixelWidth
    property real   _spacing:           ScreenTools.defaultFontPixelWidth / 2


    QGCLabel {
        id: mainStatusLabel
        property string _manualModeText:        qsTr("Manual Mode")
        property string _autoModeText:          qsTr("Auto Mode")
        property string _simulationModeText:    qsTr("Simulation Mode")

        text: {
            switch (_activeVehicle.kriso.nav_mode) {
                case 1: return mainStatusLabel._manualModeText;
                case 2: return mainStatusLabel._autoModeText;
                case 3: return mainStatusLabel._simulationModeText;
                default: return "Test Mode";
            }
        }
    }

    Item {
        Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
        height:                 1
    }
    
    QGCColoredImage {
        id:         flightModeIcon
        width:      ScreenTools.defaultFontPixelWidth * 2
        height:     ScreenTools.defaultFontPixelHeight * 0.75
        fillMode:   Image.PreserveAspectFit
        mipmap:     true
        color:      qgcPal.text
        source:     "/qmlimages/FlightModesComponentIcon.png"
        visible:    _activeVehicle
    }


    QGCLabel {
        id: modeLabel
        property string _hdgModeText:           qsTr("HDG Mode")
        property string _dpModeText:            qsTr("DP Mode")
        property string _wpModeText:            qsTr("WP Mode")

        text: {
            switch (_activeVehicle.kriso.nav_mode) {
                case 'dp': return modeLabel._dpModeText;
                case 'wp': return modeLabel._wpModeText;
                case 'hdg': return modeLabel._hdgModeText;
                default: return "HDG Mode";
            }
        }
    }
}
  

