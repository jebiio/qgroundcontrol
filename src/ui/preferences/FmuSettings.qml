/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0

Rectangle {
    id:                 _root
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property Fact _savePath:                            QGroundControl.settingsManager.appSettings.savePath
    property Fact _appFontPointSize:                    QGroundControl.settingsManager.appSettings.appFontPointSize
    property Fact _userBrandImageIndoor:                QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor
    property Fact _userBrandImageOutdoor:               QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor
    property Fact _virtualJoystick:                     QGroundControl.settingsManager.appSettings.virtualJoystick
    property Fact _virtualJoystickAutoCenterThrottle:   QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle

    property real   _labelWidth:                ScreenTools.defaultFontPixelWidth * 20
    property real   _comboFieldWidth:           ScreenTools.defaultFontPixelWidth * 30
    property real   _valueFieldWidth:           ScreenTools.defaultFontPixelWidth * 10
    property string _mapProvider:               QGroundControl.settingsManager.flightMapSettings.mapProvider.value
    property string _mapType:                   QGroundControl.settingsManager.flightMapSettings.mapType.value
    property Fact   _followTarget:              QGroundControl.settingsManager.appSettings.followTarget
    property real   _panelWidth:                _root.width * _internalWidthRatio
    property real   _margins:                   ScreenTools.defaultFontPixelWidth
    property var    _planViewSettings:          QGroundControl.settingsManager.planViewSettings
    property var    _flyViewSettings:           QGroundControl.settingsManager.flyViewSettings
    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings
    property string _videoSource:               _videoSettings.videoSource.rawValue
    property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
    property bool   _isUDP264:                  _isGst && _videoSource === _videoSettings.udp264VideoSource
    property bool   _isUDP265:                  _isGst && _videoSource === _videoSettings.udp265VideoSource
    property bool   _isRTSP:                    _isGst && _videoSource === _videoSettings.rtspVideoSource
    property bool   _isTCP:                     _isGst && _videoSource === _videoSettings.tcpVideoSource
    property bool   _isMPEGTS:                  _isGst && _videoSource === _videoSettings.mpegtsVideoSource
    property bool   _videoAutoStreamConfig:     QGroundControl.videoManager.autoStreamConfigured
    property bool   _showSaveVideoSettings:     _isGst || _videoAutoStreamConfig
    property bool   _disableAllDataPersistence: QGroundControl.settingsManager.appSettings.disableAllPersistence.rawValue

    property string gpsDisabled: "Disabled"
    property string gpsUdpPort:  "UDP Port"

    readonly property real _internalWidthRatio: 0.8

        QGCFlickable {
            clip:               true
            anchors.fill:       parent
            contentHeight:      outerItem.height
            contentWidth:       outerItem.width

            Item {
                id:     outerItem
                width: settingsColumn.width + (_margins * 10)
                // width:  Math.max(_root.width, settingsColumn.width)
                height: settingsColumn.height

                ColumnLayout {
                    id:                         settingsColumn
                    anchors.horizontalCenter:   parent.horizontalCenter

                    QGCLabel {
                        id:         trainModeLabel
                        text:       qsTr("Train Mode")
                        visible:    true
                    }
                    Rectangle {
                        Layout.preferredHeight: trainCol.height + (_margins * 2)
                        Layout.preferredWidth:  trainCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                trainModeLabel.visible
                        Layout.fillWidth:       true

                        ColumnLayout {
                            id:                         trainCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins
                            
                            GridLayout {
                                columns: 2

                                QGCLabel {
                                    text:       qsTr("train path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("valid path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }

                                QGCLabel {
                                    text:       qsTr("test path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("result path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("seed")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                
                                QGCLabel {
                                    text:       qsTr("model")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("selective method")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("var_to_forecast")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("past windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                
                                QGCLabel {
                                    text:       qsTr("future windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("epoch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("batch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("num_workers")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("lr")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("float")
                                    visible:    guidedMinAltField.visible
                                }
                                
                                QGCLabel {
                                    text:       qsTr("weight_decay")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("float")
                                    visible:    guidedMinAltField.visible
                                }                               
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: detectionModeLabel.visible }
                    QGCLabel {
                        id:         detectionModeLabel
                        text:       qsTr("Detection Mode")
                        visible:    true
                    }
                    Rectangle {
                        Layout.preferredHeight: detectionCol.height + (_margins * 2)
                        Layout.preferredWidth:  detectionCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                detectionModeLabel.visible
                        Layout.fillWidth:       true

                        ColumnLayout {
                            id:                         detectionCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins
                            
                            GridLayout {
                                columns: 2

                                QGCLabel {
                                    text:       qsTr("model path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("string")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("past windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("future windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("past windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                
                                QGCLabel {
                                    text:       qsTr("epoch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("batch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("num_workers")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("int")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("lr")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("float")
                                    visible:    guidedMinAltField.visible
                                }
                                
                                QGCLabel {
                                    text:       qsTr("weight_decay")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCLabel {
                                    text:       qsTr("float")
                                    visible:    guidedMinAltField.visible
                                }                               
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: forwarderIPLabel.visible }
                    QGCLabel {
                        id:         forwarderIPLabel
                        text:       qsTr("Forward IP")
                        visible:    QGroundControl.settingsManager.unitsSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id:                         unitsGrid
                            anchors.topMargin:          _margins
                            anchors.top:                parent.top
                            Layout.fillWidth:           false
                            anchors.horizontalCenter:   parent.horizontalCenter
                            flow:                       GridLayout.TopToBottom
                            columns:                       2

                            QGCLabel { text: qsTr("Server Address") }

                            QGCTextField {
                                id:                     hostField
                                text:                   "0.0.0.0"
                            }
                            QGCLabel { text: qsTr("Port") }

                            QGCTextField {
                                id:                     testField
                                text:                   "0000"
                            }

                        }
                    }

                    Item { width: 1; height: _margins; visible: forwarderReceivePort.visible }
                    QGCLabel {
                        id:         forwarderReceivePort
                        text:       qsTr("Forward Receive Port")
                        visible:    true
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid2.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid2.width + (_margins * 20)
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id:                         unitsGrid2
                            anchors.topMargin:          _margins
                            anchors.top:                parent.top
                            Layout.fillWidth:           false
                            anchors.horizontalCenter:   parent.horizontalCenter
                            flow:                       GridLayout.TopToBottom
                            columns:                       2

    
                            QGCLabel { text: qsTr("Port") }

                            QGCTextField {
                                id:                     testField2
                                text:                   "0000"
                            }

                        }
                    }

                    Item { width: 1; height: _margins; visible: engineIpTcp.visible }
                    QGCLabel {
                        id:         engineIpTcp
                        text:       qsTr("Engine IP TCP")
                        visible:    true
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid3.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid3.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id:                         unitsGrid3
                            anchors.topMargin:          _margins
                            anchors.top:                parent.top
                            Layout.fillWidth:           false
                            anchors.horizontalCenter:   parent.horizontalCenter
                            flow:                       GridLayout.TopToBottom
                            columns:                       2

                            QGCLabel { text: qsTr("Server Address") }

                            QGCTextField {
                                id:                     hostField3
                                text:                   "0.0.0.0"
                            }
                            QGCLabel { text: qsTr("Port") }

                            QGCTextField {
                                id:                     testField3
                                text:                   "0000"
                            }

                        }
                    }


                    Item { width: 1; height: _margins; visible: engineIpUdp.visible }
                    QGCLabel {
                        id:         engineIpUdp
                        text:       qsTr("Engine IP UDP")
                        visible:    true
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid4.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid4.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id:                         unitsGrid4
                            anchors.topMargin:          _margins
                            anchors.top:                parent.top
                            Layout.fillWidth:           false
                            anchors.horizontalCenter:   parent.horizontalCenter
                            flow:                       GridLayout.TopToBottom
                            columns:                       2

                            QGCLabel { text: qsTr("Server Address") }

                            QGCTextField {
                                id:                     hostField4
                                text:                   "0.0.0.0"
                            }
                            QGCLabel { text: qsTr("Port") }

                            QGCTextField {
                                id:                     testField4
                                text:                   "0000"
                            }

                        }
                    }


                    Item { width: 1; height: _margins; visible: engineReceivePort.visible }
                    QGCLabel {
                        id:         miscSectionLabel
                        text:       qsTr("EngineReceive Port")
                        visible:    true
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid5.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid5.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id:                         unitsGrid5
                            anchors.topMargin:          _margins
                            anchors.top:                parent.top
                            Layout.fillWidth:           false
                            anchors.horizontalCenter:   parent.horizontalCenter
                            flow:                       GridLayout.TopToBottom
                            columns:                       2

                            QGCLabel { text: qsTr("Port") }

                            QGCTextField {
                                id:                     testField5
                                text:                   "0000"
                            }

                        }
                    }


                    // Item { width: 1; height: _margins; visible: miscSectionLabel.visible }
                    // QGCLabel {
                    //     id:         miscSectionLabel
                    //     text:       qsTr("Miscellaneous")
                    //     visible:    QGroundControl.settingsManager.appSettings.visible
                    // }
                    // Rectangle {
                    //     Layout.preferredWidth:  Math.max(comboGrid.width, miscCol.width) + (_margins * 2)
                    //     Layout.preferredHeight: (pathRow.visible ? pathRow.y + pathRow.height : miscColItem.y + miscColItem.height)  + (_margins * 2)
                    //     Layout.fillWidth:       true
                    //     color:                  qgcPal.windowShade
                    //     visible:                miscSectionLabel.visible

                    //     Item {
                    //         id:                 comboGridItem
                    //         anchors.margins:    _margins
                    //         anchors.top:        parent.top
                    //         anchors.left:       parent.left
                    //         anchors.right:      parent.right
                    //         height:             comboGrid.height

                    //         GridLayout {
                    //             id:                         comboGrid
                    //             anchors.horizontalCenter:   parent.horizontalCenter
                    //             columns:                    2

                    //             QGCLabel {
                    //                 text:           qsTr("Language")
                    //                 visible: QGroundControl.settingsManager.appSettings.qLocaleLanguage.visible
                    //             }
                    //             FactComboBox {
                    //                 Layout.preferredWidth:  _comboFieldWidth
                    //                 fact:                   QGroundControl.settingsManager.appSettings.qLocaleLanguage
                    //                 indexModel:             false
                    //                 visible:                QGroundControl.settingsManager.appSettings.qLocaleLanguage.visible
                    //             }

                    //             QGCLabel {
                    //                 text:           qsTr("Color Scheme")
                    //                 visible: QGroundControl.settingsManager.appSettings.indoorPalette.visible
                    //             }
                    //             FactComboBox {
                    //                 Layout.preferredWidth:  _comboFieldWidth
                    //                 fact:                   QGroundControl.settingsManager.appSettings.indoorPalette
                    //                 indexModel:             false
                    //                 visible:                QGroundControl.settingsManager.appSettings.indoorPalette.visible
                    //             }

                    //             QGCLabel {
                    //                 text:       qsTr("Map Provider")
                    //                 width:      _labelWidth
                    //             }

                    //             QGCComboBox {
                    //                 id:             mapCombo
                    //                 model:          QGroundControl.mapEngineManager.mapProviderList
                    //                 Layout.preferredWidth:  _comboFieldWidth
                    //                 onActivated: {
                    //                     _mapProvider = textAt(index)
                    //                     QGroundControl.settingsManager.flightMapSettings.mapProvider.value=textAt(index)
                    //                     QGroundControl.settingsManager.flightMapSettings.mapType.value=QGroundControl.mapEngineManager.mapTypeList(textAt(index))[0]
                    //                 }
                    //                 Component.onCompleted: {
                    //                     var index = mapCombo.find(_mapProvider)
                    //                     if(index < 0) index = 0
                    //                     mapCombo.currentIndex = index
                    //                 }
                    //             }
                    //             QGCLabel {
                    //                 text:       qsTr("Map Type")
                    //                 width:      _labelWidth
                    //             }
                    //             QGCComboBox {
                    //                 id:             mapTypeCombo
                    //                 model:          QGroundControl.mapEngineManager.mapTypeList(_mapProvider)
                    //                 Layout.preferredWidth:  _comboFieldWidth
                    //                 onActivated: {
                    //                     _mapType = textAt(index)
                    //                     QGroundControl.settingsManager.flightMapSettings.mapType.value=textAt(index)
                    //                 }
                    //                 Component.onCompleted: {
                    //                     var index = mapTypeCombo.find(_mapType)
                    //                     if(index < 0) index = 0
                    //                     mapTypeCombo.currentIndex = index
                    //                 }
                    //             }

                    //             QGCLabel {
                    //                 text:                   qsTr("Stream GCS Position")
                    //                 visible:                _followTarget.visible
                    //             }
                    //             FactComboBox {
                    //                 Layout.preferredWidth:  _comboFieldWidth
                    //                 fact:                   _followTarget
                    //                 indexModel:             false
                    //                 visible:                _followTarget.visible
                    //             }
                    //             QGCLabel {
                    //                 text:                           qsTr("UI Scaling")
                    //                 visible:                        _appFontPointSize.visible
                    //                 Layout.alignment:               Qt.AlignVCenter
                    //             }
                    //             Item {
                    //                 width:                          _comboFieldWidth
                    //                 height:                         baseFontEdit.height * 1.5
                    //                 visible:                        _appFontPointSize.visible
                    //                 Layout.alignment:               Qt.AlignVCenter
                    //                 Row {
                    //                     spacing:                    ScreenTools.defaultFontPixelWidth
                    //                     anchors.verticalCenter:     parent.verticalCenter
                    //                     QGCButton {
                    //                         width:                  height
                    //                         height:                 baseFontEdit.height * 1.5
                    //                         text:                   "-"
                    //                         anchors.verticalCenter: parent.verticalCenter
                    //                         onClicked: {
                    //                             if (_appFontPointSize.value > _appFontPointSize.min) {
                    //                                 _appFontPointSize.value = _appFontPointSize.value - 1
                    //                             }
                    //                         }
                    //                     }
                    //                     QGCLabel {
                    //                         id:                     baseFontEdit
                    //                         width:                  ScreenTools.defaultFontPixelWidth * 6
                    //                         text:                   (QGroundControl.settingsManager.appSettings.appFontPointSize.value / ScreenTools.platformFontPointSize * 100).toFixed(0) + "%"
                    //                         horizontalAlignment:    Text.AlignHCenter
                    //                         anchors.verticalCenter: parent.verticalCenter
                    //                     }
                    //                     Text {

                    //                     }

                    //                     QGCButton {
                    //                         width:                  height
                    //                         height:                 baseFontEdit.height * 1.5
                    //                         text:                   "+"
                    //                         anchors.verticalCenter: parent.verticalCenter
                    //                         onClicked: {
                    //                             if (_appFontPointSize.value < _appFontPointSize.max) {
                    //                                 _appFontPointSize.value = _appFontPointSize.value + 1
                    //                             }
                    //                         }
                    //                     }
                    //                 }
                    //             }
                    //         }
                    //     }

                    //     Item {
                    //         id:                 miscColItem
                    //         anchors.margins:    _margins
                    //         anchors.left:       parent.left
                    //         anchors.right:      parent.right
                    //         anchors.top:        comboGridItem.bottom
                    //         anchors.topMargin:  ScreenTools.defaultFontPixelHeight
                    //         height:             miscCol.height

                    //         ColumnLayout {
                    //             id:                         miscCol
                    //             anchors.horizontalCenter:   parent.horizontalCenter
                    //             spacing:                    _margins

                    //             FactCheckBox {
                    //                 text:       qsTr("Use Vehicle Pairing")
                    //                 fact:       _usePairing
                    //                 visible:    _usePairing.visible && QGroundControl.supportsPairing
                    //                 property Fact _usePairing: QGroundControl.settingsManager.appSettings.usePairing
                    //             }

                    //             FactCheckBox {
                    //                 text:       qsTr("Mute all audio output")
                    //                 fact:       _audioMuted
                    //                 visible:    _audioMuted.visible
                    //                 property Fact _audioMuted: QGroundControl.settingsManager.appSettings.audioMuted
                    //             }

                    //             FactCheckBox {
                    //                 text:       qsTr("Save application data to SD Card")
                    //                 fact:       _androidSaveToSDCard
                    //                 visible:    _androidSaveToSDCard.visible
                    //                 property Fact _androidSaveToSDCard: QGroundControl.settingsManager.appSettings.androidSaveToSDCard
                    //             }

                    //             FactCheckBox {
                    //                 text:       qsTr("Check for Internet connection")
                    //                 fact:       _checkInternet
                    //                 visible:    _checkInternet && _checkInternet.visible
                    //                 property Fact _checkInternet: QGroundControl.settingsManager.appSettings.checkInternet
                    //             }

                    //             QGCCheckBox {
                    //                 id:         clearCheck
                    //                 text:       qsTr("Clear all settings on next start")
                    //                 checked:    false
                    //                 onClicked: {
                    //                     checked ? clearDialog.visible = true : QGroundControl.clearDeleteAllSettingsNextBoot()
                    //                 }
                    //                 MessageDialog {
                    //                     id:                 clearDialog
                    //                     visible:            false
                    //                     icon:               StandardIcon.Warning
                    //                     standardButtons:    StandardButton.Yes | StandardButton.No
                    //                     title:              qsTr("Clear Settings")
                    //                     text:               qsTr("All saved settings will be reset the next time you start %1. Is this really what you want?").arg(QGroundControl.appName)
                    //                     onYes: {
                    //                         QGroundControl.deleteAllSettingsNextBoot()
                    //                         clearDialog.visible = false
                    //                     }
                    //                     onNo: {
                    //                         clearCheck.checked  = false
                    //                         clearDialog.visible = false
                    //                     }
                    //                 }
                    //             }

                    //             // Check box to show/hide Remote ID submenu in App settings
                    //             FactCheckBox {
                    //                 text:       qsTr("Enable Remote ID")
                    //                 fact:       _remoteIDEnable
                    //                 visible:    _remoteIDEnable.visible
                    //                 property Fact _remoteIDEnable: QGroundControl.settingsManager.remoteIDSettings.enable
                    //             }
                    //         }
                    //     }

                    //     RowLayout {
                    //         id:                 pathRow
                    //         anchors.margins:    _margins
                    //         anchors.left:       parent.left
                    //         anchors.right:      parent.right
                    //         anchors.top:        miscColItem.bottom
                    //         visible:            _savePath.visible && !ScreenTools.isMobile

                    //         QGCLabel { text: qsTr("Application Load/Save Path") }
                    //         QGCTextField {
                    //             Layout.fillWidth:   true
                    //             readOnly:           true
                    //             text:               _savePath.rawValue === "" ? qsTr("<not set>") : _savePath.value
                    //         }
                    //         QGCButton {
                    //             text:       qsTr("Browse")
                    //             onClicked:  savePathBrowseDialog.openForLoad()
                    //             QGCFileDialog {
                    //                 id:             savePathBrowseDialog
                    //                 title:          qsTr("Choose the location to save/load files")
                    //                 folder:         _savePath.rawValue
                    //                 selectExisting: true
                    //                 selectFolder:   true
                    //                 onAcceptedForLoad: _savePath.rawValue = file
                    //             }
                    //         }
                    //     }
                    // }

                   
                } // settingsColumn
            }
    }
}
