/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KrisoAISFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"


const char* KrisoAISFactGroup::_lonFactName =         "lon";   
const char* KrisoAISFactGroup::_latFactName =         "lat";    
const char* KrisoAISFactGroup::_msg_typeFactName =    "msg_type";   
const char* KrisoAISFactGroup::_repeatFactName =      "repeat";     
const char* KrisoAISFactGroup::_mmsiFactName =        "mmsi";   
const char* KrisoAISFactGroup::_reserved_1FactName =  "reserved_1";    
const char* KrisoAISFactGroup::_speedFactName =       "speed";    
const char* KrisoAISFactGroup::_courseFactName =      "course";    
const char* KrisoAISFactGroup::_headingFactName =     "heading";    
const char* KrisoAISFactGroup::_secondFactName =      "second";    
const char* KrisoAISFactGroup::_reserved_2FactName =  "reserved_2";    
const char* KrisoAISFactGroup::_radioFactName =       "radio";    
const char* KrisoAISFactGroup::_accuracyFactName =    "accuracy";    
const char* KrisoAISFactGroup::_csFactName =          "cs";      
const char* KrisoAISFactGroup::_displayFactName =     "display";     
const char* KrisoAISFactGroup::_dscFactName =         "dsc";     
const char* KrisoAISFactGroup::_bandFactName =        "band";     
const char* KrisoAISFactGroup::_msg22FactName =       "msg22";     
const char* KrisoAISFactGroup::_assignedFactName =    "assigned";     
const char* KrisoAISFactGroup::_raimFactName =        "raim";    


KrisoAISFactGroup::KrisoAISFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoAISFact.json", parent)
    , _lon            (0, _lonFactName,          FactMetaData::valueTypeDouble)  
    , _lat            (0, _latFactName,          FactMetaData::valueTypeDouble)  
    , _msg_type       (0, _msg_typeFactName,     FactMetaData::valueTypeUint32)   
    , _repeat         (0, _repeatFactName,       FactMetaData::valueTypeUint32)   
    , _mmsi           (0, _mmsiFactName,         FactMetaData::valueTypeUint32)   
    , _reserved_1     (0, _reserved_1FactName,   FactMetaData::valueTypeUint32)   
    , _speed          (0, _speedFactName,        FactMetaData::valueTypeFloat)    
    , _course         (0, _courseFactName,       FactMetaData::valueTypeFloat)    
    , _heading        (0, _headingFactName,      FactMetaData::valueTypeUint32)   
    , _second         (0, _secondFactName,       FactMetaData::valueTypeUint32)   
    , _reserved_2     (0, _reserved_2FactName,   FactMetaData::valueTypeUint32)   
    , _radio          (0, _radioFactName,        FactMetaData::valueTypeUint32)   
    , _accuracy       (0, _accuracyFactName,     FactMetaData::valueTypeUint8)  
    , _cs             (0, _csFactName,           FactMetaData::valueTypeUint8)  
    , _display        (0, _displayFactName,      FactMetaData::valueTypeUint8)  
    , _dsc            (0, _dscFactName,          FactMetaData::valueTypeUint8)  
    , _band           (0, _bandFactName,         FactMetaData::valueTypeUint8)  
    , _msg22          (0, _msg22FactName,        FactMetaData::valueTypeUint8)  
    , _assigned       (0, _assignedFactName,     FactMetaData::valueTypeUint8)  
    , _raim           (0, _raimFactName,         FactMetaData::valueTypeUint8)  
{
    _addFact(&_lon, _lonFactName);
    _addFact(&_lat, _latFactName);
    _addFact(&_msg_type, _msg_typeFactName);
    _addFact(&_repeat, _repeatFactName);
    _addFact(&_mmsi, _mmsiFactName);
    _addFact(&_reserved_1, _reserved_1FactName);
    _addFact(&_speed, _speedFactName);
    _addFact(&_course, _courseFactName);
    _addFact(&_heading, _headingFactName);
    _addFact(&_second, _secondFactName);
    _addFact(&_reserved_2, _reserved_2FactName);
    _addFact(&_radio, _radioFactName);
    _addFact(&_accuracy, _accuracyFactName);
    _addFact(&_cs, _csFactName);
    _addFact(&_display, _displayFactName);
    _addFact(&_dsc, _dscFactName);
    _addFact(&_band, _bandFactName);
    _addFact(&_msg22, _msg22FactName);
    _addFact(&_assigned, _assignedFactName);
    _addFact(&_raim, _raimFactName);

    _lon.setRawValue(std::numeric_limits<double>::quiet_NaN());
    _lat.setRawValue(std::numeric_limits<double>::quiet_NaN());
    _msg_type.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _repeat.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _mmsi.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _reserved_1.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _speed.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _course.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _heading.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _second.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _reserved_2.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _radio.setRawValue(std::numeric_limits<uint32_t>::quiet_NaN());
    _accuracy.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());
    _cs.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());
    _display.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());
    _dsc.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());
    _band.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());
    _msg22.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());
    _assigned.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());
    _raim.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());


}

void KrisoAISFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_AIS_STATUS:
        // _handleKRISOAISStatus(message);
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

void KrisoAISFactGroup::_handleKRISOAISStatus(mavlink_message_t& message)
{
    mavlink_kriso_ais_status_t krisoAISStatus;
    mavlink_msg_kriso_ais_status_decode(&message, &krisoAISStatus);

    lon()->setRawValue           (krisoAISStatus.lon);
    lat()->setRawValue           (krisoAISStatus.lat);
    msg_type()->setRawValue      (krisoAISStatus.msg_type);
    repeat()->setRawValue        (krisoAISStatus.repeat);
    mmsi()->setRawValue          (krisoAISStatus.mmsi);
    reserved_1()->setRawValue    (krisoAISStatus.reserved_1);
    speed()->setRawValue         (krisoAISStatus.speed);
    course()->setRawValue        (krisoAISStatus.course);
    heading()->setRawValue       (krisoAISStatus.heading);
    second()->setRawValue        (krisoAISStatus.second);
    reserved_2()->setRawValue    (krisoAISStatus.reserved_2);
    radio()->setRawValue         (krisoAISStatus.radio);
    accuracy()->setRawValue      (krisoAISStatus.accuracy);
    cs()->setRawValue            (krisoAISStatus.cs);
    display()->setRawValue       (krisoAISStatus.display);
    dsc()->setRawValue           (krisoAISStatus.dsc);
    band()->setRawValue          (krisoAISStatus.band);
    msg22()->setRawValue         (krisoAISStatus.msg22);
    assigned()->setRawValue      (krisoAISStatus.assigned);
    raim()->setRawValue          (krisoAISStatus.raim);
    
}
