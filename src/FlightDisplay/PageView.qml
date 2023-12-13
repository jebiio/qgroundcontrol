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
    // color: "white"
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

            Text{
                text : _krisoFactName
                color: "white"
                font.pointSize: 10
                anchors.centerIn: parent
            }
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
            // visible:                true
            // visible:                (_krisoFactName != "KrisoVoltage") ? true : false
            visible:                pageWidgetLoader.item ? (pageWidgetLoader.item.showSettingsIcon ? pageWidgetLoader.item.showSettingsIcon : false) : false

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



}
