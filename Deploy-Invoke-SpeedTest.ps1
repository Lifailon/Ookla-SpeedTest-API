$path_psm = ($env:PSModulePath.Split(";")[0])+"\Invoke-SpeedTest\1.0\Invoke-SpeedTest.psm1"
$path_psd = ($env:PSModulePath.Split(";")[0])+"\Invoke-SpeedTest\1.0\Invoke-SpeedTest.psd1"

if (!(Test-Path $path_psm)) {
    New-Item $path_psm -ItemType File -Force
}

if (!(Test-Path $path_psd)) {
    New-Item $path_psd -ItemType File -Force
}

irm https://raw.githubusercontent.com/Lifailon/Ookla-SpeedTest-API/rsa/Invoke-SpeedTest/1.0/Invoke-SpeedTest.psm1 | 
Out-File $path_psm -Force
irm https://raw.githubusercontent.com/Lifailon/Ookla-SpeedTest-API/rsa/Invoke-SpeedTest/1.0/Invoke-SpeedTest.psd1 | 
Out-File $path_psd -Force