#Requires -RunAsAdministrator
<#
.FiveM Priority & Affinity Optimizer
.รันทุกครั้งก่อนเล่น FiveM - ปรับ Priority สูงสุด
#>

Write-Host "FiveM Priority Optimizer - Starting..." -ForegroundColor Cyan

# Function to set process priority
function Set-FiveMPriority {
    $fivemProcesses = @("FiveM.exe", "FiveM_GTAProcess.exe", "FiveM_b2545_GTAProcess.exe", "FiveM_b2699_GTAProcess.exe", "FiveM_b2802_GTAProcess.exe", "FiveM_b2944_GTAProcess.exe")
    
    foreach ($procName in $fivemProcesses) {
        $processes = Get-Process -Name $procName -ErrorAction SilentlyContinue
        foreach ($process in $processes) {
            # Set priority to Realtime (หรือ High ถ้า Realtime ไม่ได้)
            try {
                $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Realtime
            } catch {
                $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
            }
            
            # Set I/O Priority to High
            $process.PriorityBoostEnabled = $true
            
            Write-Host "[$($process.ProcessName)] Priority set to: $($process.PriorityClass)" -ForegroundColor Green
        }
    }
}

# Function to optimize system for gaming
function Optimize-SystemForGaming {
    # Empty standby list (clear RAM cache)
    $memoryStandby = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory
    Write-Host "Freeing up standby memory..." -ForegroundColor Yellow
    
    # Disable dynamic tick temporarily
    bcdedit /set disabledynamictick yes | Out-Null
    
    # Optimize timer resolution
    $timeBeginPeriod = Add-Type -MemberDefinition @"
        [DllImport("winmm.dll")]
        public static extern int timeBeginPeriod(int msec);
"@ -Name "Winmm" -PassThru
    $timeBeginPeriod::timeBeginPeriod(1) | Out-Null
    
    Write-Host "Timer resolution optimized to 1ms" -ForegroundColor Green
}

# Function to kill unnecessary processes while gaming
function Stop-UnnecessaryProcesses {
    $processesToStop = @(
        "OneDrive",
        "Spotify",
        "Discord",  # แก้ไข: รัน Discord แยกถ้าต้องใช้
        "Telegram",
        "Chrome",   # แก้ไข: ปิดเฉพาะ tab ที่ไม่จำเป็น
        "Firefox",
        "Edge",
        "Steam",    # แก้ไข: Steam ควรรันแต่ให้ปิด overlay
        "EpicGamesLauncher",
        "Origin",
        "EA Desktop"
    )
    
    foreach ($proc in $processesToStop) {
        Get-Process -Name $proc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "Unnecessary processes stopped" -ForegroundColor Green
}

# Function to set power plan to ultimate performance
function Set-UltimatePerformance {
    $ultimatePlan = powercfg /list | Select-String "Ultimate Performance" | ForEach-Object { $_.Line.Split()[3] }
    if ($ultimatePlan) {
        powercfg /setactive $ultimatePlan
        Write-Host "Power plan set to: Ultimate Performance" -ForegroundColor Green
    } else {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        $newPlan = powercfg /list | Select-String "Ultimate Performance" | ForEach-Object { $_.Line.Split()[3] }
        powercfg /setactive $newPlan
        Write-Host "Created and activated: Ultimate Performance" -ForegroundColor Green
    }
}

# Main execution
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   FIVEM PRIORITY OPTIMIZER           " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

Set-UltimatePerformance
Optimize-SystemForGaming
Stop-UnnecessaryProcesses

Write-Host ""
Write-Host "Monitoring for FiveM processes..." -ForegroundColor Cyan
Write-Host "Press [Ctrl+C] to stop monitoring" -ForegroundColor Yellow

# Continuous monitoring
while ($true) {
    Set-FiveMPriority
    Start-Sleep -Milliseconds 500
}
