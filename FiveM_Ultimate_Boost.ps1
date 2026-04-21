#Requires -RunAsAdministrator
<#
.FiveM Ultimate Performance Booster
.สร้างสำหรับ: Windows 11 + FiveM PVP (300 players)
.เป้าหมาย: FPS สูงสุด, Latency ต่ำสุด, Response เหนือชั้น
#>

$ErrorActionPreference = "SilentlyContinue"
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   FIVEM ULTIMATE PERFORMANCE BOOSTER   " -ForegroundColor Green
Write-Host "   Windows 11 Optimization for PVP      " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# ==================== SYSTEM RESTORE POINT ====================
Write-Host "[1/8] Creating System Restore Point..." -ForegroundColor Yellow
Checkpoint-Computer -Description "FiveM_Boost_Before" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
Write-Host "      Done!" -ForegroundColor Green

# ==================== NETWORK OPTIMIZATION ====================
Write-Host "[2/8] Optimizing Network for Low Latency..." -ForegroundColor Yellow

# Disable Nagle's Algorithm (TCP_NODELAY) - ลด delay ในการส่ง packet
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force

# Network Throttling Index - ปิดการจำกัด bandwidth
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -PropertyType DWord -Force

# System Responsiveness - เน้นให้เกมได้ priority
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 1 -PropertyType DWord -Force

# TCP Optimizations
netsh int tcp set global autotuninglevel=disabled | Out-Null
netsh int tcp set global chimney=enabled | Out-Null
netsh int tcp set global rss=enabled | Out-Null
netsh int tcp set global netdma=enabled | Out-Null
netsh int tcp set global dca=enabled | Out-Null
netsh int tcp set global ecncapability=disabled | Out-Null
netsh int tcp set global congestionprovider=ctcp | Out-Null
netsh int tcp set global timestamps=disabled | Out-Null
netsh int tcp set global rsc=disabled | Out-Null

# Disable Window Auto-Tuning (ลด latency แต่อาจลด throughput นิดหน่อย)
netsh int tcp set global autotuninglevel=disabled | Out-Null

# DNS Cache optimization
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "CacheHashTableBucketSize" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "CacheHashTableSize" -Value 384 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "MaxCacheEntryTtlLimit" -Value 64000 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "MaxSOACacheEntryTtlLimit" -Value 301 -PropertyType DWord -Force

Write-Host "      Network Optimized!" -ForegroundColor Green

# ==================== MOUSE & KEYBOARD OPTIMIZATION ====================
Write-Host "[3/8] Optimizing Mouse & Keyboard Response..." -ForegroundColor Yellow

# Mouse: Disable pointer precision (enhance pointer precision = OFF)
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0" -PropertyType String -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0" -PropertyType String -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0" -PropertyType String -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -Value "10" -PropertyType String -Force

# Disable mouse acceleration in registry
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseXCurve" -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseYCurve" -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -Force

# Keyboard response rate optimization
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 100 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" -Name "MouseDataQueueSize" -Value 100 -PropertyType DWord -Force

# HID optimizations for gaming peripherals
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\hidusb\Parameters" -Name "DisableSelectiveSuspend" -Value 1 -PropertyType DWord -Force

# USB polling rate improvement (1000Hz for gaming mice)
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{745A17A0-74D3-11D0-B6FE-00A0C90F57DA}\0000" -Name "HighResTimer" -Value 1 -PropertyType DWord -Force

Write-Host "      Mouse & Keyboard Optimized!" -ForegroundColor Green

# ==================== CPU & PROCESS OPTIMIZATION ====================
Write-Host "[4/8] Optimizing CPU & Process Priority..." -ForegroundColor Yellow

# Disable CPU parking (ให้ CPU ทุก core active เสมอ)
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current

# Game Mode registry tweaks
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Affinity" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Background Only" -Value "False" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Clock Rate" -Value 10000 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Value "High" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "SFIO Priority" -Value "High" -PropertyType String -Force

# Disable HPET (High Precision Event Timer) - ลด latency
bcdedit /set useplatformclock false | Out-Null
bcdedit /set disabledynamictick yes | Out-Null

# Disable dynamic tick
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -Name "DisableDynamicTick" -Value 1 -PropertyType DWord -Force

# Timer resolution
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -Name "MaximumTimerResolution" -Value 5000 -PropertyType DWord -Force

