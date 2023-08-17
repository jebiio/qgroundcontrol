/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once
#include <QGeoCoordinate>
#include "FactGroup.h"
#include "QGCMAVLink.h"

class KrisoGainFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoGainFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* dp_surge_pgain        READ  dp_surge_pgain   CONSTANT)     
    Q_PROPERTY(Fact* dp_surge_dgain        READ  dp_surge_dgain   CONSTANT)     
    Q_PROPERTY(Fact* dp_sway_pgain         READ  dp_sway_pgain    CONSTANT)    
    Q_PROPERTY(Fact* dp_sway_dgain         READ  dp_sway_dgain    CONSTANT)    
    Q_PROPERTY(Fact* dp_yaw_pgain          READ  dp_yaw_pgain     CONSTANT)   
    Q_PROPERTY(Fact* dp_yaw_dgain          READ  dp_yaw_dgain     CONSTANT)   
    Q_PROPERTY(Fact* nav_surge_pgain       READ  nav_surge_pgain  CONSTANT)      
    Q_PROPERTY(Fact* nav_surge_dgain       READ  nav_surge_dgain  CONSTANT)      
    Q_PROPERTY(Fact* nav_yaw_pgain         READ  nav_yaw_pgain    CONSTANT)    
    Q_PROPERTY(Fact* nav_yaw_dgain         READ  nav_yaw_dgain    CONSTANT)    
    Q_PROPERTY(Fact* lat                   READ  lat              CONSTANT)
    Q_PROPERTY(Fact* lon                   READ  lon              CONSTANT)
    Q_PROPERTY(Fact* dp_yaw                READ  dp_yaw           CONSTANT)
    Q_PROPERTY(Fact* spd_cmd               READ  spd_cmd          CONSTANT)
    Q_PROPERTY(Fact* hdg_cmd               READ  hdg_cmd          CONSTANT)

    Fact*       dp_surge_pgain    (){return &_dp_surge_pgain;}  
    Fact*       dp_surge_dgain    (){return &_dp_surge_dgain;}  
    Fact*       dp_sway_pgain     (){return &_dp_sway_pgain;}   
    Fact*       dp_sway_dgain     (){return &_dp_sway_dgain;}   
    Fact*       dp_yaw_pgain      (){return &_dp_yaw_pgain;}    
    Fact*       dp_yaw_dgain      (){return &_dp_yaw_dgain;}    
    Fact*       nav_surge_pgain   (){return &_nav_surge_pgain;} 
    Fact*       nav_surge_dgain   (){return &_nav_surge_dgain;} 
    Fact*       nav_yaw_pgain     (){return &_nav_yaw_pgain;}   
    Fact*       nav_yaw_dgain     (){return &_nav_yaw_dgain;}   
    Fact*       lat               () {return &_lat; }
    Fact*       lon               () {return &_lon; }
    Fact*       dp_yaw            () {return &_dp_yaw; }
    Fact*       spd_cmd           () {return &_spd_cmd; }
    Fact*       hdg_cmd           () {return &_hdg_cmd; }


    void updateHDGFact(float speed, float degree, float surgeP, float surgeD, float yawP, float yawD);
    void updateDPFact(float surgeP, float surgeD, float swayP, float swayD, float yawP, float yawD, float yaw);
    void updateDPCoordinateFact(QGeoCoordinate clickedCoordindate);
    


    static const char* _dp_surge_pgainFactName;
    static const char* _dp_surge_dgainFactName;
    static const char* _dp_sway_pgainFactName;
    static const char* _dp_sway_dgainFactName;
    static const char* _dp_yaw_pgainFactName;
    static const char* _dp_yaw_dgainFactName;
    static const char* _nav_surge_pgainFactName;
    static const char* _nav_surge_dgainFactName;
    static const char* _nav_yaw_pgainFactName;
    static const char* _nav_yaw_dgainFactName;    
    static const char* _latFactName;
    static const char* _lonFactName;
    static const char* _dp_yawFactName;
    static const char* _spd_cmdFactName;
    static const char* _hdg_cmdFactName;
    

protected:

    Fact        _dp_surge_pgain;
    Fact        _dp_surge_dgain;
    Fact        _dp_sway_pgain;
    Fact        _dp_sway_dgain;
    Fact        _dp_yaw_pgain;
    Fact        _dp_yaw_dgain;
    Fact        _nav_surge_pgain;
    Fact        _nav_surge_dgain;
    Fact        _nav_yaw_pgain;
    Fact        _nav_yaw_dgain;
    Fact        _lat;
    Fact        _lon;
    Fact        _dp_yaw;
    Fact        _spd_cmd;
    Fact        _hdg_cmd;

};
