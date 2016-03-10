#SingleInstance Force ; 複数起動の禁止

	; .xls  : Excel.Sheet.8
	; .xlsx : Excel.Sheet.12
	aDir := ["Excel.Sheet.12","Excel.Sheet.8","Excel.SheetMacroEnabled.12","Excel.CSV"]
	Loop, % aDir.MaxIndex()
	{
		dir := aDir[A_Index]

		; 「別のウィンドウで開く」という項目を作る
		RegWrite, REG_SZ, HKCR, %dir%\shell\OpenInNewWindow, , 別のウィンドウで開く(&W)
		if(ErrorLevel==1)
		{
			; 管理者権限で実行しないと RegWrite がエラーになる
			MsgBox, 0x30, Excel, 管理者権限で実行してください。
			ExitApp
		}

		; 通常の「開く」のコマンドを取得
		; Excel 2010 の通常設定は、
		; "C:\Program Files (x86)\Microsoft Office\Office14\EXCEL.EXE" /dde
		RegRead, openCommand, HKCR, %dir%\shell\Open\command,
		; .EXE までを分離して reg1 に入れる
		RegExMatch(openCommand, "^("".*?"")", reg)

		; 「別のウィンドウで開く」コマンドの内容を設定
		RegWrite, REG_SZ, HKCR, %dir%\shell\OpenInNewWindow\command, , %reg1% `"`%1`"

		; ファイルの開き方のデフォルトを設定
		; ダブルクリックで「別のウィンドウで開く」になる
		RegWrite, REG_SZ, HKCR, %dir%\shell, , OpenInNewWindow
	}
	MsgBox, 0x40, Excel, 正常に完了しました。

ExitApp
