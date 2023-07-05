/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KrisoVoltageStatusFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"

const char* KrisoVoltageStatusFactGroup::_ch1_voltFactName =            "ch1_volt";
const char* KrisoVoltageStatusFactGroup::_ch2_voltFactName =            "ch2_volt"; 
const char* KrisoVoltageStatusFactGroup::_ch3_voltFactName =            "ch3_volt";
const char* KrisoVoltageStatusFactGroup::_ch4_voltFactName =            "ch4_volt";  
const char* KrisoVoltageStatusFactGroup::_invertor_voltFactName =       "invertor_volt";  


KrisoVoltageStatusFactGroup::KrisoVoltageStatusFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoVoltageStatusFact.json", parent)
    , _ch1_volt               (0, _ch1_voltFactName,                FactMetaData::valueTypeFloat)
    , _ch2_volt               (0, _ch2_voltFactName,                FactMetaData::valueTypeFloat)
    , _ch3_volt               (0, _ch3_voltFactName,                FactMetaData::valueTypeFloat)
    , _ch4_volt               (0, _ch4_voltFactName,                FactMetaData::valueTypeFloat)
    , _invertor_volt          (0, _invertor_voltFactName,           FactMetaData::valueTypeFloat)
    

{
    _addFact(&_ch1_volt,            _ch1_voltFactName);
    _addFact(&_ch2_volt,            _ch2_voltFactName);
    _addFact(&_ch3_volt,            _ch3_voltFactName);
    _addFact(&_ch4_volt,            _ch4_voltFactName);
    _addFact(&_invertor_volt,       _invertor_voltFactName);

    _ch1_volt.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _ch2_volt.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _ch3_volt.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _ch4_volt.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _invertor_volt.setRawValue(std::numeric_limits<float>::quiet_NaN());

}

void KrisoVoltageStatusFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_VOL_STATUS:
        _handleKrisoVolStatus(message);
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

void KrisoVoltageStatusFactGroup::_handleKrisoVolStatus(mavlink_message_t& message)
{
    mavlink_kriso_vol_status_t krisoVolStatus;
    mavlink_msg_kriso_vol_status_decode(&message, &krisoVolStatus);

    ch1_volt()->setRawValue                     (krisoVolStatus.ch1_volt);
    ch2_volt()->setRawValue                     (krisoVolStatus.ch2_volt);
    ch3_volt()->setRawValue                     (krisoVolStatus.ch3_volt);
    ch4_volt()->setRawValue                     (krisoVolStatus.ch4_volt);
    invertor_volt()->setRawValue                (krisoVolStatus.invertor_volt);

    
}
