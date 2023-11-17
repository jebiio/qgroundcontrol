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



class KrisoPLCtoVCCFactGroup : public FactGroup
{
    Q_OBJECT

public:
    KrisoPLCtoVCCFactGroup(QObject* parent = nullptr);

  
    Q_PROPERTY(Fact* mr_mtr_sta            READ mr_mtr_sta      CONSTANT)
    Q_PROPERTY(Fact* mr_flt_msg_err1       READ mr_flt_msg_err1     CONSTANT)
    Q_PROPERTY(Fact* mr_flt_msg_err2       READ mr_flt_msg_err2     CONSTANT)
    Q_PROPERTY(Fact* mr_flt_msg_warn1      READ mr_flt_msg_warn1        CONSTANT)
    Q_PROPERTY(Fact* mr_flt_msg_warn2      READ mr_flt_msg_warn2        CONSTANT)
    Q_PROPERTY(Fact* mr_mtr_curr_real      READ mr_mtr_curr_real        CONSTANT)
    Q_PROPERTY(Fact* mr_temp               READ mr_temp     CONSTANT)
    Q_PROPERTY(Fact* mr_mtr_rpm_real       READ mr_mtr_rpm_real     CONSTANT)
    Q_PROPERTY(Fact* mr_mtr_rot_real       READ mr_mtr_rot_real     CONSTANT)
    Q_PROPERTY(Fact* ml_mtr_sta            READ ml_mtr_sta      CONSTANT)
    Q_PROPERTY(Fact* ml_flt_msg_err1       READ ml_flt_msg_err1     CONSTANT)
    Q_PROPERTY(Fact* ml_flt_msg_err2       READ ml_flt_msg_err2     CONSTANT)
    Q_PROPERTY(Fact* ml_flt_msg_warn1      READ ml_flt_msg_warn1        CONSTANT)
    Q_PROPERTY(Fact* ml_flt_msg_warn2      READ ml_flt_msg_warn2        CONSTANT)
    Q_PROPERTY(Fact* ml_mtr_curr_real      READ ml_mtr_curr_real        CONSTANT)
    Q_PROPERTY(Fact* ml_temp               READ ml_temp     CONSTANT)
    Q_PROPERTY(Fact* ml_mtr_rpm_real       READ ml_mtr_rpm_real     CONSTANT)
    Q_PROPERTY(Fact* ml_mtr_rot_real       READ ml_mtr_rot_real     CONSTANT)
    Q_PROPERTY(Fact* br_mtr_sta            READ br_mtr_sta      CONSTANT)
    Q_PROPERTY(Fact* br_flt_msg            READ br_flt_msg      CONSTANT)
    Q_PROPERTY(Fact* br_mtr_curr_real      READ br_mtr_curr_real        CONSTANT)
    Q_PROPERTY(Fact* br_temp               READ br_temp     CONSTANT)
    Q_PROPERTY(Fact* br_mtr_rpm            READ br_mtr_rpm      CONSTANT)
    Q_PROPERTY(Fact* br_mtr_rot_sta        READ br_mtr_rot_sta      CONSTANT)
    Q_PROPERTY(Fact* bl_mtr_sta            READ bl_mtr_sta      CONSTANT)
    Q_PROPERTY(Fact* bl_flt_msg            READ bl_flt_msg      CONSTANT)
    Q_PROPERTY(Fact* bl_mtr_curr_real      READ bl_mtr_curr_real        CONSTANT)
    Q_PROPERTY(Fact* bl_temp               READ bl_temp     CONSTANT)
    Q_PROPERTY(Fact* bl_mtr_rpm            READ bl_mtr_rpm      CONSTANT)
    Q_PROPERTY(Fact* bl_mtr_rot_sta        READ bl_mtr_rot_sta      CONSTANT)
    Q_PROPERTY(Fact* sr_str_rpm            READ sr_str_rpm      CONSTANT)
    Q_PROPERTY(Fact* sr_str_ang            READ sr_str_ang      CONSTANT)
    Q_PROPERTY(Fact* sl_str_rpm            READ sl_str_rpm      CONSTANT)
    Q_PROPERTY(Fact* sl_str_ang            READ sl_str_ang      CONSTANT)
    Q_PROPERTY(Fact* batt400vdc            READ batt400vdc      CONSTANT)
    Q_PROPERTY(Fact* batt24vdc_1           READ batt24vdc_1     CONSTANT)
    Q_PROPERTY(Fact* batt24vdc_2           READ batt24vdc_2     CONSTANT)

