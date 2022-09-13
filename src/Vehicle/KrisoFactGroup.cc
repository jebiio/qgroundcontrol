/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KrisoFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"

const char* KrisoFactGroup::_t1_rpsFactName =       "t1rps";
const char* KrisoFactGroup::_t2_rpsFactName =       "t2_rps"; 
const char* KrisoFactGroup::_t3_rpsFactName =       "t3_rps";
const char* KrisoFactGroup::_t3_angleFactName =     "t3_angle";  
const char* KrisoFactGroup::_t4_rpsFactName =       "t4_rps";
const char* KrisoFactGroup::_t4_angleFactName =     "t4_angle"; 
const char* KrisoFactGroup::_nav_modeFactName =     "nav_mode"; 
const char* KrisoFactGroup::_nav_rollFactName =     "nav_roll"; 
const char* KrisoFactGroup::_nav_pitchFactName =    "nav_pitch"; 
const char* KrisoFactGroup::_nav_yawFactName =      "nav_yaw"; 
const char* KrisoFactGroup::_nav_cogFactName =      "nav_cog"; 
const char* KrisoFactGroup::_nav_sogFactName =      "nav_sog"; 
const char* KrisoFactGroup::_nav_uspdFactName =     "nav_uspd"; 
const char* KrisoFactGroup::_nav_vspdFactName =     "nav_vspd"; 
const char* KrisoFactGroup::_nav_longitudeFactName ="lon";   
const char* KrisoFactGroup::_nav_latitudeFactName = "lat";  
const char* KrisoFactGroup::_nav_gpstimeFactName =  "nav_gpstime";  
const char* KrisoFactGroup::_wea_airtemFactName =   "wea_airtem";  
const char* KrisoFactGroup::_wea_wattemFactName =   "wea_wattem";  
const char* KrisoFactGroup::_wea_pressFactName =    "wea_press";  
const char* KrisoFactGroup::_wea_relhumFactName =   "wea_relhum";  
const char* KrisoFactGroup::_wea_windirtFactName =  "wea_windirt";  
const char* KrisoFactGroup::_wea_winspdtFactName =  "wea_winspdt";  
const char* KrisoFactGroup::_wea_watdirFactName =   "wea_watdir";  
const char* KrisoFactGroup::_wea_watspdFactName =   "wea_watspd";   
const char* KrisoFactGroup::_wea_visibiranFactName ="wea_visibiran";  


KrisoFactGroup::KrisoFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoFact.json", parent)
    , _t1_rps               (0, _t1_rpsFactName,            FactMetaData::valueTypeFloat)
    , _t2_rps               (0, _t2_rpsFactName,            FactMetaData::valueTypeFloat)
    , _t3_rps               (0, _t3_rpsFactName,            FactMetaData::valueTypeFloat)
    , _t3_angle             (0, _t3_angleFactName,          FactMetaData::valueTypeFloat)
    , _t4_rps               (0, _t4_rpsFactName,            FactMetaData::valueTypeFloat)
    , _t4_angle             (0, _t4_angleFactName,          FactMetaData::valueTypeFloat)
    , _nav_mode             (0, _nav_modeFactName,          FactMetaData::valueTypeUint8)
    , _nav_roll             (0, _nav_rollFactName,          FactMetaData::valueTypeFloat)
    , _nav_pitch            (0, _nav_pitchFactName,         FactMetaData::valueTypeFloat)
    , _nav_yaw              (0, _nav_yawFactName,           FactMetaData::valueTypeFloat)
    , _nav_cog              (0, _nav_cogFactName,           FactMetaData::valueTypeFloat)
    , _nav_sog              (0, _nav_sogFactName,           FactMetaData::valueTypeFloat)
    , _nav_uspd             (0, _nav_uspdFactName,          FactMetaData::valueTypeFloat)
    , _nav_vspd             (0, _nav_vspdFactName,          FactMetaData::valueTypeFloat)
    , _nav_longitude        (0, _nav_longitudeFactName,     FactMetaData::valueTypeDouble) 
    , _nav_latitude         (0, _nav_latitudeFactName,      FactMetaData::valueTypeDouble) 
    , _nav_gpstime          (0, _nav_gpstimeFactName,       FactMetaData::valueTypeFloat)
    , _wea_airtem           (0, _wea_airtemFactName,        FactMetaData::valueTypeFloat)
    , _wea_wattem           (0, _wea_wattemFactName,        FactMetaData::valueTypeFloat)
    , _wea_press            (0, _wea_pressFactName,         FactMetaData::valueTypeFloat)
    , _wea_relhum           (0, _wea_relhumFactName,        FactMetaData::valueTypeFloat)
    , _wea_windirt          (0, _wea_windirtFactName,       FactMetaData::valueTypeFloat)
    , _wea_winspdt          (0, _wea_winspdtFactName,       FactMetaData::valueTypeFloat)
    , _wea_watdir           (0, _wea_watdirFactName,        FactMetaData::valueTypeFloat)
    , _wea_watspd           (0, _wea_watspdFactName,        FactMetaData::valueTypeFloat)
    , _wea_visibiran        (0, _wea_visibiranFactName,     FactMetaData::valueTypeFloat)     

