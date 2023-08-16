/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
#include <QGeoCoordinate>
#include "KrisoCmdFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"


const char* KrisoCmdFactGroup::_t1_rpmFactName       = "t1_rpm";
const char* KrisoCmdFactGroup::_t2_rpmFactName       = "t2_rpm";
const char* KrisoCmdFactGroup::_t3_rpmFactName       = "t3_rpm";
const char* KrisoCmdFactGroup::_t3_angleFactName     = "t3_angle";
const char* KrisoCmdFactGroup::_t4_rpmFactName       = "t4_rpm";
const char* KrisoCmdFactGroup::_t4_angleFactName     = "t4_angle";
const char* KrisoCmdFactGroup::_oper_modeFactName     = "oper_mode";
const char* KrisoCmdFactGroup::_mission_modeFactName  = "mission_mode"; 
const char* KrisoCmdFactGroup::_logging_statusFactName  = "logging_status"; 
// const char* KrisoCmdFactGroup::_ca_modeFactName       = "ca_mode";
// const char* KrisoCmdFactGroup::_ca_methodFactName     = "ca_method";  



KrisoCmdFactGroup::KrisoCmdFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoCmdFact.json", parent)
    , _t1_rpm                 (0, _t1_rpmFactName,          FactMetaData::valueTypeFloat) 
    , _t2_rpm                 (0, _t2_rpmFactName,          FactMetaData::valueTypeFloat)
    , _t3_rpm                 (0, _t3_rpmFactName,          FactMetaData::valueTypeFloat)
    , _t3_angle               (0, _t3_angleFactName,        FactMetaData::valueTypeFloat) 
    , _t4_rpm                 (0, _t4_rpmFactName,          FactMetaData::valueTypeFloat)         
    , _t4_angle               (0, _t4_angleFactName,        FactMetaData::valueTypeFloat)    
    , _oper_mode              (0, _oper_modeFactName,       FactMetaData::valueTypeUint32)  
    , _mission_mode           (0, _mission_modeFactName,    FactMetaData::valueTypeUint32)    
    , _logging_status          (0, _logging_statusFactName,    FactMetaData::valueTypeUint8)      
{
    _addFact(&_t1_rpm,       _t1_rpmFactName);    
    _addFact(&_t2_rpm,       _t2_rpmFactName);
    _addFact(&_t3_rpm,       _t3_rpmFactName);
    _addFact(&_t3_angle,     _t3_angleFactName);
    _addFact(&_t4_rpm,       _t4_rpmFactName);
    _addFact(&_t4_angle,     _t4_angleFactName);
    _addFact(&_oper_mode,    _oper_modeFactName);
    _addFact(&_mission_mode, _mission_modeFactName);
    _addFact(&_logging_status, _logging_statusFactName);

    _oper_mode.setRawValue(10);
    _mission_mode.setRawValue(10);


}

void KrisoCmdFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_CONTROL_COMMAND_TO_VCC:
        _handleKRISOCommand(message);
        break;
    case MAVLINK_MSG_ID_KRISO_ROS_LOG_STATUS:
        _handleKRISOLogStatus(message);
        break;
    case MAVLINK_MSG_ID_HIGH_LATENCY2:
        // _handleHighLatency2(message);
        break;
    default:
        break;
    }

}

void KrisoCmdFactGroup::_handleKRISOCommand(mavlink_message_t& message)
{
    mavlink_kriso_control_command_to_vcc_t krisoCmd;
    mavlink_msg_kriso_control_command_to_vcc_decode(&message, &krisoCmd);
   
    t1_rpm()->setRawValue           (krisoCmd.t1_rpm);
    t2_rpm()->setRawValue           (krisoCmd.t2_rpm);
    t3_rpm()->setRawValue           (krisoCmd.t3_rpm);
    t3_angle()->setRawValue         (krisoCmd.t3_angle);
    t4_rpm()->setRawValue           (krisoCmd.t4_rpm);
    t4_angle()->setRawValue         (krisoCmd.t4_angle);    
    oper_mode()->setRawValue        (krisoCmd.oper_mode);     
    mission_mode()->setRawValue     (krisoCmd.mission_mode);     
}


void KrisoCmdFactGroup::_handleKRISOLogStatus(mavlink_message_t& message)
{
    mavlink_kriso_ros_log_status_t krisoLoggingStatus;
    mavlink_msg_kriso_ros_log_status_decode(&message, &krisoLoggingStatus);
    
    logging_status()->setRawValue   (krisoLoggingStatus.logging_status);
}
