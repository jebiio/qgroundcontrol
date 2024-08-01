
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
    DEFINE_SETTINGFACT(forwarderReceivePort)
    DEFINE_SETTINGFACT(EngineServerIP)
    DEFINE_SETTINGFACT(EngineServerTCPPort)
    DEFINE_SETTINGFACT(EngineServerUDPPort)
    DEFINE_SETTINGFACT(EngineReceivePort)

};
