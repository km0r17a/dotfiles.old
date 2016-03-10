#SingleInstance Force ; •¡”‹N“®‚Ì‹Ö~
IfWinNotExist,ahk_exe AltTabTuner8.exe
{
  Run,"C:\usr\AltTabTuner8\AltTabTuner8.exe"
  WinWait,ahk_exe AltTabTuner8.exe
  ControlClick, Apply, ahk_exe AltTabTuner8.exe
  WinClose,ahk_exe AltTabTuner8.exe
}
