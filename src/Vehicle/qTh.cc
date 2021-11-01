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
    point = 0;
}


void qTh::write_droneBotLog()
{   
    QString path = "/Log/";
    QString csv_file_name = "test_log.csv";
    // .bin 파일 생성
    QString bin_fine_name = "binary_log.bin";

    QDir dir;
    dir.mkpath(path);

    csv_file_name.prepend(path);
    QFile csvFile(csv_file_name);

    //file name
    bin_fine_name.prepend(path);
    QFile binFile(bin_fine_name);
    
    
    csvFile.open(QIODevice::WriteOnly |  QIODevice::Append);
    QTextStream out(&csvFile);

    //QDataStream

    //read
    binFile.open(QIODevice::ReadOnly);
    QByteArray data = binFile.readAll();

//    int point_from_byte;
   // auto read = binFile.read(&point_from_byte, sizeof(int));
    QString byteArray = QString(data);
    
    qDebug() << "read byte: " << data ;
  //  qDebug() << "read byte to string : " << QString::number(point_from_byte);


    //write
    // binFile.open(QIODevice::WriteOnly |  QIODevice::Append);
    // QDataStream outBin(&binFile);

    if(csvFile.pos() == 0){
        qDebug() << "file empty, header generated";
        out << "point,\ttime,\tlatitude,\tlongitude,\taltitude\n";
    }
   
    out <<  point << ", "<< time_usec << ", " << latitude << ", " << longitude << ", " << altitude <<"\n";
    csvFile.close();

    // outBin << point ;
    binFile.close();   

}


void qTh::run()
{
    while (true)
    {  
        point++;
        write_droneBotLog();
        sleep(1);
    }
}


void qTh::_update_gps_data(double lat_raw, double lon_raw, double alt_raw, uint64_t time_raw)
{
    latitude = lat_raw;
    longitude = lon_raw;
    altitude = alt_raw;
    time_usec = time_raw;

    // qDebug() << "gps time : " << time_usec; 

}



