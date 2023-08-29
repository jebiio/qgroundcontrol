/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KrisoWTtoVCCFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"

const char* KrisoWTtoVCCFactGroup::_psi_dFactName =          "psi_d";
const char* KrisoWTtoVCCFactGroup::_spd_dFactName =          "spd_d"; 
const char* KrisoWTtoVCCFactGroup::_wp_lat_dFactName =       "wp_lat_d";
const char* KrisoWTtoVCCFactGroup::_wp_lon_dFactName =       "wp_lon_d";  
const char* KrisoWTtoVCCFactGroup::_track_path_idxFactName = "track_path_idx";  


KrisoWTtoVCCFactGroup::KrisoWTtoVCCFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoWTtoVCCFact.json", parent)
    , _psi_d                    (0, _psi_dFactName,                 FactMetaData::valueTypeFloat)
    , _spd_d                    (0, _spd_dFactName,                 FactMetaData::valueTypeFloat)
    , _wp_lat_d                 (0, _wp_lat_dFactName,              FactMetaData::valueTypeFloat)
    , _wp_lon_d                 (0, _wp_lon_dFactName,              FactMetaData::valueTypeFloat)
    , _track_path_idx           (0, _track_path_idxFactName,        FactMetaData::valueTypeUint32)
    

{
    _addFact(&_psi_d,                 _psi_dFactName);
    _addFact(&_spd_d,                 _spd_dFactName);
    _addFact(&_wp_lat_d,              _wp_lat_dFactName);
    _addFact(&_wp_lon_d,              _wp_lon_dFactName);
    _addFact(&_track_path_idx,        _track_path_idxFactName);

    _psi_d.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _spd_d.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wp_lat_d.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wp_lon_d.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _track_path_idx.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());

}

void KrisoWTtoVCCFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_WT_TO_VCC:
        _handleKrisoWTtoVCC(message);
        break;
    case MAVLINK_MSG_ID_HIGH_LATENCY:
        // _handleHighLatency(message);
        break;
    case MAVLINK_MSG_ID_HIGH_LATENCY2:
        // _handleHighLatency2(message);
        break;
    default:
        break;
    }
}

void KrisoWTtoVCCFactGroup::_handleKrisoWTtoVCC(mavlink_message_t& message)
{
    mavlink_kriso_wt_to_vcc_t krisoWTtoVCC;
    mavlink_msg_kriso_wt_to_vcc_decode(&message, &krisoWTtoVCC);

    psi_d()->setRawValue                       (krisoWTtoVCC.psi_d);
    spd_d()->setRawValue                       (krisoWTtoVCC.spd_d);
    wp_lat_d()->setRawValue                    (krisoWTtoVCC.wp_lat_d);
    wp_lon_d()->setRawValue                    (krisoWTtoVCC.wp_lon_d);
    track_path_idx()->setRawValue              (krisoWTtoVCC.track_path_idx);

    
}
