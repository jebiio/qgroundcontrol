#include "qth.h"
#include <QDebug>
#include <QFile>
#include <QString>
#include <QtQml>
#include <QTextStream>
#include <iostream>

using std::cout; using std::cin;
using std::endl; using std::string;

qTh::qTh(QObject *parent): QThread(parent)
{

    longitude =0.0;
    latitude = 0.0;
    altitude = 0.0;
}

//영상

void qTh::write_droneBotLog()
{   
    QDateTime dateTime = QDateTime::currentDateTime();
    QString time_format = "yyyy.MM.dd.HH:mm:ss";

    qDebug() << dateTime.toString();

    auto file_name = QString("/Log/");
    file_name.append("dronebot.txt");

    QDir dir;
    dir.mkpath("/Log/");

    QFile file(file_name);
    file.open(QIODevice::WriteOnly |  QIODevice::Append);
    QTextStream out(&file);

    string str = std::to_string(way);
    QString qstr = QString::fromStdString(str);

    out <<  way << ", "<< dateTime.toString(time_format)<< ", " << latitude << ", " << longitude << ", " << altitude << ", " <<"\n";
    file.close();

}


void qTh::run()
{
    while (true)
    {  
        write_droneBotLog();
        sleep(10);
    }
}

void qTh::_update_gps_data(double lat_raw, double lon_raw, double alt_raw)
{
    latitude = lat_raw;
    longitude = lon_raw;
    altitude = alt_raw;

}



