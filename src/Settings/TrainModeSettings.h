
#pragma once

#include "SettingsGroup.h"

class TrainModeSettings : public SettingsGroup
{
    Q_OBJECT
public:
    TrainModeSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(trainPath)
    DEFINE_SETTINGFACT(validPath)
    DEFINE_SETTINGFACT(testPath)
    DEFINE_SETTINGFACT(resultPath)
    DEFINE_SETTINGFACT(seed)
    DEFINE_SETTINGFACT(model)
    DEFINE_SETTINGFACT(selectiveMethod)
    DEFINE_SETTINGFACT(varToForecast)
    DEFINE_SETTINGFACT(pastWindowsSize)
    DEFINE_SETTINGFACT(futureWindowsSize)
    DEFINE_SETTINGFACT(epoch)
    DEFINE_SETTINGFACT(batch)
    DEFINE_SETTINGFACT(numWorkers)
    DEFINE_SETTINGFACT(lr)
    DEFINE_SETTINGFACT(weight)

};
