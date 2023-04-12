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

class KrisoVoltageStatusFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoVoltageStatusFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* t1_rpm                     READ ch1_volt               CONSTANT)
    Q_PROPERTY(Fact* ch2_volt                   READ ch2_volt               CONSTANT)
    Q_PROPERTY(Fact* ch3_volt                   READ ch3_volt               CONSTANT)
    Q_PROPERTY(Fact* ch4_volt                   READ ch4_volt               CONSTANT)


    Fact*       ch1_volt                        (){return &_ch1_volt;}
    Fact*       ch2_volt                        (){return &_ch2_volt;}
    Fact*       ch3_volt                        (){return &_ch3_volt;}
    Fact*       ch4_volt                        (){return &_ch4_volt;}


    // Overrides from FactGroup
    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _ch1_voltFactName;
    static const char* _ch2_voltFactName;
    static const char* _ch3_voltFactName;
    static const char* _ch4_voltFactName;

protected:
    void _handleKrisoVolStatus   (mavlink_message_t& message);

    Fact        _ch1_volt;
    Fact        _ch2_volt;
    Fact        _ch3_volt;
    Fact        _ch4_volt;
};
