# Title: Game Streaming Environment Manager (Sunshine/Playnite)
# Created By: Abraham Huitron
# Created Date: 04/14/2026
# Updated Date: 04/14/2026
# Version: 1.1
# Update Log: Added toggle flag for desktop error logging

<#
.SYNOPSIS
    Streaming Environment Manager (Sunshine/Playnite)

.DESCRIPTION
    Automates transitions between productivity and gaming/streaming environments.
    - 'Start': Minimizes UI, boosts Sunshine priority, stops background apps, and launches Playnite.
    - 'Stop': Resets priority, restores background apps, and resets Playnite to background.
    Logging: Saves errors to a timestamped .txt file on the Desktop when the -EnableLogging flag is used.
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('Start', 'Stop')]
    [string]$Mode,

    # --- TOGGLE FLAGS ---
    # [switch] is used to prevent the "Cannot convert System.String to Boolean" error.
    [switch]$UsePlaynite,
    [switch]$EnableLogging
)

# --- CONFIGURATION ---
$appsToStop = @(
    'Chrome'
    ,'Discord'
    ,'EarTrumpet'
    ,'Microsoft.CmdPal.UI'
    ,'PowerToys'
    ,'Twinkle Tray'
    #,'FakeApp' # Used for testing error handling
)

$appsToRestart = @(
    'Discord'
    ,'EarTrumpet'
    ,'PowerToys'
    ,'Twinkle Tray'
    #,'FakeApp' # Used for testing error handling
)

$playnitePath = "$env:LOCALAPPDATA\Playnite\Playnite.DesktopApp.exe"

# 1. DYNAMIC PATH DETECTION
# This ensures the log file is created correctly even with OneDrive active.
$sessionTime = Get-Date -Format 'yyyy-MM-dd_HHmm'
$desktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$script:failedApps = @()

# Helper function to track errors
function Track-Error($AppName, $Action) {
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    # Use ${} to prevent drive-reference parser errors.
    $errorMessage = "$timestamp | FAILED to ${Action}: $AppName"
    $script:failedApps += $errorMessage
    Write-Host "Error: $errorMessage" -ForegroundColor Yellow
}

# 1. Handle Service Priority
try {
    $sunshineProcesses = Get-Process -Name 'Sunshine', 'sunshinesvc' -ErrorAction SilentlyContinue
    foreach ($process in $sunshineProcesses) {
        $priority = if ($Mode -eq 'Start') { 'High' } else { 'Normal' }
        $process.PriorityClass = $priority
        Write-Host "Set priority for $($process.Name) to $priority." -ForegroundColor Magenta
    }
} catch {
    Write-Warning "Admin privileges required to change process priority."
}

# 2. Execute Action
Write-Host "Minimizing all windows..." -ForegroundColor Yellow
(New-Object -ComObject Shell.Application).MinimizeAll()

if ($Mode -eq 'Start') {
    # --- STANDARD APP STOP ---
    foreach ($app in $appsToStop) {
        try {
            $proc = Get-Process -Name $app -ErrorAction SilentlyContinue
            if ($proc) {
                Write-Host "Stopping $app..." -ForegroundColor Red
                $proc | Stop-Process -Force -ErrorAction Stop
            } else {
                Track-Error $app "Find"
            }
        } catch { Track-Error $app "Stop" }
    }

    # --- START PLAYNITE (FULLSCREEN) ---
    if ($UsePlaynite -and (Test-Path $playnitePath)) {
        try {
            Get-Process -Name "Playnite.DesktopApp" -ErrorAction SilentlyContinue | Stop-Process -Force
            Write-Host "Launching Playnite in Fullscreen..." -ForegroundColor Green
            Start-Process $playnitePath -ArgumentList "--startfullscreen", "--hidesplashscreen", "--nolibupdate" -ErrorAction Stop
        } catch { Track-Error "Playnite" "Start" }
    }

} else {
    # --- STOP LOGIC (RESTART APPS) ---
    
    # --- RESET PLAYNITE (BACKGROUND) ---
    if ($UsePlaynite -and (Test-Path $playnitePath)) {
        try {
            Write-Host "Resetting Playnite to Background..." -ForegroundColor Cyan
            Get-Process -Name "Playnite.DesktopApp" -ErrorAction SilentlyContinue | Stop-Process -Force | Wait-Process
            Start-Process $playnitePath -ArgumentList "--startdesktop", "--startminimized", "--hidesplashscreen", "--nolibupdate" -ErrorAction Stop
        } catch { Track-Error "Playnite" "Reset" }
    }

    # Restoring Productivity Apps
    $startApps = Get-StartApps 
    foreach ($appName in $appsToRestart) {
        try {
            $procName = $appName -replace '\s',''
            if (-not (Get-Process -Name $procName -ErrorAction SilentlyContinue)) {
                if ($appName -eq 'Discord') {
                    $discordPath = "$env:LOCALAPPDATA\Discord\Update.exe"
                    Start-Process $discordPath -ArgumentList "--processStart Discord.exe --process-start-args `"--start-minimized`"" -ErrorAction Stop
                } else {
                    $appEntry = $startApps | Where-Object { $_.Name -like "*$appName*" } | Select-Object -First 1
                    if ($appEntry) { 
                        Write-Host "Starting $appName..." -ForegroundColor Green
                        Start-Process "shell:AppsFolder\$($appEntry.AppID)" -ErrorAction Stop
                    } else {
                        Track-Error $appName "Restart"
                    }
                }
            }
        } catch { Track-Error $appName "Restart" }
    }
}

# --- LOGGING ONLY (GUI POPUPS REMOVED) ---
if ($EnableLogging -and ($script:failedApps.Count -gt 0)) {
    try {
        $prefix = if ($Mode -eq 'Start') { "Start_" } else { "End_" }
        $logFileName = "${prefix}Streaming_Error_Log_${sessionTime}.txt"
        $logFile = Join-Path $desktopPath $logFileName

        $script:failedApps | Out-File -FilePath $logFile -Append -Encoding utf8
        Write-Host "Errors logged to: $logFile" -ForegroundColor Yellow
    } catch {
        Write-Error "Could not write to log file"
    }
}