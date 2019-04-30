; This script is to automate the keys and clicks to exit Apex Legeds as fast as possible and start searching for another match.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; This ensures every time the script is called it stops any previous instance and start a new one.

#InstallKeybdHook ; This is to ensure the script monitors keystrokes.
SetTitleMatchMode, 3 ; 3=EXACT. This is the mode to identify the Apex Legends window ahk_class.

; Start of the actual script.

!Ins:: ; If you press Alt + Ins it executes the lines below.
KeyWait, Ins ; Waits for the Ins key to be released.
KeyWait, Alt

isActive := true

if WinActive("ahk_class Respawn001") ; Checks if Apex Legends window is active (focused). This ahk_class parameter is obtained from AutoHotKey Window Spy.
{
    ; Sending exit keystrokes. Usually for games SendPlay is used instead of SendInput. But in Apex Legends it doesn't work.
    SendInput, {Escape}{Click, 965, 620}{Click, 850, 720} ; Send ESC and 2 clicks at the specified coordinates.

    SetTimer, Timeout, -12000 ; Running the timeout loop asynchronously in 12 seconds. The - sign indicates it starts to run 12 seconds from now and only once and then it stops.
    ; Using a Loop Until to detect the color of the A in the Apex logo in the upper left corner. This appears only when you're in the lobby.
    ; Meaning you've disconnected and we can proceed.
    Loop
    {
        PixelGetColor, color, 108, 30 ; Getting the color in the upper left corner coordinates.
    } Until (color = "0xFFFFFF" || !isActive)

    if (isActive)
    {
        ; Now we want to detect the color of the "READY" A letter in the lower left corner beacuse that only appears when we have skipped all score screens.
        ; We'll keep pressing space to skip all screens until we reach the main lobby screen.
        Loop
        {
            PixelGetColor, color, 240, 960 ; Getting the color at the button coordinates.
            SendInput, {Space}
        } Until (color = "0xF0F0F0" || !isActive)
        SendInput, {Click, 240, 960} ; Click on the big READY button at the lowest left corner to search for a match.
    }

    SetTimer, Timeout, Off ; Stop the timer here also just in case.
}
return ; This stops the script from running further.

; This is to ensure the loop exits, to avoid infinite iterations.
Timeout:
isActive := false
return

ManualAbort:
^!Ins::
SetTimer, Timeout, Off ; Stop the timer here also just in case.
isActive := false
exit