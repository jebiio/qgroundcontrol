#pragma once


typedef float float32;
typedef double float64;
typedef unsigned char uint8;

struct Waypoint {
    float64 lat;
    float64 lon;
    float32 spd_cmd;
    float32 acceptance_radius;
};

struct WaypointControl {
    Waypoint global_path[100];
    float32 nav_surge_pgain;
    float32 nav_surge_dgain;
    float32 nav_yaw_pgain;
    float32 nav_yaw_dgain;
    uint8   count;
};