/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2
import QtPositioning    5.3

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0

ColumnLayout {
    id:         root
    spacing:    ScreenTools.defaultFontPixelWidth * 0.5

    property var    map
    property var    fitFunctions
    property bool   showMission:          true
    property bool   showAllItems:         true
    property bool enableFlagChanged: false

    QGCLabel { text: qsTr("수심가능 영역선택:") }

    QGCButton {
        text:               qsTr("시작점 선택")
        Layout.fillWidth:   true
        visible:            showMission

        onClicked: {
            // dropPanel.hide()
            fitFunctions.fitMapViewportToMissionItems()
            enableFlagChanged = true
        }
    }

    QGCButton {
        text:               qsTr("종료점 선택")
        Layout.fillWidth:   true
        visible:            showAllItems

        onClicked: {
            // dropPanel.hide()
            fitFunctions.fitMapViewportToAllItems()
        }
    }

} // Column
