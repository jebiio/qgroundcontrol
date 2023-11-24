/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KrisoPLCtoVCCFactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"



const char* KrisoPLCtoVCCFactGroup::_mr_mtr_staFactName = "mr_mtr_sta";   
const char* KrisoPLCtoVCCFactGroup::_mr_flt_msg_err1FactName = "mr_flt_msg_err1";    
const char* KrisoPLCtoVCCFactGroup::_mr_flt_msg_err2FactName = "mr_flt_msg_err2";   
const char* KrisoPLCtoVCCFactGroup::_mr_flt_msg_warn1FactName = "mr_flt_msg_warn1";     
const char* KrisoPLCtoVCCFactGroup::_mr_flt_msg_warn2FactName = "mr_flt_msg_warn2";   
const char* KrisoPLCtoVCCFactGroup::_mr_mtr_curr_realFactName = "mr_mtr_curr_real";    
const char* KrisoPLCtoVCCFactGroup::_mr_tempFactName = "mr_temp";    
const char* KrisoPLCtoVCCFactGroup::_mr_mtr_rpm_realFactName = "mr_mtr_rpm_real";    
const char* KrisoPLCtoVCCFactGroup::_mr_mtr_rot_realFactName = "mr_mtr_rot_real";    
const char* KrisoPLCtoVCCFactGroup::_ml_mtr_staFactName = "ml_mtr_sta";    
const char* KrisoPLCtoVCCFactGroup::_ml_flt_msg_err1FactName = "ml_flt_msg_err1";    
const char* KrisoPLCtoVCCFactGroup::_ml_flt_msg_err2FactName = "ml_flt_msg_err2";    
const char* KrisoPLCtoVCCFactGroup::_ml_flt_msg_warn1FactName = "ml_flt_msg_warn1";    
const char* KrisoPLCtoVCCFactGroup::_ml_flt_msg_warn2FactName = "ml_flt_msg_warn2";      
const char* KrisoPLCtoVCCFactGroup::_ml_mtr_curr_realFactName = "ml_mtr_curr_real";     
const char* KrisoPLCtoVCCFactGroup::_ml_tempFactName = "ml_temp";     
const char* KrisoPLCtoVCCFactGroup::_ml_mtr_rpm_realFactName = "ml_mtr_rpm_real";     
const char* KrisoPLCtoVCCFactGroup::_ml_mtr_rot_realFactName = "ml_mtr_rot_real";     
const char* KrisoPLCtoVCCFactGroup::_br_mtr_staFactName = "br_mtr_sta";     
const char* KrisoPLCtoVCCFactGroup::_br_flt_msgFactName = "br_flt_msg";    
const char* KrisoPLCtoVCCFactGroup::_br_mtr_curr_realFactName = "br_mtr_curr_real";   
const char* KrisoPLCtoVCCFactGroup::_br_tempFactName = "br_temp";    
const char* KrisoPLCtoVCCFactGroup::_br_mtr_rpmFactName = "br_mtr_rpm";   
const char* KrisoPLCtoVCCFactGroup::_br_mtr_rot_staFactName = "br_mtr_rot_sta";     
const char* KrisoPLCtoVCCFactGroup::_bl_mtr_staFactName = "bl_mtr_sta";   
const char* KrisoPLCtoVCCFactGroup::_bl_flt_msgFactName = "bl_flt_msg";    
const char* KrisoPLCtoVCCFactGroup::_bl_mtr_curr_realFactName = "bl_mtr_curr_real";    
const char* KrisoPLCtoVCCFactGroup::_bl_tempFactName = "bl_temp";    
const char* KrisoPLCtoVCCFactGroup::_bl_mtr_rpmFactName = "bl_mtr_rpm";    
const char* KrisoPLCtoVCCFactGroup::_bl_mtr_rot_staFactName = "bl_mtr_rot_sta";    
const char* KrisoPLCtoVCCFactGroup::_sr_str_rpmFactName = "sr_str_rpm";    
const char* KrisoPLCtoVCCFactGroup::_sr_str_angFactName = "sr_str_ang";    
const char* KrisoPLCtoVCCFactGroup::_sl_str_rpmFactName = "sl_str_rpm";    
const char* KrisoPLCtoVCCFactGroup::_sl_str_angFactName = "sl_str_ang";      
const char* KrisoPLCtoVCCFactGroup::_batt400vdcFactName = "batt400vdc";     
const char* KrisoPLCtoVCCFactGroup::_batt24vdc_1FactName = "batt24vdc_1";     
const char* KrisoPLCtoVCCFactGroup::_batt24vdc_2FactName = "batt24vdc_2";    


