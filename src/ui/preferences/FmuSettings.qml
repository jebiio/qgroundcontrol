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
    property var    _trainModeSettings:         QGroundControl.settingsManager.trainModeSettings
    property var    _detectionModeSettings:     QGroundControl.settingsManager.detectionModeSettings
    property var    _fmuSettings:               QGroundControl.settingsManager.fmuSettings
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
                                FactTextField {
                                    id:                     trainPathField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.trainPath
                                }

                                QGCLabel {
                                    text:       qsTr("valid path")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     validPathField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.validPath
                                }

                                QGCLabel {
                                    text:       qsTr("test path")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     testPathField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.testPath
                                }
                                QGCLabel {
                                    text:       qsTr("result path")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     resultPathField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.resultPath
                                }
                                QGCLabel {
                                    text:       qsTr("seed")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     seedField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.seed
                                }
                                QGCLabel {
                                    text:       qsTr("model")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     modelField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.model
                                }
                                QGCLabel {
                                    text:       qsTr("selective method")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     selectiveField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.selectiveMethod
                                }
                                QGCLabel {
                                    text:       qsTr("var_to_forecast")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     varField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.varToForecast
                                }
                                QGCLabel {
                                    text:       qsTr("past windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     pastField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.pastWindowsSize
                                }
                                
                                QGCLabel {
                                    text:       qsTr("future windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     futureField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.futureWindowsSize
                                }
                                QGCLabel {
                                    text:       qsTr("epoch")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     epochField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.epoch
                                }
                                QGCLabel {
                                    text:       qsTr("batch")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     batchField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.batch
                                }
                                QGCLabel {
                                    text:       qsTr("num_workers")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     numWorkersField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.numWorkers
                                }
                                QGCLabel {
                                    text:       qsTr("lr")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     lrField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.lr
                                }
                                
                                QGCLabel {
                                    text:       qsTr("weight_decay")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     weightDecayField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _trainModeSettings.weight
                                }                           
                            }
                            
                            // mode별 저장 버튼 필요시 추가
                            // RowLayout{
                            //     anchors.right: parent.right
                            //     spacing: 10

                            //     QGCButton{
                            //         text: qsTr("SAVE")
                            //         onClicked: {
                            //             console.log("Train mode Save button clicked")
                            //         }
                            //     }
                            // }
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

                                QGCLabel{
                                    text: qsTr("model")
                                    visible: guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionModelField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.model
                                }

                                QGCLabel {
                                    text:       qsTr("model path")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionModelPathField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.modelPath
                                }
                                QGCLabel {
                                    text:       qsTr("past windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionPastField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.pastWindowsSize
                                }
                                QGCLabel {
                                    text:       qsTr("future windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionFutureField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.futureWindowsSize
                                }
                                
                                QGCLabel {
                                    text:       qsTr("epoch")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionEpochField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.epoch
                                }
                                QGCLabel {
                                    text:       qsTr("batch")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionBatchField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.batch
                                }
                                QGCLabel {
                                    text:       qsTr("num_workers")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionNumWorkersField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.numWorkers
                                }
                                QGCLabel {
                                    text:       qsTr("lr")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionLrField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.lr
                                }
                                QGCLabel {
                                    text:       qsTr("weight_decay")
                                    visible:    guidedMinAltField.visible
                                }
                                FactTextField {
                                    id:                     detectionWeightDecayField
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                fact.visible
                                    fact:                   _detectionModeSettings.weightDecay
                                }                      
                            }
                            // mode별 저장 버튼 필요시 추가
                            // RowLayout{
                            //     anchors.right: parent.right
                            //     spacing: 10

                            //     QGCButton{
                            //         text: qsTr("SAVE")
                            //         onClicked: {
                            //             console.log("Detection mode Save button clicked")
                            //         }
                            //     }
                            // }
                        }
                    }
                    Rectangle {
                        height: 40
                        Layout.preferredWidth: 200 
                        Layout.fillWidth: true  
                        color:    "transparent"

                        QGCButton {
                            width: 100  
                            height: 30  
                            text: qsTr("적용")
                            anchors.centerIn: parent  
                            onClicked: {
                                //함수 구현 
                                console.log("Save button clicked");
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: forwarderIPLabel.visible }
                    QGCLabel {
                        id:         forwarderIPLabel
                        text:       qsTr("Forwarder Server IP")
                        visible:    QGroundControl.settingsManager.unitsSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id: unitsGrid
                            columns: 2
                            columnSpacing: 10
                            rowSpacing: 10
                            Layout.fillWidth: true

                            QGCLabel {
                                text: qsTr("  IP:")
                                Layout.alignment: Qt.AlignLeft
                            }
                            FactTextField {
                                id: ipField
                                Layout.fillWidth: true
                                fact: _fmuSettings.forwarderServerIP
                            }

                            QGCLabel {
                                text: qsTr("  Port:")
                                Layout.alignment: Qt.AlignLeft
                            }
                            FactTextField {
                                id: portField
                                Layout.fillWidth: true
                                fact: _fmuSettings.forwarderServerPort
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: forwarderReceivePort.visible }
                    QGCLabel {
                        id:         forwarderReceivePort
                        text:       qsTr("Forwarder Listen Port")
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
                            // anchors.horizontalCenter:   parent.horizontalCenter
                            rows:                       1
                            columns:                    2


                            QGCLabel { 
                                text: qsTr("  Port :") 
                                Layout.column: 0  
                                Layout.alignment: Qt.AlignLeft
                            }
                            FactTextField {
                                id: portField2
                                Layout.column: 1  
                                Layout.fillWidth: true
                                fact: _fmuSettings.forwarderListenPort
                            }          
                        }
                    }

                    Item { width: 1; height: _margins; visible: engineIpTcp.visible }
                    QGCLabel {
                        id:         engineIpTcp
                        text:       qsTr("Engine Server IP")
                        visible:    true
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid3.height + (_margins * 2)
                        Layout.preferredWidth: unitsGrid3.width + (_margins * 2)
                        color: qgcPal.windowShade
                        visible: miscSectionLabel.visible
                        Layout.fillWidth: true

                        GridLayout {
                            id: unitsGrid3
                            anchors.topMargin: _margins
                            anchors.top: parent.top
                            Layout.fillWidth: true
                            // anchors.horizontalCenter: parent.horizontalCenter
                            rows: 3  
                            columns: 2  

                            
                            QGCLabel {
                                text: qsTr("  IP             : ")
                                Layout.column: 0  
                                Layout.row: 0   
                                anchors.leftMargin: 10
                                // Layout.alignment: Qt.AlignLeft
                            }
                            FactTextField {
                                id: hostField
                                Layout.column: 1  
                                Layout.row: 0     
                                Layout.fillWidth: true
                                fact: _fmuSettings.engineServerIP
                            }

                            
                            QGCLabel {
                                text: qsTr("  TCP Port : ")
                                Layout.column: 0  
                                Layout.row: 1     
                                // Layout.alignment: Qt.AlignLeft
                            }
                            FactTextField {
                                id: tcpPortField
                                Layout.column: 1  
                                Layout.row: 1     
                                Layout.fillWidth: true
                                fact: _fmuSettings.engineServerTCPPort
                            }
                            QGCLabel {
                                text: qsTr("  UDP Port : ")
                                Layout.column: 0  
                                Layout.row: 2     
                            }
                            FactTextField {
                                id: udpPortField
                                Layout.column: 1  
                                Layout.row: 2     
                                Layout.fillWidth: true
                                fact: _fmuSettings.engineServerUDPPort
                            }
                        }
                    }



                    Item { width: 1; height: _margins; visible: engineIpUdp.visible }
                    QGCLabel {
                        id:         engineIpUdp
                        text:       qsTr("Engine Listen Port")
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
                            // anchors.horizontalCenter:   parent.horizontalCenter
                            flow:                       GridLayout.TopToBottom
                            columns:                       2

                            RowLayout{
                                QGCLabel { text: qsTr("  Port : ") }
                                FactTextField {
                                    id: udpPortField2
                                    Layout.fillWidth: true
                                    fact: _fmuSettings.engineListenUDPPort
                                }
                            }
                        }
                    }


                   
                } // settingsColumn
            }

    }

        // 전체 파라미터 저장 기능 추가시 주석 해제
        // QGCButton {
        //     text: qsTr("SAVE")
        //     anchors.top: parent.top
        //     anchors.right: parent.right
        //     anchors.topMargin: 20
        //     anchors.rightMargin: 20
        //     onClicked: {
        //         console.log("Save button clicked");
        //     }
        // }
}
