To interpolate a frame on the client side....

Server will send state packets at ticks: 1,3,6,9,12...
*occasionally, not every frame*

Clients will send input packets at probably every tick: 1,2,3,4,5,6...

If both client and server are running at 60 ticks/second, that's about 0.0167 seconds/tick

OK, OK, for Mathz purposes, why don't we just assume we are running at 50 ticks/seconds or 0.02 seconds/tick

Let's assume there is a trip time of 0.1000

If Server sends a packet tick=0 at time = 0
Client receives packet tick=0 at time = 0.1

If Server and Client started at time = 0
Client and Server are at tick 5 when time = 0.1

However, it is extremely unlikely Client and Server started at same time, so client has to figure out two things

- What delay is there in sending/receiving a packet?
- What tick is the server currently on?

The client connects, the client receives a packet at time = 0.1... so now we know about what tick the server is on minus the delay in sending.

The client sends a packet with client tick at about time = 0. So here is some sample traffic with time.

Time|Client_Tick|Server_Tick|CliLastRecv|ServLastRecb|ServSend|ServRecv|CliSend|CliRecv|CliSendTime|CliRecvOffset|RTT|Delay|CliServerTick
----|-----------|-----------|-----------|------------|--------|--------|-------|-------------------|-------------|---|-----|-------------|-------------
0|0|1234|0|0|"1234,0"||||||||
0.01|0|1234|0|0|||||||||
0.02|1|1235|0|0|||"1,0"||||||
0.03|1|1235|0|0|||||||||
0.04|2|1236|1234|0|||"2,1234"|"1234,0"|||||
0.05|2|1236|1234|0|"1236,0"||||||||
0.06|3|1237|1234|0||"1,0"|"3,1234"||||||
0.07|3|1237|1234|1|||||||||
0.08|4|1238|1234|1||"2,1234"|"4,1234"||||||
0.09|4|1238|1236|2||||"1236,0"|||||
0.1|5|1239|1236|2|"1239,2"|"3,1234"|"5,1236"||||||
0.11|5|1239|1236|3|||||||||
0.12|6|1240|1236|3||"4,1234"|"6,1236"||||||
0.13|6|1240|1236|4|||||||||
0.14|7|1241|1239|4||"5,1236"|"7,1239"|"1239,2"|0.04|0.02|0.08|0.04|1241
0.15|7|1241|1239|5|"1241,5"||||||||
0.16|8|1242|1239|5||"6,1236"|"8,1239"||||||
0.17|8|1242|1239|6|||||||||
0.18|9|1243|1239|6||"7,1239"|"9,1239"||||||
0.19|9|1243|1241|7||||"1241,5"|0.09|0.02|0.08|0.04|1243
0.2|10|1244|1241|7|"1244,7"|"8,1239"|"10,1241"||||||
0.21|10|1244|1241|8|||||||||
0.22|11|1245|1241|8||"9,1239"|"11,1241"||||||
0.23|11|1245|1241|9|||||||||
0.24|12|1246|1244|9||"10,1241"|"12,1244"|"1244,7"|0.14|0.02|0.08|0.04|1246
0.25|12|1246|1244|10|"1246,10"||||||||
0.26|13|1247|1244|10||"11,1241"|"13,1244"||||||
0.27|13|1247|1244|11|||||||||
0.28|14|1248|1244|11||"12,1244"|"14,1244"||||||
0.29|14|1248|1246|12||||"1246,10"|0.19|0.02|0.08|0.04|1248
0.3|15|1249|1246|12|"1249,12"|"13,1244"|"15,1246"||||||
0.31|15|1249|1246|13|||||||||
0.32|16|1250|1246|13||"14,1244"|"16,1246"||||||
0.33|16|1250|1246|14|||||||||
0.34|17|1251|1249|14||"15,1246"|"17,1249"|"1249,12"|0.24|0.02|0.08|0.04|1251
0.35|17|1251|1249|15|"1251,15"||||||||
0.36|18|1252|1249|15||"16,1246"|"18,1249"||||||
0.37|18|1252|1249|16|||||||||
0.38|19|1253|1249|16||"17,1249"|"19,1249"||||||
0.39|19|1253|1251|17||||"1251,15"|0.29|0.02|0.08|0.04|1253
0.4|20|1254|1251|17|"1254,17"|"18,1249"|"20,1251"||||||
0.41|20|1254|1251|18|||||||||
0.42|21|1255|1251|18||"19,1249"|"21,1251"||||||
0.43|21|1255|1251|19|||||||||
0.44|22|1256|1254|19||"20,1251"|"22,1254"|"1254,17"|0.34|0.02|0.08|0.04|1256
0.45|22|1256|1254|20|"1256,20"||||||||
0.46|23|1257|1254|20||"21,1251"|"23,1254"||||||
0.47|23|1257|1254|21|||||||||
0.48|24|1258|1254|21||"22,1254"|"24,1254"||||||
0.49|24|1258|1256|22||||"1256,20"|0.39|0.02|0.08|0.04|1258
0.5|25|1259|1256|22|"1259,22"|"23,1254"|"25,1256"||||||

- It is important to establish that the tick_rate at both client and server are **tick_rate = 0.02**

- At **time 0.04**, the client receives an estimate of the **server tick 1234**, but not sure how accurate this is...

- At this point the client still does not know delay between client and server

- Same thing at **time 0.09**

- At **time 0.14**, the client receives another estimate, this time with additional information!

  - The client receives the **server tick 1239** and the last received **client tick 2**
  - Additional server sends **offset time 0.02**, aka time between server receiving client tick and sending server tick/packet
  - The client knows **client tick 2** was sent at **time 0.04**
  - Now the client can compute the **Round Trip Time (RTT)**
    - RTT = Current Time - Client Tick Sent Time - Offset time
    - **RTT** = 0.14 - 0.04 - 0.02 = **0.08**
  - The delay (time it took from server to client) = RTT / 2
    - **delay** = 0.08 / 2 = **0.04**

- At **time 0.14**, the client now predict the current server tick

  - current server tick = received server tick + delay / tick_rate

  - **current server tick** = 1239 + 0.04 / 0.02 = **1241**

- After **time 0.14**, the client can use delay to predict server tick at any time by:

  - current server tick = last_received_server_tick + (current_time - last_received_server_time + delay) / tick_rate
  - At **time 0.16**, **current_server_tick** = 1239 + (0.16 - 0.14 + 0.04) / 0.02 = **1242**

### Sliding Window

It may be beneficial to have a sliding window of the last X values. A sliding windows is an array of size X, where the value of the window can be

- Average of all values
- Median of all values
- Mode of all values
- Min/Max of all values

For the delay, the average or median delay of the last 10 packets may be more helpful than having a rapidly changing delay each frame.

