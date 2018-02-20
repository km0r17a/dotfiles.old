import sys
import os
import time
import re

import pyauto
import keyhac_keymap
from keyhac import *

def configure(keymap):

    mackey = True

    if 1:
        keymap.editor = "gvim.exe"

    #----------------------------------------------
    # emacs keybind
    #----------------------------------------------

    emacs_target = [
                    "MCalc.exe"
                    , "chrome.exe"
                    , "vivaldi.exe"
                    , "Giraffe.exe"
                    , "TE64.exe"
                    , "TeraPad.exe"
                    , "WINWORD.EXE"
                    , "notepad.exe"
                    ]

    side_of_ctrl_key = "L"
    side_of_alt_key = "L"

    class MyEmacs:
        pass

    myemacs = MyEmacs()
    myemacs.is_marked = False
    myemacs.is_undo_mode = True

    def is_emacs_target(window):
        if window.getProcessName() in emacs_target:
            return True
        return False

    def delete_backward_char():
        self_insert_command("Back")()

    def delete_char():
        self_insert_command("Delete")()

    def backward_char():
        self_insert_command("Left")()

    def forward_char():
        self_insert_command("Right")()

    def previous_line():
        self_insert_command("Up")()

    def next_line():
        self_insert_command("Down")()

    def move_beginning_of_line():
        self_insert_command("Home")()

    def move_end_of_line():
        self_insert_command("End")()
        if checkWindow("WINWORD.EXE$", "_WwG$"): # Microsoft Word
            if myemacs.is_marked:
                self_insert_command("Left")()

    def beginning_of_buffer():
        self_insert_command("C-Home")()
 
    def end_of_buffer():
        self_insert_command("C-End")()

    def kill_line(repeat=1):
        myemacs.is_marked = True
        if repeat == 1:
            mark(move_end_of_line)()
            delay()
            self_insert_command("C-c", "Delete")() # 改行を消せるようにするため C-x にはしていない
        else:
            def move_end_of_region():
                if checkWindow("WINWORD.EXE$", "_WwG$"): # Microsoft Word
                    for i in range(repeat):
                        next_line()
                    move_beginning_of_line()
                else:
                    for i in range(repeat - 1):
                        next_line()
                    move_end_of_line()
                    forward_char()
            mark(move_end_of_region)()
            delay()
            kill_region()

    def kill_region():
        self_insert_command("C-x")()

    def kill_ring_save():
        self_insert_command("C-c")()
        if (checkWindow("sakura.exe$", "EditorClient$|SakuraView166$") or # Sakura Editor
            checkWindow("Code.exe$", "Chrome_WidgetWin_1$")):             # Visual Studio Code
            # 選択されているリージョンのハイライトを解除するために Esc を発行する
            self_insert_command("Esc")()

    def yank():
        self_insert_command("C-v")()

    def page_up():
        self_insert_command("PageUp")()

    def page_down():
        self_insert_command("PageDown")()

    def set_mark_command():
        if myemacs.is_marked:
            myemacs.is_marked = False
        else:
            myemacs.is_marked = True

    def keyboard_quit():
        # Microsoft Excel または Evernote 以外の場合、Esc を発行する
        if not (checkWindow("EXCEL.EXE$", "EXCEL") or checkWindow("Evernote.exe$", "WebViewHost$")):
            self_insert_command("Esc")()
        keymap.command_RecordStop()
        if myemacs.is_undo_mode:
            myemacs.is_undo_mode = False
        else:
            myemacs.is_undo_mode = True

    def self_insert_command(*keys):
        return keymap.InputKeyCommand(*list(map(addSideModifier, keys)))

    def addSideModifier(key):
        key = key.replace("C-", side_of_ctrl_key + "C-")
        key = key.replace("A-", side_of_alt_key + "A-")
        return key

    def checkProgram(processName):
        return re.match(processName, keymap.wnd.getProcessName())
