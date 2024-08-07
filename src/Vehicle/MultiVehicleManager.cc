/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "MultiVehicleManager.h"
#include "AutoPilotPlugin.h"
#include "MAVLinkProtocol.h"
#include "UAS.h"
#include "QGCApplication.h"
#include "FollowMe.h"
#include "ParameterManager.h"
#include "SettingsManager.h"
#include "QGCCorePlugin.h"
#include "QGCOptions.h"
#include "LinkManager.h"

#if defined (__ios__) || defined(__android__)
#include "MobileScreenMgr.h"
#endif

#include <QQmlEngine>

QGC_LOGGING_CATEGORY(MultiVehicleManagerLog, "MultiVehicleManagerLog")

const char* MultiVehicleManager::_gcsHeartbeatEnabledKey = "gcsHeartbeatEnabled";
void MultiVehicleManager::printInfo()
{
    qWarning() << "activeVehicle Info: ";
    if(_activeVehicle != nullptr){
        _activeVehicle->printInfo();
    }
    
    qWarning() << "Vehicles Info: "<< _vehicles.count();
    if (_vehicles.count() <1){
        qWarning() << "No vehicles";
        return;

    }
   for (int i=0; i<_vehicles.count(); i++) {
        Vehicle *v = qobject_cast<Vehicle*>(_vehicles[i]);
         v->printInfo();
        //  _vehicles[i].printInfo();
    }    
}

MultiVehicleManager::MultiVehicleManager(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
    , _activeVehicleAvailable(false)
    , _parameterReadyVehicleAvailable(false)
    , _activeVehicle(nullptr)
    , _offlineEditingVehicle(nullptr)
    , _firmwarePluginManager(nullptr)
    , _joystickManager(nullptr)
    , _mavlinkProtocol(nullptr)
    , _gcsHeartbeatEnabled(true)
{
    QSettings settings;
    _gcsHeartbeatEnabled = settings.value(_gcsHeartbeatEnabledKey, true).toBool();
    _gcsHeartbeatTimer.setInterval(_gcsHeartbeatRateMSecs);
    _gcsHeartbeatTimer.setSingleShot(false);
}

void MultiVehicleManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);

    _firmwarePluginManager =     _toolbox->firmwarePluginManager();
    _joystickManager =           _toolbox->joystickManager();
    _mavlinkProtocol =           _toolbox->mavlinkProtocol();
    _forwarderProtocol =         _toolbox->forwarderProtocol();
    _engineProtocol =           _toolbox->engineProtocol();
    
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<MultiVehicleManager>("QGroundControl.MultiVehicleManager", 1, 0, "MultiVehicleManager", "Reference only");

    connect(_mavlinkProtocol, &MAVLinkProtocol::vehicleHeartbeatInfo, this, &MultiVehicleManager::_vehicleHeartbeatInfo);
    connect(_forwarderProtocol, &ForwarderProtocol::vehicleHeartbeatInfo, this, &MultiVehicleManager::_vehicleHeartbeatInfo2);
    connect(&_gcsHeartbeatTimer, &QTimer::timeout, this, &MultiVehicleManager::_sendGCSHeartbeat);
    connect(_engineProtocol, &EngineProtocol::engineHeartbeatInfo, this, &MultiVehicleManager::_engineHeartbeatInfo);
    // connect(_engineProtocol, &ForwarderProtocol::engineMessageReceived, this, &MultiVehicleManager::_engineMessageReceived);
    
    if (_gcsHeartbeatEnabled) {
        _gcsHeartbeatTimer.start();
    }

    _offlineEditingVehicle = new Vehicle(Vehicle::MAV_AUTOPILOT_TRACK, Vehicle::MAV_TYPE_TRACK, _firmwarePluginManager, this);
}
void MultiVehicleManager::_engineHeartbeatInfo(LinkInterface* link, int vehicleId)
{
    qWarning() << "---nsr --- MultiVehicleManager::_engineHeartbeatInfo!!!! ";
    EngineMsg msg = EngineMsg();

    switch(currentEngineMode){
    case (int)EngineMode::TRAIN_MODE:
            // parsing msg
            // if state : handle_msg()
                // UI update :
                // response (UDP)
            handleEngineTrainState(link, msg);
            // qgcApp()->showAppMessage("TRAIN_MODE");
            // link->writeBytesThreadSafe("TRAIN_MODE", 10);
            break;
    case (int)EngineMode::DETECTION_MODE:
            handleEngineDetectionState(link, msg);
            // qgcApp()->showAppMessage("DETECTION_MODE");
            // link->writeBytesThreadSafe("DETECTION_MODE", 10);
            break;
        default:
            break;
    }
}

