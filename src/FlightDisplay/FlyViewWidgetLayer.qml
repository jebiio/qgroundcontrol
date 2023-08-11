/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

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

// This is the ui overlay layer for the widgets/tools for Fly View
Item {
    id: _root

    property var    parentToolInsets
    property var    totalToolInsets:        _totalToolInsets
    property var    mapControl

    readonly property real  _margin:            ScreenTools.defaultFontPixelWidth / 2
    // readonly property real  _hamburgerSize:     commandPicker.height * 0.75
    // readonly property real  _trashSize:         commandPicker.height * 0.75

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _planMasterController:  globals.planMasterControllerFlyView
    property var    _missionController:     _planMasterController.missionController
    property var    _geoFenceController:    _planMasterController.geoFenceController
    property var    _rallyPointController:  _planMasterController.rallyPointController
    property var    _guidedController:      globals.guidedControllerFlyView
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 45

    QGCToolInsets {
        id:                     _totalToolInsets
        leftEdgeTopInset:       toolStrip.leftInset
        leftEdgeCenterInset:    toolStrip.leftInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  mapScale.centerInset
        bottomEdgeRightInset:   0
    }

    FlyViewMissionCompleteDialog {
        missionController:      _missionController
        geoFenceController:     _geoFenceController
        rallyPointController:   _rallyPointController
    }

    Row {
        id:                 multiVehiclePanelSelector
        anchors.margins:    _toolsMargin
        anchors.top:        parent.top
        anchors.right:      parent.right
        width:              _rightPanelWidth
        spacing:            ScreenTools.defaultFontPixelWidth
        visible:            QGroundControl.multiVehicleManager.vehicles.count > 1 && QGroundControl.corePlugin.options.flyView.showMultiVehicleList

        property bool showSingleVehiclePanel:  !visible || singleVehicleRadio.checked

        QGCMapPalette { id: mapPal; lightColors: true }

        QGCRadioButton {
            id:             singleVehicleRadio
            text:           qsTr("Single")
            checked:        true
            textColor:      mapPal.text
        }

        QGCRadioButton {
            text:           qsTr("Multi-Vehicle")
            textColor:      mapPal.text
        }
    }

    MultiVehicleList {
        anchors.margins:    _toolsMargin
        anchors.top:        multiVehiclePanelSelector.bottom
        anchors.right:      parent.right
        width:              _rightPanelWidth
        height:             parent.height - y - _toolsMargin
        visible:            !multiVehiclePanelSelector.showSingleVehiclePanel
    }

    FlyViewInstrumentPanel {
        id:                         instrumentPanel
        anchors.margins:            _toolsMargin
        anchors.top:                multiVehiclePanelSelector.visible ? multiVehiclePanelSelector.bottom : parent.top
        anchors.right:              parent.right
        width:                      _rightPanelWidth
        spacing:                    _toolsMargin
        visible:                    QGroundControl.corePlugin.options.flyView.showInstrumentPanel && multiVehiclePanelSelector.showSingleVehiclePanel
        availableHeight:            parent.height - y - _toolsMargin

        property real rightInset: visible ? parent.width - x : 0
    }

    // PhotoVideoControl {
    //     id:                     photoVideoControl
    //     anchors.margins:        _toolsMargin
    //     anchors.right:          parent.right
    //     width:                  _rightPanelWidth
    //     state:                  _verticalCenter ? "verticalCenter" : "topAnchor"
    //     states: [
    //         State {
    //             name: "verticalCenter"
    //             AnchorChanges {
    //                 target:                 photoVideoControl
    //                 anchors.top:            undefined
    //                 anchors.verticalCenter: _root.verticalCenter
    //             }
    //         },
    //         State {
    //             name: "topAnchor"
    //             AnchorChanges {
    //                 target:                 photoVideoControl
    //                 anchors.verticalCenter: undefined
    //                 anchors.top:            instrumentPanel.bottom
    //             }
    //         }
    //     ]

    //     property bool _verticalCenter: !QGroundControl.settingsManager.flyViewSettings.alternateInstrumentPanel.rawValue
    // }

    TelemetryValuesBar {
        id:                 telemetryPanel
        x:                  recalcXPosition()
        anchors.margins:    _toolsMargin

        // States for custom layout support
        states: [
            State {
                name: "bottom"
                when: telemetryPanel.bottomMode

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                    anchors.right: undefined
                    anchors.verticalCenter: undefined
                }

                PropertyChanges {
                    target: telemetryPanel
                    x: recalcXPosition()
                }
            },

            State {
                name: "right-video"
                when: !telemetryPanel.bottomMode && photoVideoControl.visible

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: photoVideoControl.bottom
                    anchors.bottom: undefined
                    anchors.right: parent.right
                    anchors.verticalCenter: undefined
                }
            },

            State {
                name: "right-novideo"
                when: !telemetryPanel.bottomMode && !photoVideoControl.visible

                AnchorChanges {
                    target: telemetryPanel
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        ]

        function recalcXPosition() {
            // First try centered
            var halfRootWidth   = _root.width / 2
            var halfPanelWidth  = telemetryPanel.width / 2
            var leftX           = (halfRootWidth - halfPanelWidth) - _toolsMargin
            var rightX          = (halfRootWidth + halfPanelWidth) + _toolsMargin
            if (leftX >= parentToolInsets.leftEdgeBottomInset || rightX <= parentToolInsets.rightEdgeBottomInset ) {
                // It will fit in the horizontalCenter
                return halfRootWidth - halfPanelWidth
            } else {
                // Anchor to left edge
                return parentToolInsets.leftEdgeBottomInset + _toolsMargin
            }
        }
    }

    //-- Virtual Joystick
    Loader {
        id:                         virtualJoystickMultiTouch
        z:                          QGroundControl.zOrderTopMost + 1
        width:                      parent.width  - (_pipOverlay.width / 2)
        height:                     Math.min(parent.height * 0.25, ScreenTools.defaultFontPixelWidth * 16)
        visible:                    _virtualJoystickEnabled && !QGroundControl.videoManager.fullScreen && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)
        anchors.bottom:             parent.bottom
        anchors.bottomMargin:       parentToolInsets.leftEdgeBottomInset + ScreenTools.defaultFontPixelHeight * 2
        anchors.horizontalCenter:   parent.horizontalCenter
        source:                     "qrc:/qml/VirtualJoystick.qml"
        active:                     _virtualJoystickEnabled && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)

        property bool autoCenterThrottle: QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle.rawValue

        property bool _virtualJoystickEnabled: QGroundControl.settingsManager.appSettings.virtualJoystick.rawValue
    }

    FlyViewToolStrip {
        id:                     toolStrip
        anchors.leftMargin:     _toolsMargin + parentToolInsets.leftEdgeCenterInset
        anchors.topMargin:      _toolsMargin + parentToolInsets.topEdgeLeftInset
        anchors.left:           parent.left
        anchors.top:            parent.top
        z:                      QGroundControl.zOrderWidgets
        maxHeight:              parent.height - y - parentToolInsets.bottomEdgeLeftInset - _toolsMargin
        visible:                false

        onDisplayPreFlightChecklist: mainWindow.showPopupDialogFromComponent(preFlightChecklistPopup)

        property real leftInset: x + width
    }

    FlyViewAirspaceIndicator {
        anchors.top:                parent.top
        anchors.topMargin:          ScreenTools.defaultFontPixelHeight * 0.25
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderWidgets
        show:                       mapControl.pipState.state !== mapControl.pipState.pipState
    }

    VehicleWarnings {
        anchors.centerIn:   parent
        z:                  QGroundControl.zOrderTopMost
    }

    MapScale {
        id:                 mapScale
        anchors.margins:    _toolsMargin
        anchors.left:       toolStrip.right
        anchors.top:        parent.top
        mapControl:         _mapControl
        buttonsOnLeft:      false
        visible:            !ScreenTools.isTinyScreen && QGroundControl.corePlugin.options.flyView.showMapScale && mapControl.pipState.state === mapControl.pipState.fullState

        property real centerInset: visible ? parent.height - y : 0
    }

    Component {
        id: preFlightChecklistPopup
        FlyViewPreFlightChecklistPopup {
        }
    }

    

    Item {
        anchors.fill:           rightPanel
        anchors.topMargin:      _toolsMargin
        DeadMouseArea {
            anchors.fill:   parent
        }
        Column {
            id:                 rightControls
            spacing:            ScreenTools.defaultFontPixelHeight * 0.5
            anchors.left:       parent.left
            anchors.right:      parent.right
            anchors.top:        parent.top
        }

        Rectangle {
            color: "white"
            radius: 10
            width: parent.width
            height: 100
            opacity: 0.8
            anchors.margins: 10
            visible: true

            QGCTabBar {
                id: layerTabBar
                width: parent.width
                visible: (!planControlColapsed || !_airspaceEnabled) && QGroundControl.corePlugin.options.enablePlanViewSelector
                Component.onCompleted: {
                    currentIndex = 0
                    krisoStatusBtn.clicked()
                }
                
                QGCTabButton {
                    id: krisoStatusBtn
                    text: qsTr("상태정보")
                    enabled: true
                    onClicked: {
                        page1.visible = true
                        page2.visible = false
                    }
                }
                QGCTabButton {
                    id: krisoBatteryBtn
                    text: qsTr("배터리정보")
                    enabled: true
                    onClicked: {
                        page1.visible = false
                        page2.visible = true
                    }
                }
                QGCTabButton {
                    id: krisoLoggingStatusBtn
                    text: qsTr("로깅정보")
                    enabled: true
                }
                QGCTabButton {
                    id: krisoTajectorySetupBtn
                    text: qsTr("궤적설정")
                    enabled: true
                }
            }

            PageView {
                id: page1
                _krisoFactName: "KrisoStatus"
                anchors.top: layerTabBar.bottom
                visible: false
            }

            PageViewVoltage {
                id: page2
                _krisoFactName: "KrisoVoltage"
                anchors.top: layerTabBar.bottom
                visible: false
            }

        }
    
    }


    Rectangle {
        id:                 rightPanel
        height:             parent.height * 0.18
        width:              _rightPanelWidth
        opacity:             0.01
        anchors.top:        instrumentPanel.bottom
        anchors.topMargin:        _toolsMargin
        anchors.right:      parent.right
        anchors.rightMargin: _toolsMargin
        radius:     _radius
    }

    // 모드선택
    Rectangle {
        id: container
        color: "white"
        radius: 10
        anchors.top : toolStrip.bottom
        anchors.left: parent.left
        anchors.margins: 10
        visible : _activeVehicle ? true : false

        implicitWidth: rightPanel.width + padding * 2
        implicitHeight: commandColumn.height + padding * 2

        property real padding: 10

        Column {
            id: commandColumn
            anchors.centerIn: parent
            spacing: 10

            Text {
                id: operationModeLabel
                text: "< 명령 >\n운용모드"
                color: "black"
            }

            Row {
                id: operationModeRow
                spacing: 10
                KrisoRadioButton {
                    id: manualMode
                    text: "수동"
                    onIsPressedChanged: {
                        missionModeRow.enabled = !isPressed;
                        if(isPressed) {
                            hdgGainEditorContainer.visible = false;
                            dpGainEditorContainer.visible = false;
                            autoMode.isPressed = false;
                            simulationMode.isPressed = false;
                            moveToPlanView.visible = false;
                        }
                    }
                }
                KrisoRadioButton {
                    id: autoMode
                    text: "자동"
                    onIsPressedChanged: {
                        if(isPressed) {
                            manualMode.isPressed = false;
                            missionModeRow.enabled = true;
                        }
                    }
                }
                KrisoRadioButton {
                    id: simulationMode
                    text: "시뮬레이션"
                    onIsPressedChanged: {
                        if(isPressed) {
                            manualMode.isPressed = false;
                            missionModeRow.enabled = true;
                        }
                    }
                }
            }

            Text {
                id: missionModeLabel
                text: "임무모드 - 운용시작"
                color: "black"
            }

            Row {
                id: missionModeRow
                spacing: 10

                KrisoRadioButton {
                    id: wpMode
                    text: "WP"
                    enabled: !manualMode.isPressed
                    onIsPressedChanged: {
                        if(isPressed){
                            moveToPlanView.visible = true;
                            dpMode.isPressed = false;
                            dpGainEditorContainer.visible = false;
                            hdgGainEditorContainer.visible = false
                        }else {
                            moveToPlanView.visible = false;
                        }
                    }
                }
                KrisoRadioButton {
                    id: hdgMode
                    text: "HDG"
                    enabled: !manualMode.isPressed
                    onIsPressedChanged: {
                        if(isPressed) {
                            hdgGainEditorContainer.visible = true;
                            dpMode.isPressed = false;
                            dpGainEditorContainer.visible = false;
                            moveToPlanView.visible = false;
                        } else {
                            hdgGainEditorContainer.visible = false;
                            // hdgGainEditorContainer.visible = false;
                        }
                    }
                }
                KrisoRadioButton {
                    id: dpMode
                    text: "DP"
                    enabled: !manualMode.isPressed
                    onIsPressedChanged: {
                        if(isPressed) {
                            dpGainEditorContainer.visible = true;
                            hdgMode.isPressed = false;
                            hdgGainEditorContainer.visible = false;
                            moveToPlanView.visible = false;
                        } else {
                            // dpmodeContainer.visible = false;
                            dpGainEditorContainer.visible = false;
                        }
                    }
                }
            }

            Row {
                spacing: 10
                
                Button {
                    text: "모드변경"
                    onClicked: {
                        if(manualMode.checked){
                            _activeVehicle.kriso_sendOPModeCommand(1, 0)
                        }else if(autoMode.checked){
                            if(wpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(2, 1)
                            }else if(hdgMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(2, 2)
                            }else if(dpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(2, 3)
                            }
                        }else if(simulationMode.checked){
                            if(wpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(3, 1)
                            }else if(hdgMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(3, 2)
                            }else if(dpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(3, 3)
                            }
                        }
                    }
                }

                QGCButton {
                    id : moveToPlanView
                    text: "계획생성"
                    visible : wpMode.isPressed ? true : false
                    onClicked: mainWindow.showPlanView()
                }
            }
        }
    }

    // WP Container
    // Rectangle {
    //     id: wpcontainer
    //     color: "white"
    //     radius: 10
    //     anchors.top : container.bottom
    //     anchors.left: parent.left
    //     anchors.margins: 10
    //     visible : wpMode.isPressed ? ture : false

    //     implicitWidth: rightPanel.width + padding * 2
    //     implicitHeight: wpColumn.height + padding * 2

    //     property real padding: 10

    //     Row {
    //         id: wpColumn
    //         anchors.centerIn: parent
    //         spacing: 10

    //         QGCButton {
    //             text: "계획생성"
    //             onClicked: mainWindow.showPlanView()
    //         }
    //         QGCButton {
    //             text: "운행시작"
    //             onClicked: _activeVehicle.kriso_sendWTCommand(_missionController.visualItems)
    //             // onClicked: _activeVehicle.kriso_sendWTCommand()
    //         }
    //     }


    // } 

    // Rectangle {
    //     id: hdgcontainer
    //     color: "white"
    //     radius: 10
    //     anchors.top : container.bottom
    //     anchors.left: parent.left
    //     anchors.margins: 10
    //     visible: false

    //     implicitWidth: rightPanel.width + padding * 2
    //     implicitHeight: hdgColumn.height + padding * 2

    //     property real padding: 10

    //     Column {
    //         id: hdgColumn
    //         anchors.centerIn: parent
    //         spacing: 10

    //         RowLayout {
    //             width : parent.width
    //             Text {
    //                 text: "< HDG >\n제어명령"
    //                 color: "black"
    //             }
    //             Item {
    //                 Layout.fillWidth: true
    //             }
    //             QGCButton {
    //                 id: hdgGainButton
    //                 text: "Gain"
    //                 onClicked: {
    //                     if (hdgMode.isPressed) {            
    //                     hdgGainEditorContainer.visible = !hdgGainEditorContainer.visible;
    //                     dpGainEditorContainer.visible = false;}
    //                 }
    //             }
    //         }

    //         Row {
    //             spacing: 10

    //             Text {
    //                 text: "속도 값  "
    //                 color: "black"
    //             }
    //             QGCTextField {
    //                 // id : hdgSpeedInput
    //                 placeholderText: "속도 입력"
    //             }
    //         }

    //         Row {
    //             spacing: 10

    //             Text {
    //                 text: "선수각 값"
    //                 color: "black"
    //             }
    //             QGCTextField {
    //                 // id : hdgDegreeInput
    //                 placeholderText: "선수각 입력"
    //             }
    //         }

    //         RowLayout {
    //             width : parent.width
    //             Button {
    //                 text: "명령전송"
    //                 onClicked: {
    //                     _activeVehicle.kriso_sendHDGCommand(parseFloat(hdgSpeedInput.text), parseFloat(hdgDegreeInput.text))
    //                     hdgSpeedInput.text = "";
    //                     hdgDegreeInput.text = "";
    //                 }
    //             }
    //             Item {
    //                 Layout.fillWidth: true
    //             }

    //         }
    //     }
    // }

    // DP Container
    // Rectangle {
    //     id: dpmodeContainer
    //     color: "white"
    //     radius: 10
    //     anchors.top: toolStrip.bottom
    //     anchors.left: container.right
    //     anchors.margins: 10
    //     visible: false

    //     implicitWidth: rightPanel.width + padding * 2
    //     implicitHeight: dpModeColumn.height + padding * 2

    //     property real padding: 10

    //     Column {
    //         id: dpModeColumn
    //         anchors.centerIn: parent
    //         spacing: 10
            
    //         RowLayout {
    //             width : parent.width
    //             Text {
    //                 text: "< DP >\n입력값"
    //                 color: "black"
    //             }
    //             Item {
    //                 Layout.fillWidth: true
    //             }
    //             Button {
    //                 id : dpGainButton
    //                 text: "Gain"
    //                 onClicked: {
    //                     if (dpMode.isPressed){
    //                         dpGainEditorContainer.visible = !dpGainEditorContainer.visible;
    //                         hdgGainEditorContainer.visible = false;
    //                     }
    //                 }
    //             }
    //             QGCButton {
    //                 id : coordinateButton
    //                 text: _activeVehicle.dpButton ? "선택완료" : "좌표선택"
    //                 onClicked: {
    //                     _activeVehicle.isKrisoDPClickableLayer = !_activeVehicle.isKrisoDPClickableLayer
    //                 }
    //             }
    //         }


    //         Row {
    //             spacing: 10

    //             Text {
    //                 text: "위도"
    //                 color: "black"
    //             }
    //             QGCTextField {
    //                 // id: dpLatInput
    //                 text : _activeVehicle.getFactGroup("krisoGain").getFact("lat").rawValue.toFixed(7)
    //                 placeholderText: "위도 입력"
    //             }
    //         }

    //         Row {
    //             spacing: 10

    //             Text {
    //                 text: "경도"
    //                 color: "black"
    //             }
    //             QGCTextField {
    //                 // id: dpLonInput
    //                 text : _activeVehicle.getFactGroup("krisoGain").getFact("lon").rawValue.toFixed(7)
    //                 placeholderText: "경도 입력"
    //             }
    //         }

    //         Row {
    //             spacing: 10

    //             Text {
    //                 text: "선수각"
    //                 color: "black"
    //             }
    //             QGCTextField {
    //                 id: dpYawInput
    //                 placeholderText: "각도 입력"
    //             }
    //         }

    //         Button {
    //             text: "명령전송"
    //             onClicked: {
    //                 _activeVehicle.kriso_sendDPCommand(parseFloat(dpLatInput.text), parseFloat(dpLonInput.text), parseFloat(dpYawInput.text))
    //             }
    //         }
    //     }
    // }

    // DP Gain Container
    Rectangle {
        id: dpGainEditorContainer
        color: "white"
        radius: 10
        anchors.top: toolStrip.bottom
        anchors.left: container.right
        anchors.margins: 10
        width: 280
        height: dpMainColumn.height + 2*padding
        visible: false
        // visible: dpMode.isPressed && !hdgMode.isPressed


        property real padding: 10 

        Column {
            id: dpMainColumn
            width: dpGainEditorContainer.width - 2*padding
            spacing: 5
            padding: 10
            

            RowLayout {
                width: dpMainColumn.width
                Text {
                    text: "DP Editor"
                    font.pointSize: 12
                }
                Item {
                    Layout.fillWidth: true
                }
                QGCButton {
                    text: "Cancel"
                    onClicked: dpGainEditorContainer.visible = false
                    font.pointSize: 10
                }
                QGCButton {
                    text: "Save"
                    onClicked:{
                        _activeVehicle.kriso_sendDPCommand();
                        // Save logic goes here
                        dpGainEditorContainer.visible = false
                    }
                }
            }

            Rectangle {
                color: "gray"
                height: 1
                width: dpMainColumn.width
            }

            // ===============================  dp mode ====================================

            RowLayout {
                Text {
                    text: "선수각"
                    color: "black"
                }
                QGCTextField {
                    id: dpYawInput
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("yaw").rawValue.toFixed(2)
                }
            }

            RowLayout {
                Text {
                    text: "위도"
                    color: "black"
                }
                QGCTextField {
                    id: dpLatInput
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("lat").rawValue.toFixed(7)
                }
            }

            RowLayout {
                Text {
                    text: "경도"
                    color: "black"
                }
                QGCTextField {
                    id: dpLonInput
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("lon").rawValue.toFixed(7)
                }
            }

            RowLayout {
                Text {
                    text: "      "
                    font.pointSize: 12
                }
                
                Button {
                    text: "좌표선택"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        _activeVehicle.isKrisoDPClickableLayer = true
                    }
                }

                Button {
                    text: "선택완료"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        _activeVehicle.isKrisoDPClickableLayer = false
                    }
                }
            }

            RowLayout {
                Text {
                    id: dpSurgePGainText
                    text: "dp_surge_pgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                QGCTextField {
                    id: dpSurgePGainInput
                    placeholderText: "Enter value"
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_surge_pgain").rawValue.toFixed(2)
                    font.pointSize: 10
                }
            }
            RowLayout {
                Text {
                    text: "dp_surge_dgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                QGCTextField {
                    id: dpSurgeDGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_surge_dgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"
                    font.pointSize: 10
                }
            }
            RowLayout {
                Text {
                    text: "dp_sway_pgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                QGCTextField {
                    id: dpSwayPGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_sway_pgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"
                    font.pointSize: 10
                }
            }
            RowLayout {
                Text {
                    text: "dp_sway_dgain" 
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                QGCTextField {
                    id: dpSwayDGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_sway_dgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"
                    font.pointSize: 10
                }
            }
            RowLayout {
                width: parent.width * 0.8
                Text {
                    text: "dp_yaw_pgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100        
                }
                QGCTextField {
                    id: dpYawPGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_yaw_pgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"
                    font.pointSize: 10

                }
            }
            RowLayout {
                Text {
                    text: "dp_yaw_dgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                QGCTextField {
                    id: dpYawDGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_yaw_dgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"
                    font.pointSize: 10
                }
            }
            RowLayout {
                width: parent.width
                Item {
                    Layout.fillWidth: true
                }
                Button {
                    text: "입력완료"
                    onClicked: {
                        _activeVehicle.kriso_dpGainSave(
                            parseFloat(dpSurgePGainInput.text), 
                            parseFloat(dpSurgeDGainInput.text), 
                            parseFloat(dpSwayPGainInput.text), 
                            parseFloat(dpSwayDGainInput.text),
                            parseFloat(dpYawPGainInput.text), 
                            parseFloat(dpYawDGainInput.text),
                            parseFloat(dpYawInput.text)
                        )
                    }
                }
            }
        }
    }

    // HDG Gain Container
    Rectangle {
        id: hdgGainEditorContainer
        color: "white"
        radius: 10
        anchors.top: toolStrip.bottom
        anchors.left: container.right
        anchors.margins: 10
        width: 320
        height: hdgMainColumn.height + 2*padding
        visible: false
        // visible: !dpMode.isPressed && hdgMode.isPressed


        property real padding: 10 

        Column {
            id: hdgMainColumn
            width: hdgGainEditorContainer.width - 2*padding
            spacing: 5
            padding: 10

            RowLayout {
                width: hdgMainColumn.width
                Text {
                    text: "HDG Gain Editor"
                    font.pointSize: 12
                }
                Item {
                    Layout.fillWidth: true
                }
                QGCButton {
                    text: "Cancel"
                    onClicked: hdgGainEditorContainer.visible = false
                    font.pointSize: 10
                }
                QGCButton {
                    text: "Save"
                    onClicked: {
                        _activeVehicle.kriso_sendHDGCommand(parseFloat(hdgSpeedInput.text), parseFloat(hdgDegreeInput.text))
                        // Save logic goes here
                        hdgGainEditorContainer.visible = false
                    }
                    font.pointSize: 10
                }
            }

            Rectangle {
                color: "gray"
                height: 1
                width: hdgMainColumn.width
            }

            RowLayout {
                Text {
                    text: "속도값"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                TextField {
                    id : hdgSpeedInput
                    placeholderText: "속도 입력"
                    width: parent.width * 0.5 
                }
            }

            RowLayout {
                Text {
                    text: "선수각"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                TextField {
                    id : hdgDegreeInput
                    placeholderText: "선수각 입력"
                    width: parent.width * 0.5
                }
            }


            RowLayout {
                Text {
                    text: "nav_surge_pgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                TextField {
                    id: navSurgePGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_surge_pgain").rawValue.toFixed(2)
                    font.pointSize: 10
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Text {
                    text: "nav_surge_dgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                TextField {
                    id: navSurgeDGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_surge_dgain").rawValue.toFixed(2)
                    font.pointSize: 10
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Text {
                    text: "nav_yaw_pgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                TextField {
                    id: navYawPGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_yaw_pgain").rawValue.toFixed(2)
                    font.pointSize: 10
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Text {
                    text: "nav_yaw_dgain"
                    font.pointSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 100
                    
                }
                TextField {
                    id: navYawDGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_yaw_dgain").rawValue.toFixed(2)
                    font.pointSize: 10
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                width: parent.width
                Item {
                    Layout.fillWidth: true
                }
                Button {
                    text: "입력완료"
                    onClicked: {
                        _activeVehicle.kriso_hdgGainSave(
                            parseFloat(navSurgePGainInput.text), 
                            parseFloat(navSurgeDGainInput.text), 
                            parseFloat(navYawPGainInput.text), 
                            parseFloat(navYawDGainInput.text)
                        );
                    }
                }
            }
        }
    }

}
