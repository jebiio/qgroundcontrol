/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "QGCMapCircle.h"
#include "QGCGeo.h"
#include "JsonHelper.h"
#include "QGCQGeoCoordinate.h"

#include <QGeoRectangle>
#include <QDebug>
#include <QJsonArray>

const char* QGCMapCircle::jsonCircleKey =   "circle";
const char* QGCMapCircle::_jsonCenterKey =  "center";
const char* QGCMapCircle::_jsonRadiusKey =  "radius";
const char* QGCMapCircle::_radiusFactName = "Radius";
const char* QGCMapCircle::_jsonCenterLatKey = "centerLat";
const char* QGCMapCircle::_jsonCenterLonKey = "centerLon";
//center latitude, longitude Fact added to the FactMetaDataMap


const char* QGCMapCircle::_centerLatFactName = "CenterLat";
const char* QGCMapCircle::_centerLonFactName = "CenterLon";

QGCMapCircle::QGCMapCircle(QObject* parent)
    : QObject           (parent)
    , _dirty            (false)
    , _interactive      (false)
    , _showRotation     (false)
    , _clockwiseRotation(true)
{
    _init();
}

QGCMapCircle::QGCMapCircle(const QGeoCoordinate& center, double radius, bool showRotation, bool clockwiseRotation, QObject* parent)
    : QObject           (parent)
    , _dirty            (false)
    , _center           (center)
    , _radius           (FactSystem::defaultComponentId, _radiusFactName, FactMetaData::valueTypeDouble)
    , _centerLat        (FactSystem::defaultComponentId, _centerLatFactName, FactMetaData::valueTypeDouble)
    , _centerLon        (FactSystem::defaultComponentId, _centerLonFactName, FactMetaData::valueTypeDouble)
    , _interactive      (false)
    , _showRotation     (showRotation)
    , _clockwiseRotation(clockwiseRotation)
    
{
    _radius.setRawValue(radius);
    _centerLat.setRawValue(center.latitude());
    _centerLon.setRawValue(center.longitude());
    _init();
}

QGCMapCircle::QGCMapCircle(const QGCMapCircle& other, QObject* parent)
    : QObject           (parent)
    , _dirty            (false)
    , _center           (other._center)
    , _radius           (FactSystem::defaultComponentId, _radiusFactName, FactMetaData::valueTypeDouble)
    , _centerLat        (FactSystem::defaultComponentId, _centerLatFactName, FactMetaData::valueTypeDouble)
    , _centerLon        (FactSystem::defaultComponentId, _centerLonFactName, FactMetaData::valueTypeDouble)
    , _interactive      (false)
    , _showRotation     (other._showRotation)
    , _clockwiseRotation(other._clockwiseRotation)
{
    _radius.setRawValue(other._radius.rawValue());
    _centerLat.setRawValue(other._centerLat.rawValue());
    _centerLon.setRawValue(other._centerLon.rawValue());
    _init();
}

const QGCMapCircle& QGCMapCircle::operator=(const QGCMapCircle& other)
{
    setCenter(other._center);
    _radius.setRawValue(other._radius.rawValue());
    _centerLat.setRawValue(other._centerLat.rawValue());
    _centerLon.setRawValue(other._centerLon.rawValue());
    setDirty(true);

    return *this;
}

void QGCMapCircle::_init(void)
{
    _nameToMetaDataMap = FactMetaData::createMapFromJsonFile(QStringLiteral(":/json/QGCMapCircle.Facts.json"), this);
    _radius.setMetaData(_nameToMetaDataMap[_radiusFactName]);
    _centerLat.setMetaData(_nameToMetaDataMap[_centerLatFactName]);
    _centerLon.setMetaData(_nameToMetaDataMap[_centerLonFactName]);

    connect(this,       &QGCMapCircle::centerChanged,   this, &QGCMapCircle::_setDirty);
    connect(&_radius,   &Fact::rawValueChanged,         this, &QGCMapCircle::_setDirty);
    connect(&_centerLat, &Fact::rawValueChanged,         this, &QGCMapCircle::_setDirty);
    connect(&_centerLon, &Fact::rawValueChanged,         this, &QGCMapCircle::_setDirty);
}

void QGCMapCircle::setDirty(bool dirty)
{
    if (_dirty != dirty) {
        _dirty = dirty;
        emit dirtyChanged(dirty);
    }
}

void QGCMapCircle::saveToJson(QJsonObject& json)
{
    QJsonValue jsonValue;
    QJsonObject circleObject;

    JsonHelper::saveGeoCoordinate(_center, false /* writeAltitude*/, jsonValue);
    circleObject.insert(_jsonCenterKey, jsonValue);
    circleObject.insert(_jsonRadiusKey, _radius.rawValue().toDouble());
    circleObject.insert(_jsonCenterLatKey, _centerLat.rawValue().toDouble());
    circleObject.insert(_jsonCenterLonKey, _centerLon.rawValue().toDouble());

    json.insert(jsonCircleKey, circleObject);
}

bool QGCMapCircle::loadFromJson(const QJsonObject& json, QString& errorString)
{
    errorString.clear();

    QList<JsonHelper::KeyValidateInfo> circleKeyInfo = {
        { jsonCircleKey, QJsonValue::Object, true },
    };
    if (!JsonHelper::validateKeys(json, circleKeyInfo, errorString)) {
        return false;
    }

    QJsonObject circleObject = json[jsonCircleKey].toObject();

    QList<JsonHelper::KeyValidateInfo> circleObjectKeyInfo = {
        { _jsonCenterKey, QJsonValue::Array,    true },
        { _jsonRadiusKey, QJsonValue::Double,   true },
        { _jsonCenterLatKey, QJsonValue::Double, true },
        { _jsonCenterLonKey, QJsonValue::Double, true },
    };
    if (!JsonHelper::validateKeys(circleObject, circleObjectKeyInfo, errorString)) {
        return false;
    }

    QGeoCoordinate center;
    if (!JsonHelper::loadGeoCoordinate(circleObject[_jsonCenterKey], false /* altitudeRequired */, center, errorString)) {
        return false;
    }
    setCenter(center);
    _radius.setRawValue(circleObject[_jsonRadiusKey].toDouble());
    _centerLat.setRawValue(circleObject[_jsonCenterLatKey].toDouble());
    _centerLon.setRawValue(circleObject[_jsonCenterLonKey].toDouble());

    _interactive =          false;
    _showRotation =         false;
    _clockwiseRotation =    true;

    return true;
}

void QGCMapCircle::setCenter(QGeoCoordinate newCenter)
{
    if (newCenter != _center) {
        _center = newCenter;
        _centerLat.setRawValue(newCenter.latitude());
        _centerLon.setRawValue(newCenter.longitude());
        setDirty(true);
        emit centerChanged(newCenter);
    }
}

void QGCMapCircle::_setDirty(void)
{
    setDirty(true);
}

void QGCMapCircle::setInteractive(bool interactive)
{
    if (_interactive != interactive) {
        _interactive = interactive;
        emit interactiveChanged(interactive);
    }
}

void QGCMapCircle::setShowRotation(bool showRotation)
{
    if (showRotation != _showRotation) {
        _showRotation = showRotation;
        emit showRotationChanged(showRotation);
    }
}

void QGCMapCircle::setClockwiseRotation(bool clockwiseRotation)
{
    if (clockwiseRotation != _clockwiseRotation) {
        _clockwiseRotation = clockwiseRotation;
        emit clockwiseRotationChanged(clockwiseRotation);
    }
}
