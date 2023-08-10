/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KrisoStatusFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"

const char* KrisoStatusFactGroup::_nav_longitudeFactName =    "nav_longitude";   
const char* KrisoStatusFactGroup::_nav_latitudeFactName =     "nav_latitude";    
const char* KrisoStatusFactGroup::_nav_rollFactName =         "nav_roll";   
const char* KrisoStatusFactGroup::_nav_pitchFactName =        "nav_pitch";     
const char* KrisoStatusFactGroup::_nav_yawFactName =          "nav_yaw";   
const char* KrisoStatusFactGroup::_nav_yaw_rateFactName =     "nav_yaw_rate";    
const char* KrisoStatusFactGroup::_nav_cogFactName =          "nav_cog";    
const char* KrisoStatusFactGroup::_nav_sogFactName =          "nav_sog";    
const char* KrisoStatusFactGroup::_nav_uspdFactName =         "nav_uspd";    
const char* KrisoStatusFactGroup::_nav_vspdFactName =         "nav_vspd";    
const char* KrisoStatusFactGroup::_nav_wspdFactName =         "nav_wspd";    
const char* KrisoStatusFactGroup::_nav_heaveFactName =        "nav_heave";    
const char* KrisoStatusFactGroup::_nav_gpstimeFactName =      "nav_gpstime";    
const char* KrisoStatusFactGroup::_wea_airtemFactName =       "wea_airtem";      
const char* KrisoStatusFactGroup::_wea_wattemFactName =       "wea_wattem";     
const char* KrisoStatusFactGroup::_wea_pressFactName =        "wea_press";     
const char* KrisoStatusFactGroup::_wea_relhumFactName =       "wea_relhum";     
const char* KrisoStatusFactGroup::_wea_dewptFactName =        "wea_dewpt";     
const char* KrisoStatusFactGroup::_wea_windirtFactName =      "wea_windirt";     
const char* KrisoStatusFactGroup::_wea_winspdtFactName =      "wea_winspdt";    
const char* KrisoStatusFactGroup::_wea_windirrFactName =      "wea_windirr";     
const char* KrisoStatusFactGroup::_wea_watspdrFactName =      "wea_watspdr";   
const char* KrisoStatusFactGroup::_wea_watdirFactName =       "wea_watdir";     
const char* KrisoStatusFactGroup::_wea_watspdFactName =       "wea_watspd";      
const char* KrisoStatusFactGroup::_wea_visibiranFactName =    "wea_visibiran";     
const char* KrisoStatusFactGroup::_nav_modeFactName =         "nav_mode";    

KrisoStatusFactGroup::KrisoStatusFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoStatusFact.json", parent)
    , _nav_longitude       (0, _nav_longitudeFactName,   FactMetaData::valueTypeDouble)
    , _nav_latitude        (0, _nav_latitudeFactName,    FactMetaData::valueTypeDouble)
    , _nav_roll            (0, _nav_rollFactName,        FactMetaData::valueTypeFloat) 
    , _nav_pitch           (0, _nav_pitchFactName,       FactMetaData::valueTypeFloat) 
    , _nav_yaw             (0, _nav_yawFactName,         FactMetaData::valueTypeFloat) 
    , _nav_yaw_rate        (0, _nav_yaw_rateFactName,    FactMetaData::valueTypeFloat) 
    , _nav_cog             (0, _nav_cogFactName,         FactMetaData::valueTypeFloat) 
    , _nav_sog             (0, _nav_sogFactName,         FactMetaData::valueTypeFloat) 
    , _nav_uspd            (0, _nav_uspdFactName,        FactMetaData::valueTypeFloat) 
    , _nav_vspd            (0, _nav_vspdFactName,        FactMetaData::valueTypeFloat) 
    , _nav_wspd            (0, _nav_wspdFactName,        FactMetaData::valueTypeFloat) 
    , _nav_heave           (0, _nav_heaveFactName,       FactMetaData::valueTypeFloat) 
    , _nav_gpstime         (0, _nav_gpstimeFactName,     FactMetaData::valueTypeFloat) 
    , _wea_airtem          (0, _wea_airtemFactName,      FactMetaData::valueTypeFloat) 
    , _wea_wattem          (0, _wea_wattemFactName,      FactMetaData::valueTypeFloat) 
    , _wea_press           (0, _wea_pressFactName,       FactMetaData::valueTypeFloat) 
    , _wea_relhum          (0, _wea_relhumFactName,      FactMetaData::valueTypeFloat) 
    , _wea_dewpt           (0, _wea_dewptFactName,       FactMetaData::valueTypeFloat) 
    , _wea_windirt         (0, _wea_windirtFactName,     FactMetaData::valueTypeFloat) 
    , _wea_winspdt         (0, _wea_winspdtFactName,     FactMetaData::valueTypeFloat) 
    , _wea_windirr         (0, _wea_windirrFactName,     FactMetaData::valueTypeFloat) 
    , _wea_watspdr         (0, _wea_watspdrFactName,     FactMetaData::valueTypeFloat) 
    , _wea_watdir          (0, _wea_watdirFactName,      FactMetaData::valueTypeFloat) 
    , _wea_watspd          (0, _wea_watspdFactName,      FactMetaData::valueTypeFloat) 
    , _wea_visibiran       (0, _wea_visibiranFactName,   FactMetaData::valueTypeFloat) 
    , _nav_mode            (0, _nav_modeFactName,        FactMetaData::valueTypeUint8)

    

