/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtLocation                   5.3
import QtPositioning                5.3
import QtQuick.Dialogs              1.2

import QGroundControl               1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

FlightMap {
    id:                         _root
    allowGCSLocationCenter:     true
    allowVehicleLocationCenter: !_keepVehicleCentered
    planView:                   false
    zoomLevel:                  QGroundControl.flightMapZoom
    center:                     QGroundControl.flightMapPosition

    property Item pipState: _pipState
    QGCPipState {
        id:         _pipState
        pipOverlay: _pipOverlay
        isDark:     _isFullWindowItemDark
    }

    property var    rightPanelWidth
    property var    planMasterController
    property bool   pipMode:                    false   // true: map is shown in a small pip mode
    property var    toolInsets                          // Insets for the center viewport area

    property var    _activeVehicle:             QGroundControl.multiVehicleManager.activeVehicle
    property var    _planMasterController:      planMasterController
    property var    _geoFenceController:        planMasterController.geoFenceController
    property var    _rallyPointController:      planMasterController.rallyPointController
    property var    _activeVehicleCoordinate:   _activeVehicle ? _activeVehicle.coordinate : QtPositioning.coordinate()
    property real   _toolButtonTopMargin:       parent.height - mainWindow.height + (ScreenTools.defaultFontPixelHeight / 2)
    property real   _toolsMargin:               ScreenTools.defaultFontPixelWidth * 0.75
    property bool   _airspaceEnabled:           QGroundControl.airmapSupported ? (QGroundControl.settingsManager.airMapSettings.enableAirMap.rawValue && QGroundControl.airspaceManager.connected): false
    property var    _flyViewSettings:           QGroundControl.settingsManager.flyViewSettings
    property bool   _keepMapCenteredOnVehicle:  _flyViewSettings.keepMapCenteredOnVehicle.rawValue

    property bool   _disableVehicleTracking:    false
    property bool   _keepVehicleCentered:       pipMode ? true : false
    property bool   _saveZoomLevelSetting:      true

    property double ais_lat :  _activeVehicle.getFactGroup("krisoAIS").getFact("lat").value
    property double ais_lon :  _activeVehicle.getFactGroup("krisoAIS").getFact("lon").value


    function updateAirspace(reset) {
        if(_airspaceEnabled) {
            var coordinateNW = _root.toCoordinate(Qt.point(0,0), false /* clipToViewPort */)
            var coordinateSE = _root.toCoordinate(Qt.point(width,height), false /* clipToViewPort */)
            if(coordinateNW.isValid && coordinateSE.isValid) {
                QGroundControl.airspaceManager.setROI(coordinateNW, coordinateSE, false /*planView*/, reset)
            }
        }
    }

    function _adjustMapZoomForPipMode() {
        _saveZoomLevelSetting = false
        if (pipMode) {
            if (QGroundControl.flightMapZoom > 3) {
                zoomLevel = QGroundControl.flightMapZoom - 3
            }
        } else {
            zoomLevel = QGroundControl.flightMapZoom
        }
        _saveZoomLevelSetting = true
    }

    onPipModeChanged: _adjustMapZoomForPipMode()

    onVisibleChanged: {
        if (visible) {
            // Synchronize center position with Plan View
            center = QGroundControl.flightMapPosition
        }
    }

    onZoomLevelChanged: {
        if (_saveZoomLevelSetting) {
            QGroundControl.flightMapZoom = zoomLevel
            updateAirspace(false)
        }
    }
    onCenterChanged: {
        QGroundControl.flightMapPosition = center
        updateAirspace(false)
    }

    on_AirspaceEnabledChanged: {
        updateAirspace(true)
    }

    // We track whether the user has panned or not to correctly handle automatic map positioning
    Connections {
        target: gesture

        function onPanStarted() {       _disableVehicleTracking = true }
        function onFlickStarted() {     _disableVehicleTracking = true }
        function onPanFinished() {      panRecenterTimer.restart() }
        function onFlickFinished() {    panRecenterTimer.restart() }
    }

    function pointInRect(point, rect) {
        return point.x > rect.x &&
                point.x < rect.x + rect.width &&
                point.y > rect.y &&
                point.y < rect.y + rect.height;
    }

    property real _animatedLatitudeStart
    property real _animatedLatitudeStop
    property real _animatedLongitudeStart
    property real _animatedLongitudeStop
    property real animatedLatitude
    property real animatedLongitude

    onAnimatedLatitudeChanged: _root.center = QtPositioning.coordinate(animatedLatitude, animatedLongitude)
    onAnimatedLongitudeChanged: _root.center = QtPositioning.coordinate(animatedLatitude, animatedLongitude)

    NumberAnimation on animatedLatitude { id: animateLat; from: _animatedLatitudeStart; to: _animatedLatitudeStop; duration: 1000 }
    NumberAnimation on animatedLongitude { id: animateLong; from: _animatedLongitudeStart; to: _animatedLongitudeStop; duration: 1000 }

    function animatedMapRecenter(fromCoord, toCoord) {
        _animatedLatitudeStart = fromCoord.latitude
        _animatedLongitudeStart = fromCoord.longitude
        _animatedLatitudeStop = toCoord.latitude
        _animatedLongitudeStop = toCoord.longitude
        animateLat.start()
        animateLong.start()
    }

    function _insetRect() {
        return Qt.rect(toolInsets.leftEdgeCenterInset,
                       toolInsets.topEdgeCenterInset,
                       _root.width - toolInsets.leftEdgeCenterInset - toolInsets.rightEdgeCenterInset,
                       _root.height - toolInsets.topEdgeCenterInset - toolInsets.bottomEdgeCenterInset)
    }

    function recenterNeeded() {
        var vehiclePoint = _root.fromCoordinate(_activeVehicleCoordinate, false /* clipToViewport */)
        var insetRect = _insetRect()
        return !pointInRect(vehiclePoint, insetRect)
    }

    function updateMapToVehiclePosition() {
        if (animateLat.running || animateLong.running) {
            return
        }
        // We let FlightMap handle first vehicle position
        if (!_keepMapCenteredOnVehicle && firstVehiclePositionReceived && _activeVehicleCoordinate.isValid && !_disableVehicleTracking) {
            if (_keepVehicleCentered) {
                _root.center = _activeVehicleCoordinate
            } else {
                if (firstVehiclePositionReceived && recenterNeeded()) {
                    // Move the map such that the vehicle is centered within the inset area
                    var vehiclePoint = _root.fromCoordinate(_activeVehicleCoordinate, false /* clipToViewport */)
                    var insetRect = _insetRect()
                    var centerInsetPoint = Qt.point(insetRect.x + insetRect.width / 2, insetRect.y + insetRect.height / 2)
                    var centerOffset = Qt.point((_root.width / 2) - centerInsetPoint.x, (_root.height / 2) - centerInsetPoint.y)
                    var vehicleOffsetPoint = Qt.point(vehiclePoint.x + centerOffset.x, vehiclePoint.y + centerOffset.y)
                    var vehicleOffsetCoord = _root.toCoordinate(vehicleOffsetPoint, false /* clipToViewport */)
                    animatedMapRecenter(_root.center, vehicleOffsetCoord)
                }
            }
        }
    }

    on_ActiveVehicleCoordinateChanged: {
        if (_keepMapCenteredOnVehicle && _activeVehicleCoordinate.isValid && !_disableVehicleTracking) {
            _root.center = _activeVehicleCoordinate
        }
    }

    Timer {
        id:         panRecenterTimer
        interval:   10000
        running:    false
        onTriggered: {
            _disableVehicleTracking = false
            updateMapToVehiclePosition()
        }
    }

    Timer {
        interval:       500
        running:        true
        repeat:         true
        onTriggered:    updateMapToVehiclePosition()
    }

    QGCMapPalette { id: mapPal; lightColors: isSatelliteMap }

    Connections {
        target:                 _missionController
        ignoreUnknownSignals:   true
        function onNewItemsFromVehicle() {
            var visualItems = _missionController.visualItems
            if (visualItems && visualItems.count !== 1) {
                mapFitFunctions.fitMapViewportToMissionItems()
                firstVehiclePositionReceived = true
            }
        }
    }

    MapFitFunctions {
        id:                         mapFitFunctions // The name for this id cannot be changed without breaking references outside of this code. Beware!
        map:                        _root
        usePlannedHomePosition:     false
        planMasterController:       _planMasterController
    }

    ObstacleDistanceOverlayMap {
        id: obstacleDistance
        showText: !pipMode
    }

    // Add trajectory lines to the map
    MapPolyline {
        id:         trajectoryPolyline
        line.width: 3
        line.color: {
            if (_activeVehicle) {
                switch (_activeVehicle.kriso.nav_mode.value) {
                    case 1.0: return "red";
                    case 2.0: return "orange";
                    case 3.0: return "blue";
                    default: return "yellow";
                }
            }
            return "yellow";
        }
        z:          QGroundControl.zOrderTrajectoryLines
        visible:    _activeVehicle? _activeVehicle.trajectoryVisible : false

        Connections {
            target:                 QGroundControl.multiVehicleManager
            function onActiveVehicleChanged(activeVehicle) {
                trajectoryPolyline.path = _activeVehicle ? _activeVehicle.trajectoryPoints.list() : []
            }
        }

        Connections {
            target:                 _activeVehicle ? _activeVehicle.trajectoryPoints : null
            onPointAdded:           trajectoryPolyline.addCoordinate(coordinate)
            onUpdateLastPoint:      trajectoryPolyline.replaceCoordinate(trajectoryPolyline.pathLength() - 1, coordinate)
            onPointsCleared:        trajectoryPolyline.path = []
        }
    }

    // SOS Custom Map item
    // MapItemView {
    //     model: QGroundControl.multiVehicleManager.vehicles
    //     delegate: SosMapItem {
    //         vehicle:        object
    //         coordinate:     QtPositioning.coordinate(ais_lat, ais_lon)
    //         map:            _root
    //         size:           pipMode ? ScreenTools.defaultFontPixelHeight : ScreenTools.defaultFontPixelHeight * 3
    //         z:              QGroundControl.zOrderVehicles
    //     }
    // }


    // MapItemView {
    //     model: _activeVehicle ? _activeVehicle.aisCoordinateList : 0 
    //     delegate: MapQuickItem {
    //         id: itemIndicator
    //         coordinate: object.coordinate
    //         z: QGroundControl.zOrderMapItems
    //         sourceItem: Item {
    //             width: 30
    //             height: 30
    //             Rectangle {
    //                 width: parent.width
    //                 height: parent.height
    //                 color: "red"
    //                 rotation: 45 // 45도 회전하여 삼각형 모양을 만듭니다.
    //                 anchors.centerIn: parent
    //                 Text {
    //                     text:(isNaN(parseFloat(object.coordinate.altitude)) ? "0" : parseFloat(object.coordinate.altitude).toFixed(0))
    //                     color: "white"
    //                     font.pixelSize: 15
    //                     font.bold: true 
    //                     anchors.centerIn: parent
    //                 }
    //             }
    //         }
    //     }
    // }

    MapItemView {
        model: _activeVehicle ? _activeVehicle.tidalRangeList : 0 
        delegate: MapQuickItem {
            id: itemIndicator
            coordinate: object.coordinate
            z: QGroundControl.zOrderMapItems
            sourceItem: Item {
                width: 30
                height: 30
                Image {
                    id: obstacle
                    source: "/InstrumentValueIcons/flag.svg"
                    width: parent.width
                    height: parent.height
                }
                ColorOverlay {
                    anchors.fill:       obstacle
                    source:             obstacle
                    color:              "#33ff33"
                }
                // Text {
                //     text: "jaeeun test"
                //     color: "red"
                //     font.pixelSize: 10
                //     anchors.top: obstacle.bottom
                //     anchors.horizontalCenter: obstacle.horizontalCenter
                // }
            }
        }
    }

    MapItemView {
        id : obstacleItem
        model: _activeVehicle ? _activeVehicle.aisCoordinateList : 0 
        delegate: MapQuickItem {
            id: itemIndicator
            coordinate: object.coordinate
            z: QGroundControl.zOrderMapItems
            sourceItem: Item {
                width: 30
                height: 30
                Image {
                    id: obstacle
                    source: "/qmlimages/sos.svg" 
                    width: parent.width
                    height: parent.height
                }
                Text {
                    text: (isNaN(parseFloat(object.coordinate.altitude)) ? "0" : parseFloat(object.coordinate.altitude).toFixed(0))
                    color: "red"
                    font.pixelSize: 10
                    anchors.top: obstacle.bottom
                    anchors.horizontalCenter: obstacle.horizontalCenter
                }

                Item {
                    id: lineItem
                    width: 5 
                    height: obstacle.height 
                    anchors.bottom: obstacle.top
                    anchors.horizontalCenter: obstacle.horizontalCenter

                    Rectangle {
                        width: lineItem.width * 0.4
                        height: lineItem.height
                        color: "red" 
                        transform: Rotation {
                            origin.x: lineItem.width / 2
                            origin.y: lineItem.height / 2
                            angle: 0  // 회전각 (선수각) 표기 
                        }
                    }
                } 
            }
        }
    }

  


    // Add the vehicles to the map
    MapItemView {
        model: QGroundControl.multiVehicleManager.vehicles
        delegate: VehicleMapItem {
            vehicle:        object
            coordinate:     object.coordinate
            map:            _root
            size:           pipMode ? ScreenTools.defaultFontPixelHeight : ScreenTools.defaultFontPixelHeight * 3
            z:              QGroundControl.zOrderVehicles
        }
    }
    // Add distance sensor view
    MapItemView{
        model: QGroundControl.multiVehicleManager.vehicles
        delegate: ProximityRadarMapView {
            vehicle:        object
            coordinate:     object.coordinate
            map:            _root
            z:              QGroundControl.zOrderVehicles
        }
    }
    // Add ADSB vehicles to the map
    MapItemView {
        model: QGroundControl.adsbVehicleManager.adsbVehicles
        delegate: VehicleMapItem {
            coordinate:     object.coordinate
            altitude:       object.altitude
            callsign:       object.callsign
            heading:        object.heading
            alert:          object.alert
            map:            _root
            z:              QGroundControl.zOrderVehicles
        }
    }

    // Test
    // Rectangle{
    //     anchors.centerIn: parent
    //     color: 'green'
    //     width: 200
    //     height: 300
    //     z:              QGroundControl.zOrderMapItems
    // }

    // MapRectangle {
    //     color: 'green'
    //     border.width: 2
    //     topLeft {
    //         latitude: 37.4854173
    //         longitude: 126.9683638
    //     }
    //     bottomRight {
    //         latitude: 37.4840061
    //         longitude: 126.9704662
    //     }
    // }
    
    // Canvas {
    //     id: canvas
    //     anchors.fill: parent
    //     onPaint: {
    //         var ctx = getContext("2d");
    //         ctx.reset();

    //         var centerCoordinate = QtPositioning.coordinate(37.4854173, 126.9683638);
    //         var radiusPointCoordinate = QtPositioning.coordinate(37.4863173, 126.9683638);/* Some code to calculate the coordinate 10m away from centerCoordinate */

    //         var center = _root.fromCoordinate(centerCoordinate);
    //         var radiusPoint = _root.fromCoordinate(radiusPointCoordinate);
            
    //         var dx = center.x - radiusPoint.x;
    //         var dy = center.y - radiusPoint.y;
    //         var radius = Math.sqrt(dx * dx + dy * dy); // calculate Euclidean distance

    //         ctx.beginPath();

    //         var startAngle = Math.PI * 1.5;
    //         var endAngle = Math.PI * 5/4;

    //         ctx.arc(center.x, center.y, radius, startAngle, endAngle, true);
    //         ctx.lineTo(center.x, center.y); 
    //         ctx.fillStyle = 'rgba(255, 0, 0, 0.5)';
    //         ctx.fill();
    //     }

    //     Connections {
    //         target: _root
    //         onCenterChanged: canvas.requestPaint();
    //         onZoomLevelChanged: canvas.requestPaint();
    //     }
    // }

    // Add the items associated with each vehicles flight plan to the map
    Repeater {
        model: _activeVehicle.planPathVisible? QGroundControl.multiVehicleManager.vehicles : null

        PlanMapItems {
            map:                    _root
            largeMapView:           !pipMode
            planMasterController:   masterController
            vehicle:                _vehicle

            property var _vehicle: object

            PlanMasterController {
                id: masterController
                Component.onCompleted: startStaticActiveVehicle(object)
            }
        }
    }

    MapItemView {
        model: pipMode ? undefined : _missionController.directionArrows

        delegate: MapLineArrow {
            visible:        _activeVehicle.planPathVisible 
            fromCoord:      object ? object.coordinate1 : undefined
            toCoord:        object ? object.coordinate2 : undefined
            arrowPosition:  2
            z:              QGroundControl.zOrderWaypointLines
        }
    }

    // Allow custom builds to add map items
    CustomMapItems {
        map:            _root
        largeMapView:   !pipMode
    }

    GeoFenceMapVisuals {
        id :                    geoFenceMapVisuals
        map:                    _root
        myGeoFenceController:   _geoFenceController
        interactive:            _activeVehicle.fixedDPCoordinateEnabled
        planView:               true
        homePosition:           _activeVehicle && _activeVehicle.homePosition.isValid ? _activeVehicle.homePosition :  QtPositioning.coordinate()
    }

    // Rally points on map
    MapItemView {
        model: _rallyPointController.points

        delegate: MapQuickItem {
            id:             itemIndicator
            anchorPoint.x:  sourceItem.anchorPointX
            anchorPoint.y:  sourceItem.anchorPointY
            coordinate:     object.coordinate
            z:              QGroundControl.zOrderMapItems

            sourceItem: MissionItemIndexLabel {
                id:         itemIndexLabel
                label:      qsTr("R", "rally point map item label")
            }
        }
    }

    // Camera trigger points
    MapItemView {
        model: _activeVehicle ? _activeVehicle.cameraTriggerPoints : 0

        delegate: CameraTriggerIndicator {
            coordinate:     object.coordinate
            z:              QGroundControl.zOrderTopMost
        }
    }

    // GoTo Location visuals
    MapQuickItem {
        id:             gotoLocationItem
        visible:        false
        z:              QGroundControl.zOrderMapItems
        anchorPoint.x:  sourceItem.anchorPointX
        anchorPoint.y:  sourceItem.anchorPointY
        sourceItem: MissionItemIndexLabel {
            checked:    true
            index:      -1
            label:      qsTr("DP here", "Go to location waypoint")
        }

        property bool inGotoFlightMode: _activeVehicle ? _activeVehicle.flightMode === _activeVehicle.gotoFlightMode : false

        onInGotoFlightModeChanged: {
            if (!inGotoFlightMode && gotoLocationItem.visible) {
                // Hide goto indicator when vehicle falls out of guided mode
                gotoLocationItem.visible = false
            }
        }

        Connections {
            target: QGroundControl.multiVehicleManager
            function onActiveVehicleChanged(activeVehicle) {
                if (!activeVehicle) {
                    gotoLocationItem.visible = false
                }
            }
        }

        Connections {
            target: _activeVehicle
            onIsKrisoDPClickableLayerChanged: {
                if (_activeVehicle.isKrisoDPClickableLayer) {
                    gotoLocationItem.visible = false
                }
            }
        }


        function show(coord) {
            gotoLocationItem.coordinate = coord
            gotoLocationItem.visible = true
        }

        function hide() {
            gotoLocationItem.visible = false
        }

        function actionConfirmed() {
            // We leave the indicator visible. The handling for onInGuidedModeChanged will hide it.
        }

        function actionCancelled() {
            hide()
        }
    }

    // Orbit editing visuals
    QGCMapCircleVisuals {
        id:             orbitMapCircle
        mapControl:     parent
        mapCircle:      _mapCircle
        visible:        false

        property alias center:              _mapCircle.center
        property alias clockwiseRotation:   _mapCircle.clockwiseRotation
        readonly property real defaultRadius: 30

        Connections {
            target: QGroundControl.multiVehicleManager
            function onActiveVehicleChanged(activeVehicle) {
                if (!activeVehicle) {
                    orbitMapCircle.visible = false
                }
            }
        }

        function show(coord) {
            _mapCircle.radius.rawValue = defaultRadius
            orbitMapCircle.center = coord
            orbitMapCircle.visible = true
        }

        function hide() {
            orbitMapCircle.visible = false
        }

        function actionConfirmed() {
            // Live orbit status is handled by telemetry so we hide here and telemetry will show again.
            hide()
        }

        function actionCancelled() {
            hide()
        }

        function radius() {
            return _mapCircle.radius.rawValue
        }

        Component.onCompleted: globals.guidedControllerFlyView.orbitMapCircle = orbitMapCircle

        QGCMapCircle {
            id:                 _mapCircle
            interactive:        true
            radius.rawValue:    30
            showRotation:       true
            clockwiseRotation:  true
        }
    }

    // ROI Location visuals
    MapQuickItem {
        id:             roiLocationItem
        visible:        _activeVehicle && _activeVehicle.isROIEnabled
        z:              QGroundControl.zOrderMapItems
        anchorPoint.x:  sourceItem.anchorPointX
        anchorPoint.y:  sourceItem.anchorPointY
        sourceItem: MissionItemIndexLabel {
            checked:    true
            index:      -1
            label:      qsTr("ROI here", "Make this a Region Of Interest")
        }

        //-- Visibilty controlled by actual state
        function show(coord) {
            roiLocationItem.coordinate = coord
        }

        function hide() {
        }

        function actionConfirmed() {
        }

        function actionCancelled() {
        }
    }

    // Orbit telemetry visuals
    QGCMapCircleVisuals {
        id:             orbitTelemetryCircle
        mapControl:     parent
        mapCircle:      _activeVehicle ? _activeVehicle.orbitMapCircle : null
        visible:        _activeVehicle ? _activeVehicle.orbitActive : false
    }

    MapQuickItem {
        id:             orbitCenterIndicator
        anchorPoint.x:  sourceItem.anchorPointX
        anchorPoint.y:  sourceItem.anchorPointY
        coordinate:     _activeVehicle ? _activeVehicle.orbitMapCircle.center : QtPositioning.coordinate()
        visible:        orbitTelemetryCircle.visible

        sourceItem: MissionItemIndexLabel {
            checked:    true
            index:      -1
            label:      qsTr("Orbit", "Orbit waypoint")
        }
    }

    // Handle guided mode clicks
    MouseArea {
        anchors.fill: parent

        QGCMenu {
            id: clickMenu
            property var coord
            QGCMenuItem {
                text:           qsTr("Go to location")
                visible:        globals.guidedControllerFlyView.showGotoLocation 

                onTriggered: {
                    gotoLocationItem.show(clickMenu.coord)
                    globals.guidedControllerFlyView.confirmAction(globals.guidedControllerFlyView.actionGoto, clickMenu.coord, gotoLocationItem)
                    // _activeVehicle.kriso_dpClickedLocation(clickMenu.coord);
                }
            }
            QGCMenuItem {
                text:           qsTr("Orbit at location")
                visible:        false
                // visible:        globals.guidedControllerFlyView.showOrbit

                onTriggered: {
                    orbitMapCircle.show(clickMenu.coord)
                    globals.guidedControllerFlyView.confirmAction(globals.guidedControllerFlyView.actionOrbit, clickMenu.coord, orbitMapCircle)
                }
            }
            QGCMenuItem {
                text:           qsTr("ROI at location")
                visible:        false
                // visible:        globals.guidedControllerFlyView.showROI

                onTriggered: {
                    roiLocationItem.show(clickMenu.coord)
                    globals.guidedControllerFlyView.confirmAction(globals.guidedControllerFlyView.actionROI, clickMenu.coord, roiLocationItem)
                }
            }
        }
        onClicked: {
            var clickCoord = _root.toCoordinate(Qt.point(mouse.x, mouse.y), false /* clipToViewPort */);
            clickMenu.coord = clickCoord;

            if (_activeVehicle && !globals.guidedControllerFlyView.guidedUIVisible) {
                if (_activeVehicle.fixedDPCoordinateEnabled) {
                    gotoLocationItem.show(clickMenu.coord);
                    _activeVehicle.kriso_dpClickedLocation(clickMenu.coord);

                    // 선택한 좌표를 중심으로 반지름 30m인 원을 그리기
                    var radius = 30; // 반지름 30m

                    var rect = Qt.rect(mouse.x - radius, mouse.y - radius, radius * 2, radius * 2);
                    var topLeftCoord = _root.toCoordinate(Qt.point(rect.x, rect.y), false /* clipToViewPort */);
                    var bottomRightCoord = _root.toCoordinate(Qt.point(rect.x + rect.width, rect.y + rect.height), false /* clipToViewPort */);

    
                    _geoFenceController.updateCircle(topLeftCoord, bottomRightCoord);
                    
                } else if (_activeVehicle.krisoTidalEnabled) {
                    _activeVehicle.insertKrisoTidalRange(clickMenu.coord);
                }
            }
        }
    }

    // Airspace overlap support
    MapItemView {
        model:              _airspaceEnabled && QGroundControl.settingsManager.airMapSettings.enableAirspace && QGroundControl.airspaceManager.airspaceVisible ? QGroundControl.airspaceManager.airspaces.circles : []
        delegate: MapCircle {
            center:         object.center
            radius:         object.radius
            color:          object.color
            border.color:   object.lineColor
            border.width:   object.lineWidth
        }
    }

    MapItemView {
        model:              _airspaceEnabled && QGroundControl.settingsManager.airMapSettings.enableAirspace && QGroundControl.airspaceManager.airspaceVisible ? QGroundControl.airspaceManager.airspaces.polygons : []
        delegate: MapPolygon {
            path:           object.polygon
            color:          object.color
            border.color:   object.lineColor
            border.width:   object.lineWidth
        }
    }

    MapScale {
        id:                 mapScale
        anchors.margins:    _toolsMargin
        anchors.left:       parent.left
        anchors.top:        parent.top
        mapControl:         _root
        buttonsOnLeft:      false
        visible:            !ScreenTools.isTinyScreen && QGroundControl.corePlugin.options.flyView.showMapScale && mapControl.pipState.state === mapControl.pipState.windowState

        property real centerInset: visible ? parent.height - y : 0
    }

}
