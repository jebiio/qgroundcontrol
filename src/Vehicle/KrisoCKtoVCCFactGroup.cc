/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
#include <QGeoCoordinate>
#include "KrisoCKtoVCCFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"


const char* KrisoCKtoVCCFactGroup::_psi_dFactName       = "psi_d";
const char* KrisoCKtoVCCFactGroup::_spd_dFactName        = "spd_d";


KrisoCKtoVCCFactGroup::KrisoCKtoVCCFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoCKtoVCCFact.json", parent)
    , _psi_d          (0, _psi_dFactName,    FactMetaData::valueTypeFloat) 
    , _spd_d          (0, _spd_dFactName,    FactMetaData::valueTypeFloat)  
{
    _addFact(&_psi_d,       _psi_dFactName);    
    _addFact(&_spd_d,       _spd_dFactName);

}

void KrisoCKtoVCCFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_CK_TO_VCC:
        _handleKRISOCKtoVCC(message);
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

void KrisoCKtoVCCFactGroup::_handleKRISOCKtoVCC(mavlink_message_t& message)
{
    mavlink_kriso_ck_to_vcc_t krisoCKtoVCC;
    mavlink_msg_kriso_ck_to_vcc_decode(&message, &krisoCKtoVCC);
   
    psi_d()->setRawValue       (krisoCKtoVCC.psi_d);
    spd_d()->setRawValue       (krisoCKtoVCC.spd_d);
}

