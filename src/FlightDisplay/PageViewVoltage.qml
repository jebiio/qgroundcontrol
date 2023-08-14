import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0

Rectangle {
    id:     _root
    height: pageFlickable.y + pageFlickable.height + _margins
    color:  "white"
    radius: ScreenTools.defaultFontPixelWidth * 0.5
    width:  ScreenTools.defaultFontPixelWidth * 45
    anchors.left: parent.left
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    
    property real   maxHeight     : 500  ///< Maximum height that should be taken, smaller than this is ok

    property real   _margins:           ScreenTools.defaultFontPixelWidth / 2
    property real   _pageWidth:         _root.width
    
    property var    _instrumentPages:   QGroundControl.corePlugin.instrumentPages
    property string _krisoFactName: ""
    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle

    property int currentPage: 1 


    QGCPalette { id:qgcPal; colorGroupEnabled: parent.enabled }


    RowLayout{
        id: pageCombo

        anchors.left:   parent.left
        anchors.right:  parent.right
        width: 25
        height: 25

        Rectangle {
            width: parent.width
            Layout.fillHeight: true
            color: "#5688B9"
             // 다른 컨텐츠 아래에 배치되도록
            Text{
                text : _krisoFactName
                color: "white"
                font.pointSize: 10
                anchors.centerIn: parent
            }
        }
    }


    // Fact 표기 되는 부분 


    Rectangle {
        id: page2
        anchors.top: pageCombo.bottom
        width: parent.width
        height: _largeColumn.height

        Column {
            id: _largeColumn
            width:      _pageWidth
            spacing:    _margins
            anchors.margins:    _margins
            anchors.top:        pageCombo.bottom
            anchors.left:       parent.left
            anchors.right:      parent.right

            Repeater {
                model :_activeVehicle.getFactGroup("krisoVoltage").factNames
                // model: _activeVehicle ? controller.largeValueKrisos : 0
                Loader {
                    sourceComponent: fact ? largeValueKriso : undefined
                    property Fact fact: _activeVehicle.getFactGroup("krisoVoltage").getFact(modelData)
                    // property Fact fact: _activeVehicle.getFact(modelData.replace("Vehicle.", ""))
                }
            } 

            Component {
                id: largeValueKriso

                Column {
                    width:  _largeColumn.width
                    property bool largeValueKriso: true

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
                        font.pointSize:         ScreenTools.mediumFontPointSize * (largeValueKriso ? 1.3 : 1.0)
                        font.family:            largeValueKriso ? ScreenTools.demiboldFontFamily : ScreenTools.normalFontFamily
                        fontSizeMode:           Text.HorizontalFit
                        text:                   fact.enumOrValueString
                        color:                  "black"
                    }
                }
            }
        }
    }


}
