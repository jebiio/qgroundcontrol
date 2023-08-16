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

class KrisoAISFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoAISFactGroup(QObject* parent = nullptr);

  
    Q_PROPERTY(Fact* lon                READ lon              CONSTANT)
    Q_PROPERTY(Fact* lat                READ lat              CONSTANT)
    Q_PROPERTY(Fact* msg_type           READ msg_type         CONSTANT)
    Q_PROPERTY(Fact* repeat             READ repeat           CONSTANT)
    Q_PROPERTY(Fact* mmsi               READ mmsi             CONSTANT)
    Q_PROPERTY(Fact* reserved_1         READ reserved_1       CONSTANT)
    Q_PROPERTY(Fact* speed              READ speed            CONSTANT)
    Q_PROPERTY(Fact* course             READ course           CONSTANT)
    Q_PROPERTY(Fact* heading            READ heading          CONSTANT)
    Q_PROPERTY(Fact* second             READ second           CONSTANT)
    Q_PROPERTY(Fact* reserved_2         READ reserved_2       CONSTANT)
    Q_PROPERTY(Fact* radio              READ radio            CONSTANT)
    Q_PROPERTY(Fact* accuracy           READ accuracy         CONSTANT)
    Q_PROPERTY(Fact* cs                 READ cs               CONSTANT)
    Q_PROPERTY(Fact* display            READ display          CONSTANT)
    Q_PROPERTY(Fact* dsc                READ dsc              CONSTANT)
    Q_PROPERTY(Fact* band               READ band             CONSTANT)
    Q_PROPERTY(Fact* msg22              READ msg22            CONSTANT)
    Q_PROPERTY(Fact* assigned           READ assigned         CONSTANT)
    Q_PROPERTY(Fact* raim               READ raim             CONSTANT)


    Fact*   lon            (){return &_lon;}               
    Fact*   lat            (){return &_lat;}              
    Fact*   msg_type       (){return &_msg_type;}          
    Fact*   repeat         (){return &_repeat;}           
    Fact*   mmsi           (){return &_mmsi;}         
    Fact*   reserved_1     (){return &_reserved_1;}              
    Fact*   speed          (){return &_speed;}         
    Fact*   course         (){return &_course;}         
    Fact*   heading        (){return &_heading;}          
    Fact*   second         (){return &_second;}          
    Fact*   reserved_2     (){return &_reserved_2;}          
    Fact*   radio          (){return &_radio;}           
    Fact*   accuracy       (){return &_accuracy;}             
    Fact*   cs             (){return &_cs;}            
    Fact*   display        (){return &_display;}            
    Fact*   dsc            (){return &_dsc;}           
    Fact*   band           (){return &_band;}            
    Fact*   msg22          (){return &_msg22;}           
    Fact*   assigned       (){return &_assigned;}             
    Fact*   raim           (){return &_raim;}             
 



    // Overrides from FactGroup
    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _lonFactName;
    static const char* _latFactName;
    static const char* _msg_typeFactName;
    static const char* _repeatFactName;
    static const char* _mmsiFactName;
    static const char* _reserved_1FactName;
    static const char* _speedFactName;
    static const char* _courseFactName;
    static const char* _headingFactName;
    static const char* _secondFactName;
    static const char* _reserved_2FactName;
    static const char* _radioFactName;
    static const char* _accuracyFactName;
    static const char* _csFactName;
    static const char* _displayFactName;
    static const char* _dscFactName;
    static const char* _bandFactName;
    static const char* _msg22FactName;
    static const char* _assignedFactName;
    static const char* _raimFactName;


protected:
    void _handleKRISOAISStatus   (mavlink_message_t& message);


    Fact    _lon;
    Fact    _lat;
    Fact    _msg_type;
    Fact    _repeat;
    Fact    _mmsi;
    Fact    _reserved_1;
    Fact    _speed;
    Fact    _course;
    Fact    _heading;
    Fact    _second;
    Fact    _reserved_2;
    Fact    _radio;
    Fact    _accuracy;
    Fact    _cs;
    Fact    _display;
    Fact    _dsc;
    Fact    _band;
    Fact    _msg22;
    Fact    _assigned;
    Fact    _raim;

};