{
    _addFact(&_t1_rps,                     _t1_rpsFactName); 
    _addFact(&_t2_rps,                     _t2_rpsFactName); 
    _addFact(&_t3_rps,                     _t3_rpsFactName); 
    _addFact(&_t3_angle,                 _t3_angleFactName); 
    _addFact(&_t4_rps,                     _t4_rpsFactName); 
    _addFact(&_t4_angle,                 _t4_angleFactName); 
    _addFact(&_nav_mode,                 _nav_modeFactName); 
    _addFact(&_nav_roll,                 _nav_rollFactName); 
    _addFact(&_nav_pitch,               _nav_pitchFactName); 
    _addFact(&_nav_yaw,                   _nav_yawFactName); 
    _addFact(&_nav_cog,                   _nav_cogFactName); 
    _addFact(&_nav_sog,                   _nav_sogFactName); 
    _addFact(&_nav_uspd,                 _nav_uspdFactName); 
    _addFact(&_nav_vspd,                 _nav_vspdFactName); 
    _addFact(&_nav_longitude,       _nav_longitudeFactName); 
    _addFact(&_nav_latitude,         _nav_latitudeFactName); 
    _addFact(&_nav_gpstime,           _nav_gpstimeFactName); 
    _addFact(&_wea_airtem,             _wea_airtemFactName); 
    _addFact(&_wea_wattem,             _wea_wattemFactName); 
    _addFact(&_wea_press,               _wea_pressFactName); 
    _addFact(&_wea_relhum,             _wea_relhumFactName); 
    _addFact(&_wea_windirt,           _wea_windirtFactName); 
    _addFact(&_wea_winspdt,           _wea_winspdtFactName); 
    _addFact(&_wea_watdir,             _wea_watdirFactName); 
    _addFact(&_wea_watspd,             _wea_watspdFactName); 
    _addFact(&_wea_visibiran,       _wea_visibiranFactName); 


    _t1_rps.setRawValue(std::numeric_limits<float>::quiet_NaN());           
    _t2_rps.setRawValue(std::numeric_limits<float>::quiet_NaN());           
    _t3_rps.setRawValue(std::numeric_limits<float>::quiet_NaN());           
    _t3_angle.setRawValue(std::numeric_limits<float>::quiet_NaN());         
    _t4_rps.setRawValue(std::numeric_limits<float>::quiet_NaN());           
    _t4_angle.setRawValue(std::numeric_limits<float>::quiet_NaN());         
    _nav_mode.setRawValue(std::numeric_limits<float>::quiet_NaN());         
    _nav_roll.setRawValue(std::numeric_limits<float>::quiet_NaN());         
    _nav_pitch.setRawValue(std::numeric_limits<float>::quiet_NaN());        
    _nav_yaw.setRawValue(std::numeric_limits<float>::quiet_NaN());          
    _nav_cog.setRawValue(std::numeric_limits<float>::quiet_NaN());          
    _nav_sog.setRawValue(std::numeric_limits<float>::quiet_NaN());          
    _nav_uspd.setRawValue(std::numeric_limits<float>::quiet_NaN());         
    _nav_vspd.setRawValue(std::numeric_limits<float>::quiet_NaN());         
    _nav_longitude.setRawValue(std::numeric_limits<float>::quiet_NaN());    
    _nav_latitude.setRawValue(std::numeric_limits<float>::quiet_NaN());     
    _nav_gpstime.setRawValue(std::numeric_limits<float>::quiet_NaN());      
    _wea_airtem.setRawValue(std::numeric_limits<float>::quiet_NaN());       
    _wea_wattem.setRawValue(std::numeric_limits<float>::quiet_NaN());       
    _wea_press.setRawValue(std::numeric_limits<float>::quiet_NaN());        
    _wea_relhum.setRawValue(std::numeric_limits<float>::quiet_NaN());       
    _wea_windirt.setRawValue(std::numeric_limits<float>::quiet_NaN());      
    _wea_winspdt.setRawValue(std::numeric_limits<float>::quiet_NaN());      
    _wea_watdir.setRawValue(std::numeric_limits<float>::quiet_NaN());       
    _wea_watspd.setRawValue(std::numeric_limits<float>::quiet_NaN());       
    _wea_visibiran.setRawValue(std::numeric_limits<float>::quiet_NaN());    
}

void KrisoFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_STATUS:
        _handleKRISOStatus(message);
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

void KrisoFactGroup::_handleKRISOStatus(mavlink_message_t& message)
{
    mavlink_gps_raw_int_t gpsRawInt;
    mavlink_msg_gps_raw_int_decode(&message, &gpsRawInt);

    nav_latitude()->setRawValue              (gpsRawInt.lat * 1e-7);
    nav_longitude()->setRawValue              (gpsRawInt.lon * 1e-7);
}
