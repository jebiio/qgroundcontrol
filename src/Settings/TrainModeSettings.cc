/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "TrainModeSettings.h"

#include <QQmlEngine>
#include <QtQml>

DECLARE_SETTINGGROUP(TrainMode, "TrainMode")
{
    qmlRegisterUncreatableType<TrainModeSettings>("QGroundControl.SettingsManager", 1, 0, "TrainModeSettings", "Reference only");
}

DECLARE_SETTINGSFACT(TrainModeSettings, trainPath)
DECLARE_SETTINGSFACT(TrainModeSettings, validPath)
DECLARE_SETTINGSFACT(TrainModeSettings, testPath)
DECLARE_SETTINGSFACT(TrainModeSettings, resultPath)
DECLARE_SETTINGSFACT(TrainModeSettings, seed)
DECLARE_SETTINGSFACT(TrainModeSettings, model)
DECLARE_SETTINGSFACT(TrainModeSettings, selectiveMethod)
DECLARE_SETTINGSFACT(TrainModeSettings, varToForecast)
DECLARE_SETTINGSFACT(TrainModeSettings, pastWindowsSize)
DECLARE_SETTINGSFACT(TrainModeSettings, futureWindowsSize)
DECLARE_SETTINGSFACT(TrainModeSettings, epoch)
DECLARE_SETTINGSFACT(TrainModeSettings, batch)
DECLARE_SETTINGSFACT(TrainModeSettings, numWorkers)
DECLARE_SETTINGSFACT(TrainModeSettings, lr)
DECLARE_SETTINGSFACT(TrainModeSettings, weight)
