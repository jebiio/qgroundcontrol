/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KrisoGainFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"

const char* KrisoGainFactGroup::_dp_surge_pgainFactName  = "dp_surge_pgain";
const char* KrisoGainFactGroup::_dp_surge_dgainFactName  = "dp_surge_dgain"; 
const char* KrisoGainFactGroup::_dp_sway_pgainFactName   = "dp_sway_pgain";
const char* KrisoGainFactGroup::_dp_sway_dgainFactName   = "dp_sway_dgain";  
const char* KrisoGainFactGroup::_dp_yaw_pgainFactName    = "dp_yaw_pgain";  
const char* KrisoGainFactGroup::_dp_yaw_dgainFactName    = "dp_yaw_dgain";
const char* KrisoGainFactGroup::_nav_surge_pgainFactName = "nav_surge_pgain"; 
const char* KrisoGainFactGroup::_nav_surge_dgainFactName = "nav_surge_dgain";
const char* KrisoGainFactGroup::_nav_yaw_pgainFactName   = "nav_yaw_pgain";  
const char* KrisoGainFactGroup::_nav_yaw_dgainFactName   = "nav_yaw_dgain";  


KrisoGainFactGroup::KrisoGainFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoGainFactGroup.json", parent)
    , _dp_surge_pgain                 (0, _dp_surge_pgainFactName,                FactMetaData::valueTypeFloat)
    , _dp_surge_dgain                 (0, _dp_surge_dgainFactName,                FactMetaData::valueTypeFloat)
    , _dp_sway_pgain                  (0, _dp_sway_pgainFactName,                FactMetaData::valueTypeFloat)
    , _dp_sway_dgain                  (0, _dp_sway_dgainFactName,                FactMetaData::valueTypeFloat)
    , _dp_yaw_pgain                   (0, _dp_yaw_pgainFactName,           FactMetaData::valueTypeFloat)
    , _dp_yaw_dgain                   (0, _dp_yaw_dgainFactName,                FactMetaData::valueTypeFloat)
    , _nav_surge_pgain                (0, _nav_surge_pgainFactName,                FactMetaData::valueTypeFloat)
    , _nav_surge_dgain                (0, _nav_surge_dgainFactName,                FactMetaData::valueTypeFloat)
    , _nav_yaw_pgain                  (0, _nav_yaw_pgainFactName,                FactMetaData::valueTypeFloat)
    , _nav_yaw_dgain                  (0, _nav_yaw_dgainFactName,           FactMetaData::valueTypeFloat)
    

{
    _addFact(&_dp_surge_pgain,      _dp_surge_pgainFactName);
    _addFact(&_dp_surge_dgain,      _dp_surge_dgainFactName);
    _addFact(&_dp_sway_pgain,       _dp_sway_pgainFactName);
    _addFact(&_dp_sway_dgain,       _dp_sway_dgainFactName);
    _addFact(&_dp_yaw_pgain,        _dp_yaw_pgainFactName);
    _addFact(&_dp_yaw_dgain,        _dp_yaw_dgainFactName);
    _addFact(&_nav_surge_pgain,     _nav_surge_pgainFactName);
    _addFact(&_nav_surge_dgain,     _nav_surge_dgainFactName);
    _addFact(&_nav_yaw_pgain,       _nav_yaw_pgainFactName);
    _addFact(&_nav_yaw_dgain,       _nav_yaw_dgainFactName);

    _dp_surge_pgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _dp_surge_dgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _dp_sway_pgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _dp_sway_dgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _dp_yaw_pgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _dp_yaw_dgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_surge_pgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_surge_dgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_yaw_pgain.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _nav_yaw_dgain.setRawValue(std::numeric_limits<float>::quiet_NaN());

}


void KrisoGainFactGroup::updateHDGFact(float surgeP, float surgeD, float yawP, float yawD)
{
    nav_surge_pgain()->setRawValue                   (surgeP);
    nav_surge_dgain()->setRawValue                   (surgeD);
    nav_yaw_pgain()->setRawValue                     (yawP);
    nav_yaw_dgain()->setRawValue                     (yawD);
}

void KrisoGainFactGroup::updateDPFact(float surgeP, float surgeD, float swayP, float swayD, float yawP, float yawD)
{
    dp_surge_pgain()->setRawValue                       (surgeP);
    dp_surge_dgain()->setRawValue                       (surgeD);
    dp_sway_pgain()->setRawValue                        (swayP);
    dp_sway_dgain()->setRawValue                        (swayD);
    dp_yaw_pgain()->setRawValue                         (yawP);
    dp_yaw_dgain()->setRawValue                         (yawD);

}
