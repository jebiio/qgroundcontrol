
#include "FMUSettings.h"

#include <QQmlEngine>
#include <QtQml>

DECLARE_SETTINGGROUP(FMU, "FMU")
{
    qmlRegisterUncreatableType<FMUSettings>("QGroundControl.SettingsManager", 1, 0, "FMUSettings", "Reference only");
}

DECLARE_SETTINGSFACT(FMUSettings, forwarderServerIP)
DECLARE_SETTINGSFACT(FMUSettings, forwarderServerPort)
DECLARE_SETTINGSFACT(FMUSettings, forwarderListenPort)
DECLARE_SETTINGSFACT(FMUSettings, engineServerIP)
DECLARE_SETTINGSFACT(FMUSettings, engineServerTCPPort)
DECLARE_SETTINGSFACT(FMUSettings, engineServerUDPPort)
DECLARE_SETTINGSFACT(FMUSettings, engineListenUDPPort)