#        return (processName is None or re.match(processName, keymap.getWindow().getProcessName()))

    def checkWindow(processName, className):
        return ((processName is None or re.match(processName, keymap.getWindow().getProcessName())) and
                (className is None or re.match(className, keymap.getWindow().getClassName())))

    def delay(sec=0.02):
        time.sleep(sec)

    def mark(func):
        def _func():
            if myemacs.is_marked:
                # D-Shift だと、M-< や M-> 押下時に、D-Shift が解除されてしまう。その対策。
                self_insert_command("D-LShift", "D-RShift")()
                delay()
                func()
                self_insert_command("U-LShift", "U-RShift")()
            else:
                func()
        return _func

    def reset_mark(func):
        def _func():
            func()
            myemacs.is_marked = False
        return _func

    def switch_ime(flag):
 
        # if not flag:
        if flag:
            ime_status = 1
        else:
            ime_status = 0
 
        # IMEのON/OFFをセット
        keymap.wnd.setImeStatus(ime_status)

    def ime_on():
        switch_ime(True)
 
    def ime_off():
        switch_ime(False)

    def del_and_imeoff():
        self_insert_command("Esc")()
        keymap.wnd.setImeStatus(0)

    if 1:
        keymap_myemacs = keymap.defineWindowKeymap( check_func=is_emacs_target )

        keymap_myemacs[ "LC-Space" ] = set_mark_command
        keymap_myemacs[ "LC-p" ] = mark(previous_line)
        keymap_myemacs[ "LC-n" ] = mark(next_line)
        keymap_myemacs[ "LC-f" ] = mark(forward_char)
        keymap_myemacs[ "LC-b" ] = mark(backward_char)
        keymap_myemacs[ "LC-a" ] = mark(move_beginning_of_line)
        keymap_myemacs[ "LC-e" ] = mark(move_end_of_line)
        keymap_myemacs[ "LC-g" ] = reset_mark(keyboard_quit)
        keymap_myemacs[ "LC-k" ] = reset_mark(kill_line)
        keymap_myemacs[ "LC-c" ] = reset_mark(kill_ring_save)
        keymap_myemacs[ "LC-x" ] = reset_mark(kill_region)
        keymap_myemacs[ "LC-y" ] = reset_mark(yank)
        keymap_myemacs[ "LC-v" ] = reset_mark(yank)

    if mackey == False:
        keymap_myemacs[ "LC-q" ] = "A-F4"       # Exit

    #----------------------------------------------
    # emacs keybind limited
    #----------------------------------------------

    delete_char_list = [
                        "EXCEL.EXE"
                        , "cmd.exe"
                        , "eclipse.exe"
                        ]

    tab_like_vim_list = [
            "gvim.exe", "idea64.exe", "RLogin.exe", "eclipse.exe"
            ]

    if 1:
        def able_to_delete_char(window):
            if window.getProcessName() in delete_char_list:
                return True
            return False

        keymap_delete_char = keymap.defineWindowKeymap( check_func=able_to_delete_char )

        if mackey == False:
            keymap_delete_char[ "LC-q" ] = "A-F4"

    if 1:
        def select_tab(window):
            if window.getProcessName() in ("chrome.exe", "vivaldi.exe", "TE64.exe"):
                return True
            return False

        keymap_select_tab = keymap.defineWindowKeymap( check_func=select_tab )
        keymap_select_tab[ "LW-LA-i" ] = "F12"
        keymap_select_tab[ "LA-r" ] = "C-R"
        keymap_select_tab[ "LA-t" ] = "C-T"
        keymap_select_tab[ "LA-0" ] = "C-0"
        keymap_select_tab[ "LA-1" ] = "C-1"
        keymap_select_tab[ "LA-2" ] = "C-2"
        keymap_select_tab[ "LA-3" ] = "C-3"
        keymap_select_tab[ "LA-4" ] = "C-4"
        keymap_select_tab[ "LA-5" ] = "C-5"
        keymap_select_tab[ "LA-6" ] = "C-6"
        keymap_select_tab[ "LA-7" ] = "C-7"
        keymap_select_tab[ "LA-9" ] = "C-9"

    if 1:
        def move_tab(window):
            if window.getProcessName() in ("SourceTree.exe", "vivaldi.exe", "chrome.exe", "TE64.exe", "AcroRd32.exe"):
                return True
            return False

        keymap_move_tab = keymap.defineWindowKeymap( check_func=move_tab )
        keymap_move_tab[ "LS-LA-OpenBracket" ] = "Ctrl-Shift-Tab"
        keymap_move_tab[ "LS-LA-CloseBracket" ] = "Ctrl-Tab"

    if 1:
        def is_excel(window):
            if window.getProcessName() in ("EXCEL.EXE"):
                return True
            return False

        keymap_excel = keymap.defineWindowKeymap( check_func=is_excel )
