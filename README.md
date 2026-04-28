# 🎮 Game Streaming Environment Manager

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An automated PowerShell utility designed to seamlessly transition a standard productivity desktop into an optimized, low-latency local game-streaming environment using **Sunshine** and **Playnite**.

Whether you're streaming to a handheld device or another room, this script ensures maximum system resources are dedicated to your games and provides a clean return to your regular desktop setup when you're done.

## 📑 Table of Contents
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Usage](#-usage)
- [Configuration](#-configuration)
- [Troubleshooting & Logs](#-troubleshooting--logs)
- [License](#-license)

## ✨ Features

### `Start` Mode (Gaming/Streaming Environment)
* **Instant UI Cleanup:** Minimizes all active windows to clear the desktop interface.
* **Network & Performance Boost:** Elevates **Sunshine** (`Sunshine`, `sunshinesvc`) process priority to 'High', prioritizing streaming traffic and reducing latency. 
* **Resource Management:** Closes non-essential productivity and background apps (e.g., Chrome, Discord, PowerToys, Twinkle Tray) to free up CPU and RAM for demanding titles.
* **Seamless Playnite Integration:** Optionally closes the background Playnite client and relaunches it in Fullscreen mode for a controller-friendly, console-like interface.

### `Stop` Mode (Productivity Environment)
* **Priority Reset:** Returns Sunshine process priority back to 'Normal'.
* **App Restoration:** Quietly restarts the essential productivity applications that were closed during the start sequence without intrusive pop-ups.
* **Playnite Reset:** Safely exits Playnite Fullscreen and relaunches it minimized to the system tray.

## 🛠️ Prerequisites

* **OS:** Windows 10 or Windows 11
* **Environment:** PowerShell (Run as Administrator is required for changing process priorities).
* **Streaming Host:** [Sunshine](https://github.com/LizardByte/Sunshine) installed and running.
* **Game Launcher:** [Playnite](https://playnite.link/) (Optional, utilized via the `-UsePlaynite` switch).

## 🚀 Installation

1. Clone this repository or download the source code:
   ```bash
   git clone [https://github.com/AbrahamHuitron/game-streaming-environment-manager.git](https://github.com/AbrahamHuitron/game-streaming-environment-manager.git)
   ```
2. Place the `game_streaming.ps1` script in a convenient directory (e.g., `C:\Scripts\`).
3. Ensure your system allows local script execution. You may need to run this command in PowerShell as an Administrator once:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## 🎮 Usage

Execute the script via PowerShell, providing the mandatory `-Mode` parameter. You can integrate these commands directly into Sunshine's "Command Preparations" (Do/Undo commands) for fully automated transitions. **The Do/Undo commands must be elevated due to the fact that PowerShell needs admin permissions to change Sunshine/Apollo's Process Priority.**

**1. Launch the Streaming Environment** 

Here you adjust the parameters you'd like to use or NOT use before the stream begins.

```powershell
.\game_streaming.ps1 -Mode Start
```

**2. Launch with Playnite (Fullscreen) w/logging**
Include the `-UsePlaynite` switch to automatically manage the Playnite desktop-to-fullscreen transition. Additionally you can also use `-EnableLogging` to ensure a log file of any programs that fail to start/stop are saved to your desktop.
```powershell
.\game_streaming.ps1 -Mode Start -UsePlaynite -EnableLogging
```

**3. Restore the Productivity Environment**
```powershell
.\game_streaming.ps1 -Mode Stop -UsePlaynite -EnableLogging
```

## ⚙️ Configuration

You can easily customize which applications are managed by editing the arrays at the top of the `game_streaming.ps1` file:

* **`$appsToStop`**: The exact process names to terminate when starting a stream. 
  *(Default: Chrome, Discord, EarTrumpet, Microsoft.CmdPal.UI, PowerToys, Twinkle Tray)*
* **`$appsToRestart`**: The names of the applications to relaunch when ending a stream. The script uses `Get-StartApps` to find and launch them dynamically.

*Note: Discord is hardcoded to launch with `--start-minimized` during the stop sequence to prevent the UI from popping up over your desktop.*

## 📝 Troubleshooting & Logs

This script operates entirely silently without GUI popups. 
* It features dynamic path detection to ensure logs are saved correctly, even if your Desktop is managed by OneDrive.
* If an application fails to start or stop, the script generates a timestamped text file directly on your Desktop (e.g., `Start_Streaming_Error_Log_2026-04-14_1830.txt`).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
**Created by:** Abraham Huitron  
**Version:** 1.0