void MultiVehicleManager::setEngineMode(uint8_t mode)
{
    currentEngineMode = mode;
}

void MultiVehicleManager::handleEngineDetectionState(LinkInterface* link, EngineMsg& msg)
{
    EngineMsg expectedMsg = EngineMsg();
    switch(currentEngineDetectionState)
    {
    case (int)DetectionState::WAIT_FOR_DETECTION_START:
            // qgcApp()->showAppMessage("DETECTION_START");
            // link->writeBytesThreadSafe("DETECTION_START", 10);
            expectedMsg.useVocabulary(Vocabulary::ALARM_DETECTION_START);
            if(msg.compare(expectedMsg))
            {
                currentEngineDetectionState = (uint8_t)DetectionState::WAIT_FOR_DETECTION_ALARM;
                // ToDo : sent to UI for alarm (button text change : start -> stop)
            }
            break;
        case (int)DetectionState::WAIT_FOR_DETECTION_ALARM:
            // ToDo : sent to UI for Detection alarm

            break;
        // case (int)DetectionState::DETECTION_COMPLETE:
        //     // ToDo : sent to UI for alarm
        //     break;
        case (int)DetectionState::SENT_DETECTION_STOP:
            // not defined yet
            break;
    }
}

void MultiVehicleManager::handleEngineTrainState(LinkInterface* link, EngineMsg& msg)
{
    EngineMsg expectedMsg = EngineMsg();
    switch(currentEngineTrainState)
    {
        case (int)TrainState::WAIT_FOR_TRAIN_START:
            // if(msg == STARTCmd())
            expectedMsg.useVocabulary(Vocabulary::ALARM_TRAIN_START);
            if(msg.compare(expectedMsg))
            {
                currentEngineTrainState = (uint8_t)TrainState::WAIT_FOR_TRAIN_PROGRESS;
                // ToDo : sent to UI for alarm (button text change : start -> stop)
            }
            break;
        case (int)TrainState::WAIT_FOR_TRAIN_PROGRESS:
            expectedMsg.useVocabulary(Vocabulary::ALARM_TRAIN_SUCCESS);
            if(msg.compare(expectedMsg))
            {
                currentEngineTrainState = (uint8_t)TrainState::TRAIN_COMPLETE;
                // ToDo : sent to UI for complete alarm
            } else {
                // ToDo : sent to UI for progress 
            }
            break;
        case (int)TrainState::TRAIN_COMPLETE:
            break;
        case (int)TrainState::SENT_TRAIN_STOP:
            break;
        default:
            //not defined msg received in train mode
            break;
    } 
}

void MultiVehicleManager::sentEngineCommand(uint8_t mode, uint8_t cmd)
{
    EngineMsg msg = EngineMsg();
    if(mode == (int)EngineMode::TRAIN_MODE)
    {
        switch(cmd)
        {
            case 1 :// START:
                msg.useVocabulary(Vocabulary::CONTROL_TRAIN_START);
                currentEngineTrainState = (uint8_t)TrainState::WAIT_FOR_TRAIN_START;
                break;
            case 0 : // STOP:
                msg.useVocabulary(Vocabulary::CONTROL_TRAIN_STOP);
                currentEngineTrainState = (uint8_t)TrainState::SENT_TRAIN_STOP;
                break;
        }
    }
    else if(mode == (int)EngineMode::DETECTION_MODE)
    {
        switch(cmd)
        {
            case 1 :// START:
                msg.useVocabulary(Vocabulary::CONTROL_DETECTION_START);
                currentEngineDetectionState = (uint8_t)DetectionState::WAIT_FOR_DETECTION_START;
                break;
            case 0 : // STOP:
                msg.useVocabulary(Vocabulary::CONTROL_DETECTION_STOP);
                //link->write(msg.toBytes());
                currentEngineDetectionState = (uint8_t)DetectionState::SENT_DETECTION_STOP;
                break;
        }
    }
}


