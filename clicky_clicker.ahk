#Persistent
SetBatchLines, -1
DetectHiddenWindows, On
SetTitleMatchMode, 2

odd := true
paused := false

SetTimer, WatchKeys, 20
return

Esc::paused := !paused

WatchKeys:
if (paused)
    return

if GetKeyState("h", "P") {
    ExitApp
}

if GetKeyState("x", "P") {
    KeyWait, x
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

if GetKeyState("z", "P") {
    KeyWait, z
    Send, {Alt Down}{Tab}
    Sleep, 100
    Send, {Alt Up}
}

if GetKeyState("s", "P") {
    KeyWait, s
    send, {Alt Down}{F4}
    sleep, 100
    send, {Alt Up}
}

if GetKeyState("a", "P")
{
    KeyWait, a
    Send, {Media_Play_Pause}
}

return