#SingleInstance Force ; �����N���̋֎~

	; .xls  : Excel.Sheet.8
	; .xlsx : Excel.Sheet.12
	aDir := ["Excel.Sheet.12","Excel.Sheet.8","Excel.SheetMacroEnabled.12","Excel.CSV"]
	Loop, % aDir.MaxIndex()
	{
		dir := aDir[A_Index]

		; �u�ʂ̃E�B���h�E�ŊJ���v�Ƃ������ڂ����
		RegWrite, REG_SZ, HKCR, %dir%\shell\OpenInNewWindow, , �ʂ̃E�B���h�E�ŊJ��(&W)
		if(ErrorLevel==1)
		{
			; �Ǘ��Ҍ����Ŏ��s���Ȃ��� RegWrite ���G���[�ɂȂ�
			MsgBox, 0x30, Excel, �Ǘ��Ҍ����Ŏ��s���Ă��������B
			ExitApp
		}

		; �ʏ�́u�J���v�̃R�}���h���擾
		; Excel 2010 �̒ʏ�ݒ�́A
		; "C:\Program Files (x86)\Microsoft Office\Office14\EXCEL.EXE" /dde
		RegRead, openCommand, HKCR, %dir%\shell\Open\command,
		; .EXE �܂ł𕪗����� reg1 �ɓ����
		RegExMatch(openCommand, "^("".*?"")", reg)

		; �u�ʂ̃E�B���h�E�ŊJ���v�R�}���h�̓��e��ݒ�
		RegWrite, REG_SZ, HKCR, %dir%\shell\OpenInNewWindow\command, , %reg1% `"`%1`"

		; �t�@�C���̊J�����̃f�t�H���g��ݒ�
		; �_�u���N���b�N�Łu�ʂ̃E�B���h�E�ŊJ���v�ɂȂ�
		RegWrite, REG_SZ, HKCR, %dir%\shell, , OpenInNewWindow
	}
	MsgBox, 0x40, Excel, ����Ɋ������܂����B

ExitApp
