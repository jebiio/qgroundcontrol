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

class KrisoCmdFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoCmdFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact*  t1_rpm                    READ t1_rpm         CONSTANT)
    Q_PROPERTY(Fact*  t2_rpm                    READ t2_rpm         CONSTANT)
    Q_PROPERTY(Fact*  t3_rpm                    READ t3_rpm         CONSTANT)
    Q_PROPERTY(Fact*  t3_angle                  READ t3_angle       CONSTANT)
    Q_PROPERTY(Fact*  t4_rpm                    READ t4_rpm         CONSTANT)
    Q_PROPERTY(Fact*  t4_angle                  READ t4_angle       CONSTANT)
    Q_PROPERTY(Fact*  oper_mode                 READ oper_mode      CONSTANT)     
    Q_PROPERTY(Fact*  mission_mode              READ mission_mode   CONSTANT)     

 

    Fact*       t1_rpm            (){return &_t1_rpm;}
    Fact*       t2_rpm            (){return &_t2_rpm;}
    Fact*       t3_rpm            (){return &_t3_rpm;}
    Fact*       t3_angle          (){return &_t3_angle;}    
    Fact*       t4_rpm            (){return &_t4_rpm;}
    Fact*       t4_angle          (){return &_t4_angle;}    
    Fact*       oper_mode         (){return &_oper_mode;}  
    Fact*       mission_mode      (){return &_mission_mode;}  


    // Overrides from FactGroup

    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _t1_rpmFactName;
    static const char* _t2_rpmFactName;
    static const char* _t3_rpmFactName;
    static const char* _t3_angleFactName;
    static const char* _t4_rpmFactName;
    static const char* _t4_angleFactName;
    static const char* _oper_modeFactName;
    static const char* _mission_modeFactName;


protected:
    void _handleKRISOSCommand(mavlink_message_t& message);
    
    Fact        _t1_rpm;
    Fact        _t2_rpm;
    Fact        _t3_rpm;
    Fact        _t3_angle;
    Fact        _t4_rpm;
    Fact        _t4_angle;
    Fact        _oper_mode;
    Fact        _mission_mode;

};
