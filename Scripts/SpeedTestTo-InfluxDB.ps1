### Variables for connect to InfluxDB
$ip    = "192.168.3.104" # IP-address server
$p     = "8086"			 # Port server
$db    = "powershell"	 # Database name
$table = "speedtest"	 # Measurement/Table name
###

$ipp   = $ip+":"+$p
$url   = "http://$ipp/write?db=$db"
$hn    = $ENV:COMPUTERNAME
$tz    = (Get-TimeZone).BaseUtcOffset.TotalMinutes

while ($True) {
    $test  = Invoke-SpeedTest
    $down  = $test.download
    $up    = $test.upload
    $ping  = $test.latency

	$unixtime  = (New-TimeSpan -Start (Get-Date "01/01/1970") -End ((Get-Date).AddMinutes(-$tz))).TotalSeconds # UTC 0 (if +)
    $timestamp = ([string]$unixtime -replace "\..+") + "000000000"

    Invoke-RestMethod -Method POST -Uri $url -Body "$table,host=$hn download=$down,upload=$up,ping=$ping $timestamp"
    Start-Sleep -Seconds 600
}