#pragma once

#include <stdint.h>

#pragma pack(1)
typedef struct _fmu_stream_t {
    uint32_t id;
    uint64_t count;
    uint32_t pressure;
    uint32_t temperature;
    uint32_t humidity;
    uint8_t padding[4];

    double qw;
    double qx;
    double qy;
    double qz;

    double gw;
    double gx;
    double gy;
    double gz;

    double aw;
    double ax;
    double ay;
    double az;


    double mw;
    double mx;
    double my;
    double mz;

    double latitude;
    double longitude;
    double msl;
    double altref;
    double spd;
    double time;
    uint32_t date;

    uint8_t n;
    uint8_t e;
    uint8_t fs;
    uint8_t nosv;
    uint8_t status;
    uint8_t system_id;
} FmuStream; 

#pragma pack()