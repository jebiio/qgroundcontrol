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
import QtQuick.Controls         2.4

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
        property string _manualModeText:        qsTr("수동")
        property string _autoModeText:          qsTr("자동")
        property string _simulationModeText:    qsTr("시뮬레이션")
        font.pointSize: 13

        text: {
            if (_activeVehicle) {
                switch (_activeVehicle.kriso.nav_mode) {
                    case 1: return mainStatusLabel._manualModeText;
                    case 2: return mainStatusLabel._autoModeText;
                    case 3: return mainStatusLabel._simulationModeText;
                    default: return "수동";
                }
            } else {
                return "";
            }
        }
    }

    Item {
        Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
        height:                 1
    }
    
    // QGCColoredImage {
    //     id:         flightModeIcon
    //     width:      ScreenTools.defaultFontPixelWidth * 2
    //     height:     ScreenTools.defaultFontPixelHeight * 0.75
    //     fillMode:   Image.PreserveAspectFit
    //     mipmap:     true
    //     color:      qgcPal.text
    //     source:     "/qmlimages/FlightModesComponentIcon.png"
    //     visible:    _activeVehicle
    // }


    QGCLabel {
        id: modeLabel
        property string _hdgModeText:           qsTr("HDG Mode")
        property string _dpModeText:            qsTr("DP Mode")
        property string _wpModeText:            qsTr("WP Mode")
        font.pointSize: 13

        text: {
            if (_activeVehicle) {
                switch (_activeVehicle.kriso.nav_mode) {
                    case 'dp': return modeLabel._dpModeText;
                    case 'wp': return modeLabel._wpModeText;
                    case 'hdg': return modeLabel._hdgModeText;
                    default: return "HDG Mode";
                }
            } else {
                return "";
            }
        }
    }

    Switch {
        id: customToggle
        width: 100 
        height: 25
        checked: true
        enabled: false 

        onCheckedChanged: {
            console.log("Switch is now:", checked ? "ON" : "OFF")
        }

        background: Rectangle {
            width: 50
            radius: customToggle.height / 2
            color: customToggle.checked ? "green" : "lightgray"
            border.color: "gray"
            border.width: 2

            Text {
                anchors.centerIn: parent
                color: "white"
                font.pointSize: 10
                text: customToggle.checked ? "ON" : "OFF"
            }
        }

        indicator: Rectangle {
            id: indiRec
            width: customToggle.width / 2.2
            height: customToggle.height / 1.2
            radius: height / 2
            color: "white"
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            x: customToggle.checked ? background.width - width - 2 : 2

        }
    }

}
  

