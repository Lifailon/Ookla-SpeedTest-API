function Invoke-SpeedTest {
<#
.SYNOPSIS
Module creating metrics measurements Internet speed to mode cli (no use dependencies) for output to console PSObject and log file
Data collection resource: speedtest.net (dev Ookla)
Using native API method (via InternetExplorer) for web function start
Using REST API GET method (via Invoke-RestMethod) for parsing JSON report
Works in PSVersion 5.1 (PowerShell 7.3 not supported)
.DESCRIPTION
Example:
$SpeedTest = Invoke-SpeedTest # Output to variable full report
Invoke-SpeedTest -LogWrite # Write to log
Invoke-SpeedTest -LogWrite -LogPath "$env:temp\Documents\Ookla-SpeedTest-Log.txt" # Set default path for log
Invoke-SpeedTest -LogRead | ft # Out log to PSObject
Invoke-SpeedTest -LogClear # Clear log file
.LINK
https://github.com/Lifailon/Ookla-SpeedTest-API
#>
    param(
        [switch]$LogWrite,
        $LogPath = "$env:temp\Ookla-SpeedTest-Log.txt",
        [switch]$LogRead,
        [switch]$LogClear
    )
    
    if ($LogClear) {
        $null > $LogPath
        return
    }
    
    if (!$LogRead) {
    ### IE Settings: Certificate check disable
    $reg_path1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
    $reg_path2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing"
    if ((Get-ItemProperty $reg_path1).CertificateRevocation -eq 1) {
        Set-ItemProperty -Path $reg_path1 -Name CertificateRevocation -Value 0
        Set-ItemProperty -Path $reg_path1 -Name WarnonBadCertRecving -Value 0
        Set-ItemProperty -Path $reg_path2 -Name State -Value 146944 # Enable: 146432
    }
    
    try {
    $ie = New-Object -ComObject InternetExplorer.Application
    # Debug
    # $ie.Visible = $true
    $ie.navigate("https://www.speedtest.net")
    
    while ($True) {
        if ($ie.ReadyState -eq 4) {
            break
        } else {
            Start-Sleep -Milliseconds 100
        }
    }
    
    $Source_URL = $ie.LocationURL
    $SPAN_Elements = $ie.document.IHTMLDocument3_getElementsByTagName("SPAN")
    $Go_Button = $SPAN_Elements | Where-Object innerText -like "go"
    $Go_Button.Click()
    
    ### Get result URL
    $Sec = 0
    $Proc = 0
    while ($True) {
        if ($ie.LocationURL -notlike $Source_URL) {
            Write-Progress -Activity "SpeedTest Completed" -PercentComplete 100
            $Result_URL = $ie.LocationURL
			$ie.Stop()
			$ie.Quit()
            break
        } else {
            Start-Sleep 2
            $Sec += 2
            $Proc += 1
            Write-Progress -Activity "Started SpeedTest" -Status "Run time: $Sec sec" -PercentComplete $Proc
        }
    }
    
    ### Parsing Web Content (JSON)
    $Cont = Invoke-RestMethod $Result_URL
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
    $up = "$u1.$u2 Mbit"
    
    $Out_Log = "$time  Download: $down  Upload: $up  Ping latency: $ping ms"
    $Out_Log >> $LogPath
    }
    
    return $Data.result
    }
    ### Debug stop process
    finally {
        if (Get-Process *iexplore*) {
            Get-Process *iexplore* | Stop-Process -Force -InformationAction Ignore
        }
    }
    }
    
    if ($LogRead) {
        $gcLog = Get-Content $LogPath
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