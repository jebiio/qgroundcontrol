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