void MultiVehicleManager::_vehicleHeartbeatInfo2(LinkInterface* link, int vehicleId)
{
    int default_component_id = 0;
    
    qWarning() << "---nsr --- MultiVehicleManager::_vehicleHeartbeatInfo2!!!! ";

    MAV_AUTOPILOT default_autopilot = MAV_AUTOPILOT_GENERIC;
    MAV_TYPE default_type = MAV_TYPE_GENERIC;

    // already have a vehicle with this id
    if (_ignoreVehicleIds.contains(vehicleId) || getVehicleById(vehicleId) || vehicleId == 0) {
        return;
    }

    Vehicle* vehicle = new Vehicle(link, vehicleId, default_component_id, default_autopilot, default_type, _firmwarePluginManager, _joystickManager);
    connect(vehicle->vehicleLinkManager(),  &VehicleLinkManager::allLinksRemoved,       this, &MultiVehicleManager::_deleteVehiclePhase1);
    
    _vehicles.append(vehicle);

    // Send QGC heartbeat ASAP, this allows PX4 to start accepting commands
    // _sendGCSHeartbeat(); QGC-> PX4로 전송

    qgcApp()->toolbox()->settingsManager()->appSettings()->defaultFirmwareType()->setRawValue(default_autopilot);

    emit vehicleAdded(vehicle);

    if (_vehicles.count() > 1) {
        qgcApp()->showAppMessage(tr("Connected to Vehicle %1").arg(vehicleId));
    } else {
        setActiveVehicle(vehicle);
    }

#if defined (__ios__) || defined(__android__)
    if(_vehicles.count() == 1) {
        //-- Once a vehicle is connected, keep screen from going off
        qCDebug(MultiVehicleManagerLog) << "QAndroidJniObject::keepScreenOn";
        MobileScreenMgr::setKeepScreenOn(true);
    }
#endif
}