#        keymap_excel[ "LC-LW-Left" ] = "Ctrl-PageUp"
#        keymap_excel[ "LC-LW-Right" ] = "Ctrl-PageDown"
        keymap_excel[ "LS-LA-OpenBracket" ] = "Ctrl-PageUp"
        keymap_excel[ "LS-LA-CloseBracket" ] = "Ctrl-PageDown"
        keymap_excel[ "F11" ] = "Delete"

    if 1:
        def tab_like_vim(window):
            if window.getProcessName() in tab_like_vim_list:
                return True
            return False
        
        keymap_tab_like_vim = keymap.defineWindowKeymap( check_func=tab_like_vim )
        keymap_tab_like_vim[ "LA-LS-OpenBracket" ] = "Esc","g","Shift-t"
        keymap_tab_like_vim[ "LA-LS-CloseBracket" ] = "g","t"

    if 1:
        def is_vim(window):
            if window.getProcessName() in ("gvim.exe", "VirtualBox.exe"):
                return True
            return False

        keymap_vim = keymap.defineWindowKeymap( check_func=is_vim )
        keymap_vim[ "LA-v" ] = "Shift-Insert"

    if 1:
        def is_cmd(window):
            if window.getProcessName() in ("cmd.exe"):
                return True
            return False

        keymap_cmd = keymap.defineWindowKeymap( check_func=is_cmd )
#        keymap_cmd[ "LA-v" ] = "Shift-Space","e","p"
        keymap_cmd[ "LA-v" ] = "Shift-Insert"

    if 1:
        def is_browser(window):
            if window.getProcessName() in ("vivaldi.exe", "chrome.exe", "iexplore.exe"):
                return True
            return False

        keymap_browser = keymap.defineWindowKeymap( check_func=is_browser )
        keymap_browser[ "LA-l" ] = "Ctrl-l"

    if 1:
        def is_filer(window):
            if window.getProcessName() in ("TE64.exe", "explorer.exe"):
                return True
            return False

        keymap_filer = keymap.defineWindowKeymap( check_func=is_filer )
        keymap_filer[ "LA-l" ] = "Alt-d"
        keymap_filer[ "LA-LS-r" ] = "F2"

    if 1:
        def able_to_handle_cursor(window):
            if window.getProcessName() in ("POWERPNT.EXE"):
                return True
            return False

        keymap_cursor = keymap.defineWindowKeymap( check_func=able_to_handle_cursor )
        keymap_cursor[ "LC-Space" ] = set_mark_command
        keymap_cursor[ "LC-p" ] = mark(previous_line)
        keymap_cursor[ "LC-n" ] = mark(next_line)
        keymap_cursor[ "LC-c" ] = reset_mark(kill_ring_save)
        keymap_cursor[ "LC-v" ] = reset_mark(yank)
        keymap_cursor[ "LC-a" ] = move_beginning_of_line
        keymap_cursor[ "LC-e" ] = move_end_of_line
        keymap_cursor[ "LC-k" ] = reset_mark(kill_line)

        if mackey == False:
            keymap_cursor[ "LC-q" ] = "A-F4"

    if 1:
        keymap_acrobat = keymap.defineWindowKeymap( exe_name="AcroRd32.exe", class_name="Edit" )
        keymap_acrobat[ "LC-p" ] = previous_line
        keymap_acrobat[ "LC-n" ] = next_line
        keymap_acrobat[ "LC-f" ] = forward_char
        keymap_acrobat[ "LC-b" ] = backward_char
        keymap_acrobat[ "LC-a" ] = move_beginning_of_line
        keymap_acrobat[ "LC-e" ] = move_end_of_line

        if mackey == False:
            keymap_acrobat[ "LC-q" ] = "A-F4"       # Exit

    #----------------------------------------------
    # exclude application
    #----------------------------------------------

    if 1:
        def excluded(window):
            if window.getProcessName() not in ("EXCEL.EXE", "RLogin.exe"):
                return True
            return False

        keymap_excluded = keymap.defineWindowKeymap( check_func=excluded )
        keymap_excluded[ "LC-d" ] = "Delete"
        keymap_excluded[ "LA-s" ] = "C-S"
        keymap_excluded[ "LA-c" ] = "C-C"

    #----------------------------------------------
    # my global keybind
    #----------------------------------------------

    keymap_global = keymap.defineWindowKeymap()

    # Esc / Enter / Quit
    if 1:
#        keymap_global[ "LC-OpenBracket" ] = del_and_imeoff
        keymap_global[ "LC-OpenBracket" ] = "Esc"
        keymap_global[ "LC-j" ] = "Enter"
        keymap_global[ "LA-q" ] = "Alt-F4"

    # Del / Undo / Copy / Paste
    if 1:
        keymap_global[ "LC-h" ] = reset_mark(delete_backward_char)
        keymap_global[ "LA-z" ] = "C-Z"
        keymap_global[ "LA-w" ] = "C-W"
        keymap_global[ "LA-x" ] = "C-X"
