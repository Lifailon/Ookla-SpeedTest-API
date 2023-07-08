$ip    = "192.168.3.104"
$p     = "8086"
$db    = "powershell"
$table = "speedtest"
$sleep = 90

$ipp   = $ip+":"+$p
$url   = "http://$ipp/write?db=$db"
$hn    = $ENV:COMPUTERNAME

while ($True) {
    $test  = Invoke-SpeedTest
    $down  = $test.download
    $up    = $test.upload
    $ping  = $test.latency

    $unixtime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds
    $timestamp = ([string]$unixtime -replace "\..+") + "000000000"

    Invoke-RestMethod -Method POST -Uri $url -Body "$table,host=$hn download=$down,upload=$up,ping=$ping $timestamp"
    Start-Sleep -Seconds $sleep
}