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

class KrisoCKtoVCCFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoCKtoVCCFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact*  psi_d               READ    psi_d     CONSTANT)
    Q_PROPERTY(Fact*  spd_d               READ    spd_d      CONSTANT)

    Fact*       psi_d        (){return &_psi_d;}
    Fact*       spd_d        (){return &_spd_d;}

    // Overrides from FactGroup

    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _psi_dFactName;
    static const char* _spd_dFactName;


protected:
    void _handleKRISOCKtoVCC(mavlink_message_t& message);
    Fact        _psi_d;
    Fact        _spd_d;
};
