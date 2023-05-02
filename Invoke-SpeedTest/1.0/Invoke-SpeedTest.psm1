function Invoke-SpeedTest {
<#
.SYNOPSIS
Module for creating metrics measurements Internet speed to mode cli (no use dependencies) and output to log file
Data collection resource: speedtest.net (dev Ookla)
Using native API method (via InternetExplorer) for web function start
Using REST API GET method (via Invoke-RestMethod) for parsing JSON report
Works in PSVersion 5.1 (PowerShell 7.3 not supported)
.DESCRIPTION
Example:
$SpeedTest = Invoke-SpeedTest # Output to variable full report
Invoke-SpeedTest -LogWrite # Write to log
Invoke-SpeedTest -LogWrite -LogPath "$home\Documents\Ookla-SpeedTest-Log.txt" # Set default path for log
Invoke-SpeedTest -LogRead # Out log to PSObject
.LINK
https://github.com/Lifailon/Ookla-SpeedTest-API
#>
param(
    [switch]$LogWrite,
    $LogPath = "$home\Documents\Ookla-SpeedTest-Log.txt",
    [switch]$LogRead
)

if (!$LogRead) {
$ie = New-Object -ComObject InternetExplorer.Application
$ie.navigate("https://www.speedtest.net")

while ($True) {
    if ($ie.ReadyState -eq 4) {
        break
    } else {
        sleep -Milliseconds 100
    }
}

$SPAN_Elements = $ie.document.IHTMLDocument3_getElementsByTagName("SPAN")
$Go_Button = $SPAN_Elements | ? innerText -like "go"
$Go_Button.Click()

### Get result URL
$Source_URL = $ie.LocationURL
$Sec = 0
while ($True) {
    if ($ie.LocationURL -notlike $Source_URL) {
        Write-Progress -Activity "SpeedTest Completed" -PercentComplete 100
        $Result_URL = $ie.LocationURL
        $ie.Quit()
        break
    } else {
        sleep 1
        $Sec += 1
        Write-Progress -Activity "Started SpeedTest" -Status "Run time: $Sec sec" -PercentComplete $Sec
    }
}

### Parsing Web Content (JSON)
$Cont = irm $Result_URL
$Data = ($Cont -split "window.OOKLA.")[3] -replace "(.+ = )|(;)" | ConvertFrom-Json

### Convert Unix Time
$EpochTime = [DateTime]"1/1/1970"
$TimeZone = Get-TimeZone
$UTCTime = $EpochTime.AddSeconds($Data.result.date)
$Data.result.date = $UTCTime.AddMinutes($TimeZone.BaseUtcOffset.TotalMinutes)

if ($LogWrite) {
$time = $Data.result.date
$ping = $Data.result.idle_latency

$Download = [string]($Data.result.download)
$d2 = $Download[-3..-1] -Join ""
$d1 = $Download[-10..-4] -Join ""
$down = "$d1.$d2 Mbit"

$Upload = [string]($Data.result.upload)
$u2 = $Upload[-3..-1] -Join ""
$u1 = $Upload[-10..-4] -Join ""
$up = "$d1.$d2 Mbit"

$Out_Log = "$time  Download: $down  Upload: $up  Ping latency: $ping ms"
$Out_Log >> $LogPath
}

$Data.result
}

if ($LogRead) {
    $gcLog = gc $LogPath
    $Collections = New-Object System.Collections.Generic.List[System.Object]
    foreach ($gcl in $gcLog) {
        $out = $gcl -split "\s\s"
        $dt  = $out[0] -split "\s"
        $Collections.Add([PSCustomObject]@{
            Date        = $dt[0];
            Time        = $dt[1];
            Download    = $out[1] -replace "Download: ";
            Upload      = $out[2] -replace "Upload: ";
            Ping        = $out[3] -replace "Ping latency: ";
        })
    }
    $Collections
}
}