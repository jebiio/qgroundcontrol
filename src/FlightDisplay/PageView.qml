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
    color:  qgcPal.window
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

    

    onCurrentPageChanged: {
        switch(currentPage) {
            case 1:
                pageFlickable.visible = true
                page2.visible = false
                break
            case 2:
                pageFlickable.visible = false
                page2.visible = true
                break
            default:
                break
        }
    }

    RowLayout{
        id: pageCombo

        anchors.left:   parent.left
        anchors.right:  parent.right
        width: 25
        height: 25

        Rectangle {
            anchors.fill: parent
            color: "#5688B9"
            z: -1 // 다른 컨텐츠 아래에 배치되도록
        }
        Text{
            text : _krisoFactName
            color: "white"
            font.pointSize: 10
            anchors.centerIn: parent
        }

        QGCColoredImage {
            anchors.rightMargin:     _margins * 5
            anchors.right:           parent.right
            anchors.verticalCenter: parent.verticalCenter
            source:                 "/res/gear-white.svg"
            mipmap:                 true
            height:                 parent.height * 0.7
            width:                  height
            sourceSize.height:      height
            color:                  qgcPal.text
            fillMode:               Image.PreserveAspectFit
            visible:                true
            // visible:                (_krisoFactName != "KrisoVoltage") ? true : false
            // visible:                pageWidgetLoader.item ? (pageWidgetLoader.item.showSettingsIcon ? pageWidgetLoader.item.showSettingsIcon : false) : false

            QGCMouseArea {
                fillItem:   parent
                onClicked:  pageWidgetLoader.item.showSettings()
            }
        }


    }


    // Fact 표기 되는 부분 
    QGCFlickable {
        id:                 pageFlickable
        anchors.margins:    _margins
        anchors.top:        pageCombo.bottom
        anchors.left:       parent.left
        anchors.right:      parent.right
        height:             Math.min(_maxHeight, pageWidgetLoader.height)
        contentHeight:      pageWidgetLoader.height
        flickableDirection: Flickable.VerticalFlick
        clip:               true

        property real _maxHeight: maxHeight - y - _margins

        Loader {
            id:     pageWidgetLoader
            source: _instrumentPages[0].url
            property real pageWidth:  parent.width
        }

    }

    Rectangle {
        id: page2
        anchors.top: pageCombo.bottom
        width: parent.width
        height: _largeColumn.height
        visible: false

        Column {
            id: _largeColumn
            width:      _pageWidth
            spacing:    _margins
            anchors.margins:    _margins
            anchors.top:        pageCombo.bottom
            anchors.left:       parent.left
            anchors.right:      parent.right

            Repeater {
                model : (currentPage == 2) ? _activeVehicle.getFactGroup("krisoVoltage").factNames : 0
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
