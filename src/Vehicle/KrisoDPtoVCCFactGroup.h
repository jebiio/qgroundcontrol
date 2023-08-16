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

class KrisoDPtoVCCFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoDPtoVCCFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact*  surge_error               READ    surge_error     CONSTANT)
    Q_PROPERTY(Fact*  sway_error                READ    sway_error      CONSTANT)
    Q_PROPERTY(Fact*  yaw_error                 READ    yaw_error       CONSTANT)
    Q_PROPERTY(Fact*  dp_start_stop             READ    dp_start_stop   CONSTANT)

    Fact*       surge_error        (){return &_surge_error;}
    Fact*       sway_error         (){return &_sway_error;}
    Fact*       yaw_error          (){return &_yaw_error;}
    Fact*       dp_start_stop      (){return &_dp_start_stop;}    


    // Overrides from FactGroup

    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _surge_errorFactName;
    static const char* _sway_errorFactName;
    static const char* _yaw_errorFactName;
    static const char* _dp_start_stopFactName;


protected:
    void _handleKRISODPtoVCC(mavlink_message_t& message);
    
    Fact        _surge_error;
    Fact        _sway_error;
    Fact        _yaw_error;
    Fact        _dp_start_stop;

};
