object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'RTL8710 Dumper'
  ClientHeight = 731
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
  object btnRead: TButton
    Left = 8
    Top = 688
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
    Left = 8
    Top = 460
    Width = 681
    Height = 49
    Caption = ' Flash Size '
    Columns = 8
    ItemIndex = 0
    Items.Strings = (
      '1MB'
      '2MB'
      '4M'
      '8M'
      '16M'
      '32M'
      '64M'
      '128M')
    TabOrder = 2
    OnClick = btnFlashSizeClick
  end
  object btnSave: TButton
    Left = 260
    Top = 688
    Width = 177
    Height = 25
    Caption = 'Save ...'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 512
    Top = 688
    Width = 177
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 356
    Width = 681
    Height = 25
    TabOrder = 5
  end
  object btnMemory: TRadioGroup
    Left = 8
    Top = 400
    Width = 681
    Height = 49
    Caption = ' Memory '
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      'ROM'
      'RAM'
      'Flash'
      'Custom     ')
    TabOrder = 6
    OnClick = btnMemoryClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 600
    Width = 681
    Height = 69
    Caption = ' JLink Setting '
    TabOrder = 7
    object Label1: TLabel
      Left = 16
      Top = 29
      Width = 120
      Height = 16
      Caption = 'JLink Interface'
    end
    object Label2: TLabel
      Left = 360
      Top = 29
      Width = 88
      Height = 16
      Caption = 'JLink Speed'
    end
    object cbInterface: TComboBox
      Left = 156
      Top = 25
      Width = 160
      Height = 24
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 0
      Text = 'SWD'
      Items.Strings = (
        'JTAG'
        'SWD')
    end
    object cbSpeed: TComboBox
      Left = 468
      Top = 25
      Width = 160
      Height = 24
      Style = csDropDownList
      ItemIndex = 6
      TabOrder = 1
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
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 520
    Width = 681
    Height = 68
    Caption = ' Custom '
    TabOrder = 8
    object Label3: TLabel
      Left = 14
      Top = 33
      Width = 104
      Height = 16
      Caption = 'Address (HEX)'
    end
    object Label4: TLabel
      Left = 368
      Top = 33
      Width = 80
      Height = 16
      Caption = 'Size (HEX)'
    end
    object edtAddress: TEdit
      Left = 156
      Top = 29
      Width = 160
      Height = 24
      Enabled = False
      MaxLength = 8
      TabOrder = 0
      OnExit = edtAddressExit
    end
    object edtSize: TEdit
      Left = 468
      Top = 29
      Width = 160
      Height = 24
      Enabled = False
      MaxLength = 8
      TabOrder = 1
      OnExit = edtSizeExit
    end
  end
  object DlgSave: TSaveDialog
    Filter = 'Binary Files (*.bin)|*.bin'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 40
    Top = 108
  end
end
