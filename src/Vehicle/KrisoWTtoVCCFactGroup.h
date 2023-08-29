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

class KrisoWTtoVCCFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoWTtoVCCFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* psi_d                          READ psi_d                              CONSTANT)
    Q_PROPERTY(Fact* spd_d                          READ spd_d                              CONSTANT)
    Q_PROPERTY(Fact* wp_lat_d                       READ wp_lat_d                           CONSTANT)
    Q_PROPERTY(Fact* wp_lon_d                       READ wp_lon_d                           CONSTANT)
    Q_PROPERTY(Fact* track_path_idx                 READ track_path_idx                     CONSTANT)


    Fact*       psi_d                   (){return &_psi_d;}
    Fact*       spd_d                   (){return &_spd_d;}
    Fact*       wp_lat_d                (){return &_wp_lat_d;}
    Fact*       wp_lon_d                (){return &_wp_lon_d;}
    Fact*       track_path_idx          (){return &_track_path_idx;}


    // Overrides from FactGroup
    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _psi_dFactName;
    static const char* _spd_dFactName;
    static const char* _wp_lat_dFactName;
    static const char* _wp_lon_dFactName;
    static const char* _track_path_idxFactName;

protected:
    void _handleKrisoWTtoVCC   (mavlink_message_t& message);

    Fact        _psi_d;
    Fact        _spd_d;
    Fact        _wp_lat_d;
    Fact        _wp_lon_d;
    Fact        _track_path_idx;
};