Write-Host "      CPU & Process Optimized!" -ForegroundColor Green

# ==================== MEMORY OPTIMIZATION ====================
Write-Host "[5/8] Optimizing Memory Management..." -ForegroundColor Yellow

# Large System Cache
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -PropertyType DWord -Force

# Disable paging executive
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1 -PropertyType DWord -Force

# Clear page file at shutdown = OFF (เร็วขึ้น)
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 0 -PropertyType DWord -Force

# SecondLevelDataCache (ตาม L2/L3 cache ของ CPU)
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SecondLevelDataCache" -Value 256 -PropertyType DWord -Force

# Prefetch & Superfetch optimization
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Value 0 -PropertyType DWord -Force

# Disable memory compression (ลด latency)
Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue

Write-Host "      Memory Optimized!" -ForegroundColor Green

# ==================== WINDOWS SERVICES OPTIMIZATION ====================
Write-Host "[6/8] Optimizing Windows Services..." -ForegroundColor Yellow

$servicesToDisable = @(
    "DiagTrack",                    # Diagnostic Tracking
    "dmwapppushservice",            # WAP Push Message Routing
    "SysMain",                      # Superfetch
    "WSearch",                      # Windows Search
    "MapsBroker",                   # Downloaded Maps Manager
    "WMPNetworkSvc",                # Windows Media Player Network Sharing
    "XblAuthManager",               # Xbox Live Auth Manager
    "XblGameSave",                  # Xbox Live Game Save
    "XboxNetApiSvc",                # Xbox Live Networking
    "XboxGipSvc",                   # Xbox Accessory Management
    "BthAvctpSvc",                  # AVCTP Service
    "PhoneSvc",                     # Phone Service
    "wisvc",                        # Windows Insider Service
    "RetailDemo",                   # Retail Demo
    "TabletInputService",           # Tablet Input (ถ้าไม่ใช้ touch screen)
    "WbioSrvc",                     # Windows Biometric (ถ้าไม่ใช้ fingerprint)
    "icssvc",                       # Windows Mobile Hotspot
    "lfsvc",                        # Geolocation Service
    "SharedAccess",                 # Internet Connection Sharing
    "WpcMonSvc",                    # Parental Controls
    "SEMgrSvc"                      # Payments and NFC/SE Manager
)

foreach ($service in $servicesToDisable) {
    Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
    Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
}

Write-Host "      Services Optimized!" -ForegroundColor Green

# ==================== DISK & STORAGE OPTIMIZATION ====================
Write-Host "[7/8] Optimizing Disk & Storage..." -ForegroundColor Yellow

# Disable SysMain (Superfetch)
Stop-Service -Name SysMain -Force -ErrorAction SilentlyContinue
Set-Service -Name SysMain -StartupType Disabled -ErrorAction SilentlyContinue

# Disable Windows Search indexing
Stop-Service -Name WSearch -Force -ErrorAction SilentlyContinue
Set-Service -Name WSearch -StartupType Disabled -ErrorAction SilentlyContinue

# Disable disk defrag scheduled task
Get-ScheduledTask -TaskName "ScheduledDefrag" -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null

# NTFS optimizations
fsutil behavior set disablelastaccess 1 | Out-Null
fsutil behavior set disable8dot3 1 | Out-Null

Write-Host "      Disk Optimized!" -ForegroundColor Green

# ==================== VISUAL EFFECTS OPTIMIZATION ====================
Write-Host "[8/8] Optimizing Visual Effects..." -ForegroundColor Yellow

# Disable visual effects for best performance
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -PropertyType DWord -Force

# Disable animations
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -PropertyType Binary -Force
New-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -PropertyType String -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -PropertyType DWord -Force

# Disable transparency
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -PropertyType DWord -Force

Write-Host "      Visual Effects Optimized!" -ForegroundColor Green

# ==================== COMPLETION ====================
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   OPTIMIZATION COMPLETE!              " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please RESTART your computer for all changes to take effect!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Additional Recommendations:" -ForegroundColor Cyan
Write-Host "  1. Run GPEDIT_Network.reg to apply group policy network tweaks" -ForegroundColor White
Write-Host "  2. Run FiveM_Priority.ps1 before launching FiveM" -ForegroundColor White
Write-Host "  3. Use Process Lasso to auto-set FiveM priority" -ForegroundColor White
Write-Host ""
Pause
