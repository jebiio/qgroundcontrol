
#pragma once

#include "SettingsGroup.h"

class DetectionModeSettings : public SettingsGroup
{
    Q_OBJECT
public:
    DetectionModeSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(model)
    DEFINE_SETTINGFACT(modelPath)
    DEFINE_SETTINGFACT(pastWindowsSize)
    DEFINE_SETTINGFACT(futureWindowsSize)
    DEFINE_SETTINGFACT(epoch)
    DEFINE_SETTINGFACT(batch)
    DEFINE_SETTINGFACT(numWorkers)
    DEFINE_SETTINGFACT(lr)
    DEFINE_SETTINGFACT(weightDecay)

};
