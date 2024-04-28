# server
* ToDo
```
* FMUServer 생성
   * TCP Server
   * 1234 port를 생성한다.
   * client로부터 FMUUDPLink port를 수신한다.
       * 수신한 port로 FMUUDPLink를 생성할때 port로 사용한다.
* FMUUDPLink 는
   * UDP server
   * 생성시에 인자로 받은 port로 동작한다.
   * 동작
      * client로부터 message를 수신한다.
      * 이 message를 파싱하여 사용한다. 
         * 위도, 경도, 자세 정보
* FMU UDP client Link 생성(여러개 생성 가능)
```

## Forwarder Init Communication Protocol
* ToDo
```
* 외부 Forwarder TCP Server와 TCP 통신을 담당하는 ForwarderTCPClient class를 생성
* ForwarderTCPClient가 하는 일
   * 초기화 : Forwarder TCP Server의 IP는 127.0.0.1이다. 이 server의 9700 port에 접속한다.
   * 이 Client는 5가지 상태를 가진다. HelloState, HelloAckState, PortSendState, OkAckState, DoneState
   * HelloState에서는 Server에게 'hello' 문자열을 전송한다. 문자열을 전송하고 난 후 HelloAckState로 변경한다.
   * HelloAckState에서는 Server로부터 'hello Ok'라는 문자열을 즉 ack 수신을 받을때까지 대기한다. 이 ack를 수신하면 PortSendState로 변경한다. 만약 ack를 수신하면 만약 30초 이내에 ack를 수신받지 못한 경우 HelloState 동작을 수행한다.
   * PortSendState에서는 Server에게 '10000'을 전송하고 OkAckState로 변경한다.
   * OkAckState에서는 Server로부터 'OK/Ready'라는 문자열을 즉 ack 수신을 받을때까지 대기한다. 이 ack를 수신하면 DoneState로 변경한다.
   * DoneState에서는 '10000' port로 ForwarderUDPServer class의 인스턴스를 생성한다.
```

## Engine Init Communication Protocol
* ToDo
```
* 외부 Engine TCP Server와 TCP 통신을 담당하는 EngineTCPClient class를 생성
* EngineTCPClient가 하는 일
   * 초기화 : Engine TCP Server의 IP는 127.0.0.1이다. 이 server의 9898 port에 접속한다.
   * 이 Client는 7가지 상태를 가진다. HelloState, HelloAckState, ModeSendState, ModeAckState, PortSendState, OkAckState,DoneState
   * HelloState에서는 Server에게 'hello' 문자열을 전송한다. 문자열을 전송하고 난 후 HelloAckState로 변경한다.
   * HelloAckState에서는 Server로부터 'hello Ok'라는 문자열을 즉 ack 수신을 받을때까지 대기한다. 이 ack를 수신하면 ModeSendState로 변경한다. 만약 ack를 수신하면 만약 30초 이내에 ack를 수신받지 못한 경우 HelloState 동작을 수행한다.
   * ModeSendState에서는 Server에게 'Train'을 전송하고 ModeAckState로 변경한다.
   * ModeAckState에서는 Server로부터 'Mode Ok'라는 문자열을 즉 ack 수신을 받을때까지 대기한다. 이 ack를 수신하면 PortSendState로 변경한다. 
   * PortSendState에서는 Server에게 '15300'을 전송하고 OkAckState로 변경한다.
   * OkAckState에서는 Server로부터 'OK/Port'라는 문자열을 즉 ack 수신을 받을때까지 대기한다. 이 ack를 수신하면 DoneState로 변경한다.
   * DoneState에서는 '10000' port로 EngineUDPServer class의 인스턴스를 생성한다.
```

## ForwarderUDPServer
* ToDo
```
* ForwarderUDPServer는 IP가 '127.0.0.1'이고 port는 10000이다.
* ForwarderUDPServer가 하는 일
   * 10000 port로부터 20byte packet을 주기적으로 수신한다. 
   * 수신한 packet을 '127.0.0.1' IP의 15300 port를 가지는 udp server로 전송한다.
```


## EngineAlarmUDPServer
* ToDo
```
* EngienAlarmUDPServer

```