    Fact*   mr_mtr_sta                  (){return &_mr_mtr_sta;}                
    Fact*   mr_flt_msg_err1             (){return &_mr_flt_msg_err1;}               
    Fact*   mr_flt_msg_err2             (){return &_mr_flt_msg_err2;}           
    Fact*   mr_flt_msg_warn1            (){return &_mr_flt_msg_warn1;}            
    Fact*   mr_flt_msg_warn2            (){return &_mr_flt_msg_warn2;}          
    Fact*   mr_mtr_curr_real            (){return &_mr_mtr_curr_real;}               
    Fact*   mr_temp                     (){return &_mr_temp;}          
    Fact*   mr_mtr_rpm_real             (){return &_mr_mtr_rpm_real;}          
    Fact*   mr_mtr_rot_real             (){return &_mr_mtr_rot_real;}           
    Fact*   ml_mtr_sta                  (){return &_ml_mtr_sta;}           
    Fact*   ml_flt_msg_err1             (){return &_ml_flt_msg_err1;}           
    Fact*   ml_flt_msg_err2             (){return &_ml_flt_msg_err2;}            
    Fact*   ml_flt_msg_warn1            (){return &_ml_flt_msg_warn1;}              
    Fact*   ml_flt_msg_warn2            (){return &_ml_flt_msg_warn2;}             
    Fact*   ml_mtr_curr_real            (){return &_ml_mtr_curr_real;}             
    Fact*   ml_temp                     (){return &_ml_temp;}            
    Fact*   ml_mtr_rpm_real             (){return &_ml_mtr_rpm_real;}             
    Fact*   ml_mtr_rot_real             (){return &_ml_mtr_rot_real;}            
    Fact*   br_mtr_sta                  (){return &_br_mtr_sta;}              
    Fact*   br_flt_msg                  (){return &_br_flt_msg;}          
    Fact*   br_mtr_curr_real            (){return &_br_mtr_curr_real;}          
    Fact*   br_temp                     (){return &_br_temp;}          
    Fact*   br_mtr_rpm                  (){return &_br_mtr_rpm;}           
    Fact*   br_mtr_rot_sta              (){return &_br_mtr_rot_sta;}           
    Fact*   bl_mtr_sta                  (){return &_bl_mtr_sta;}           
    Fact*   bl_flt_msg                  (){return &_bl_flt_msg;}            
    Fact*   bl_mtr_curr_real            (){return &_bl_mtr_curr_real;}              
    Fact*   bl_temp                     (){return &_bl_temp;}             
    Fact*   bl_mtr_rpm                  (){return &_bl_mtr_rpm;}             
    Fact*   bl_mtr_rot_sta              (){return &_bl_mtr_rot_sta;}            
    Fact*   sr_str_rpm                  (){return &_sr_str_rpm;}             
    Fact*   sr_str_ang                  (){return &_sr_str_ang;}            
    Fact*   sl_str_rpm                  (){return &_sl_str_rpm;}              
    Fact*   sl_str_ang                  (){return &_sl_str_ang;}        
    Fact*   batt400vdc                  (){return &_batt400vdc;}             
    Fact*   batt24vdc_1                 (){return &_batt24vdc_1;}            
    Fact*   batt24vdc_2                 (){return &_batt24vdc_2;}             



    // Overrides from FactGroup
    virtual void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _mr_mtr_staFactName;
    static const char* _mr_flt_msg_err1FactName;
    static const char* _mr_flt_msg_err2FactName;
    static const char* _mr_flt_msg_warn1FactName;
    static const char* _mr_flt_msg_warn2FactName;
    static const char* _mr_mtr_curr_realFactName;
    static const char* _mr_tempFactName;
    static const char* _mr_mtr_rpm_realFactName;
    static const char* _mr_mtr_rot_realFactName;
    static const char* _ml_mtr_staFactName;
    static const char* _ml_flt_msg_err1FactName;
    static const char* _ml_flt_msg_err2FactName;
    static const char* _ml_flt_msg_warn1FactName;
    static const char* _ml_flt_msg_warn2FactName;
    static const char* _ml_mtr_curr_realFactName;
    static const char* _ml_tempFactName;
    static const char* _ml_mtr_rpm_realFactName;
    static const char* _ml_mtr_rot_realFactName;
    static const char* _br_mtr_staFactName;
    static const char* _br_flt_msgFactName;
    static const char* _br_mtr_curr_realFactName;
    static const char* _br_tempFactName;
    static const char* _br_mtr_rpmFactName;
    static const char* _br_mtr_rot_staFactName;
    static const char* _bl_mtr_staFactName;
    static const char* _bl_flt_msgFactName;
    static const char* _bl_mtr_curr_realFactName;
    static const char* _bl_tempFactName;
    static const char* _bl_mtr_rpmFactName;
    static const char* _bl_mtr_rot_staFactName;
    static const char* _sr_str_rpmFactName;
    static const char* _sr_str_angFactName;
    static const char* _sl_str_rpmFactName;
    static const char* _sl_str_angFactName;
    static const char* _batt400vdcFactName;
    static const char* _batt24vdc_1FactName;
    static const char* _batt24vdc_2FactName;


protected:
    void _handleKRISOPlcToVcc   (mavlink_message_t& message);


    Fact    _mr_mtr_sta;
    Fact    _mr_flt_msg_err1;
    Fact    _mr_flt_msg_err2;
    Fact    _mr_flt_msg_warn1;
    Fact    _mr_flt_msg_warn2;
    Fact    _mr_mtr_curr_real;
    Fact    _mr_temp;
    Fact    _mr_mtr_rpm_real;
    Fact    _mr_mtr_rot_real;
    Fact    _ml_mtr_sta;
    Fact    _ml_flt_msg_err1;
    Fact    _ml_flt_msg_err2;
    Fact    _ml_flt_msg_warn1;
    Fact    _ml_flt_msg_warn2;
    Fact    _ml_mtr_curr_real;
    Fact    _ml_temp;
    Fact    _ml_mtr_rpm_real;
    Fact    _ml_mtr_rot_real;
    Fact    _br_mtr_sta;
    Fact    _br_flt_msg;
    Fact    _br_mtr_curr_real;
    Fact    _br_temp;
    Fact    _br_mtr_rpm;
    Fact    _br_mtr_rot_sta;
    Fact    _bl_mtr_sta;
    Fact    _bl_flt_msg;
    Fact    _bl_mtr_curr_real;
    Fact    _bl_temp;
    Fact    _bl_mtr_rpm;
    Fact    _bl_mtr_rot_sta;
    Fact    _sr_str_rpm;
    Fact    _sr_str_ang;
    Fact    _sl_str_rpm;
    Fact    _sl_str_ang;
    Fact    _batt400vdc;
    Fact    _batt24vdc_1;
    Fact    _batt24vdc_2;

};
