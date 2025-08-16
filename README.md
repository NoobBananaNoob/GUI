# GUI
Encrypted Terminal & Access Control System (AutoHotkey v1)
This script is a GUI-based authentication and control panel built in AutoHotkey v1. It acts as a secure access gateway for launching programs, managing encrypted data entries, and configuring system-like settings — all with a retro terminal aesthetic.

# Features
# Password-Protected Access

Passwords are stored in an encrypted format using a custom (3x+2) mod 26 cipher.

Optional password visibility toggle for login fields.

Built-in password change system with confirmation checks.

# Fail Attempt Tracking & Lockdowns

Configurable max failed attempts before temporary or long-term lockout.

Lockout duration fully customizable in the settings panel.

Persistent fail count tracking across sessions.

Optional logging of wrong attempts (saved with timestamps via a batch file).

# Custom Boot & Exit Animations

Authentic terminal-style loading steps.

Option to disable animations for faster access.

# Configurable Settings Panel

Change lockout time, failed attempt limit, Chrome profile number, animations, and logging.

All settings saved to configs.cfg for persistence.

Encrypted Data Management

Store and retrieve encrypted "entries" (can be adapted for any kind of text).

Add new entries (auto-encrypted).

View and copy decrypted entries.

Selectively delete stored entries.

# Program & Web Launcher

One-click launch for:

clicky_clicker.exe

Chrome with specific profiles and URLs (YouTube, ChatGPT, class portals, etc.)

Multi-launch options for running several tasks at once.

# Self-Healing File Structure

On startup, missing config or data files are recreated with default values.

Generates required folders in %AppData%\MainGUI.

# Integrated Logging System

Wrong password attempts can be recorded with timestamps to a secure log file.

Log creation handled by an auto-generated oooh.bat file.

# File Structure
The script stores its data in:

%AppData%\MainGUI\
  ├─ winlogxs.dll        → Lockdown timestamp
 
  ├─ systems32.sys       → Failed attempt count
 
  ├─ logons.dll          → Encrypted entries
 
  ├─ logoffs.dll         → Encrypted password
 
  ├─ configs.cfg         → User settings
 
  ├─ knernals32.txt      → Log file for wrong attempts (optional)
 
# Usage
Run the script with AutoHotkey v1.

Enter the correct access key to unlock the main menu.

Navigate through:

Access → Manage encrypted entries.

Launch Mission Interface → Open web tools.

Start Clicky_clicker.exe → Launch a local executable.

Settings → Change system parameters
