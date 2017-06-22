import sys
import os
import time
import re

import pyauto
import keyhac_keymap
from keyhac import *

def configure(keymap):

    if 1:
        keymap.editor = "gvim.exe"

    #----------------------------------------------
    # emacs keybind
    #----------------------------------------------

    emacs_target = [
                    "MCalc.exe"
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
#       if checkProgram("TE64.exe"):
#           self_insert_command("C-w")()
#       else:
        self_insert_command("C-x")()

    def kill_ring_save():
        self_insert_command("C-c")()
        if (checkWindow("sakura.exe$", "EditorClient$|SakuraView166$") or # Sakura Editor
            checkWindow("Code.exe$", "Chrome_WidgetWin_1$")):             # Visual Studio Code
            # 選択されているリージョンのハイライトを解除するために Esc を発行する
            self_insert_command("Esc")()

    def yank():
        self_insert_command("C-v")()

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
        return (processName is None or re.match(processName, keymap.getWindow().getProcessName()))

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

    if 1:
        keymap_myemacs = keymap.defineWindowKeymap( check_func=is_emacs_target )

        keymap_myemacs[ "C-Space" ] = set_mark_command
        keymap_myemacs[ "C-p" ] = mark(previous_line)
        keymap_myemacs[ "C-n" ] = mark(next_line)
        keymap_myemacs[ "C-f" ] = mark(forward_char)
        keymap_myemacs[ "C-b" ] = mark(backward_char)
        keymap_myemacs[ "C-a" ] = mark(move_beginning_of_line)
        keymap_myemacs[ "C-e" ] = mark(move_end_of_line)
        keymap_myemacs[ "C-g" ] = reset_mark(keyboard_quit)
#        keymap_myemacs[ "C-h" ] = reset_mark(delete_backward_char)
        keymap_myemacs[ "C-k" ] = reset_mark(kill_line)
        keymap_myemacs[ "A-S-Comma" ] = mark(beginning_of_buffer)
        keymap_myemacs[ "A-S-Period" ] = mark(end_of_buffer)
#        keymap_myemacs[ "C-w" ] = reset_mark(kill_region)
        keymap_myemacs[ "C-c" ] = reset_mark(kill_ring_save)
        keymap_myemacs[ "C-x" ] = reset_mark(kill_region)
        keymap_myemacs[ "C-y" ] = reset_mark(yank)
        keymap_myemacs[ "C-v" ] = reset_mark(yank)
        keymap_myemacs[ "C-q" ] = "A-F4"       # Exit

    #----------------------------------------------
    # emacs keybind limited
    #----------------------------------------------

    delete_char_list = [
                        "EXCEL.EXE"
                        , "TeraPad.exe"
                        , "vivaldi.exe"
                        , "cmd.exe"
                        , "eclipse.exe"
                        , "idea64.exe"
                        ]

    if 1:
        def able_to_delete_char(window):
            if window.getProcessName() in delete_char_list:
                return True
            return False

        keymap_delete_char = keymap.defineWindowKeymap( check_func=able_to_delete_char )
#        keymap_delete_char[ "C-h" ] = delete_backward_char
        keymap_delete_char[ "C-q" ] = "A-F4"

    if 1:
        def able_to_home_end(window):
            if window.getProcessName() in ("EXCEL.EXE"):
                return True
            return False

        keymap_home_end = keymap.defineWindowKeymap( check_func=able_to_home_end )
        keymap_home_end[ "A-S-Comma" ] = mark(beginning_of_buffer)
        keymap_home_end[ "A-S-Period" ] = mark(end_of_buffer)

    if 1:
        def able_to_handle_cursor(window):
            if window.getProcessName() in ("vivaldi.exe"):
                return True
            return False

        keymap_cursor = keymap.defineWindowKeymap( check_func=able_to_handle_cursor )
        keymap_cursor[ "C-p" ] = previous_line
        keymap_cursor[ "C-n" ] = next_line
        keymap_cursor[ "C-a" ] = move_beginning_of_line
        keymap_cursor[ "C-e" ] = move_end_of_line
        keymap_cursor[ "C-k" ] = reset_mark(kill_line)
#        keymap_cursor[ "C-h" ] = delete_backward_char
        keymap_cursor[ "C-q" ] = "A-F4"

    if 1:
        keymap_acrobat = keymap.defineWindowKeymap( exe_name="AcroRd32.exe", class_name="Edit" )
        keymap_acrobat[ "C-p" ] = previous_line
        keymap_acrobat[ "C-n" ] = next_line
        keymap_acrobat[ "C-f" ] = forward_char
        keymap_acrobat[ "C-b" ] = backward_char
        keymap_acrobat[ "C-a" ] = move_beginning_of_line
        keymap_acrobat[ "C-e" ] = move_end_of_line
#        keymap_acrobat[ "C-h" ] = delete_backward_char
        keymap_acrobat[ "C-q" ] = "A-F4"       # Exit

    #----------------------------------------------
    # my global keybind
    #----------------------------------------------

    keymap_global = keymap.defineWindowKeymap()

    # Esc / Enter / Delete
    if 1:
#        keymap_global[ "C-h" ] = reset_mark(delete_backward_char)
#        keymap_global[ "C-OpenBracket" ] = "Esc"
        keymap_global[ "C-j" ] = "Enter"

#        if window.getProcessName() in ("EXCEL.EXE"):
#        if not (checkWindow("EXCEL.EXE$", "EXCEL")):
#            keymap_global[ "C-d" ] = "Delete"
#            keymap_global[ "S-C-d" ] = "S-Delete"

    # Move Window
    if 1:
        keymap_global[ "S-C-y" ] = keymap.MoveWindowCommand( -20, 0 )
        keymap_global[ "S-C-o" ] = keymap.MoveWindowCommand( +20, 0 )
        keymap_global[ "S-C-i" ] = keymap.MoveWindowCommand( 0, -10 )
        keymap_global[ "S-C-u" ] = keymap.MoveWindowCommand( 0, +10 )

    if 1:
        def minimize_window():
            wnd = keymap.getTopLevelWindow()
            if wnd and not wnd.isMinimized():
                wnd.minimize()

#        keymap_global[ "A-C-m" ] = minimize_window

