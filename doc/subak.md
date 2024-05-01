# QGCToolbox
* top level services/tools 관리 목적 (일종의 app 전역 변수 구조체)
   * LinkManager : public QGCTool
   * MAVLinkProtocol : public QGCTool
   * MultiVehicleManager : public QGCTool
   * MAVLinkLogManager : public QGCTool
   * SettingsManager : public QGCTool
   * FactSystem : public QGCTool
   * 참고 : ADSBVehicleManager
# LinkManager
* 
# Vehicle
* 
* LinkInterface 와  MAVLinkProtocol::messageReceived 연결
* MAVLinkProtocol::messageReceived 와 Vehicle::_mavlinkMessageReceived 연결

# LinkInterface
* 정의
   * Ground application과 통신하는데 사용하는 모든 links에 대한 interface를 정의
* 상속
   * QThread
