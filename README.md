# Ookla-SpeedTest-API
Module creating metrics measurements Internet speed to mode cli (no use dependencies) for output to console PSObject and log file \
Data collection resource: **speedtest.net (dev Ookla)**
## Used methods
- Using **native API method (via InternetExplorer)** for web function start
- Using REST API GET method (via Invoke-RestMethod) for parsing JSON report
## Install/Update
Download and run the script **[Deploy-Invoke-SpeedTest.ps1](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/Deploy-Invoke-SpeedTest.ps1)** \
Works in PSVersion 5.1 (PowerShell 7.3 not supported)
## Module Invoke-SpeedTest
```
PS C:\Users\Lifailon> Invoke-SpeedTest -LogWrite


date               : 08.05.2023 11:36:10
id                 : 14708271987
connection_icon    : wireless
download           : 33418
upload             : 35442
latency            : 15
distance           : 50
country_code       : RU
server_id          : 2707
server_name        : Bryansk
sponsor_name       : DOM.RU
sponsor_url        :
connection_mode    : multi
isp_name           : Resource Link
isp_rating         : 4.0
test_rank          : 63
test_grade         : B-
test_rating        : 4
idle_latency       : 17
download_latency   : 116
upload_latency     : 75
additional_servers : {@{server_id=8191; server_name=Bryansk; sponsor_name=SectorTelecom.ru}, @{server_id=46278; server_
                     name=Fokino; sponsor_name=Fokks - Promyshlennaya avtomatika Ltd.}, @{server_id=18218; server_name=
                     Bryansk; sponsor_name=RIA-link Ltd.}}
path               : result/14708271987
hasSecondary       : True
```
## Output log to console
```
PS C:\Users\Lifailon> Invoke-SpeedTest -LogRead | ft

Date       Time     Download    Upload      Ping
----       ----     --------    ------      ----
05/08/2023 02:10:32 36.293 Mbit 34.832 Mbit 16 ms
05/08/2023 02:39:18 34.623 Mbit 34.623 Mbit 18 ms
05/08/2023 02:49:01 33.530 Mbit 35.573 Mbit 16 ms
05/08/2023 10:50:50 32.638 Mbit 37.382 Mbit 15 ms
05/08/2023 11:20:33 37.402 Mbit 39.780 Mbit 16 ms
05/08/2023 11:21:34 36.034 Mbit 35.835 Mbit 16 ms
05/08/2023 11:33:04 32.101 Mbit 32.742 Mbit 18 ms
05/08/2023 11:36:10 33.418 Mbit 35.442 Mbit 17 ms
```
