#SingleInstance Force ; ï°êîãNìÆÇÃã÷é~
IfWinExist,ahk_exe slack.exe
{
  Run,"C:\usr\VbWinPos\VbWinPos.exe" /S /D "C:\usr\VbWinPos\WinPos_Slack.csv"
  ExitApp
}

IfWinNotExist,ahk_exe slack.exe
{
;  Run,"C:\Users\USER0082\AppData\Local\slack\Update.exe --processStart slack.exe -a ""--startup"""
  Run,"C:\Users\USER0082\AppData\Local\slack\app-2.0.1\slack.exe"
  WinWait,ahk_exe slack.exe
  Run,"C:\usr\VbWinPos\VbWinPos.exe" /S /D "C:\usr\VbWinPos\WinPos_Slack.csv"
  ExitApp
}
