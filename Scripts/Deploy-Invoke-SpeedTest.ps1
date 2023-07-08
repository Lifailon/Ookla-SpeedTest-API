$path = ($env:PSModulePath.Split(";")[0])+"\Invoke-SpeedTest\"
$psm = "$path"+"Invoke-SpeedTest.psm1"
if (Test-Path $path) {
Remove-Item "$path\" -Recurse
}
New-Item $psm -ItemType "File" -Force | Out-Null
(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Lifailon/Ookla-SpeedTest-API/rsa/Invoke-SpeedTest/Invoke-SpeedTest.psm1") | Out-File $psm -Encoding default -Force