KrisoPLCtoVCCFactGroup::KrisoPLCtoVCCFactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/KrisoPLCtoVCCFact.json", parent)
    , _mr_mtr_sta                   (0, _mr_mtr_staFactName, FactMetaData::valueTypeInt16)  
    , _mr_flt_msg_err1              (0, _mr_flt_msg_err1FactName, FactMetaData::valueTypeInt16)  
    , _mr_flt_msg_err2              (0, _mr_flt_msg_err2FactName, FactMetaData::valueTypeInt16)   
    , _mr_flt_msg_warn1             (0, _mr_flt_msg_warn1FactName, FactMetaData::valueTypeInt16)   
    , _mr_flt_msg_warn2             (0, _mr_flt_msg_warn2FactName, FactMetaData::valueTypeInt16)   
    , _mr_mtr_curr_real             (0, _mr_mtr_curr_realFactName, FactMetaData::valueTypeInt16)   
    , _mr_temp                      (0, _mr_tempFactName, FactMetaData::valueTypeInt16)    
    , _mr_mtr_rpm_real              (0, _mr_mtr_rpm_realFactName, FactMetaData::valueTypeInt16)    
    , _mr_mtr_rot_real              (0, _mr_mtr_rot_realFactName, FactMetaData::valueTypeInt16)   
    , _ml_mtr_sta                   (0, _ml_mtr_staFactName, FactMetaData::valueTypeInt16)   
    , _ml_flt_msg_err1              (0, _ml_flt_msg_err1FactName, FactMetaData::valueTypeInt16)   
    , _ml_flt_msg_err2              (0, _ml_flt_msg_err2FactName, FactMetaData::valueTypeInt16)   
    , _ml_flt_msg_warn1             (0, _ml_flt_msg_warn1FactName, FactMetaData::valueTypeInt16)  
    , _ml_flt_msg_warn2             (0, _ml_flt_msg_warn2FactName, FactMetaData::valueTypeInt16)  
    , _ml_mtr_curr_real             (0, _ml_mtr_curr_realFactName, FactMetaData::valueTypeInt16)  
    , _ml_temp                      (0, _ml_tempFactName, FactMetaData::valueTypeInt16)  
    , _ml_mtr_rpm_real              (0, _ml_mtr_rpm_realFactName, FactMetaData::valueTypeInt16)  
    , _ml_mtr_rot_real              (0, _ml_mtr_rot_realFactName, FactMetaData::valueTypeInt16)  
    , _br_mtr_sta                   (0, _br_mtr_staFactName, FactMetaData::valueTypeInt16)  
    , _br_flt_msg                   (0, _br_flt_msgFactName, FactMetaData::valueTypeInt16)  
    , _br_mtr_curr_real             (0, _br_mtr_curr_realFactName, FactMetaData::valueTypeInt16)    
    , _br_temp                      (0, _br_tempFactName, FactMetaData::valueTypeInt16)   
    , _br_mtr_rpm                   (0, _br_mtr_rpmFactName, FactMetaData::valueTypeInt16)   
    , _br_mtr_rot_sta               (0, _br_mtr_rot_staFactName, FactMetaData::valueTypeInt16)   
    , _bl_mtr_sta                   (0, _bl_mtr_staFactName, FactMetaData::valueTypeInt16)   
    , _bl_flt_msg                   (0, _bl_flt_msgFactName, FactMetaData::valueTypeInt16)  
    , _bl_mtr_curr_real             (0, _bl_mtr_curr_realFactName, FactMetaData::valueTypeInt16)  
    , _bl_temp                      (0, _bl_tempFactName, FactMetaData::valueTypeInt16)  
    , _bl_mtr_rpm                   (0, _bl_mtr_rpmFactName, FactMetaData::valueTypeInt16)  
    , _bl_mtr_rot_sta               (0, _bl_mtr_rot_staFactName, FactMetaData::valueTypeInt16)  
    , _sr_str_rpm                   (0, _sr_str_rpmFactName, FactMetaData::valueTypeInt16)  
    , _sr_str_ang                   (0, _sr_str_angFactName, FactMetaData::valueTypeInt16)  
    , _sl_str_rpm                   (0, _sl_str_rpmFactName, FactMetaData::valueTypeInt16)  
    , _sl_str_ang                   (0, _sl_str_angFactName, FactMetaData::valueTypeInt16)  
    , _batt400vdc                   (0, _batt400vdcFactName, FactMetaData::valueTypeInt16)  
    , _batt24vdc_1                  (0, _batt24vdc_1FactName, FactMetaData::valueTypeInt16)  
    , _batt24vdc_2                  (0, _batt24vdc_2FactName, FactMetaData::valueTypeInt16)  
{
    _addFact(&_mr_mtr_sta, _mr_mtr_staFactName);
    _addFact(&_mr_flt_msg_err1, _mr_flt_msg_err1FactName);
    _addFact(&_mr_flt_msg_err2, _mr_flt_msg_err2FactName);
    _addFact(&_mr_flt_msg_warn1, _mr_flt_msg_warn1FactName);
    _addFact(&_mr_flt_msg_warn2, _mr_flt_msg_warn2FactName);
    _addFact(&_mr_mtr_curr_real, _mr_mtr_curr_realFactName);
    _addFact(&_mr_temp, _mr_tempFactName);
    _addFact(&_mr_mtr_rpm_real, _mr_mtr_rpm_realFactName);
    _addFact(&_mr_mtr_rot_real, _mr_mtr_rot_realFactName);
    _addFact(&_ml_mtr_sta, _ml_mtr_staFactName);
    _addFact(&_ml_flt_msg_err1, _ml_flt_msg_err1FactName);
    _addFact(&_ml_flt_msg_err2, _ml_flt_msg_err2FactName);
    _addFact(&_ml_flt_msg_warn1, _ml_flt_msg_warn1FactName);
    _addFact(&_ml_flt_msg_warn2, _ml_flt_msg_warn2FactName);
    _addFact(&_ml_mtr_curr_real, _ml_mtr_curr_realFactName);
    _addFact(&_ml_temp, _ml_tempFactName);
    _addFact(&_ml_mtr_rpm_real, _ml_mtr_rpm_realFactName);
    _addFact(&_ml_mtr_rot_real, _ml_mtr_rot_realFactName);
    _addFact(&_br_mtr_sta, _br_mtr_staFactName);
    _addFact(&_br_flt_msg, _br_flt_msgFactName);
    _addFact(&_br_mtr_curr_real, _br_mtr_curr_realFactName);
    _addFact(&_br_temp, _br_tempFactName);
    _addFact(&_br_mtr_rpm, _br_mtr_rpmFactName);
    _addFact(&_br_mtr_rot_sta, _br_mtr_rot_staFactName);
    _addFact(&_bl_mtr_sta, _bl_mtr_staFactName);
    _addFact(&_bl_flt_msg, _bl_flt_msgFactName);
    _addFact(&_bl_mtr_curr_real, _bl_mtr_curr_realFactName);
    _addFact(&_bl_temp, _bl_tempFactName);
    _addFact(&_bl_mtr_rpm, _bl_mtr_rpmFactName);
    _addFact(&_bl_mtr_rot_sta, _bl_mtr_rot_staFactName);
    _addFact(&_sr_str_rpm, _sr_str_rpmFactName);
    _addFact(&_sr_str_ang, _sr_str_angFactName);
    _addFact(&_sl_str_rpm, _sl_str_rpmFactName);
    _addFact(&_sl_str_ang, _sl_str_angFactName);
    _addFact(&_batt400vdc, _batt400vdcFactName);
    _addFact(&_batt24vdc_1, _batt24vdc_1FactName);
    _addFact(&_batt24vdc_2, _batt24vdc_2FactName);


    _mr_mtr_sta.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_flt_msg_err1.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_flt_msg_err2.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_flt_msg_warn1.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_flt_msg_warn2.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_mtr_curr_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_temp.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_mtr_rpm_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _mr_mtr_rot_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_mtr_sta.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_flt_msg_err1.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_flt_msg_err2.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_flt_msg_warn1.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_flt_msg_warn2.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_mtr_curr_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_temp.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_mtr_rpm_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _ml_mtr_rot_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _br_mtr_sta.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _br_flt_msg.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _br_mtr_curr_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _br_temp.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _br_mtr_rpm.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _br_mtr_rot_sta.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _bl_mtr_sta.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _bl_flt_msg.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _bl_mtr_curr_real.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _bl_temp.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _bl_mtr_rpm.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _bl_mtr_rot_sta.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _sr_str_rpm.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _sr_str_ang.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _sl_str_rpm.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _sl_str_ang.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _batt400vdc.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _batt24vdc_1.setRawValue(std::numeric_limits<int>::quiet_NaN());
    _batt24vdc_2.setRawValue(std::numeric_limits<int>::quiet_NaN());



}

void KrisoPLCtoVCCFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_KRISO_PLC_TO_VCC:
        _handleKRISOPlcToVcc(message);
        break;
    case MAVLINK_MSG_ID_HIGH_LATENCY:
        // _handleHighLatency(message);
        break;
    case MAVLINK_MSG_ID_HIGH_LATENCY2:
        // _handleHighLatency2(message);
        break;
    default:
        break;
    }
}

void KrisoPLCtoVCCFactGroup::_handleKRISOPlcToVcc(mavlink_message_t& message)
{

    mavlink_kriso_plc_to_vcc_t krisoPLCtoVCC;
    mavlink_msg_kriso_plc_to_vcc_decode(&message, &krisoPLCtoVCC);

    mr_mtr_sta()->setRawValue(krisoPLCtoVCC.mr_mtr_sta);
    mr_flt_msg_err1()->setRawValue(krisoPLCtoVCC.mr_flt_msg_err1);
    mr_flt_msg_err2()->setRawValue(krisoPLCtoVCC.mr_flt_msg_err2);
    mr_flt_msg_warn1()->setRawValue(krisoPLCtoVCC.mr_flt_msg_warn1);
    mr_flt_msg_warn2()->setRawValue(krisoPLCtoVCC.mr_flt_msg_warn2);
    mr_mtr_curr_real()->setRawValue(krisoPLCtoVCC.mr_mtr_curr_real);
    mr_temp()->setRawValue(krisoPLCtoVCC.mr_temp);
    mr_mtr_rpm_real()->setRawValue(krisoPLCtoVCC.mr_mtr_rpm_real);
    mr_mtr_rot_real()->setRawValue(krisoPLCtoVCC.mr_mtr_rot_real);
    ml_mtr_sta()->setRawValue(krisoPLCtoVCC.ml_mtr_sta);
    ml_flt_msg_err1()->setRawValue(krisoPLCtoVCC.ml_flt_msg_err1);
    ml_flt_msg_err2()->setRawValue(krisoPLCtoVCC.ml_flt_msg_err2);
    ml_flt_msg_warn1()->setRawValue(krisoPLCtoVCC.ml_flt_msg_warn1);
    ml_flt_msg_warn2()->setRawValue(krisoPLCtoVCC.ml_flt_msg_warn2);
    ml_mtr_curr_real()->setRawValue(krisoPLCtoVCC.ml_mtr_curr_real);
    ml_temp()->setRawValue(krisoPLCtoVCC.ml_temp);
    ml_mtr_rpm_real()->setRawValue(krisoPLCtoVCC.ml_mtr_rpm_real);
    ml_mtr_rot_real()->setRawValue(krisoPLCtoVCC.ml_mtr_rot_real);
    br_mtr_sta()->setRawValue(krisoPLCtoVCC.br_mtr_sta);
    br_flt_msg()->setRawValue(krisoPLCtoVCC.br_flt_msg);
    br_mtr_curr_real()->setRawValue(krisoPLCtoVCC.br_mtr_curr_real);
    br_temp()->setRawValue(krisoPLCtoVCC.br_temp);
    br_mtr_rpm()->setRawValue(krisoPLCtoVCC.br_mtr_rpm);
    br_mtr_rot_sta()->setRawValue(krisoPLCtoVCC.br_mtr_rot_sta);
    bl_mtr_sta()->setRawValue(krisoPLCtoVCC.bl_mtr_sta);
    bl_flt_msg()->setRawValue(krisoPLCtoVCC.bl_flt_msg);
    bl_mtr_curr_real()->setRawValue(krisoPLCtoVCC.bl_mtr_curr_real);
    bl_temp()->setRawValue(krisoPLCtoVCC.bl_temp);
    bl_mtr_rpm()->setRawValue(krisoPLCtoVCC.bl_mtr_rpm);
    bl_mtr_rot_sta()->setRawValue(krisoPLCtoVCC.bl_mtr_rot_sta);
    sr_str_rpm()->setRawValue(krisoPLCtoVCC.sr_str_rpm);
    sr_str_ang()->setRawValue(krisoPLCtoVCC.sr_str_ang);
    sl_str_rpm()->setRawValue(krisoPLCtoVCC.sl_str_rpm);
    sl_str_ang()->setRawValue(krisoPLCtoVCC.sl_str_ang);
    batt400vdc()->setRawValue(krisoPLCtoVCC.batt400vdc);
    batt24vdc_1()->setRawValue(krisoPLCtoVCC.batt24vdc_1);
    batt24vdc_2()->setRawValue(krisoPLCtoVCC.batt24vdc_2);
}
