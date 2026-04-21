#Requires -RunAsAdministrator
<#
.FiveM Restore Default Settings
.ใช้เมื่อต้องการคืนค่าเริ่มต้น
#>

Write-Host "Restoring Default Windows Settings..." -ForegroundColor Yellow

# Restore power plan to balanced
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e

# Enable services
$servicesToEnable = @("SysMain", "WSearch", "DiagTrack", "dmwapppushservice")
foreach ($service in $servicesToEnable) {
    Set-Service -Name $service -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $service -ErrorAction SilentlyContinue
}

# Restore network defaults
netsh int tcp set global autotuninglevel=normal | Out-Null
netsh int tcp set global chimney=disabled | Out-Null
netsh int tcp set global rss=enabled | Out-Null
netsh int tcp set global netdma=disabled | Out-Null
netsh int tcp set global dca=disabled | Out-Null
netsh int tcp set global ecncapability=enabled | Out-Null
netsh int tcp set global congestionprovider=default | Out-Null
netsh int tcp set global timestamps=enabled | Out-Null

# Restore visual effects
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x9E,0x12,0x07,0x80,0x12,0x00,0x00,0x00)) -PropertyType Binary -Force

# Re-enable prefetch
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Value 3 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Value 3 -PropertyType DWord -Force

# Restore HPET
bcdedit /set useplatformclock true | Out-Null
bcdedit /set disabledynamictick no | Out-Null

Write-Host "Default settings restored! Please restart your computer." -ForegroundColor Green
Pause