#        keymap_global[ "LA-v" ] = "C-V"

    # Change Desktop
    if 1:
        keymap_global[ "LW-LC-h" ] = "W-C-Left"
        keymap_global[ "LW-LC-l" ] = "W-C-Right"

    # HJKL
    if 1:
        keymap.replaceKey( 242, 243 )

        keymap_global[ "RW-h" ] = mark(backward_char)
        keymap_global[ "RW-l" ] = mark(forward_char) 
        keymap_global[ "RW-j" ] = mark(next_line) 
        keymap_global[ "RW-k" ] = mark(previous_line)
        keymap_global[ "RW-0" ] = mark(move_beginning_of_line)
        keymap_global[ "RW-9" ] = mark(move_end_of_line)

        keymap_global[ "LS-RW-h" ] = "Shift-Left"
        keymap_global[ "LS-RW-l" ] = "Shift-Right"
        keymap_global[ "LS-RW-j" ] = "Shift-Down"
        keymap_global[ "LS-RW-k" ] = "Shift-Up"
        keymap_global[ "LS-RW-0" ] = "Shift-Home"
        keymap_global[ "LS-RW-9" ] = "Shift-End"

    if 0:
        keymap_global[ "RC-h" ] = mark(backward_char)
        keymap_global[ "RC-l" ] = mark(forward_char) 
        keymap_global[ "RC-j" ] = mark(next_line) 
        keymap_global[ "RC-k" ] = mark(previous_line)
        keymap_global[ "RC-0" ] = mark(move_beginning_of_line)
        keymap_global[ "RC-9" ] = mark(move_end_of_line)

        keymap_global[ "LS-RC-h" ] = "Shift-Left"
        keymap_global[ "LS-RC-l" ] = "Shift-Right"
        keymap_global[ "LS-RC-j" ] = "Shift-Down"
        keymap_global[ "LS-RC-k" ] = "Shift-Up"
        keymap_global[ "LS-RC-0" ] = "Shift-Home"
        keymap_global[ "LS-RC-9" ] = "Shift-End"

    if 1:
        keymap_global[ "LA-LS-Comma" ] = mark(beginning_of_buffer)
        keymap_global[ "LA-LS-Period" ] = mark(end_of_buffer)
        keymap_global[ "LW-LC-Comma" ] = mark(page_up)
        keymap_global[ "LW-LC-Period" ] = mark(page_down)

    # Alt + Arrow
    if 1:
        keymap_global[ "A-OpenBracket" ] = "A-Left"
        keymap_global[ "A-CloseBracket" ] = "A-Right"

    # Alt + Tab
    if 1:
        keymap_global[ "LA-j" ] = "Alt-Tab"
        keymap_global[ "LA-k" ] = "Shift-Alt-Tab"

    # Replace
    if 1:
        keymap.replaceKey("Back", "BackSlash")
        keymap.replaceKey("BackSlash", "Back")

    if mackey == False:
        keymap.replaceKey("RWin", "Apps")
        keymap.replaceKey("Apps", "RCtrl")

    if 1:
        keymap_global[ "LC-LW-m" ] = "Apps"

    # Move Window
    if 1:
        keymap_global[ "LS-LC-y" ] = keymap.MoveWindowCommand( -20, 0 )
        keymap_global[ "LS-LC-o" ] = keymap.MoveWindowCommand( +20, 0 )
        keymap_global[ "LS-LC-i" ] = keymap.MoveWindowCommand( 0, -10 )
        keymap_global[ "LS-LC-u" ] = keymap.MoveWindowCommand( 0, +10 )

    if 1:
        def maximize_window():
            wnd = keymap.getTopLevelWindow()
            if wnd and not wnd.isMaximized():
                wnd.maximize()

        def restore_window():
            wnd = keymap.getTopLevelWindow()
            if wnd and wnd.isMaximized():
                wnd.restore()

        def minimize_window():
            wnd = keymap.getTopLevelWindow()
            if wnd and not wnd.isMinimized():
                wnd.minimize()

        def toggle_window():
            wnd = keymap.getTopLevelWindow()
            if wnd and not wnd.isMaximized():
                wnd.maximize()
            elif wnd and wnd.isMaximized():
                wnd.restore()

        keymap_global[ "LW-m" ] = minimize_window
        keymap_global[ "LW-w" ] = toggle_window