void MultiVehicleManager::_vehicleHeartbeatInfo(LinkInterface* link, int vehicleId, int componentId, int vehicleFirmwareType, int vehicleType)
{
    // Special case PX4 Flow since depending on firmware it can have different settings. We force to the PX4 Firmware settings.
    if (link->isPX4Flow()) {
        vehicleId = 81;
        componentId = 50;//MAV_COMP_ID_AUTOPILOT1;
        vehicleFirmwareType = MAV_AUTOPILOT_GENERIC;
        vehicleType = 0;
    }

    if (componentId != MAV_COMP_ID_AUTOPILOT1) {
        // Special case for PX4 Flow
        if (vehicleId != 81 || componentId != 50) {
            // Don't create vehicles for components other than the autopilot
            qCDebug(MultiVehicleManagerLog()) << "Ignoring heartbeat from unknown component port:vehicleId:componentId:fwType:vehicleType"
                                              << link->linkConfiguration()->name()
                                              << vehicleId
                                              << componentId
                                              << vehicleFirmwareType
                                              << vehicleType;
            return;
        }
    }

#if !defined(NO_ARDUPILOT_DIALECT)
    // When you flash a new ArduCopter it does not set a FRAME_CLASS for some reason. This is the only ArduPilot variant which
    // works this way. Because of this the vehicle type is not known at first connection. In order to make QGC work reasonably
    // we assume ArduCopter for this case.
    if (vehicleType == 0 && vehicleFirmwareType == MAV_AUTOPILOT_ARDUPILOTMEGA) {
        vehicleType = MAV_TYPE_QUADROTOR;
    }
#endif

    if (_vehicles.count() > 0 && !qgcApp()->toolbox()->corePlugin()->options()->multiVehicleEnabled()) {
        return;
    }
    if (_ignoreVehicleIds.contains(vehicleId) || getVehicleById(vehicleId) || vehicleId == 0) {
        return;
    }

    switch (vehicleType) {
    case MAV_TYPE_GCS:
    case MAV_TYPE_ONBOARD_CONTROLLER:
    case MAV_TYPE_GIMBAL:
    case MAV_TYPE_ADSB:
        // These are not vehicles, so don't create a vehicle for them
        return;
    default:
        // All other MAV_TYPEs create vehicles
        break;
    }

    qCDebug(MultiVehicleManagerLog()) << "Adding new vehicle link:vehicleId:componentId:vehicleFirmwareType:vehicleType "
                                      << link->linkConfiguration()->name()
                                      << vehicleId
                                      << componentId
                                      << vehicleFirmwareType
                                      << vehicleType;

    if (vehicleId == _mavlinkProtocol->getSystemId()) {
        _app->showAppMessage(tr("Warning: A vehicle is using the same system id as %1: %2").arg(qgcApp()->applicationName()).arg(vehicleId));
    }

    Vehicle* vehicle = new Vehicle(link, vehicleId, componentId, (MAV_AUTOPILOT)vehicleFirmwareType, (MAV_TYPE)vehicleType, _firmwarePluginManager, _joystickManager);
    connect(vehicle,                        &Vehicle::requestProtocolVersion,           this, &MultiVehicleManager::_requestProtocolVersion);
    connect(vehicle->vehicleLinkManager(),  &VehicleLinkManager::allLinksRemoved,       this, &MultiVehicleManager::_deleteVehiclePhase1);
    connect(vehicle->parameterManager(),    &ParameterManager::parametersReadyChanged,  this, &MultiVehicleManager::_vehicleParametersReadyChanged);

    _vehicles.append(vehicle);

    // Send QGC heartbeat ASAP, this allows PX4 to start accepting commands
    _sendGCSHeartbeat();

    qgcApp()->toolbox()->settingsManager()->appSettings()->defaultFirmwareType()->setRawValue(vehicleFirmwareType);

    emit vehicleAdded(vehicle);

    if (_vehicles.count() > 1) {
        qgcApp()->showAppMessage(tr("Connected to Vehicle %1").arg(vehicleId));
    } else {
        setActiveVehicle(vehicle);
    }

#if defined (__ios__) || defined(__android__)
    if(_vehicles.count() == 1) {
        //-- Once a vehicle is connected, keep screen from going off
        qCDebug(MultiVehicleManagerLog) << "QAndroidJniObject::keepScreenOn";
        MobileScreenMgr::setKeepScreenOn(true);
    }
#endif

}

/// This slot is connected to the Vehicle::requestProtocolVersion signal such that the vehicle manager
/// tries to switch MAVLink to v2 if all vehicles support it
void MultiVehicleManager::_requestProtocolVersion(unsigned version)
{
    unsigned maxversion = 0;

    if (_vehicles.count() == 0) {
        _mavlinkProtocol->setVersion(version);
        return;
    }

    for (int i=0; i<_vehicles.count(); i++) {

        Vehicle *v = qobject_cast<Vehicle*>(_vehicles[i]);
        if (v && v->maxProtoVersion() > maxversion) {
            maxversion = v->maxProtoVersion();
        }
    }

    if (_mavlinkProtocol->getCurrentVersion() != maxversion) {
        _mavlinkProtocol->setVersion(maxversion);
    }
}

