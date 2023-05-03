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
date               : 03.05.2023 14:27:26
id                 : 14688871750
connection_icon    : wireless
download           : 225900
upload             : 273724
latency            : 5
distance           : 0
country_code       : RU
server_id          : 44487
server_name        : Moscow
sponsor_name       : VDSina.com
sponsor_url        :
connection_mode    : multi
isp_name           : Seven Sky
isp_rating         : 3.5
test_rank          : 100
test_grade         : A+
test_rating        : 5
idle_latency       : 6
download_latency   : 63
upload_latency     : 11
additional_servers : {@{server_id=14190; server_name=Moscow; sponsor_name=DOM.RU}, @{server_id=17091; server_name=Mosco
                     w; sponsor_name=Telecom Center}, @{server_id=1907; server_name=Moscow; sponsor_name=MTS}}
path               : result/14688871750
hasSecondary       : True
```
## Example log read
```
PS C:\Users\Lifailon> Invoke-SpeedTest -LogRead | ft

Date       Time     Download     Upload       Ping
----       ----     --------     ------       ----
05/02/2023 11:41:47 305.133 Mbit 305.133 Mbit 5 ms
05/02/2023 11:48:12 310.265 Mbit 310.265 Mbit 3 ms
05/02/2023 13:10:07 243.389 Mbit 243.389 Mbit 3 ms
05/02/2023 13:50:08 309.560 Mbit 309.560 Mbit 4 ms
05/02/2023 13:59:39 312.211 Mbit 312.211 Mbit 5 ms
05/02/2023 14:05:00 306.246 Mbit 306.246 Mbit 4 ms
05/02/2023 14:09:13 305.068 Mbit 305.068 Mbit 4 ms
05/02/2023 14:12:03 305.910 Mbit 305.910 Mbit 4 ms
05/02/2023 14:14:53 306.736 Mbit 306.736 Mbit 4 ms
05/02/2023 16:58:20 306.327 Mbit 306.327 Mbit 4 ms
05/03/2023 14:27:26 225.900 Mbit 225.900 Mbit 6 ms
```
## Example work
https://user-images.githubusercontent.com/116945542/235663503-6fe97b6e-7ef5-4ec0-a424-2317e00eacae.mp4
