;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;
#InstallKeybdHook
#UseHook

; The following line is a contribution of NTEmacs wiki http://www49.atwiki.jp/ntemacs/pages/20.html
SetKeyDelay 0

; turns to be 1 when ctrl-x is pressed
is_pre_x = 0
; turns to be 1 when ctrl-space is pressed
is_pre_spc = 0

; Applications you want to disable emacs-like keybindings
; (Please comment out applications you don't use)
is_target()
{
  If is_eclipse()
    Return 1 
  If is_rlogin()
    Return 1 
  If is_vbox()
    Return 1 
  If is_powerpoint()
    Return 1 
  If is_putty()
    Return 1 
  If is_excel()
    Return 1 
  If is_slack()
    Return 1 
  If is_bandZip()
    Return 1 
  IfWinActive,ahk_class FFFTPWin
    Return 1 
  IfWinActive,ahk_class #32770
    Return 1 
  IfWinActive,ahk_class mintty
    Return 1 
  IfWinActive,ahk_class ConsoleWindowClass ; Cygwin
    Return 1 
  IfWinActive,ahk_class MEADOW ; Meadow
    Return 1 
  IfWinActive,ahk_class cygwin/x X rl-xterm-XTerm-0
    Return 1
  IfWinActive,ahk_class MozillaUIWindowClass ; keysnail on Firefox
    Return 1
  ; Avoid VMwareUnity with AutoHotkey
  IfWinActive,ahk_class VMwareUnityHostWndClass
    Return 1
  IfWinActive,ahk_class Vim ; GVIM
    Return 1
  IfWinActive,ahk_class GVim ; GVIM
    Return 1
;  IfWinActive,ahk_class SWT_Window0 ; Eclipse
;    Return 1
;   IfWinActive,ahk_class Xming X
;     Return 1
;   IfWinActive,ahk_class SunAwtFrame
;     Return 1
;   IfWinActive,ahk_class Emacs ; NTEmacs
;     Return 1  
;   IfWinActive,ahk_class XEmacs ; XEmacs on Cygwin
;     Return 1
  Return 0
}

move_beginning_of_topline()
{
  global
  If is_pre_spc
    Send ^+{HOME}
  Else
    Send ^{HOME}
  Return
}

move_end_of_bottomline()
{
  global
  If is_pre_spc
    Send ^+{END}
  Else
    Send ^{END}
  Return
}

type_normal()
{
  Send %A_ThisHotkey%
  global is_pre_spc = 0
  Return
}
newSave()
{
  Send {F12}
  global is_pre_spc = 0
  global is_pre_x = 0
  Return
}
delete_to_index()
{
  Send {ShiftDown}{HOME}{SHIFTUP}
  Sleep 50
  Send ^x
  global is_pre_spc = 0
  Return
}
delete_char()
{
  Send {Del}
  global is_pre_spc = 0
  Return
}
delete_backward_char()
{
  Send {BS}
  global is_pre_spc = 0
  Return
}
kill_line()
{
  Send {ShiftDown}{END}{SHIFTUP}
  Sleep 50 ;[ms] this value depends on your environment
  Send ^x
  global is_pre_spc = 0
  Return
}
open_line()
{
  Send {END}{Enter}{Up}
  global is_pre_spc = 0
  Return
}
quit()
{
  Send {ESC}
  global is_pre_spc = 0
  Return
}
newline()
{
  Send {Enter}
  global is_pre_spc = 0
  Return
}
indent_for_tab_command()
{
  Send {Tab}
  global is_pre_spc = 0
  Return
}
newline_and_indent()
{
  Send {Enter}{Tab}
  global is_pre_spc = 0
  Return
}
isearch_forward()
{
  Send ^f
  global is_pre_spc = 0
  Return
}
isearch_backward()
{
  Send ^f
  global is_pre_spc = 0
  Return
}
kill_region()
{
  Send ^x
  global is_pre_spc = 0
  Return
}
kill_ring_save()
{
  Send ^c
  global is_pre_spc = 0
  Return
}
yank()
{
  Send ^v
  global is_pre_spc = 0
  Return
}
undo()
{
  Send ^z
  global is_pre_spc = 0
  Return
}
find_file()
{
  Send ^o
  global is_pre_x = 0
  Return
}
save_buffer()
{
  Send, ^s
  global is_pre_x = 0
  Return
}
kill_emacs()
{
  Send !{F4}
  global is_pre_x = 0
  Return
}

move_beginning_of_line()
{
  global
  if is_pre_spc
    Send +{HOME}
  Else
    Send {HOME}
  Return
}
move_end_of_line()
{
  global
  if is_pre_spc
    Send +{END}
  Else
    Send {END}
  Return
}
previous_line()
{
  global
  if is_pre_spc
    Send +{Up}
  Else
    Send {Up}
  Return
}
next_line()
{
  global
  if is_pre_spc
    Send +{Down}
  Else
    Send {Down}
  Return
}
forward_char()
{
  global
  if is_pre_spc
    Send +{Right}
  Else
    Send {Right}
  Return
}
backward_char()
{
  global
  if is_pre_spc
    Send +{Left} 
  Else
    Send {Left}
  Return
}
scroll_up()
{
  global
  if is_pre_spc
    Send +{PgUp}
  Else
    Send {PgUp}
  Return
}
scroll_down()
{
  global
  if is_pre_spc
    Send +{PgDn}
  Else
    Send {PgDn}
  Return
}

^f::
  If !is_NPEnable() ;; NOT
    Send %A_ThisHotkey%
  Else
  {
    If is_pre_x
      find_file()
    Else
      forward_char()
  }
  Return  

^d::
  If is_target()
    Send %A_ThisHotkey%
  Else
    delete_char()
  Return

^h::
  If (is_excel() || is_console() || is_eclipse())
    delete_backward_char()
  Else If is_target()
    Send %A_ThisHotkey%
  Else
    delete_backward_char()
  Return

^k::
  If (is_target() || is_slack())
    Send %A_ThisHotkey%
  Else
    kill_line()
  Return

^g::
  If (is_target() || is_word())
    Send %A_ThisHotkey%
  Else
    quit()
  Return

^j::Send {ENTER}

;^m::
;  If is_target()
;    Send %A_ThisHotkey%
;  Else
;    newline()
;  Return

;^r::
;  If is_target()
;    Send %A_ThisHotkey%
;  Else
;    isearch_backward()
;  Return

<^<!r::
  If is_office()
    Send ^{F1}
  Else
    Send %A_ThisHotkey%
  Return

^w::
  If (is_xf() || is_te())
    Send %A_ThisHotkey%
  Else If is_NPEnable()
    kill_region()
  Else If is_vim()
    Send %A_ThisHotkey%
  Else
    Send %A_ThisHotkey%
    global is_pre_spc = 0
  Return

!w::
  If is_NPEnable()
    kill_ring_save()
  Else
    Send %A_ThisHotkey%
  Return

^y::
  If is_target()
    Send %A_ThisHotkey%
  Else
    yank()
  Return

^/::
  If is_target()
    Send %A_ThisHotkey%
  Else
    undo()
  Return  
  
;$^{Space}::
;^vk20sc039::
LCtrl & vk20sc039::
  If is_target()
    Send {CtrlDown}{Space}{CtrlUp}
  Else
  {
    If is_pre_spc
      is_pre_spc = 0
    Else
      is_pre_spc = 1
  }
  Return

^@::
  If is_target()
    Send %A_ThisHotkey%
  Else
  {
    If is_pre_spc
      is_pre_spc = 0
    Else
      is_pre_spc = 1
  }
  Return

^a::
  If is_target()
    Send %A_ThisHotkey%
  Else
    move_beginning_of_line()
  Return
^e::
  If is_target()
    Send %A_ThisHotkey%
  Else
    move_end_of_line()
  Return

^q::
  If allowed_quit()
    kill_emacs()
  Else
    Send %A_ThisHotkey%
  Return

^p::
  If (is_NPEnable() || is_browser())
    previous_line()
  Else
    Send %A_ThisHotkey%
  Return

^n::
  If (is_NPEnable() || is_browser())
    next_line()
  Else
    Send %A_ThisHotkey%
  Return

^b::
  If (is_target() || is_chrome())
    Send %A_ThisHotkey%
  Else
      backward_char()
  Return

^c::
  Send %A_ThisHotkey%
  global is_pre_spc = 0
  Return

^x::
  Send %A_ThisHotkey%
  global is_pre_spc = 0
  Return

^v::
  Send %A_ThisHotkey%
  global is_pre_spc = 0
  Return

!v::
  If (is_vim() || is_putty() || is_vbox())
    ;; Paste
    Send +{Insert}
  Else If is_console()
    Send !{Space}ep
  Else
    Send %A_ThisHotkey%
  Return

^z::
  Send %A_ThisHotkey%
  global is_pre_spc = 0
  Return

<^<!s::
  If is_office()
    newSave()
  Else
    Send %A_ThisHotkey%
  Return

<+<#vkBCsc033::
  If is_target()
    Send %A_ThisHotkey%
  Else
    move_beginning_of_topline()
  Return
<+<#.::
  If is_target()
    Send %A_ThisHotkey%
  Else
    move_end_of_bottomline()
  Return

<^<+m::Send {Appskey}

<^<!p::
  If is_visio()
    Send +{F4}
  Else
    Send %A_ThisHotkey%
  Return

<!d::
  If (is_explorer() || is_xf() || is_te())
    Return
  Else
    Send %A_ThisHotkey%
  Return

<!l::
  If (is_explorer() || is_xf() || is_te())
    Send !d
  Else If is_browser()
    Send ^l
  Else
    Send %A_ThisHotkey%
  Return

