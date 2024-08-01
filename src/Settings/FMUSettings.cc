
#include "FMUSettings.h"

#include <QQmlEngine>
#include <QtQml>

DECLARE_SETTINGGROUP(FMU, "FMU")
{
    qmlRegisterUncreatableType<FMUSettings>("QGroundControl.SettingsManager", 1, 0, "FMUSettings", "Reference only");
}

DECLARE_SETTINGSFACT(FMUSettings, forwarderServerIP)
DECLARE_SETTINGSFACT(FMUSettings, forwarderServerPort)
DECLARE_SETTINGSFACT(FMUSettings, forwarderReceivePort)
DECLARE_SETTINGSFACT(FMUSettings, EngineServerIP)
DECLARE_SETTINGSFACT(FMUSettings, EngineServerTCPPort)
DECLARE_SETTINGSFACT(FMUSettings, EngineServerUDPPort)
DECLARE_SETTINGSFACT(FMUSettings, EngineReceivePort)