/// This slot is connected to the Vehicle::allLinksDestroyed signal such that the Vehicle is deleted
/// and all other right things happen when the Vehicle goes away.
void MultiVehicleManager::_deleteVehiclePhase1(Vehicle* vehicle)
{
    qCDebug(MultiVehicleManagerLog) << "_deleteVehiclePhase1" << vehicle;

    _vehiclesBeingDeleted << vehicle;

    // Remove from map
    bool found = false;
    for (int i=0; i<_vehicles.count(); i++) {
        if (_vehicles[i] == vehicle) {
            _vehicles.removeAt(i);
            found = true;
            break;
        }
    }
    if (!found) {
        qWarning() << "Vehicle not found in map!";
    }

    vehicle->uas()->shutdownVehicle();

    // First we must signal that a vehicle is no longer available.
    _activeVehicleAvailable = false;
    _parameterReadyVehicleAvailable = false;
    emit activeVehicleAvailableChanged(false);
    emit parameterReadyVehicleAvailableChanged(false);
    emit vehicleRemoved(vehicle);
    vehicle->prepareDelete();

#if defined (__ios__) || defined(__android__)
    if(_vehicles.count() == 0) {
        //-- Once no vehicles are connected, we no longer need to keep screen from going off
        qCDebug(MultiVehicleManagerLog) << "QAndroidJniObject::restoreScreenOn";
        MobileScreenMgr::setKeepScreenOn(false);
    }
#endif

    // We must let the above signals flow through the system as well as get back to the main loop event queue
    // before we can actually delete the Vehicle. The reason is that Qml may be holding on to references to it.
    // Even though the above signals should unload any Qml which has references, that Qml will not be destroyed
    // until we get back to the main loop. So we set a short timer which will then fire after Qt has finished
    // doing all of its internal nastiness to clean up the Qml. This works for both the normal running case
    // as well as the unit testing case which of course has a different signal flow!
    QTimer::singleShot(20, this, &MultiVehicleManager::_deleteVehiclePhase2);
}

void MultiVehicleManager::_deleteVehiclePhase2(void)
{
    qCDebug(MultiVehicleManagerLog) << "_deleteVehiclePhase2" << _vehiclesBeingDeleted[0];

    /// Qml has been notified of vehicle about to go away and should be disconnected from it by now.
    /// This means we can now clear the active vehicle property and delete the Vehicle for real.

    Vehicle* newActiveVehicle = nullptr;
    if (_vehicles.count()) {
        newActiveVehicle = qobject_cast<Vehicle*>(_vehicles[0]);
    }

    _activeVehicle = newActiveVehicle;
    emit activeVehicleChanged(newActiveVehicle);

    if (_activeVehicle) {
        emit activeVehicleAvailableChanged(true);
        if (_activeVehicle->parameterManager()->parametersReady()) {
            emit parameterReadyVehicleAvailableChanged(true);
        }
    }

    delete _vehiclesBeingDeleted[0];
    _vehiclesBeingDeleted.removeAt(0);
}

void MultiVehicleManager::setActiveVehicle(Vehicle* vehicle)
{
    qCDebug(MultiVehicleManagerLog) << "setActiveVehicle" << vehicle;

    if (vehicle != _activeVehicle) {
        if (_activeVehicle) {
            // The sequence of signals is very important in order to not leave Qml elements connected
            // to a non-existent vehicle.

            // First we must signal that there is no active vehicle available. This will disconnect
            // any existing ui from the currently active vehicle.
            _activeVehicleAvailable = false;
            _parameterReadyVehicleAvailable = false;
            emit activeVehicleAvailableChanged(false);
            emit parameterReadyVehicleAvailableChanged(false);
        }

        // See explanation in _deleteVehiclePhase1
        _vehicleBeingSetActive = vehicle;
        QTimer::singleShot(20, this, &MultiVehicleManager::_setActiveVehiclePhase2);
    }
}

