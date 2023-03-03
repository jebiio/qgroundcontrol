/*************************************************************************
 *
 * Copyright (c) 2013-2019, Klaralvdalens Datakonsult AB (KDAB)
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

import QtQuick 2.0
import QGroundControl 1.0
import QGroundControl.Controls      1.0
import QtQuick.Layouts              1.11

Rectangle {
    radius:     _radius
    color: "#595959"
    implicitHeight: txt.implicitHeight + 10
    width : parent.width

    property bool flag : true
    property alias text: txt.text
    property real _padding: ScreenTools.comboBoxPadding

    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: { 
            parent.clicked()
            if(!flag){
                colapseImg.source = "/res/colapse.svg"
                flag = true
            }else{
                colapseImg.source = "/res/expand.svg"
                flag = false
            }
            
        }
    }

    RowLayout {
        id:                     innerLayout
        anchors.fill : parent
        anchors.verticalCenter: parent.verticalCenter
        spacing:                _padding        

        QGCLabel { 
            id : txt
            font.pixelSize: 16
            color: "white" 
        }

        QGCColoredImage {
            id : colapseImg
            anchors.margins: 10 
            anchors.right:      parent.right
            height:             parent.height * 0.8
            width:              parent.height * 0.8
            fillMode:           Image.PreserveAspectFit
            smooth:             true
            antialiasing:       true
            color:              qgcPal.text
            source:             "/res/expand.svg"
            visible: true
        }    
    }
}
