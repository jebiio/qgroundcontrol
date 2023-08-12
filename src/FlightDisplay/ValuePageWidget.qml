/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2

import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Palette       1.0
import QGroundControl               1.0

/// Value page for InstrumentPanel PageView
Column {
    id:         _largeColumn
    width:      pageWidth
    spacing:    _margins

    property bool showSettingsIcon: true

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle
    property real   _margins:       ScreenTools.defaultFontPixelWidth / 4

    QGCPalette { id:qgcPal; colorGroupEnabled: true }

    ValuesWidgetController {
        id: controller
    }

    function showSettings() {
        mainWindow.showComponentDialog(propertyPicker, qsTr("Value Widget Setup"), mainWindow.showDialogDefaultWidth, StandardButton.Ok)
    }

    function listContains(list, value) {
        for (var i=0; i<list.length; i++) {
            if (list[i] === value) {
                return true
            }
        }
        return false
    }

    // value panel의 Large값 표시 repeater --> 아래의 (flow, component)component 형태로 qml 구성(호출)
    Repeater {
        model: _activeVehicle ? controller.largeValues : 0
        Loader {
            sourceComponent: fact ? largeValue : undefined
            property Fact fact: _activeVehicle.getFact(modelData.replace("Vehicle.", ""))
        }
    } // Repeater - Large

    // value panel의 Small값 표시 
    // flow : 정해진 크기의 박스안에서 텍스트와 같이 나란히 자동 배치 되는 
    Flow {
        id:                 _smallFlow
        width:              parent.width
        layoutDirection:    Qt.LeftToRight
        spacing:            _margins

        Repeater {
            model: _activeVehicle ? controller.smallValues : 0
            Loader {
                sourceComponent: fact ? smallValue : undefined
                property Fact fact: _activeVehicle.getFact(modelData.replace("Vehicle.", ""))
            }
        } // Repeater - Small
    } // Flow

    // value panel의 Large값 표시 component 
    Component {
        id: largeValue

        Column {
            width:  _largeColumn.width
            property bool largeValue: listContains(controller.altitudeProperties, fact.name)

            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                wrapMode:               Text.WordWrap
                text:                   fact.shortDescription + (fact.units ? " (" + fact.units + ")" : "")
                color:                  "black"
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                font.pointSize:         ScreenTools.mediumFontPointSize * (largeValue ? 1.3 : 1.0)
                font.family:            largeValue ? ScreenTools.demiboldFontFamily : ScreenTools.normalFontFamily
                fontSizeMode:           Text.HorizontalFit
                text:                   fact.enumOrValueString
                color:                  "black"
            }
        }
    }
    
    // value panel의 Small값 표시 component 
    Component {
        id: smallValue

        Column {
            width:  (pageWidth / 2) - (_margins / 2) - 0.1
            clip:   true

            QGCLabel {
                width:                  parent.width
                wrapMode:               Text.WordWrap
                horizontalAlignment:    Text.AlignHCenter
                font.pointSize:         ScreenTools.isTinyScreen ? ScreenTools.smallFontPointSize * 0.75 : ScreenTools.smallFontPointSize
                text:                   fact.shortDescription
                color:                  "black"
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                fontSizeMode:           Text.HorizontalFit
                text:                   fact.enumOrValueString
                color:                  "black"
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                font.pointSize:         ScreenTools.isTinyScreen ? ScreenTools.smallFontPointSize * 0.75 : ScreenTools.smallFontPointSize
                fontSizeMode:           Text.HorizontalFit
                text:                   fact.units
                color:                  "black"
            }
        }
    }
    
    // Selection pop-up Page (PageView.qml --> showSettings()호출시 실행되는 qml) (outer box)
    Component {
        id: propertyPicker

        QGCViewDialog {
            id: _propertyPickerDialog

            QGCFlickable {
                anchors.fill:       parent
                contentHeight:      column.height
                flickableDirection: Flickable.VerticalFlick
                clip:               true

                Column {
                    id:             column
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    spacing:        _margins

                    /*
                      Leaving this here for now just in case
                    FactCheckBox {
                        text:       qsTr("Show large compass")
                        fact:       _showLargeCompass
                        visible:    _showLargeCompass.visible

                        property Fact _showLargeCompass: QGroundControl.settingsManager.appSettings.showLargeCompass
                    }
                    */

                    Item {
                        width:  1
                        height: _margins
                    }

                    QGCLabel {
                        id:     _label
                        anchors.left:   parent.left
                        anchors.right:  parent.right
                        wrapMode:       Text.WordWrap
                        text:   qsTr("Select the values you want to display:")
                    }

                    // Loader {
                    //     anchors.left:       parent.left
                    //     anchors.right:      parent.right
                    //     sourceComponent:    factGroupList

                    //     property var    factGroup:     _activeVehicle
                    //     property string factGroupName: "Vehicle"
                    // }

                    Repeater {
                        model: ["kriso"]
                        Loader {
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            sourceComponent:    factGroupList

                            property var    factGroup:     _activeVehicle.getFactGroup(modelData)
                            property string factGroupName: modelData
                        }

                    }
                }
            }
        }
    }

    // Selection pop-up Page의 데이터가 채워지는 하위 컴포넌트(inner data box역할)  
    Component {
        id: factGroupList

        // You must push in the following properties from the Loader
        // property var factGroup
        // property string factGroupName

        Column {
            spacing:    _margins

            SectionHeader {
                id:             header
                anchors.left:   parent.left
                anchors.right:  parent.right
                text:           factGroupName.charAt(0).toUpperCase() + factGroupName.slice(1)
                checked:        false
            }

            Column {
                spacing:    _margins
                visible:    header.checked

                Repeater {
                    model: factGroup ? factGroup.factNames : 0

                    RowLayout {
                        spacing: _margins
                        visible: factGroup.getFact(modelData).shortDescription !== ""

                        property string propertyName: factGroupName + "." + modelData

                        function removeFromList(list, value) {
                            var newList = []
                            for (var i=0; i<list.length; i++) {
                                if (list[i] !== value) {
                                    newList.push(list[i])
                                }
                            }
                            return newList
                        }

                        function addToList(list, value) {
                            var found = false
                            for (var i=0; i<list.length; i++) {
                                if (list[i] === value) {
                                    found = true
                                    break
                                }
                            }
                            if (!found) {
                                list.push(value)
                            }
                            return list
                        }

                        function updateValues() {
                            if (_addCheckBox.checked) {
                                if (_largeCheckBox.checked) {
                                    controller.largeValues = addToList(controller.largeValues, propertyName)
                                    controller.smallValues = removeFromList(controller.smallValues, propertyName)
                                } else {
                                    controller.smallValues = addToList(controller.smallValues, propertyName)
                                    controller.largeValues = removeFromList(controller.largeValues, propertyName)
                                }
                            } else {
                                controller.largeValues = removeFromList(controller.largeValues, propertyName)
                                controller.smallValues = removeFromList(controller.smallValues, propertyName)
                            }
                        }

                        QGCCheckBox {
                            id:                     _addCheckBox
                            text:                   factGroup.getFact(modelData).shortDescription
                            checked:                listContains(controller.smallValues, propertyName) || _largeCheckBox.checked
                            onClicked:              updateValues()
                            Layout.fillWidth:       true
                            Layout.minimumWidth:    ScreenTools.defaultFontPixelWidth * 20

                            Component.onCompleted: {
                                if (checked) {
                                    header.checked = true
                                }
                            }
                        }

                        QGCCheckBox {
                            id:                     _largeCheckBox
                            text:                   qsTr("Large")
                            checked:                listContains(controller.largeValues, propertyName)
                            enabled:                _addCheckBox.checked
                            onClicked:              updateValues()
                        }
                    }
                }
            }
        }
    }
}