void MultiVehicleManager::_setActiveVehiclePhase2(void)
{
    qCDebug(MultiVehicleManagerLog) << "_setActiveVehiclePhase2 _vehicleBeingSetActive" << _vehicleBeingSetActive;

    //-- Keep track of current vehicle's coordinates
    if(_activeVehicle) {
        disconnect(_activeVehicle, &Vehicle::coordinateChanged, this, &MultiVehicleManager::_coordinateChanged);
    }
    if(_vehicleBeingSetActive) {
        connect(_vehicleBeingSetActive, &Vehicle::coordinateChanged, this, &MultiVehicleManager::_coordinateChanged);
    }

    // Now we signal the new active vehicle
    _activeVehicle = _vehicleBeingSetActive;
    emit activeVehicleChanged(_activeVehicle);

    // And finally vehicle availability
    if (_activeVehicle) {
        _activeVehicleAvailable = true;
        emit activeVehicleAvailableChanged(true);

        if (_activeVehicle->parameterManager()->parametersReady()) {
            _parameterReadyVehicleAvailable = true;
            emit parameterReadyVehicleAvailableChanged(true);
        }
    }
}

void MultiVehicleManager::_coordinateChanged(QGeoCoordinate coordinate)
{
    _lastKnownLocation = coordinate;
    emit lastKnownLocationChanged();
}

void MultiVehicleManager::_vehicleParametersReadyChanged(bool parametersReady)
{
    auto* paramMgr = qobject_cast<ParameterManager*>(sender());

    if (!paramMgr) {
        qWarning() << "Dynamic cast failed!";
        return;
    }

    if (paramMgr->vehicle() == _activeVehicle) {
        _parameterReadyVehicleAvailable = parametersReady;
        emit parameterReadyVehicleAvailableChanged(parametersReady);
    }
}

void MultiVehicleManager::saveSetting(const QString &name, const QString& value)
{
    QSettings settings;
    settings.setValue(name, value);
}

QString MultiVehicleManager::loadSetting(const QString &name, const QString& defaultValue)
{
    QSettings settings;
    return settings.value(name, defaultValue).toString();
}

Vehicle* MultiVehicleManager::getVehicleById(int vehicleId)
{
    for (int i=0; i< _vehicles.count(); i++) {
        Vehicle* vehicle = qobject_cast<Vehicle*>(_vehicles[i]);
        if (vehicle->id() == vehicleId) {
            return vehicle;
        }
    }

    return nullptr;
}

void MultiVehicleManager::setGcsHeartbeatEnabled(bool gcsHeartBeatEnabled)
{
    if (gcsHeartBeatEnabled != _gcsHeartbeatEnabled) {
        _gcsHeartbeatEnabled = gcsHeartBeatEnabled;
        emit gcsHeartBeatEnabledChanged(gcsHeartBeatEnabled);

        QSettings settings;
        settings.setValue(_gcsHeartbeatEnabledKey, gcsHeartBeatEnabled);

        if (gcsHeartBeatEnabled) {
            _gcsHeartbeatTimer.start();
        } else {
            _gcsHeartbeatTimer.stop();
        }
    }
}

void MultiVehicleManager::_sendGCSHeartbeat(void)
{
    LinkManager*                    linkManager = qgcApp()->toolbox()->linkManager();
    QList<SharedLinkInterfacePtr>   sharedLinks = linkManager->links();

    // Send a heartbeat out on each link
    for (int i=0; i<sharedLinks.count(); i++) {
        LinkInterface* link = sharedLinks[i].get();
        auto linkConfiguration = link->linkConfiguration();
        if (link->isConnected() && linkConfiguration && !linkConfiguration->isHighLatency()) {
            mavlink_message_t message;
            mavlink_msg_heartbeat_pack_chan(_mavlinkProtocol->getSystemId(),
                                            _mavlinkProtocol->getComponentId(),
                                            link->mavlinkChannel(),
                                            &message,
                                            MAV_TYPE_GCS,            // MAV_TYPE
                                            MAV_AUTOPILOT_INVALID,   // MAV_AUTOPILOT
                                            MAV_MODE_MANUAL_ARMED,   // MAV_MODE
                                            0,                       // custom mode
                                            MAV_STATE_ACTIVE);       // MAV_STATE

            uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
            int len = mavlink_msg_to_send_buffer(buffer, &message);
            link->writeBytesThreadSafe((const char*)buffer, len);
        }
    }
}