{
    _addFact(&_nav_longitude,   _nav_longitudeFactName);
    _addFact(&_nav_latitude,    _nav_latitudeFactName);
    _addFact(&_nav_roll,        _nav_rollFactName);
    _addFact(&_nav_pitch,       _nav_pitchFactName);
    _addFact(&_nav_yaw,         _nav_yawFactName);
    _addFact(&_nav_yaw_rate,    _nav_yaw_rateFactName);
    _addFact(&_nav_cog,         _nav_cogFactName);
    _addFact(&_nav_sog,         _nav_sogFactName);
    _addFact(&_nav_uspd,        _nav_uspdFactName);
    _addFact(&_nav_vspd,        _nav_vspdFactName);
    _addFact(&_nav_wspd,        _nav_wspdFactName);
    _addFact(&_nav_heave,       _nav_heaveFactName);
    _addFact(&_nav_gpstime,     _nav_gpstimeFactName);
    _addFact(&_wea_airtem,      _wea_airtemFactName);
    _addFact(&_wea_wattem,      _wea_wattemFactName);
    _addFact(&_wea_press,       _wea_pressFactName);
    _addFact(&_wea_relhum,      _wea_relhumFactName);
    _addFact(&_wea_dewpt,       _wea_dewptFactName);
    _addFact(&_wea_windirt,     _wea_windirtFactName);
    _addFact(&_wea_winspdt,     _wea_winspdtFactName);
    _addFact(&_wea_windirr,     _wea_windirrFactName);
    _addFact(&_wea_watspdr,     _wea_watspdrFactName);
    _addFact(&_wea_watdir,      _wea_watdirFactName);
    _addFact(&_wea_watspd,      _wea_watspdFactName);
    _addFact(&_wea_visibiran,   _wea_visibiranFactName);
    _addFact(&_nav_mode,        _nav_modeFactName);

    _nav_longitude.setRawValue(std::numeric_limits<double>::quiet_NaN());
    _nav_latitude.setRawValue(std::numeric_limits<double>::quiet_NaN());
    _nav_roll.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_pitch.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_yaw.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_yaw_rate.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_cog.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_sog.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_uspd.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_vspd.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_wspd.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_heave.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_gpstime.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_airtem.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_wattem.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_press.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_relhum.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_dewpt.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_windirt.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_winspdt.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_windirr.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_watspdr.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_watdir.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_watspd.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _wea_visibiran.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_mode.setRawValue(std::numeric_limits<uint8_t>::quiet_NaN());

}

void KrisoStatusFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
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

void KrisoStatusFactGroup::_handleKRISOStatus(mavlink_message_t& message)
{
    mavlink_kriso_status_t krisoStatus;
    mavlink_msg_kriso_status_decode(&message, &krisoStatus);

    nav_longitude()->setRawValue        (krisoStatus.nav_longitude);
    nav_latitude()->setRawValue         (krisoStatus.nav_latitude);
    nav_roll()->setRawValue             (krisoStatus.nav_roll);
    nav_pitch()->setRawValue            (krisoStatus.nav_pitch);
    nav_yaw()->setRawValue              (krisoStatus.nav_yaw);
    nav_yaw_rate()->setRawValue         (krisoStatus.nav_yaw_rate);
    nav_cog()->setRawValue              (krisoStatus.nav_cog);
    nav_sog()->setRawValue              (krisoStatus.nav_sog);
    nav_uspd()->setRawValue             (krisoStatus.nav_uspd);
    nav_vspd()->setRawValue             (krisoStatus.nav_vspd);
    nav_wspd()->setRawValue             (krisoStatus.nav_wspd);
    nav_heave()->setRawValue            (krisoStatus.nav_heave);
    nav_gpstime()->setRawValue          (krisoStatus.nav_gpstime);
    wea_airtem()->setRawValue           (krisoStatus.wea_airtem);
    wea_wattem()->setRawValue           (krisoStatus.wea_wattem);
    wea_press()->setRawValue            (krisoStatus.wea_press);
    wea_relhum()->setRawValue           (krisoStatus.wea_relhum);
    wea_dewpt()->setRawValue            (krisoStatus.wea_dewpt);
    wea_windirt()->setRawValue          (krisoStatus.wea_windirt);
    wea_winspdt()->setRawValue          (krisoStatus.wea_winspdt);
    wea_windirr()->setRawValue          (krisoStatus.wea_windirr);
    wea_watspdr()->setRawValue          (krisoStatus.wea_watspdr);
    wea_watdir()->setRawValue           (krisoStatus.wea_watdir);
    wea_watspd()->setRawValue           (krisoStatus.wea_watspd);
    wea_visibiran()->setRawValue        (krisoStatus.wea_visibiran);
    nav_mode()->setRawValue             (krisoStatus.nav_mode);

    
}
