/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
#include <QGeoCoordinate>
#include "KrisoDPtoVCCFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"


const char* KrisoDPtoVCCFactGroup::_surge_errorFactName       = "surge_error";
const char* KrisoDPtoVCCFactGroup::_sway_errorFactName        = "sway_error";
const char* KrisoDPtoVCCFactGroup::_yaw_errorFactName         = "yaw_error";
const char* KrisoDPtoVCCFactGroup::_dp_start_stopFactName     = "dp_start_stop";


KrisoDPtoVCCFactGroup::KrisoDPtoVCCFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoDPtoVCCFact.json", parent)
    , _surge_error          (0, _surge_errorFactName,   FactMetaData::valueTypeDouble) 
    , _sway_error           (0, _sway_errorFactName,    FactMetaData::valueTypeDouble)
    , _yaw_error            (0, _yaw_errorFactName,     FactMetaData::valueTypeDouble)
    , _dp_start_stop        (0, _dp_start_stopFactName, FactMetaData::valueTypeUint32)     
{
    _addFact(&_surge_error,      _surge_errorFactName);    
    _addFact(&_sway_error,       _sway_errorFactName);
    _addFact(&_yaw_error,        _yaw_errorFactName);
    _addFact(&_dp_start_stop,    _dp_start_stopFactName);

}

void KrisoDPtoVCCFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_DP_TO_VCC:
        _handleKRISODPtoVCC(message);
        break;
    case MAVLINK_MSG_ID_KRISO_ROS_LOG_STATUS:
        // _handleKRISOSLogStatus(message);
        break;
    case MAVLINK_MSG_ID_HIGH_LATENCY2:
        // _handleHighLatency2(message);
        break;
    default:
        break;
    }

}

void KrisoDPtoVCCFactGroup::_handleKRISODPtoVCC(mavlink_message_t& message)
{
    mavlink_kriso_dp_to_vcc_t krisoDPtoVCC;
    mavlink_msg_kriso_dp_to_vcc_decode(&message, &krisoDPtoVCC);
   
    surge_error()->setRawValue       (krisoDPtoVCC.surge_error);
    sway_error()->setRawValue        (krisoDPtoVCC.sway_error);
    yaw_error()->setRawValue         (krisoDPtoVCC.yaw_error);
    dp_start_stop()->setRawValue     (krisoDPtoVCC.dp_start_stop);  
}

