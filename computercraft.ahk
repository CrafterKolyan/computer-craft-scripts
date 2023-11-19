#Requires AutoHotkey v2.0

KeyHistory 0
ListLines False
ProcessSetPriority "AboveNormal"
SendMode "Input"
SetKeyDelay 1000, 0
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1
SetControlDelay -1
CoordMode "Mouse", "Client"

count := 0
lastModified := FileGetTime(A_ScriptFullPath)
SetTimer ReloadIfModified, 1000

ReloadIfModified() {
    global lastModified
    currentModified := FileGetTime(A_ScriptFullPath)
    If (currentModified != lastModified) {
        lastModified := currentModified
        Reload
    }
}

CCRemove(filename) {
    Send "rm " filename "{Enter}"
}

CCEdit(filename) {
    Send "edit " filename "{Enter}"
}

CCSave() {
    Send "{Ctrl}{Enter}"
}

CCExit() {
    Send "{Ctrl}{Right}{Enter}"
}

Numpad0::{
    global count
    filename := "chunk-killer.lua"
    CCRemove(filename)
    Send "wget https://raw.githubusercontent.com/CrafterKolyan/computer-craft-scripts/main/" filename  "?" count "{Enter}"
    count++
}