/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"
#include "QGCMAVLink.h"

class KrisoFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* t1_rps             READ t1_rps                 CONSTANT)
    // Q_PROPERTY(Fact* t2_rps             READ t2_rps                CONSTANT)
    // Q_PROPERTY(Fact* t3_rps             READ t3_rps                CONSTANT)
    // Q_PROPERTY(Fact* t3_angle           READ t3_angle              CONSTANT)
    // Q_PROPERTY(Fact* t4_rps             READ t4_rps                CONSTANT)
    // Q_PROPERTY(Fact* t4_angle           READ t4_angle              CONSTANT)
    // Q_PROPERTY(Fact* nav_mode           READ nav_mode               CONSTANT)
    // Q_PROPERTY(Fact* nav_roll           READ nav_roll               CONSTANT)
    // Q_PROPERTY(Fact* nav_pitch          READ nav_pitch              CONSTANT)
    // Q_PROPERTY(Fact* nav_yaw            READ nav_yaw                CONSTANT)
    // Q_PROPERTY(Fact* nav_cog            READ nav_cog                CONSTANT)
    // Q_PROPERTY(Fact* nav_sog            READ nav_sog                CONSTANT)
    // Q_PROPERTY(Fact* nav_uspd           READ nav_uspd               CONSTANT)
    // Q_PROPERTY(Fact* nav_vspd           READ nav_vspd               CONSTANT)
    Q_PROPERTY(Fact* nav_longitude      READ nav_longitude          CONSTANT)
    Q_PROPERTY(Fact* nav_latitude       READ nav_latitude           CONSTANT)
    // Q_PROPERTY(Fact* nav_gpstime        READ nav_gpstime            CONSTANT)
    // Q_PROPERTY(Fact* wea_airtem         READ wea_airtem             CONSTANT)
    // Q_PROPERTY(Fact* wea_wattem         READ wea_wattem             CONSTANT)
    // Q_PROPERTY(Fact* wea_press          READ wea_press              CONSTANT)
    // Q_PROPERTY(Fact* wea_relhum         READ wea_relhum             CONSTANT)
    // Q_PROPERTY(Fact* wea_windirt        READ wea_windirt            CONSTANT)
    // Q_PROPERTY(Fact* wea_winspdt        READ wea_winspdt            CONSTANT)
    // Q_PROPERTY(Fact* wea_watdir         READ wea_watdir             CONSTANT)
    // Q_PROPERTY(Fact* wea_watspd         READ wea_watspd             CONSTANT)
    // Q_PROPERTY(Fact* wea_visibiran      READ wea_visibiran          CONSTANT)

    Fact*    t1_rps         () { return  &_t1_rps;}   
    // Fact*    t2_rps         () { return  &_t2_rps;}   
    // Fact*    t3_rps         () { return  &_t3_rps;}   
    // Fact*    t3_angle       () { return  &_t3_angle;} 
    // Fact*    t4_rps         () { return  &_t4_rps;}   
    // Fact*    t4_angle       () { return  &_t4_angle;} 
    // Fact*    nav_mode       () { return  &_nav_mode;}
    // Fact*    nav_roll       () { return  &_nav_roll;}     
    // Fact*    nav_pitch      () { return  &_nav_pitch;}    
    // Fact*    nav_yaw        () { return  &_nav_yaw;}      
    // Fact*    nav_cog        () { return  &_nav_cog;}      
    // Fact*    nav_sog        () { return  &_nav_sog;}      
    // Fact*    nav_uspd       () { return  &_nav_uspd;}     
    // Fact*    nav_vspd       () { return  &_nav_vspd;}     
    Fact*    nav_longitude  () { return  &_nav_longitude;}
    Fact*    nav_latitude   () { return  &_nav_latitude;} 
    // Fact*    nav_gpstime    () { return  &_nav_gpstime;}  
    // Fact*    wea_airtem     () { return  &_wea_airtem;}   
    // Fact*    wea_wattem     () { return  &_wea_wattem;}   
    // Fact*    wea_press      () { return  &_wea_press;}    
    // Fact*    wea_relhum     () { return  &_wea_relhum;}   
    // Fact*    wea_windirt    () { return  &_wea_windirt;}  
    // Fact*    wea_winspdt    () { return  &_wea_winspdt;}  
    // Fact*    wea_watdir     () { return  &_wea_watdir;}   
    // Fact*    wea_watspd     () { return  &_wea_watspd;}   
    // Fact*    wea_visibiran  () { return  &_wea_visibiran;}

    // Overrides from FactGroup
    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char*    _t1_rpsFactName;      
    // static const char*    _t2_rpsFactName;          
    // static const char*    _t3_rpsFactName;  
    // static const char*    _t3_angleFactName;        
    // static const char*    _t4_rpsFactName;      
    // static const char*    _t4_angleFactName;        
    // static const char*    _nav_modeFactName;     
    // static const char*    _nav_rollFactName;     
    // static const char*    _nav_pitchFactName;    
    // static const char*    _nav_yawFactName;      
    // static const char*    _nav_cogFactName;      
    // static const char*    _nav_sogFactName;      
    // static const char*    _nav_uspdFactName;     
    // static const char*    _nav_vspdFactName;     
    static const char*    _nav_longitudeFactName;
    static const char*    _nav_latitudeFactName; 
    // static const char*    _nav_gpstimeFactName;  
    // static const char*    _wea_airtemFactName;   
    // static const char*    _wea_wattemFactName;   
    // static const char*    _wea_pressFactName;    
    // static const char*    _wea_relhumFactName;   
    // static const char*    _wea_windirtFactName;  
    // static const char*    _wea_winspdtFactName;  
    // static const char*    _wea_watdirFactName;   
    // static const char*    _wea_watspdFactName;   
    // static const char*    _wea_visibiranFactName;

protected:
    void _handleKRISOStatus   (mavlink_message_t& message);



    Fact        _t1_rps;
    // Fact        _t2_rps;
    // Fact        _t3_rps;
    // Fact        _t3_angle;
    // Fact        _t4_rps   ;
    // Fact        _t4_angle ;
    // Fact        _nav_mode ;
    // Fact        _nav_roll ;
    // Fact        _nav_pitch;
    // Fact        _nav_yaw  ;
    // Fact        _nav_cog  ;
    // Fact        _nav_sog  ;
    // Fact        _nav_uspd ;
    // Fact        _nav_vspd ;
    Fact        _nav_longitude;
    Fact        _nav_latitude;
    // Fact        _nav_gpstime ;
    // Fact        _wea_airtem  ;
    // Fact        _wea_wattem  ;
    // Fact        _wea_press   ;
    // Fact        _wea_relhum  ;
    // Fact        _wea_windirt ;
    // Fact        _wea_winspdt ;
    // Fact        _wea_watdir  ;
    // Fact        _wea_watspd  ;
    // Fact        _wea_visibiran;
};
