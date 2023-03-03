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

Rectangle {
    radius:     _radius
    color: "#595959"
    implicitHeight: txt.implicitHeight + 100

    property alias text: txt.text

    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }

    Row {

        Text {
            id: txt
            anchors.left:       parent.left
            anchors.top:        parent.top
            font.pixelSize: 16
            font.bold: true
            }


        QGCColoredImage {
            source:              "/res/TrashDelete.svg"
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
            color:              qgcPal.text
        }
    }
    

}
