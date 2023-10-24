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
    
    property int oper_mode :  _activeVehicle.getFactGroup("krisoCmd").getFact("oper_mode").value
    property int mission_mode : _activeVehicle.getFactGroup("krisoCmd").getFact("mission_mode").value
    property int dp_start_stop: _activeVehicle.getFactGroup("krisoDPtoVCC").getFact("dp_start_stop").value

    QGCLabel {
        id: mainStatusLabel
        property string _manualModeText:        qsTr("수동")
        property string _autoModeText:          qsTr("자동")
        property string _simulationModeText:    qsTr("시뮬레이션")
        font.pointSize: 13

        text: {
            if (_activeVehicle) {
                switch (oper_mode) {
                    case 1: return mainStatusLabel._manualModeText;
                    case 2: return mainStatusLabel._autoModeText;
                    case 3: return mainStatusLabel._simulationModeText;
                    default: return "운용모드확인불가";
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

    // Text{
    //     text: _activeVehicle.getFactGroup("krisoCmd").getFact("oper_mode").enumOrValueString
    //     color: "white"
    // }


    QGCLabel {
        id: modeLabel
        property string _remoteModeText:        qsTr("원격수동 모드")
        property string _hdgModeText:           qsTr("CK 모드")
        property string _dpModeText:            qsTr("DP 모드")
        property string _wpModeText:            qsTr("WT 모드")
        font.pointSize: 13

    

        text: {
            if(_activeVehicle){
                switch (mission_mode) {
                    case 1: return modeLabel._remoteModeText;
                    case 2: return modeLabel._wpModeText;
                    case 3: return modeLabel._hdgModeText;
                    case 4: return modeLabel._dpModeText;
                    default: return "미션모드확인불가";
                }
            }else {
                return "";
            }
            
        }
    }

    Switch {
        id: customToggle
        width: 100 
        height: 25
        checked: {
            if((mission_mode !== 10) && ((oper_mode === 1 || oper_mode === 2)))
            {
                if(dp_start_stop === 0){
                    return false;
                }else {
                    return true;
                }
            }else {
                return false
            }
        }
        enabled: false 
        visible: (_activeVehicle && mission_mode === 2) ? true : false //DP모드일때만  On,Off 표기

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
  

