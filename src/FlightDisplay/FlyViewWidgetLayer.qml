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
    readonly property real  _hamburgerSize:     commandPicker.height * 0.75
    readonly property real  _trashSize:         commandPicker.height * 0.75

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _planMasterController:  globals.planMasterControllerFlyView
    property var    _missionController:     _planMasterController.missionController
    property var    _geoFenceController:    _planMasterController.geoFenceController
    property var    _rallyPointController:  _planMasterController.rallyPointController
    property var    _guidedController:      globals.guidedControllerFlyView
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30

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

    PhotoVideoControl {
        id:                     photoVideoControl
        anchors.margins:        _toolsMargin
        anchors.right:          parent.right
        width:                  _rightPanelWidth
        state:                  _verticalCenter ? "verticalCenter" : "topAnchor"
        states: [
            State {
                name: "verticalCenter"
                AnchorChanges {
                    target:                 photoVideoControl
                    anchors.top:            undefined
                    anchors.verticalCenter: _root.verticalCenter
                }
            },
            State {
                name: "topAnchor"
                AnchorChanges {
                    target:                 photoVideoControl
                    anchors.verticalCenter: undefined
                    anchors.top:            instrumentPanel.bottom
                }
            }
        ]

        property bool _verticalCenter: !QGroundControl.settingsManager.flyViewSettings.alternateInstrumentPanel.rawValue
    }

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
        visible:                !QGroundControl.videoManager.fullScreen

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
        //-------------------------------------------------------
        // Mission Item Editor
        Item {
            id:                     missionItemEditor
            anchors.left:           parent.left
            anchors.right:          parent.right
            anchors.top:            rightControls.bottom
            anchors.topMargin:      ScreenTools.defaultFontPixelHeight * 0.25
            anchors.bottom:         parent.bottom
            anchors.bottomMargin:   ScreenTools.defaultFontPixelHeight * 0.25
            visible:                true
       
        ListView {
            id: view

            property var collapsed: ({})

            width: _rightPanelWidth
            height: 250
            focus: true
            clip: true
            spacing: 10

            model: NameModel { }

            delegate: NameDelegate {
                readonly property ListView __lv: ListView.view

                anchors {
                    left: parent.left
                    leftMargin: 2

                    right: parent.right
                    rightMargin: 2
                }

                expanded: view.isSectionExpanded( model.team )

                MouseArea {
                    anchors.fill: parent
                    onClicked: __lv.currentIndex = index
                }
            }

            highlight: HighlightDelegate {
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            section {
                property: "team"
                criteria: ViewSection.FullString

                delegate: SectionDelegate {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    text: section

                    onClicked: view.toggleSection( section )
                }
            }

            function isSectionExpanded( section ) {
                return !(section in collapsed);
            }

            function showSection( section ) {
                delete collapsed[section]
                /*emit*/ collapsedChanged();
            }

            function hideSection( section ) {
                collapsed[section] = true
                /*emit*/ collapsedChanged();
            }

            function toggleSection( section ) {
                if ( isSectionExpanded( section ) ) {
                    hideSection( section )
                } else {
                    showSection( section )
                }
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

        
        
        // ColumnLayout {
        //     id:                 valuesColumn
        //     anchors.margins:    _margin
        //     anchors.left:       parent.left
        //     anchors.right:      parent.right
        //     anchors.top:        parent.top
        //     spacing:            _margin
            
        
        //     QGCLabel {
        //         text:           qsTr("All Altitudes")
        //         font.pointSize: ScreenTools.smallFontPointSize
        //     }
        //     MouseArea {
        //         Layout.preferredWidth:  childrenRect.width
        //         Layout.preferredHeight: childrenRect.height
        //         enabled:                _noMissionItemsAdded

        //         onClicked: {
        //             var removeModes = []
        //             var updateFunction = function(altMode){ _missionController.globalAltitudeMode = altMode }
        //             if (!_controllerVehicle.supportsTerrainFrame) {
        //                 removeModes.push(QGroundControl.AltitudeModeTerrainFrame)
        //             }
        //             mainWindow.showPopupDialogFromComponent(altModeDialogComponent, { rgRemoveModes: removeModes, updateAltModeFn: updateFunction })
        //         }

        //         RowLayout {
        //             spacing: ScreenTools.defaultFontPixelWidth
        //             enabled: _noMissionItemsAdded

        //             QGCLabel {
        //                 id:     altModeLabel
        //                 text:   QGroundControl.altitudeModeShortDescription(_missionController.globalAltitudeMode)
        //             }
        //             QGCColoredImage {
        //                 height:     ScreenTools.defaultFontPixelHeight / 2
        //                 width:      height
        //                 source:     "/res/DropArrow.svg"
        //                 color:      altModeLabel.color
        //             }
        //         }
        //     }

        //     QGCLabel {
        //         text:           qsTr("Initial Waypoint Alt")
        //         font.pointSize: ScreenTools.smallFontPointSize
        //     }

        //     GridLayout {
        //         Layout.fillWidth:   true
        //         columnSpacing:      ScreenTools.defaultFontPixelWidth
        //         rowSpacing:         columnSpacing
        //         columns:            2

<<<<<<< HEAD
        //         QGCCheckBox {
        //             id:         flightSpeedCheckBox
        //             text:       qsTr("Flight speed")
        //             visible:    _showFlightSpeed
        //             checked:    missionItem.speedSection.specifyFlightSpeed
        //             onClicked:   missionItem.speedSection.specifyFlightSpeed = checked
        //         }
        //     }
        // }
=======
                QGCCheckBox {
                    id:         flightSpeedCheckBox
                    text:       qsTr("Flight speed")
                    visible:    _showFlightSpeed
                    checked:    missionItem.speedSection.specifyFlightSpeed
                    onClicked:   missionItem.speedSection.specifyFlightSpeed = checked
                }
            }
        }

        Row {
            id:                 indicatorRow
            anchors.top:        valuesColumn.bottom
            anchors.bottom:     parent.bottom
            anchors.margins:    _toolIndicatorMargins
            spacing:            ScreenTools.defaultFontPixelWidth * 1.5

            property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
            property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.66

            // Repeater {
            //     id:     appRepeater
            //     model:  QGroundControl.corePlugin.toolBarIndicators
            //     Loader {
            //         anchors.top:        parent.top
            //         anchors.bottom:     parent.bottom
            //         source:             modelData
            //         visible:            item.showIndicator
            //     }
            // }

            Repeater {
                model: _activeVehicle ? _activeVehicle.toolIndicators : []
                Loader {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    source:             modelData
                    visible:            item.showIndicator
                }
            }

            // Repeater {
            //     model: _activeVehicle ? _activeVehicle.modeIndicators : []
            //     Loader {
            //         anchors.top:        parent.top
            //         anchors.bottom:     parent.bottom
            //         source:             modelData
            //         visible:            item.showIndicator
            //     }
            // }
        }
>>>>>>> 623d09577b179b0fa30c17730a237dff5507dd6e
    }
}
