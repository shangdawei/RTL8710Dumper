object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'RTL8710 Dumper'
  ClientHeight = 522
  ClientWidth = 699
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Fixedsys'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 412
    Top = 408
    Width = 119
    Height = 16
    Caption = 'JLink Interface'
  end
  object Label2: TLabel
    Left = 588
    Top = 408
    Width = 88
    Height = 16
    Caption = 'JLink Speed'
  end
  object btnRead: TButton
    Left = 8
    Top = 476
    Width = 177
    Height = 25
    Caption = 'Read'
    TabOrder = 0
    OnClick = btnReadClick
  end
  object HexFirmware: TMPHexEditor
    Left = 8
    Top = 8
    Width = 681
    Height = 329
    Cursor = crIBeam
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    BytesPerRow = 16
    BytesPerColumn = 1
    Translation = tkASCII
    OffsetFormat = '8!10:0x|'
    Colors.Background = clWindow
    Colors.ChangedBackground = clWindow
    Colors.ChangedText = clRed
    Colors.CursorFrame = clNavy
    Colors.Offset = clBlack
    Colors.OddColumn = clBlue
    Colors.EvenColumn = clBlack
    Colors.CurrentOffsetBackground = clBtnShadow
    Colors.OffsetBackground = clBtnFace
    Colors.CurrentOffset = clBlack
    Colors.Grid = clBtnFace
    Colors.NonFocusCursorFrame = clAqua
    Colors.ActiveFieldBackground = clWindow
    FocusFrame = True
    DrawGridLines = True
    ReadOnlyView = True
    Version = 'october 7th, 2010; ?markus stephany, http://launchpad.net/dcr'
    DrawGutterGradient = False
    ShowRuler = True
  end
  object btnFlashSize: TRadioGroup
    Left = 220
    Top = 408
    Width = 161
    Height = 49
    Caption = ' Flash Size '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      '1MB'
      '2MB')
    TabOrder = 2
  end
  object btnSave: TButton
    Left = 260
    Top = 476
    Width = 177
    Height = 25
    Caption = 'Save As ...'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 512
    Top = 476
    Width = 177
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object cbInterface: TComboBox
    Left = 412
    Top = 433
    Width = 119
    Height = 24
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 5
    Text = 'SWD'
    Items.Strings = (
      'JTAG'
      'SWD')
  end
  object cbSpeed: TComboBox
    Left = 588
    Top = 433
    Width = 101
    Height = 24
    Style = csDropDownList
    ItemIndex = 6
    TabOrder = 6
    Text = '12000 KHz'
    Items.Strings = (
      '1000 KHz'
      '2000 KHz'
      '4000 KHz'
      '6000 KHz'
      '8000 KHz'
      '10000 KHz'
      '12000 KHz')
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 356
    Width = 681
    Height = 29
    TabOrder = 7
  end
  object btnMemory: TRadioGroup
    Left = 8
    Top = 408
    Width = 177
    Height = 49
    Caption = ' Memory '
    Columns = 2
    ItemIndex = 1
    Items.Strings = (
      'ROM'
      'Flash')
    TabOrder = 8
  end
  object DlgSave: TSaveDialog
    Filter = 'Binary Files (*.bin)|*.bin'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 40
    Top = 108
  end
end
