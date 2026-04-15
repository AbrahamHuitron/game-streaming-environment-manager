# 🎮 Game Streaming Environment Manager

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An automated PowerShell utility designed to seamlessly transition a standard productivity desktop into an optimized, low-latency local game-streaming environment using **Sunshine** and **Playnite**.

Whether you're streaming to a handheld device or another room, this script ensures maximum system resources are dedicated to your games and provides a clean return to your regular desktop setup when you're done.

> **💡 Tip:** Add a GIF or screenshot here showing the script in action or your Playnite interface!
> `![Demo](link-to-your-image-or-gif.gif)`

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