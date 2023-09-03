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

    property int logging_status :  _activeVehicle.getFactGroup("krisoCmd").getFact("logging_status").value


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
        visible:            false

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
            height: layerTabBar.height
            opacity: 0.9
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
                        loggingPage.visible = false
                        trajectoryPage.visible = false
                    }
                }
                QGCTabButton {
                    id: krisoBatteryBtn
                    text: qsTr("배터리정보")
                    enabled: true
                    onClicked: {
                        page1.visible = false
                        page2.visible = true
                        loggingPage.visible = false
                        trajectoryPage.visible = false
                    }
                }
                QGCTabButton {
                    id: krisoLoggingStatusBtn
                    text: qsTr("로깅정보")
                    enabled: true
                    onClicked: {
                        page1.visible = false
                        page2.visible = false
                        loggingPage.visible = true
                        trajectoryPage.visible = false

                    }
                }
                QGCTabButton {
                    id: krisoTajectorySetupBtn
                    text: qsTr("궤적설정")
                    enabled: true
                    onClicked: {
                        page1.visible = false
                        page2.visible = false
                        loggingPage.visible = false
                        trajectoryPage.visible = true

                    }
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

            Rectangle {
                id: loggingPage
                anchors.top: layerTabBar.bottom
                radius: 4
                width: parent.width
                height: 100 
                color: "white"
                visible: false

                Row {
                    anchors.centerIn: parent
                    spacing: 10  // 텍스트와 토글 사이의 간격

                    Text {
                        text: "로깅시작"
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                    }

                    Switch {
                        id: toggleSwitch
                        width: 50
                        height: 25
                        checked: false

                        onCheckedChanged: {
                            console.log("Switch is now:", checked ? "ON" : "OFF")
                            if (checked){
                                _activeVehicle.kriso_sendLogCommand(1) 
                            }else {
                                _activeVehicle.kriso_sendLogCommand(0) 
                            }
                        }

                        background: Rectangle {
                            radius: toggleSwitch.height / 2
                            color: toggleSwitch.checked ? "green" : "lightgray"
                            border.color: "gray"
                            border.width: 2
                        }

                        indicator: Rectangle {
                            width: toggleSwitch.width / 2.2
                            height: toggleSwitch.height / 1.2
                            radius: height / 2
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            x: toggleSwitch.checked ? toggleSwitch.width - width - toggleSwitch.height / 10 : toggleSwitch.height / 10
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: toggleSwitch.bottom 
                    anchors.topMargin: 20

                    Rectangle {
                        width: 100
                        height: 25
                        color: (logging_status === 1)? "green" : "red"
                        radius: 4
                        border.color: "gray"
                        border.width: 2

                        Text {
                            id: loggingStatus
                            anchors.centerIn: parent
                            text: (logging_status === 1) ? "로깅중" : "로깅 중단"
                            color: "white"
                        }
                    }
                }
            }

            Rectangle {
                id: trajectoryPage
                anchors.top: layerTabBar.bottom
                radius: 4
                width: 500
                height: 150
                color: "white"
                visible: false
                // padding: 10 
                // 궤적 표기 설정 타이틀

                ColumnLayout{
                    
                    anchors.left: parent.left
                    anchors.margins: 10
                    spacing: 10

                    Text {
                        id : trjaectoryTitle
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "궤적 표기 설정"
                        font.pixelSize: 20
                    }

                    RowLayout {
                        id: moveTrajectoryRow
                        // anchors.centerIn: parent
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        // anchors.top: trjaectoryTitle.bottom
            
                        anchors.topMargin: 20
                        spacing: 10  // 텍스트와 토글 사이의 간격

                        Text {
                            text: "이동궤적"
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter
                        }

                        Switch {
                            id: moveTrajectoryToggle
                            width: 50
                            height: 25
                            checked: true

                            onCheckedChanged: {
                                console.log("Switch is now:", checked ? "ON" : "OFF")
                                if (checked){
                                    _activeVehicle.trajectoryVisible = true
                                }else {
                                    _activeVehicle.trajectoryVisible = false
                                }
                            }

                            background: Rectangle {
                                radius: moveTrajectoryToggle.height / 3
                                color: moveTrajectoryToggle.checked ? "green" : "lightgray"
                                border.color: "gray"
                                border.width: 1
                            }

                            indicator: Rectangle {
                                width: moveTrajectoryToggle.width / 2.2
                                height: moveTrajectoryToggle.height / 1.2
                                radius: height / 2
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                                x: moveTrajectoryToggle.checked ? moveTrajectoryToggle.width - width - moveTrajectoryToggle.height / 10 : moveTrajectoryToggle.height / 10
                            }
                        }
                    }


                    RowLayout {
                        id : planTrajectoryRow
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter // 중앙 정렬
                        spacing: 10  // 텍스트와 토글 사이의 간격

                        Text {
                            text: "계획궤적"
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter
                        }

                        Switch {
                            id: planTrajectoryToggle
                            width: 50
                            height: 25
                            checked: true

                            onCheckedChanged: {
                                console.log("Switch is now:", checked ? "ON" : "OFF")
                                if (checked){
                                    _activeVehicle.planPathVisible = true
                                }else {
                                    _activeVehicle.planPathVisible = false
                                }
                            }

                            background: Rectangle {
                                radius: planTrajectoryToggle.height / 3
                                color: planTrajectoryToggle.checked ? "green" : "lightgray"
                                border.color: "gray"
                                border.width: 1
                            }

                            indicator: Rectangle {
                                width: planTrajectoryToggle.width / 2.2
                                height: planTrajectoryToggle.height / 1.2
                                radius: height / 2
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                                x: planTrajectoryToggle.checked ? planTrajectoryToggle.width - width - planTrajectoryToggle.height / 10 : planTrajectoryToggle.height / 10
                            }
                        }
                    }
                    
                    // RowLayout {
                    //     id : clearTrajectoryRow
                    //     Layout.fillWidth: true
                    //     Layout.alignment: Qt.AlignHCenter
                    //     spacing: 10  // 텍스트와 토글 사이의 간격

                    //     Text {
                    //         text: "궤적삭제"
                    //         font.pointSize: 10
                    //         verticalAlignment: Text.AlignVCenter
                    //     }

                    //     Switch {
                    //         id: clearTrajectoryToggle
                    //         width: 100
                    //         height: 25
                    //         checked:  false

                    //         onCheckedChanged: {
                    //             console.log("Switch is now:", checked ? "ON" : "OFF")
                    //             if (checked){
                    //                 // _activeVehicle.planPathVisible = true
                    //             }else {
                    //                 // _activeVehicle.planPathVisible = false
                    //             }
                    //         }

                    //         background: Rectangle {
                    //             radius: clearTrajectoryToggle.height / 3
                    //             color: clearTrajectoryToggle.checked ? "green" : "lightgray"
                    //             border.color: "gray"
                    //             border.width: 1
                    //         }

                    //         indicator: Rectangle {
                    //             width: clearTrajectoryToggle.width / 2.2
                    //             height: clearTrajectoryToggle.height / 1.2
                    //             radius: height / 2
                    //             color: "white"
                    //             anchors.verticalCenter: parent.verticalCenter
                    //             x: clearTrajectoryToggle.checked ? clearTrajectoryToggle.width - width - clearTrajectoryToggle.height / 10 : clearTrajectoryToggle.height / 10
                    //         }
                    //     }

                    // }
                }
            


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
        // visible :  _activeVehicle ? true : false
        visible : true

        implicitWidth: missionModeRow.width + padding * 2
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
                font.pixelSize: container.width / 20
            }

            Row {
                id: operationModeRow
                spacing: 10
                KrisoRadioButton {
                    id: manualMode
                    text: "수동"
                    font.pointSize:10
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
                    font.pointSize:10
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
                    font.pointSize:10
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
                font.pointSize:10
            }

            Row {
                id: missionModeRow
                spacing: 10

                // remoteMode button 
                KrisoRadioButton {
                    id: remoteMode 
                    text: "원격수동"
                    font.pointSize:10
                    enabled: (autoMode.isPressed || simulationMode.isPressed) ? true : false
                    onIsPressedChanged: {
                        if(isPressed) {
                            dpGainEditorContainer.visible = false;
                            hdgMode.isPressed = false;
                            hdgGainEditorContainer.visible = false;
                            moveToPlanView.visible = false;
                            remoteContainer.visible = true;
                            wpCAEditorContainer.visible = false
                        } else {
                            // maunal mode container추가 필요
                            remoteContainer.visible = false;
                        }
                    }
                }
                // wpMode button
                KrisoRadioButton {
                    id: wpMode
                    text: "WP"
                    font.pointSize:10
                    enabled: (autoMode.isPressed || simulationMode.isPressed) ? true : false
                    onIsPressedChanged: {
                        if(isPressed){
                            moveToPlanView.visible = true;
                            dpMode.isPressed = false;
                            dpGainEditorContainer.visible = false;
                            hdgGainEditorContainer.visible = false
                            remoteContainer.visible = false;
                            wpCAEditorContainer.visible = true;
                        }else {
                            moveToPlanView.visible = false;
                            wpCAEditorContainer.visible = false;
                        }
                    }
                }
                // hdgMode button
                KrisoRadioButton {
                    id: hdgMode
                    text: "HDG"
                    font.pointSize:10
                    enabled: (autoMode.isPressed || simulationMode.isPressed) ? true : false
                    onIsPressedChanged: {
                        if(isPressed) {
                            hdgGainEditorContainer.visible = true;
                            dpMode.isPressed = false;
                            dpGainEditorContainer.visible = false;
                            moveToPlanView.visible = false;
                            remoteContainer.visible = false;
                            wpCAEditorContainer.visible = false;
                        } else {
                            hdgGainEditorContainer.visible = false;
                            // hdgGainEditorContainer.visible = false;
                        }
                    }
                }
                // dpMode button
                KrisoRadioButton {
                    id: dpMode
                    text: "DP"
                    font.pointSize:10
                    enabled: (autoMode.isPressed || simulationMode.isPressed) ? true : false
                    onIsPressedChanged: {
                        if(isPressed) {
                            dpGainEditorContainer.visible = true;
                            hdgMode.isPressed = false;
                            hdgGainEditorContainer.visible = false;
                            moveToPlanView.visible = false;
                            remoteContainer.visible = false;
                            wpCAEditorContainer.visible = false;
                        } else {
                            // dpmodeContainer.visible = false;
                            dpGainEditorContainer.visible = false;
                        }
                    }
                }
            }

            Row {
                spacing: 10
                // 모드변경 button
                Button {
                    text: "모드변경"
                    onClicked: {
                        if(manualMode.checked){
                            _activeVehicle.kriso_sendOPModeCommand(1, 0)
                        }else if(autoMode.checked){
                            if(wpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(2, 2)
                            }else if(hdgMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(2, 3)
                            }else if(dpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(2, 4)
                            }else if (remoteMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(2, 1)
                            }
                        }else if(simulationMode.checked){
                            if(wpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(3, 2)
                            }else if(hdgMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(3, 3)
                            }else if(dpMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(3, 4)
                            }else if(remoteMode.checked){
                                _activeVehicle.kriso_sendOPModeCommand(3, 1)
                            }
                        }
                    }
                }
                // 계획생성 button
                Button {
                    id : moveToPlanView
                    text: "계획생성"
                    font.pointSize: 10 
                    visible : wpMode.isPressed ? true : false
                    onClicked: mainWindow.showPlanView()
                }
            }
        }
    }

    
    // DP Gain Container
    Rectangle {
        id: dpGainEditorContainer
        color: "white"
        radius: 10
        anchors.top: toolStrip.bottom
        anchors.left: container.right
        anchors.margins: 10
        width: 350
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
                    font.pixelSize: container.width / 20
                }
                Item {
                    Layout.fillWidth: true
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

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 110
                    
                }
                QGCTextField {
                    id: dpSurgePGainInput
                    placeholderText: "Enter value"
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_surge_pgain").rawValue.toFixed(2)

                }
            }
            RowLayout {
                Text {
                    text: "dp_surge_dgain"

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 110
                    
                }
                QGCTextField {
                    id: dpSurgeDGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_surge_dgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"

                }
            }
            RowLayout {
                Text {
                    text: "dp_sway_pgain"

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 110
                    
                }
                QGCTextField {
                    id: dpSwayPGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_sway_pgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"

                }
            }
            RowLayout {
                Text {
                    text: "dp_sway_dgain" 

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 110
                    
                }
                QGCTextField {
                    id: dpSwayDGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_sway_dgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"

                }
            }
            RowLayout {
                width: parent.width * 0.8
                Text {
                    text: "dp_yaw_pgain"
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 110       
                }
                QGCTextField {
                    id: dpYawPGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_yaw_pgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"


                }
            }
            RowLayout {
                Text {
                    text: "dp_yaw_dgain"

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 110
                    
                }
                QGCTextField {
                    id: dpYawDGainInput
                    text: _activeVehicle.getFactGroup("krisoGain").getFact("dp_yaw_dgain").rawValue.toFixed(2)
                    placeholderText: "Enter value"
                }
            }
            RowLayout {

                QGCButton {
                    text: "명령전송"
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
                        _activeVehicle.kriso_sendDPCommand();
                    }
                }
                QGCButton {
                    text: "취소"
                    onClicked: dpGainEditorContainer.visible = false
                }
            }
        }
    }

    // WP CA Gain Container
    Rectangle {
        id: wpCAEditorContainer
        color: "white"
        radius: 10
        anchors.top: toolStrip.bottom
        anchors.left: container.right
        anchors.margins: 10
        width: 400
        height: caMainColumn.height + 2*padding
        visible: false
        // visible: !dpMode.isPressed && hdgMode.isPressed


        property real padding: 10 

        Column {
            id: caMainColumn
            width: wpCAEditorContainer.width + 2*padding
            spacing: 5
            padding: 10

            RowLayout {
                // width: hdgMainColumn.width
                Text {
                    text: "CA Param Editor"
                    font.pixelSize: container.width / 20
                }
                Item {
                    Layout.fillWidth: true
                }
                Row {
                    spacing: 10

                    Switch {
                        id: caToggleSwitch
                        width: 50
                        height: 25
                        checked: false
                        visible: false

                        onCheckedChanged: {
                            console.log("Switch is now:", checked ? "ON" : "OFF")
                            if (checked){
                                _activeVehicle.kriso_sendLogCommand(1) 
                            }else {
                                _activeVehicle.kriso_sendLogCommand(0) 
                            }
                        }

                        background: Rectangle {
                            radius: caToggleSwitch.height / 2
                            color: caToggleSwitch.checked ? "green" : "lightgray"
                            border.color: "gray"
                            border.width: 2
                        }

                        indicator: Rectangle {
                            width: caToggleSwitch.width / 2.2
                            height: caToggleSwitch.height / 1.2
                            radius: height / 2
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            x: caToggleSwitch.checked ? caToggleSwitch.width - width - caToggleSwitch.height / 10 : toggleSwitch.height / 10
                        }
                    }
                }

            }

            Rectangle {
                color: "gray"
                height: 1
                width: caMainColumn.width * 0.8
            }

            RowLayout {
                Text {
                    text: "ca_alert_range"
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id : caAlertRangeInput
                    placeholderText: "ca_alert_range"
                    width: parent.width * 0.5 
                }
            }

            RowLayout {
                Text {
                    text: "ca_avoid_range"
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id : caAvoidRangeInput
                    placeholderText: "ca_avoid_range"
                    width: parent.width * 0.5
                }
            }


            RowLayout {
                Text {
                    text: "ca_param1"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id: caParam1Input
                    placeholderText: "ca_param1"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_surge_pgain").rawValue.toFixed(2)
                   
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Text {
                    text: "ca_param2"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id: caParam2Input
                    placeholderText: "ca_param2"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_surge_dgain").rawValue.toFixed(2)
                   
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Item {
                    Layout.fillWidth: true
                }
                QGCButton {
                    text: "명령전송"
                    onClicked: {
                        _activeVehicle.kriso_sendCACommand(
                            parseFloat(caAlertRangeInput.text),
                            parseFloat(caAvoidRangeInput.text),
                            parseFloat(caParam1Input.text), 
                            parseFloat(caParam2Input.text)
                        );
                    }
                }
                QGCButton {
                    text: "Cancel"
                    onClicked: wpCAEditorContainer.visible = false

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
        width: 400
        height: hdgMainColumn.height + 2*padding
        visible: false
        // visible: !dpMode.isPressed && hdgMode.isPressed


        property real padding: 10 

        Column {
            id: hdgMainColumn
            width: hdgGainEditorContainer.width + 2*padding
            spacing: 5
            padding: 10

            RowLayout {
                // width: hdgMainColumn.width
                Text {
                    text: "HDG Gain Editor"
                    font.pixelSize: container.width / 20
                }
                Item {
                    Layout.fillWidth: true
                }
            }

            Rectangle {
                color: "gray"
                height: 1
                width: hdgMainColumn.width
            }

            RowLayout {
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: "속도값"
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
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
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
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
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id: navSurgePGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_surge_pgain").rawValue.toFixed(2)
                   
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Text {
                    text: "nav_surge_dgain"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id: navSurgeDGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_surge_dgain").rawValue.toFixed(2)
                   
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Text {
                    text: "nav_yaw_pgain"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id: navYawPGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_yaw_pgain").rawValue.toFixed(2)
                   
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Text {
                    text: "nav_yaw_dgain"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    
                }
                TextField {
                    id: navYawDGainInput
                    placeholderText: "Enter value"
                    text : _activeVehicle.getFactGroup("krisoGain").getFact("nav_yaw_dgain").rawValue.toFixed(2)
                   
                    width: parent.width * 0.5

                }
            }
            RowLayout {
                Item {
                    Layout.fillWidth: true
                }
                QGCButton {
                    text: "입력완료"
                    onClicked: {
                        _activeVehicle.kriso_hdgGainSave(
                            parseFloat(hdgSpeedInput.text),
                            parseFloat(hdgDegreeInput.text),
                            parseFloat(navSurgePGainInput.text), 
                            parseFloat(navSurgeDGainInput.text), 
                            parseFloat(navYawPGainInput.text), 
                            parseFloat(navYawDGainInput.text)
                        );
                        _activeVehicle.kriso_sendHDGCommand();
                    }
                }
                QGCButton {
                    text: "취소"
                    onClicked: hdgGainEditorContainer.visible = false
                }
            }
        }
    }

    // RPM Test
    Rectangle {
        id : remoteContainer
        color: "white"
        radius: 10
        anchors.top: container.bottom
        anchors.margins: 10
        anchors.left: parent.left
        width: container.width + 80
        height: container.height + 30
        visible: false

        Column {
            id: "autoColumn"
            anchors.fill: parent 
            spacing: 5
            padding: 10

            RowLayout{

                Text {
                    text: "                             "
                    font.pixelSize: 20
                }
                
                Text {
                    text: "RPM           "
                    font.pixelSize: 15
                }

                Text {
                    text: "        타각"
                    font.pixelSize: 15
                }
            }
            
            RowLayout {

                Text {
                    id: "mainmoter"
                    text: "주추진기1(좌현)"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 150  
                }
                QGCTextField {
                    id: mainPro_t3_rpm
                    placeholderText: "t3_rpm"
                    font.pointSize: 8
                }

                QGCTextField {
                    id: mainPro_t3_angle
                    placeholderText: "t3_angle"
                    font.pointSize: 8
                }
            }

            RowLayout {

                Text {
                    text: "주추진기2(우현)"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 150  
                }
                QGCTextField {
                    id: mainPro_t4_rpm
                    placeholderText: "t4_rpm"
                    font.pointSize: 8
                }
                QGCTextField {
                    id: mainPro_t4_angle
                    placeholderText: "t4_angle"
                    font.pointSize: 8
                }
            }

            RowLayout {

                Text {
                    text: "선수추진기1(좌현)"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 150   
                }
                QGCTextField {
                    id: bowThrust_t1_rpm
                    placeholderText: "t1_rpm"
                    font.pointSize: 8
                }
            }

            RowLayout {
                
                Text {
                    text: "선수추진기2(우현)"
                   
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 150   
                }
                QGCTextField {
                    id: bowThrust_t2_rpm
                    placeholderText: "t2_rpm"
                    font.pointSize: 8
                }
            }

            Row {
                spacing: 10
                
                Text {
                    text: "                             "
                    font.pixelSize: 20
                }

                Button {
                    text: "START"
                    onClicked: {
                        var t3_rpm = parseFloat(mainPro_t3_rpm.text);
                        var t3_angle = parseFloat(mainPro_t3_angle.text);
                        var t4_rpm = parseFloat(mainPro_t4_rpm.text);
                        var t4_angle = parseFloat(mainPro_t4_angle.text);
                        var t1_rpm = parseFloat(bowThrust_t1_rpm.text);
                        var t2_rpm = parseFloat(bowThrust_t2_rpm.text);

                        _activeVehicle.kriso_sendMTCommand(1,t1_rpm,t2_rpm,t3_rpm,t3_angle, t4_rpm,t4_angle); 
                    }
                }

                Button {
                    id: initRemote
                    text: "STOP"
                    onClicked : {
                        mainPro_t3_rpm.text = "0";
                        mainPro_t3_angle.text = "0";
                        mainPro_t4_rpm.text = "0";
                        mainPro_t4_angle.text = "0";
                        bowThrust_t1_rpm.text = "0";
                        bowThrust_t2_rpm.text = "0";
                        _activeVehicle.kriso_sendMTCommand(0,0,0,0,0,0,0); 

                    }
                }
            }
        }
    }
}
