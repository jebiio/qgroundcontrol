
#pragma once

#include "SettingsGroup.h"

class FMUSettings : public SettingsGroup
{
    Q_OBJECT
public:
    FMUSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(forwarderServerIP)
    DEFINE_SETTINGFACT(forwarderServerPort)
    DEFINE_SETTINGFACT(forwarderListenPort)
    DEFINE_SETTINGFACT(engineServerIP)
    DEFINE_SETTINGFACT(engineServerTCPPort)
    DEFINE_SETTINGFACT(engineServerUDPPort)
    DEFINE_SETTINGFACT(engineListenUDPPort)
    DEFINE_SETTINGFACT(fmuRollRotaion)
    DEFINE_SETTINGFACT(fmuPitchRotaion)
    DEFINE_SETTINGFACT(fmuYawRotaion)
};
