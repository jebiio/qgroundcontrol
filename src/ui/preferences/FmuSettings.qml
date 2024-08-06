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
                                QGCTextField {
                                    id: trainPathField
                                    text: "path/to/train"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("valid path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: validPathField
                                    text: "path/to/valid"
                                    Layout.fillWidth: true
                                }

                                QGCLabel {
                                    text:       qsTr("test path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: testPathField
                                    text: "path/to/test"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("result path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: resultPathField
                                    text: "path/to/result"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("seed")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: seedField
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("model")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField{
                                    id: modelField
                                    text: "model"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("selective method")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: selectiveField
                                    text: "selective"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("var_to_forecast")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField{
                                    id: varField
                                    text: "var"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("past windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: pastField
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                
                                QGCLabel {
                                    text:       qsTr("future windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: futureField
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("epoch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: epochField
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("batch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: batchField
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("num_workers")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: numWorkersField
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("lr")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: lrField
                                    text: "0.0"
                                    Layout.fillWidth: true
                                }
                                
                                QGCLabel {
                                    text:       qsTr("weight_decay")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: weightDecayField
                                    text: "0.0"
                                    Layout.fillWidth: true
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
                                QGCTextField {
                                    id: detectionModelField
                                    text: "model"
                                    Layout.fillWidth: true
                                }

                                QGCLabel {
                                    text:       qsTr("model path")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: modelPathField
                                    text: "path/to/model"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("past windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: pastField2
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("future windows size")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: futureField2
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                
                                QGCLabel {
                                    text:       qsTr("epoch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: epochField2
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("batch")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: batchField2
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("num_workers")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: numWorkersField2
                                    text: "0"
                                    Layout.fillWidth: true
                                }
                                QGCLabel {
                                    text:       qsTr("lr")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: lrField2
                                    text: "0.0"
                                    Layout.fillWidth: true
                                }
                                
                                QGCLabel {
                                    text:       qsTr("weight_decay")
                                    visible:    guidedMinAltField.visible
                                }
                                QGCTextField {
                                    id: weightDecayField2
                                    text: "0.0"
                                    Layout.fillWidth: true
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
                            QGCTextField {
                                id: ipField
                                text: "0.0.0.0"
                                Layout.fillWidth: true
                            }

                            QGCLabel {
                                text: qsTr("  Port:")
                                Layout.alignment: Qt.AlignLeft
                            }
                            QGCTextField {
                                id: portField
                                text: "0000"
                                Layout.fillWidth: true
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

                            QGCTextField {
                                id: testField2
                                text: "0000"
                                Layout.column: 1  
                                Layout.fillWidth: true
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
                            QGCTextField {
                                id: hostField3
                                text: "0.0.0.0"
                                Layout.column: 1  
                                Layout.row: 0     
                                Layout.fillWidth: true
                            }

                            
                            QGCLabel {
                                text: qsTr("  TCP Port : ")
                                Layout.column: 0  
                                Layout.row: 1     
                                // Layout.alignment: Qt.AlignLeft
                            }
                            QGCTextField {
                                id: tcpPortField
                                text: "0000"
                                Layout.column: 1  
                                Layout.row: 1     
                                Layout.fillWidth: true
                            }

                            QGCLabel {
                                text: qsTr("  UDP Port : ")
                                Layout.column: 0  
                                Layout.row: 2     
                            }
                            QGCTextField {
                                id: udpPortField
                                text: "0000"
                                Layout.column: 1  
                                Layout.row: 2     
                                Layout.fillWidth: true
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
                                QGCTextField {
                                    // id:                     testField3
                                    text:                   "0000"
                                }
                            }

                        }
                    }


                   
                } // settingsColumn
            }

    }

        QGCButton {
            text: qsTr("SAVE")
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 20
            anchors.rightMargin: 20
            onClicked: {
                console.log("Save button clicked");
            }
        }
}
