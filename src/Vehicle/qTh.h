#ifndef QTH_H
#define QTH_H

#include <QThread>
Q_DECLARE_LOGGING_CATEGORY(VehicleLog)

class qTh: public QThread
{
    Q_OBJECT

public:
    explicit qTh(QObject* parent = 0);

    double longitude;
    double latitude;
    double altitude;
    uint64_t time_usec;
    int point;

    char* path = "./test_jaeeun.txt";
    int way = 1;
    unsigned int time = 0;


    void write_droneBotLog();
    void run();
    void _update_gps_data(double lat, double lon, double alt, uint64_t time);

};

#endif