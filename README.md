# Ookla-SpeedTest-API

[![GitHub Release](https://img.shields.io/github/v/release/Lifailon/Ookla-SpeedTest-API?display_name=release&logo=GitHub&label=GitHub&link=https%3A%2F%2Fgithub.com%2FLifailon%2FOokla-SpeedTest-API%2F)](https://github.com/Lifailon/Ookla-SpeedTest-API)
[![NuGet Version](https://img.shields.io/nuget/v/Ookla-SpeedTest?logo=NuGet&label=NuGet&link=https%3A%2F%2Fwww.nuget.org%2Fpackages%2FOokla-SpeedTest)](https://www.nuget.org/packages/Ookla-SpeedTest)
[![GitHub top language](https://img.shields.io/github/languages/top/Lifailon/Ookla-SpeedTest-API?logo=PowerShell&link=https%3A%2F%2Fgithub.com%2FPowerShell%2FPowerShell)](https://github.com/PowerShell/PowerShell)
[![GitHub License](https://img.shields.io/github/license/Lifailon/Ookla-SpeedTest-API?link=https%3A%2F%2Fgithub.com%2FLifailon%2FOokla-SpeedTest-API%2Fblob%2Frsa%2FLICENSE)](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/LICENSE)

Module for get metrics measurements Internet speed to mode cli (no use dependencies) and output to **PSObject** format or log file. Data collection resource: **speedtest.net (dev Ookla)**.

## 📚 Used methods

- Using **native API method (via COM Object InternetExplorer)** for web function start
- Using **REST API GET method (via Invoke-RestMethod)** for parsing JSON report

## 🚀 Install/Update

✔️ Works in PSVersion 5.1 \
❌ IE to PowerShell 7.3 not supported

Use the [NuGet](https://www.nuget.org/packages/Ookla-SpeedTest) package manager:

```PowerShell
Install-Module Ookla-SpeedTest -Repository NuGet
```

💡 You must have a NuGet repository registered:

```PowerShell
Get-PackageProvider # check that the nuget packet provider is installed
Find-PackageProvider # display all available package managers
Install-PackageProvider nuget # install the nuget package manager
Set-PackageSource nuget -Trusted # allow packages to be installed from the specified source
Find-Package Ookla-SpeedTest # search for packages by name in all managers
Install-Module Ookla-SpeedTest -Scope CurrentUser # install the module for the current user
```

For install or update module from the GitHub repository (used the script **[Deploy-Invoke-SpeedTest.ps1](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/Scripts/Deploy-Invoke-SpeedTest.ps1)**) use the command in the PowerShell console:
```
Invoke-Expression(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Ookla-SpeedTest-API/rsa/Scripts/Deploy-Invoke-SpeedTest.ps1")
```

## 🔔 Module Invoke-SpeedTest
```
PS C:\Users\Lifailon> $ookla = Invoke-SpeedTest -LogWrite

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

PS C:\Users\Lifailon> $ookla.additional_servers

server_id server_name sponsor_name
--------- ----------- ------------
     8191 Bryansk     SectorTelecom.ru
    46278 Fokino      Fokks - Promyshlennaya avtomatika Ltd.
    18218 Bryansk     RIA-link Ltd.
```

### 🎉 Example

Result to UI: https://www.speedtest.net/result/14708271987

![Image alt](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/Screen/UI.jpg)

## 📑 Output log to console
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
...
```

## 📊 PowerShell + InfluxDB + Grafana

### Create Service

**Download script: [SpeedTestTo-InfluxDB.ps1](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/Scripts/SpeedTestTo-InfluxDB.ps1)** (change the IP-address and database name for InfluxDB) \
**Download [NSSM](https://www.nssm.cc/download)** \
Copy files to folder: `C:\NSSM\`

```
$powershell_Path = (Get-Command powershell).Source
$NSSM_Path = "C:\NSSM\NSSM-2.24.exe"
$Script_Path = "C:\NSSM\SpeedTestTo-InfluxDB.ps1"
$Service_Name = "SpeedTestTo-InfluxDB"
& $NSSM_Path install $Service_Name $powershell_Path -ExecutionPolicy Bypass -NoProfile -f $Script_Path
Get-Service $Service_Name | Start-Service
Get-Service $Service_Name | Set-Service -StartupType Automatic

Get-Service $Service_Name | select Status,Name,StartType

Status Name                 StartType
 ------ ----                 ---------
Running SpeedTestTo-InfluxDB Automatic
```

### View Data

`SELECT * FROM "speedtest" WHERE time > now() - 40m`

![Image alt](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/Screen/InfluxDB-Data.jpg)

### Add to Dashboard

`SELECT download,upload FROM speedtest`

![Image alt](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/Screen/Grafana-Dashboard-1.jpg)

![Image alt](https://github.com/Lifailon/Ookla-SpeedTest-API/blob/rsa/Screen/Grafana-Dashboard-2.jpg)

### Changelog:

**09.07.2023:** Added script create service for dashboard Grafana from the InfluxDB \
**19.07.2023:** Debug for process stoppage (added block finally) and disable check certificate to IE settings