unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, dcrHexEditor, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm1 = class( TForm )
    btnRead: TButton;
    HexFirmware: TMPHexEditor;
    btnFlashSize: TRadioGroup;
    btnSave: TButton;
    btnClose: TButton;
    DlgSave: TSaveDialog;
    cbInterface: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbSpeed: TComboBox;
    ProgressBar1: TProgressBar;
    btnMemory: TRadioGroup;
    procedure btnReadClick( Sender: TObject );
    procedure btnCloseClick( Sender: TObject );
    procedure btnSaveClick( Sender: TObject );
    procedure FormCloseQuery( Sender: TObject; var CanClose: Boolean );
    procedure FormCreate( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  jlinkarm;

{$R *.dfm}

const
  MemroyPageSize = 1024;
  MemroyBlockSizeInPage = 64;
  MemroyBlockSizeInByte = MemroyPageSize * MemroyBlockSizeInPage;

var
  Reading: Boolean;

  MemroyBuffer: array [ 0 .. MemroyPageSize - 1 ] of byte;

procedure TForm1.btnCloseClick( Sender: TObject );
begin
  Close( );
end;

procedure TForm1.btnReadClick( Sender: TObject );
var
  I: DWORD;
  RegValue: DWORD;
  time_beg: Integer;
  NumWritten: Integer;
  RetValue: Integer;
  MemoryAddr: Cardinal;
  MemorySize: Cardinal;
  MemoryBlockCount: Cardinal;
  JLinkSpeed: Integer;
  JLinkInterface: Integer;
  msFirmware: TMemoryStream;
begin
  if btnMemory.ItemIndex = 0 then
  begin
    MemoryAddr := $00000000;
    MemorySize := 1 * 1024 * 1024;
  end else begin
    MemoryAddr := $98000000;
    if btnFlashSize.ItemIndex = 0 then
      MemorySize := 1 * 1024 * 1024
    else
      MemorySize := 2 * 1024 * 1024;
  end;

  JLinkInterface := cbInterface.ItemIndex;
  if cbSpeed.ItemIndex = cbSpeed.Items.Count - 1 then
    JLinkSpeed := 12000000
  else if cbSpeed.ItemIndex = cbSpeed.Items.Count - 2 then
    JLinkSpeed := 10000000
  else
  begin
    JLinkSpeed := StrToInt( Copy( cbSpeed.Items[ cbSpeed.ItemIndex ], 1, 4 ) ) * 1000;
  end;

  try
    Reading := True;

    RetValue := JLINKARM_Open( );
    if RetValue = 1 then
    begin
      Beep;
      ShowMessage( 'J-Link not found!' );
      Halt;
    end;

    RetValue := JLINKARM_ExecCommand( 'device = Cortex-M3', 0, 0 );
    RetValue := JLINKARM_TIF_Select( JLinkInterface );
    RetValue := JLINKARM_SetSpeed( 1000 );
    RetValue := JLINKARM_Reset( );
    RetValue := JLINKARM_Halt( );

    Sleep( 10 );

    RetValue := JLINKARM_IsConnected( );
    if RetValue = 0 then
    begin
      Beep;
      ShowMessage( 'RTL8710 not found!' );
      Halt;
    end;

    Application.ProcessMessages;

    RetValue := JLINKARM_WriteU32( $40000230, $0000D3C4 );
    RetValue := JLINKARM_WriteU32( $40000210, $00200113 );
    RetValue := JLINKARM_WriteU32( $400002C0, $00110001 );

    RetValue := JLINKARM_WriteU32( $40006008, 0 );
    RetValue := JLINKARM_WriteU32( $4000602C, 0 );
    RetValue := JLINKARM_WriteU32( $40006010, 1 );
    RetValue := JLINKARM_WriteU32( $40006014, 2 );
    RetValue := JLINKARM_WriteU32( $40006018, 0 );
    RetValue := JLINKARM_WriteU32( $4000601C, 0 );
    RetValue := JLINKARM_WriteU32( $4000604C, 0 );

    JLINKARM_WriteU32( $40000014, $01 );
    Sleep( 10 );

    RetValue := JLINKARM_SetSpeed( JLinkSpeed div 1000 );
    RetValue := JLINKARM_GetSpeed( );

    msFirmware := TMemoryStream.Create( );
    try
      ProgressBar1.Min := 0;
      ProgressBar1.Max := MemorySize div MemroyPageSize;
      ProgressBar1.Position := 0;

      if HexFirmware.DataSize > 0 then
      begin
        HexFirmware.SelectAll;
        HexFirmware.DeleteSelection( );
      end;

      MemoryBlockCount := 0;
      msFirmware.Seek( 0, soBeginning );
      for I := 0 to MemorySize div MemroyPageSize - 1 do
      begin
        RetValue := JLINKARM_ReadMem( MemoryAddr, MemroyPageSize, MemroyBuffer );
        msFirmware.Write( MemroyBuffer, MemroyPageSize );

        MemoryBlockCount := MemoryBlockCount + 1;
        if MemoryBlockCount = MemroyBlockSizeInPage then
        begin
          HexFirmware.AppendBuffer( PAnsiChar( msFirmware.Memory ), MemroyBlockSizeInByte );

          MemoryBlockCount := 0;
          msFirmware.Seek( 0, soBeginning );
        end;

        MemoryAddr := MemoryAddr + MemroyPageSize;
        ProgressBar1.Position := I;
        Application.ProcessMessages;
      end;

      RetValue := JLINKARM_WriteU32( $40000210, $00211157 );

      RetValue := JLINKARM_Reset( );

      RetValue := JLINKARM_Close( );

    finally
      msFirmware.Free;
    end;

  finally
    Reading := False;
  end;
end;

procedure TForm1.btnSaveClick( Sender: TObject );
begin
  if HexFirmware.DataSize > 0 then
  begin
    if btnMemory.ItemIndex = 0 then
    begin
      DlgSave.FileName := 'RTL8710ROM.bin';
    end else begin
      DlgSave.FileName := 'RTL8710Flash.bin';
    end;
    if DlgSave.Execute then
      HexFirmware.SaveToFile( DlgSave.FileName );
  end;
end;

procedure TForm1.FormCloseQuery( Sender: TObject; var CanClose: Boolean );
begin
  CanClose := not Reading;
end;

procedure TForm1.FormCreate( Sender: TObject );
begin
  Reading := False;
end;

end.
