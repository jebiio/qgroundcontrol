find_package(Qt6 REQUIRED COMPONENTS Core Network Qml Xml)

qt_add_library(Camera STATIC
	MavlinkCameraControl.cc
	MavlinkCameraControl.h
	QGCCameraIO.cc
	QGCCameraIO.h
	QGCCameraManager.cc
	QGCCameraManager.h
	SimulatedCameraControl.cc
	SimulatedCameraControl.h
	VehicleCameraControl.cc
	VehicleCameraControl.h
)

target_link_libraries(Camera
	PRIVATE
		Qt6::Network
		Qt6::Qml
		Qt6::Xml
		api
		Compression
		FirmwarePlugin
		Joystick
		QGCLocation
		Settings
		Vehicle
		VideoManager
	PUBLIC
		Qt6::Core
		comm
		FactSystem
		QmlControls
		qgc
)

target_include_directories(Camera PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

