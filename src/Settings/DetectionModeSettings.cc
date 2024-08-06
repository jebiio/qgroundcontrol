
#include "DetectionModeSettings.h"

#include <QQmlEngine>
#include <QtQml>

DECLARE_SETTINGGROUP(DetectionMode, "DetectionMode")
{
    qmlRegisterUncreatableType<DetectionModeSettings>("QGroundControl.SettingsManager", 1, 0, "DetectionModeSettings", "Reference only");
}



DECLARE_SETTINGSFACT(DetectionModeSettings, model)
DECLARE_SETTINGSFACT(DetectionModeSettings, modelPath)
DECLARE_SETTINGSFACT(DetectionModeSettings, pastWindowsSize)
DECLARE_SETTINGSFACT(DetectionModeSettings, futureWindowsSize)
DECLARE_SETTINGSFACT(DetectionModeSettings, epoch)
DECLARE_SETTINGSFACT(DetectionModeSettings, batch)
DECLARE_SETTINGSFACT(DetectionModeSettings, numWorkers)
DECLARE_SETTINGSFACT(DetectionModeSettings, lr)
DECLARE_SETTINGSFACT(DetectionModeSettings, weightDecay)
