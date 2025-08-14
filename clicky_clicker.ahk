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

FileRead, rawKeys, C:\Users\Administrator\AppData\Roaming\MainGUI\configs.cfg
StringSplit, keyLine, rawKeys, 
, 

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
Hotkey, , PauseNow

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
    KeyWait, 
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
    KeyWait, 
    Send, {Alt Down}{Tab}
    Sleep, 100
    Send, {Alt Up}
}

if GetKeyState(closeKey, "P") {
    KeyWait, 
    Send, {Alt Down}{F4}
    Sleep, 100
    Send, {Alt Up}
}

if GetKeyState(mediaKey, "P") {
    KeyWait, 
    Send, {Media_Play_Pause}
}

return
