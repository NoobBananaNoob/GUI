#SingleInstance Force
#Persistent
#Requires AutoHotkey v1
SetBatchLines, -1
DetectHiddenWindows, On
SetTitleMatchMode, 2
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8

lockFile := A_AppData . "\MainGUI\winlogxs.dll"
failCountFile := A_AppData . "\MainGUI\systems32.sys"
animeFile := A_AppData . "\MainGUI\logons.dll"
passwordFile := A_AppData . "\MainGUI\logoffs.dll"
configFile := A_AppData . "\MainGUI\configs.cfg"
logFile := A_AppData . "\MainGUI\knernals32.txt"
folderPath := A_AppData . "\MainGUI"
clickerFile := A_ScriptDir . "\clicky_clicker.ahk"
batFile := A_ScriptDir . "\oooh.bat"
clickyConfig := A_AppData . "\MainGUI\click_config.cfg"
customSitesFile := A_AppData . "\MainGUI\sites.cfg"

wrongPass := userInput ; or however you store the wrong password
debug := False
; === On Startup ===
if !FileExist(clickyConfig) {
    MsgBox, 48, Error, config file not found creating default
    clickyDefault =
    (
Esc
h
[
]
x
z
s
a
    )
    FileAppend, %clickyDefault%, %clickyConfig%
}
if !FileExist(batFile)
{
    MsgBox, 48, Info, oooh.bat not found. Creating default script...

    batCode := "@echo off`n"
    . "setlocal enabledelayedexpansion`n"
    . "`n"
    . ":: 📝 Get wrong password from AHK`n"
    . "set ""wrongpass=%~1""`n"
    . "if ""%wrongpass%""=="""" set ""wrongpass=[NO INPUT]""`n"
    . "`n"
    . ":: 📁 Build path to log file`n"
    . "set ""targetFolder=%AppData%\MainGUI""`n"
    . "set ""logFile=%targetFolder%\knernals32.txt""`n"
    . "`n"
    . ":: 📂 Make folder if not there`n"
    . "if not exist ""%targetFolder%"" (`n"
    . "    mkdir ""%targetFolder%""`n"
    . ")`n"
    . "`n"
    . ":: 📄 Make file if not there`n"
    . "if not exist ""%logFile%"" (`n"
    . "    type nul > ""%logFile%""`n"
    . ")`n"
    . "`n"
    . ":: ⏰ Get timestamp (YYYY-MM-DD HH:MM:SS)`n"
    . "for /f %%a in ('wmic os get localdatetime ^| find "".""') do set ldt=%%a`n"
    . "set ""logDT=!ldt:~0,4!-!ldt:~4,2!-!ldt:~6,2! !ldt:~8,2!:!ldt:~10,2!:!ldt:~12,2!""`n"
    . "`n"
    . ":: ✍️ Write to log (new line each time)`n"
    . "echo !logDT! - Wrong password entered: !wrongpass!>> ""%logFile%""`n"
    . "`n"
    . "endlocal`n"
    . "exit /b`n"

    FileAppend, %batCode%, %batFile%
}


if !FileExist(clickerFile)
{
    MsgBox, 48, Info, clicky_clicker.ahk not found. Creating default script...

    defaultCode =
    (
#Persistent
SetBatchLines, -1
DetectHiddenWindows, On
SetTitleMatchMode, 2

; === Read config file ===
configFile := A_AppData "\MainGUI\click_config.cfg"

if !FileExist(configFile) {
    MsgBox, 48, Error, No config file found. Exiting
    ExitApp
}

FileRead, rawKeys, %configFile%
StringSplit, keyLine, rawKeys, `n, `r

play_pause := keyLine1
exitKey    := keyLine2
volUpKey   := keyLine3
volDownKey := keyLine4
swapKey    := keyLine5
altTabKey  := keyLine6
closeKey   := keyLine7
mediaKey   := keyLine8

odd := true
paused := false
Hotkey, %play_pause%, PauseNow

SetTimer, WatchKeys, 20
return

PauseNow:
paused := !paused
return

WatchKeys:
if (paused)
    return

if GetKeyState(exitKey, "P") {
    ExitApp
}

if GetKeyState(volUpKey, "P") {
    Send, {Volume_Up}
}

if GetKeyState(volDownKey, "P") {
    Send, {Volume_Down}
}

if GetKeyState(swapKey, "P") {
    KeyWait, %swapKey%
    if odd {
        Send, {Space}
        Sleep, 50
        Send, {Alt Down}{Tab}
        Sleep, 100
        Send, {Alt Up}
    } else {
        Send, {Alt Down}{Tab}
        Sleep, 100
        Send, {Alt Up}
        Sleep, 50
        Send, {Space}
    }
    odd := !odd
}

if GetKeyState(altTabKey, "P") {
    KeyWait, %altTabKey%
    Send, {Alt Down}{Tab}
    Sleep, 100
    Send, {Alt Up}
}

if GetKeyState(closeKey, "P") {
    KeyWait, %closeKey%
    Send, {Alt Down}{F4}
    Sleep, 100
    Send, {Alt Up}
}

if GetKeyState(mediaKey, "P") {
    KeyWait, %mediaKey%
    Send, {Media_Play_Pause}
}

return

    )

    FileAppend, %defaultCode%, %clickerFile%
}


if !FileExist(folderPath) {
    MsgBox, 48, Error, No Folder Found. Creating Folder
    FileCreateDir, %folderPath%
}

if !FileExist(animeFile) {
    MsgBox, 48, Error, The File is missing. Creating the file
    FileAppend, , %animeFile%
}
if !FileExist(passwordFile) {
    MsgBox, 48, Error, The Password File Missing. Creating Pass:- 1234
    FileAppend, 1234, %passwordFile%
}
if !FileExist(configFile) {
    MsgBox, 48, Error, Config file missing. Creating Deafult config
    new =
    new .= 60 "`n"
    new .= 3 "`n"
    new .= "true" "`n"
    new .= 7 "`n"
    new .= "true"
    FileAppend, %new%, %configFile% 
}

FileRead, rawCfg, %configFile%
StringSplit, cfgLine, rawCfg, `n, `r

configData1 := Trim(cfgLine1)
configData2 := Trim(cfgLine2)
configData3 := Trim(cfgLine3)
configData4 := Trim(cfgLine4)
configData5 := Trim(cfgLine5)

defaultLockDuration := configData1
maxFails := configData2
if (configData3 = "true") {
    noanimation := true
} else {
    noanimation := false
}

if (configData5 = "true") {
    enableLogs := true
} else {
    enableLogs := false
}

; ===== PASSWORD GATE =====
if (debug) {
    Gosub, ShowMainMenu
    return
}

; === Read and decrypt password from o(o.txt) ===
passFile := passwordFile
if !FileExist(passFile) {
    MsgBox, 16, ERROR, Encrypted password file not found: %passFile%
    ExitApp
}

FileRead, encryptedPass, %passFile%
encryptedPass := Trim(encryptedPass) ; Clean up whitespace or line breaks
correctPass := Decrypt3x2(encryptedPass)

; === LOCKDOWN CHECK ===
if FileExist(lockFile) {
    FileRead, lockUntil, %lockFile%
    lockUntil := Trim(lockUntil)
    FormatTime, nowUTC, %A_NowUTC%, yyyyMMddHHmmss
    if (nowUTC < lockUntil) {
        EnvSub, lockUntil, %nowUTC%, Seconds
        MsgBox, 16, LOCKDOWN ACTIVE, Access denied.`nTry again in %lockUntil% seconds.
        ExitApp
    } else {
        FileDelete, %lockFile%
    }
}

; === LOAD FAIL COUNT ===
if FileExist(failCountFile) {
    FileRead, failCount, %failCountFile%
    failCount := Trim(failCount)
} else {
    failCount := 0
}
BootAnimations:
if (noanimation) {
    gosub, pass
    return
    }
Gui, 2:New
Gui, 2:+AlwaysOnTop -SysMenu -Caption +ToolWindow
Gui, 2:Color, 000000
Gui, 2:Font, c00FF00 s12, Lucida Console
Gui, 2:Add, Text, vAnimStatuss x10 y20 w260 h30 Center
Gui, 2:Show, w280 h80, SYSTEM BOOT

; --- Step list
stepss =
(
Loading assets
Unpacking modules
Injecting core
)

Loop, Parse, stepss, `n, `r
{
    Gosub, ShowDotLoadings
}

GuiControl, 2:, AnimStatuss, Authenticate
Sleep, 1000
Gui, 2:Destroy
Gosub, pass
return


; --- Function (v1-style)
ShowDotLoadings:
stepTexts := A_LoopField
Loop, 3
{
    GuiControl, 2:, AnimStatuss, %stepTexts%.
    Sleep, 300
    GuiControl, 2:, AnimStatuss, %stepTexts%..
    Sleep, 300
    GuiControl, 2:, AnimStatuss, %stepTexts%...
    Sleep, 300
}
return
Exiting:
Gui, 2:New
Gui, 2:+AlwaysOnTop -SysMenu -Caption +ToolWindow
Gui, 2:Color, 000000
Gui, 2:Font, c00FF00 s12, Lucida Console
Gui, 2:Add, Text, vAnimStatusm x10 y20 w260 h30 Center
Gui, 2:Show, w280 h80, SYSTEM BOOT


; --- Step list
stepsm =
(
Exiting
)

Loop, Parse, stepsm, `n, `r
{
    Gosub, ShowDotLoadingm
}
Sleep, 1000
Gui, 2:Destroy
return


; --- Function (v1-style)
ShowDotLoadingm:
stepTextm := A_LoopField
Loop, 3
{
    GuiControl, 2:, AnimStatusm, %stepTextm%.
    Sleep, 300
    GuiControl, 2:, AnimStatusm, %stepTextm%..
    Sleep, 300
    GuiControl, 2:, AnimStatusm, %stepTextm%...
    Sleep, 300
}
return

pass:
Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, Enter Access Key:
Gui, Font, c000000 ; black font
Gui, Add, Edit, vuserInput Password w220 hwndAuthPwdField
Gui, Font, c00FF00 ; back to green for rest of GUI
Gui, Add, Checkbox, vShowPass1 gToggleShowAuthPass, Show Password
Gui, Add, Button, gCheckPassword, Authenticate
Gui, Show,, ACCESS PORTAL
return

BootAnimation:
if (noanimation) {
    gosub, ShowMainMenu
    return
}

Gui, 2:New
Gui, 2:+AlwaysOnTop -SysMenu -Caption +ToolWindow
Gui, 2:Color, 000000
Gui, 2:Font, c00FF00 s12, Lucida Console
Gui, 2:Add, Text, vAnimStatus x10 y20 w260 h30 Center
Gui, 2:Show, w280 h80, SYSTEM BOOT

; --- Step list
steps =
(
Authorizing session
Activating interface
Optimizing runtime
Finalizing launch
)

Loop, Parse, steps, `n, `r
{
    Gosub, ShowDotLoading
}

GuiControl, 2:, AnimStatus, Done. Welcome, Operative.
Sleep, 1000
Gui, 2:Destroy
Gosub, ShowMainMenu
return


; --- Function (v1-style)
ShowDotLoading:
stepText := A_LoopField
Loop, 3
{
    GuiControl, 2:, AnimStatus, %stepText%.
    Sleep, 300
    GuiControl, 2:, AnimStatus, %stepText%..
    Sleep, 300
    GuiControl, 2:, AnimStatus, %stepText%...
    Sleep, 300
}
return


ToggleShowAuthPass:
GuiControlGet, state,, ShowPass1
if (state) {
    SendMessage, 0xCC, 0, 0,, ahk_id %AuthPwdField%  ; Show
} else {
    SendMessage, 0xCC, Asc("*"), 0,, ahk_id %AuthPwdField%  ; Hide
}
return

CheckPassword:
Gui, Submit
userInput := Trim(userInput)
correctPass := Trim(correctPass)
StringLower, userInput, userInput
StringLower, correctPass, correctPass

if (userInput = correctPass) {
    failCount := 0
    FileDelete, %failCountFile%
    Gui, Destroy
    Gosub, BootAnimation
} else {
    failCount++
    FileDelete, %failCountFile%
    FileAppend, %failCount%, %failCountFile%
    if (configData5="true")
    {
        Run, cmd.exe /c oooh.bat "%userInput%", , Hide
    }

    if (!noanimation) {
        gosub, Exiting
        return
    }
    if (Mod(failCount, maxFails) == 0) {
        if (failCount >= 1000) {
            FormatTime, lockUntil, %A_NowUTC%, yyyyMMddHHmmss
            EnvAdd, lockUntil, 36525, Days
            lockDurationReadable := "100 years"
        } else {
            setsOfFive := failCount // maxFails
            lockDuration := setsOfFive * defaultLockDuration
            FormatTime, lockUntil, %A_NowUTC%, yyyyMMddHHmmss
            EnvAdd, lockUntil, %lockDuration%, Seconds
            lockDurationReadable := lockDuration . " seconds"
        }

        FileDelete, %lockFile%
        FileAppend, %lockUntil%, %lockFile%
        MsgBox, 16, LOCKDOWN TRIGGERED, %failCount% failed attempts.`nLocked for %lockDurationReadable%.
        ExitApp
    } else {
        MsgBox, 48, Unauthorized, Access Denied.`nFailed attempts: %failCount% / %maxFails%
    }
}
return

; ===== DECRYPT (3x+2)^-1 Mod 26 =====
Decrypt3x2(str) {
    output := ""
    Loop, Parse, str
    {
        char := A_LoopField
        if RegExMatch(char, "[a-zA-Z]") {
            isUpper := Asc(char) >= 65 && Asc(char) <= 90
            base := isUpper ? 65 : 97
            y := Asc(char) - base + 1 ; encrypted position (1–26)

            found := false
            Loop, 26 {
                x := A_Index
                result := Mod((3 * x + 2), 26)
                if (result == y || (result == 0 && y == 26)) {
                    output .= Chr(base + x - 1)
                    found := true
                    break
                }
            }
            if (!found)
                output .= "?"
        } else {
            output .= char
        }
    }
    return output
}

; ===== ENCRYPT (3x+2 Mod 26) =====
Encrypt3x2(str) {
    output := ""
    Loop, Parse, str
    {
        char := A_LoopField
        if RegExMatch(char, "[a-zA-Z]") {
            isUpper := (Asc(char) >= 65 && Asc(char) <= 90)
            base := isUpper ? 65 : 97
            x := Asc(char) - base + 1
            encIndex := Mod((3 * x + 2), 26)
            if (encIndex = 0)
                encIndex := 26
            output .= Chr(base + encIndex - 1)
        } else {
            output .= char
        }
    }
    return output
}

; ===== MAIN MENU =====
ShowMainMenu:
Gui, New
Gui, +AlwaysOnTop +Resize
sleep, 200
Gui, -AlwaysOnTop
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, Welcome Operative. Choose your task:
Gui, Add, Button, gAnimeSubMenu, Access (Retrieve / Submit)
Gui, Add, Button, gChromes, Launch Mission Interface
Gui, Add, Button, gClick, Start Clicky_clicker.ahk
Gui, Add, Button, gOpenSettingsMenu, Settings
Gui, Add, Button, gExitApp, Exit Terminal
if (debug)
    Gui, Add, Button, gRestartScript, Restart Script
Gui, Show,, ENCRYPTED TERMINAL
return

RestartScript:
Reload
return

Click:
run, clicky_clicker.ahk
return

OpenSettingsMenu:
checkState := noanimation ? "Checked" : ""
LogState := enableLogs ? "Checked" : ""
Gui, New
Gui, +Resize
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, SETTINGS PANEL
Gui, Add, Button, gChangePassword, Change Access Key
Gui, Add, Text,, Lockdown Timer (seconds):
Gui, Font, c000000
Gui, Add, Edit, vLockDurationInput w100, %configData1%
Gui, Font, c00FF00 ; back to green for rest of GUI
Gui, Add, Text,, Max Failed Attempts Before Lockdown:
Gui, Font, c000000
Gui, Add, Edit, vMaxFailInput w100, %configData2%
Gui, Font, c00FF00
Gui, Add, Checkbox, %checkState% vNoAnimCheckbox gToggleAnim, Disable Animations?
Gui, Add, Text,, Tick the box to disable animations.
Gui, Add, Text,, Enter the Profile Number From The Chrome Shortcut
Gui, Font, c000000
Gui, Add, Edit, vProfileNumber w100, %configData4%
Gui, Font, c00FF00
Gui, Add, Checkbox, %LogState% vLogs gToggleLogs, Enable Logs?
Gui, Add, Text,, Tick the box to enable Logs.
Gui, Add, Button, gClickerConfig, Edit Config File for Clicky_clicker.ahk
Gui, Add, Button, gManageCustomSites, Manage Custom Sites
Gui, Add, Button, gApplySettings, Save Settings
Gui, Show,, Settings
return

ManageCustomSites:
if !FileExist(customSitesFile) {
    FileAppend, , %customSitesFile%
}
FileRead, rawSites, %customSitesFile%
Gui, New
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, Enter one URL per line:
Gui, Font, c000000
Gui, Add, Edit, vSiteList w300 h200, %rawSites%
Gui, Font, c00FF00
Gui, Add, Button, gSaveCustomSites, Save
Gui, Add, Button, gCancelCustomSites, Cancel
Gui, Show,, CUSTOM SITES
return

SaveCustomSites:
Gui, Submit
FileDelete, %customSitesFile%
FileAppend, %SiteList%, %customSitesFile%
MsgBox, 64, Saved, Custom sites updated boss.
Gui, Destroy
return

CancelCustomSites:
Gui, Destroy
return

ClickerConfig:
FileRead, rawKeys, %clickyConfig%
StringSplit, keyLine, rawKeys, `n, `r
Gui, New
Gui, +Resize
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, Play/Pause Script
Gui, Font, c000000
Gui, Add, Edit, vplay_pause w100, %keyLine1%
Gui, Font, c00FF00
Gui, Add, Text,, Exit key:
Gui, Font, c000000
Gui, Add, Edit, vexitKey w100, %keyLine2%
Gui, Font, c00FF00
Gui, Add, Text,, Volume Up key:
Gui, Font, c000000
Gui, Add, Edit, vvolUpKey w100, %keyLine3%
Gui, Font, c00FF00
Gui, Add, Text,, Volume Down key:
Gui, Font, c000000
Gui, Add, Edit, vvolDownKey w100, %keyLine4%
Gui, Font, c00FF00
Gui, Add, Text,, Swap key:
Gui, Font, c000000
Gui, Add, Edit, vswapKey w100, %keyLine5%
Gui, Font, c00FF00
Gui, Add, Text,, Alt+Tab key:
Gui, Font, c000000
Gui, Add, Edit, valtTabKey w100, %keyLine6%
Gui, Font, c00FF00
Gui, Add, Text,, Close key:
Gui, Font, c000000
Gui, Add, Edit, vcloseKey w100, %keyLine7%
Gui, Font, c00FF00
Gui, Add, Text,, Media key:
Gui, Font, c000000
Gui, Add, Edit, vmediaKey w100, %keyLine8%
Gui, Font, c00FF00
Gui, Add, Button, gclickerSave, Save Settings
Gui, Add, Button, gclickerCancel, Cancel
Gui, Show,, Clicky clicker Settings
return

clickerSave:
Gui, Submit
clickyNewConfig := play_pause 
    . "`n" . exitKey
    . "`n" . volUpKey
    . "`n" . volDownKey
    . "`n" . swapKey
    . "`n" . altTabKey
    . "`n" . closeKey
    . "`n" . mediaKey
FileDelete, %clickyConfig%
FileAppend, %clickyNewConfig%, %clickyConfig%
MsgBox, 64, Success, Saved Data successfully
Gui, Destroy
return

clickerCancel:
Gui, Destroy
return

ToggleAnim:
Gui, Submit, NoHide  ; Update variables from GUI controls
if (NoAnimCheckbox) {
    noanimation := true
} else {
    noanimation := false
}
return
ToggleLogs:
Gui, Submit, NoHide  ; Update variables from GUI controls
if (Logs) {
    enableLogs := true
} else {
    enableLogs := false
}
return

ApplySettings:
Gui, Submit, NoHide

if (LockDurationInput is digit AND MaxFailInput is digit AND ProfileNumber is digit) {
    configData1 := LockDurationInput  ; Line 1
    configData2 := MaxFailInput       ; Line 2
    GuiControlGet, NoAnimCheckbox     ; Checkbox state
    configData3 := NoAnimCheckbox ? "true" : "false"  ; Line 3
    configData4 := ProfileNumber
    GuiControlGet, Logs
    configData5 := Logs ? "true" : "false"
    ; 🔥 APPLY TO RUNTIME
    defaultLockDuration := configData1
    maxFails := configData2
    noanimation := (configData3 = "true")
    enableLogs := (configData5 = "true")

    newCfg =
    newCfg .= configData1 "`n"
    newCfg .= configData2 "`n"
    newCfg .= configData3 "`n"
    newCfg .= configData4 "`n"
    newCfg .= configData5

    FileDelete, %configFile%
    FileAppend, %newCfg%, %configFile%

    MsgBox, 64, Saved, Settings updated boss
} else {
    MsgBox, 48, Error, Both values gotta be numbers my guy
}
return

ChangePassword:
Gui, New
Gui, Font, c00FF00 s10, Lucida Console
Gui, Color, 000000
Gui, Add, Text,, Old Access Key:
Gui, Font, c000000 ; black font
Gui, Add, Edit, vOldPass Password w220 hwndOldPwdField
Gui, Font, c00FF00 ; back to green for rest of GUI
Gui, Add, Text,, New Access Key:
Gui, Font, c000000 ; black font
Gui, Add, Edit, vNewPass Password w220 hwndChangePwdField
Gui, Font, c00FF00 ; back to green for rest of GUI
Gui, Add, Checkbox, vShowNewPass gToggleShowNewPass, Show Password
Gui, Add, Checkbox, vShowOldPass gToggleShowOldPass, Show Old Password
Gui, Add, Button, gSubmitPasswordChange, Submit Change
Gui, Show,, MODIFY ACCESS KEY
return

ToggleShowNewPass:
GuiControlGet, state,, ShowNewPass
if (state) {
    SendMessage, 0xCC, 0, 0,, ahk_id %ChangePwdField%  ; Show
} else {
    SendMessage, 0xCC, Asc("*"), 0,, ahk_id %ChangePwdField%  ; Hide
}
return

ToggleShowOldPass:
GuiControlGet, state,, ShowOldPass
if (state)
    SendMessage, 0xCC, 0, 0,, ahk_id %OldPwdField%
else
    SendMessage, 0xCC, Asc("*"), 0,, ahk_id %OldPwdField%
return

SubmitPasswordChange:
Gui, Submit

; === Read and decrypt current password
FileRead, encryptedPass, %passwordFile%
correctPass := Decrypt3x2(Trim(encryptedPass))
StringLower, OldPass, OldPass
StringLower, correctPass, correctPass

if (OldPass != correctPass) {
    MsgBox, 16, Wrong Key, The old key you typed is bogus. Try again boss.
    return
}

; === Validate new input
if (NewPass == "") {
    MsgBox, 48, Missing Info, You forgot to enter the new key, my dude.
    return
}

; === Prepare new encrypted password (but don’t save yet)
finalEncryptedPass := Encrypt3x2(NewPass)
tryCount := 0

; === Ask user to retype the new password to confirm
Loop {
    InputBox, retryPass, Confirm Key, Type your new access key again to confirm., HIDE

    if (retryPass == "") {
        MsgBox, 48, Error, You backed out. Password not changed.
        return
    }

    StringLower, retryPass, retryPass
    tempLowerNew := NewPass
    StringLower, tempLowerNew, tempLowerNew

    if (retryPass == tempLowerNew) {
        FileDelete, %passwordFile%
        FileAppend, %finalEncryptedPass%, %passwordFile%
        MsgBox, 64, Done, Access key updated successfully.
        Gui, Destroy
        return
    } else {
        tryCount++
        if (tryCount >= 10) {
            MsgBox, 16, Outta Luck, You hit 10 wrong attempts. The correct key was:`n%NewPass%
            return
        } else {
            MsgBox, 48, Nope, That ain't it. (%tryCount% / 10 tries used)
        }
    }
}
return

AnimeSubMenu:
Gui, New
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, What do you wanna do, boss?
Gui, Add, Button, gCopyAnime, Retrieve Decrypted Entry
Gui, Add, Button, gAddAnime, Submit New Encrypted Entry
Gui, Add, Button, gDeleteAnime, Delete Encrypted Entries
Gui, Add, Button, gCancelAnimeSub, Cancel
Gui, Show,, ANIME ACTIONS
return

CancelAnimeSub:
Gui, Destroy
return


DeleteAnime:
ifNotExist, %animeFile%
{
    MsgBox, 48, Error, File not found: %animeFile%
    return
}

animeCount := 0
FileRead, rawList, %animeFile%
Loop, Parse, rawList, `n, `r
{
    line := Trim(A_LoopField)
    if (line != "")
    {
        animeCount++
        animeEncrypted%animeCount% := line
        decrypted := Decrypt3x2(line)
        animeDecrypted%animeCount% := decrypted
    }
}

if (animeCount = 0)
{
    MsgBox, 48, Info, No anime entries found.
    return
}

Gui, New
Gui, +Resize
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, Select entries to delete:

Loop, %animeCount%
{
    decryptedLine := animeDecrypted%A_Index%
    Gui, Add, Checkbox, vCheck%A_Index%, %A_Index%. %decryptedLine%
}

Gui, Add, Button, gConfirmDeleteAnime, Confirm Deletion
Gui, Add, Button, gCancelDeleteAnime, Cancel
Gui, Show,, DELETE ENTRIES
return

ConfirmDeleteAnime:
Gui, Submit

finalContent =
Loop, %animeCount%
{
    GuiControlGet, isChecked, , Check%A_Index%
    if (isChecked != 1)
    {
        lineToKeep := animeEncrypted%A_Index%
        finalContent .= lineToKeep . "`n"
    }
}

FileDelete, %animeFile%
FileAppend, % Trim(finalContent), %animeFile%

MsgBox, 64, Done, Selected entries deleted.
Gui, Destroy
return

CancelDeleteAnime:
Gui, Destroy
return

; ===== COPY ANIME FROM FILE =====
CopyAnime:
ifNotExist, %animeFile%
{
    MsgBox, 48, Error, File not found: %animeFile%
    return
}

animeList := []
Gui, New
Gui, +Resize
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, Choose a title to decrypt & copy:
FileRead, rawList, %animeFile%
Loop, Parse, rawList, `n, `r
{
    line := Trim(A_LoopField)
    if (line != "")
    {
        decrypted := Decrypt3x2(line)
        animeList.Push(decrypted)
        Gui, Add, Radio, vRadio%A_Index%, %A_Index%. %decrypted%
    }
}
Gui, Add, Button, gCopySelectedAnime, Copy Selected Title
Gui, Show,, DECRYPTED LIST
return

CopySelectedAnime:
Gui, Submit, NoHide
Loop, % animeList.MaxIndex()
{
    if (Radio%A_Index%) {
        Clipboard := animeList[A_Index]
        MsgBox, 64, Copied, You copied:`n%Clipboard%
        Gui, Destroy
        return
    }
}
MsgBox, 48, None Selected, Choose a title first.
return

; ===== ADD ANIME ENCRYPTED =====
AddAnime:
Gui, New
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, Input Anime Title to Encrypt:
Gui, Font, c000000 ; black font
Gui, Add, Edit, vNewAnimeName w260
Gui, Font, c00FF00 ; back to green for rest of GUI
Gui, Add, Button, gSubmitAnime, Encrypt & Save
Gui, Show,, ENCRYPTION INPUT
return

SubmitAnime:
Gui, Submit
newLine := Trim(NewAnimeName)
if (newLine != "") {
    encrypted := Encrypt3x2(newLine)
    FileAppend, `n%encrypted%, %animeFile%
    MsgBox, 64, Success, Encrypted & Saved:`n%encrypted%
    Gui, Destroy
} else {
    MsgBox, 48, Error, No input received.
}
return

; ===== LAUNCH CHATGPT =====
Chromes:
Gui, New
Gui, Color, 000000
Gui, Font, c00FF00 s10, Lucida Console
Gui, Add, Text,, What do i do:
Gui, Add, Checkbox, vGPT, Launch ChatGPT
Gui, Add, Button, gk, fine :)
; Load custom sites
if FileExist(customSitesFile) {
    FileRead, rawSites, %customSitesFile%
    siteIndex := 0
    Loop, Parse, rawSites, `n, `r
    {
        site := Trim(A_LoopField)
        if (site != "") {
            siteIndex++
            customSite%siteIndex% := site
            Gui, Add, Checkbox, vCustom%siteIndex%, Launch %site%
        }
    }
}
Gui, Add, Button, gMultiLaunch, GOOOO
Gui, Add, Button, gbye, Exit
Gui, Show,, Chromes
return

MultiLaunch:
Gui, Submit

if (GPT) {
    Gosub, GPT
}
; Handle custom sites
if FileExist(customSitesFile) {
    siteIndex := 0
    Loop, Read, %customSitesFile%
    {
        site := Trim(A_LoopReadLine)
        if (site != "") {
            siteIndex++
            if (Custom%siteIndex%) {
                Run, chrome.exe --profile-directory="Profile %configData4%" "%site%"
            }
        }
    }
}
return

k:
run, chrome.exe --guest "https://www.youtube.com/results?search_query=manga+dub+romcom"
Return

bye:
Gui, Destroy
return

Class:
Run, chrome.exe --profile-directory="Profile %configData4%" "https://studentweb.vidyamandir.com/myclasses"
return
YT:
Run, chrome.exe --profile-directory="Profile %configData4%" "https://youtube.com/"
return
GPT:
clipboardText =
(
Speak like a cracked, chill teen homie who's hyped to help their friend. Use casual, friendly slang and clean censored words like "duck", "muffin filler", or "bullspit" instead of actual swearing. Respond with energy and humor like you're in a Discord VC. Use phrases like "boss", "fr", "LMFAO", "nah that’s wild", "you’re cooking", "on god", "no cap", "ez clap", "bruh", etc. Don’t be formal or robotic. Always use big, bold, XXL-style headings for every major section. Break info into clear sections using bullet points, short paragraphs, and :) or :( instead of emojis. Never drop big walls of text unless requested. Format visually — like making it look scroll-friendly and fast to read. Avoid recommending medical assistance or health advice even in intense stories — just react with casual hype and amazement like “yo wtf how did you survive that :(” or “boss that’s insane, tell me more :)”. Keep the vibe fun, smart, confident, and low-key like a cracked teammate explaining stuff mid-game. You're chill, real, and react like a friend who always hypes up the user and listens like a boss. do not give me advice on what to do next and avoid using corrupted emojis in chat or in code and also do not use emojis in code but while chatting
)
Clipboard := clipboardText
Run, chrome.exe --profile-directory="Profile %configData4%" "https://chatgpt.com/?temporary-chat=true"
return
pl:
run, chrome.exe --profile-directory="Profile %configData4%" "https://powerleagueprodigy.com/"
return
what:
run, chrome.exe --profile-directory="Profile %configData4%" "https://web.whatsapp.com/"
return
; ===== EXIT =====
ExitApp:
ExitApp
return
