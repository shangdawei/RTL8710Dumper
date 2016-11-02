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
    ProgressBar1: TProgressBar;
    btnMemory: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbInterface: TComboBox;
    Label2: TLabel;
    cbSpeed: TComboBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    edtAddress: TEdit;
    Label4: TLabel;
    edtSize: TEdit;
    procedure btnReadClick( Sender: TObject );
    procedure btnCloseClick( Sender: TObject );
    procedure btnSaveClick( Sender: TObject );
    procedure FormCloseQuery( Sender: TObject; var CanClose: Boolean );
    procedure FormCreate( Sender: TObject );
    procedure btnMemoryClick( Sender: TObject );
    procedure btnFlashSizeClick( Sender: TObject );
    procedure edtAddressExit( Sender: TObject );
    procedure edtSizeExit( Sender: TObject );
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

  // btnMemory.ItemIndex
  MemoryTypeROM = 0;
  MemoryTypeRAM = 1;
  MemoryTypeFlash = 2;
  MemoryTypeCustom = 3;

var
  Reading: Boolean;
  MemroyBuffer: array [ 0 .. MemroyPageSize - 1 ] of byte;
  MemoryAddr: DWORD;
  MemorySize: DWORD;

procedure TForm1.btnCloseClick( Sender: TObject );
begin
  Close( );
end;

procedure TForm1.btnFlashSizeClick( Sender: TObject );
begin
  if btnMemory.ItemIndex = 2 then
  begin
    MemoryAddr := $98000000;
    MemorySize := 1 * 1024 * 1024 * ( 1 shl btnFlashSize.ItemIndex );
    edtAddress.Text := IntToHex( MemoryAddr, 8 );
    edtSize.Text := IntToHex( MemorySize, 8 );
  end;
end;

procedure TForm1.btnMemoryClick( Sender: TObject );
begin
  if btnMemory.ItemIndex = 0 then
  begin
    MemoryAddr := 0;
    MemorySize := 512 * 1024;
  end else if btnMemory.ItemIndex = 1 then
  begin
    MemoryAddr := $10000000;
    MemorySize := 448 * 1024;
  end else if btnMemory.ItemIndex = 2 then
  begin
    MemoryAddr := $98000000;
    MemorySize := 1 * 1024 * 1024 * ( 1 shl btnFlashSize.ItemIndex );
  end else begin
    MemoryAddr := $10000000;
    MemorySize := 1 * 256;
  end;

  edtAddress.Text := IntToHex( MemoryAddr, 8 );
  edtSize.Text := IntToHex( MemorySize, 8 );

  if btnMemory.ItemIndex = 3 then
  begin
    edtAddress.Enabled := True;
    edtSize.Enabled := True;
  end else begin
    edtAddress.Enabled := False;
    edtSize.Enabled := False;
  end;
end;

procedure TForm1.btnReadClick( Sender: TObject );
var
  I: DWORD;
  RegValue: DWORD;
  time_beg: Integer;
  NumWritten: Integer;
  RetValue: Integer;
  MemoryBlockCount: Cardinal;
  JLinkSpeed: Integer;
  JLinkInterface: Integer;
  msFirmware: TMemoryStream;
  NumToRead: DWORD;
  NumToAppend: DWORD;
begin
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
      Exit;
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
      Exit;
    end;

    Application.ProcessMessages;

    if MemoryAddr >= $98000000 then
    begin
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
    end;

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

      NumToRead := MemorySize;
      NumToAppend := 0;

      MemoryBlockCount := 0;
      msFirmware.Seek( 0, soBeginning );

      if MemorySize > MemroyPageSize then // at least 1 Page to Read
      begin

        for I := 0 to MemorySize div MemroyPageSize - 1 do
        begin
          RetValue := JLINKARM_ReadMem( MemoryAddr, MemroyPageSize, MemroyBuffer );
          msFirmware.Write( MemroyBuffer, MemroyPageSize );
          NumToRead := NumToRead - MemroyPageSize;
          NumToAppend := NumToAppend + MemroyPageSize;

          MemoryBlockCount := MemoryBlockCount + 1;
          if MemoryBlockCount = MemroyBlockSizeInPage then
          begin
            HexFirmware.AppendBuffer( PAnsiChar( msFirmware.Memory ), MemroyBlockSizeInByte );
            NumToAppend := 0;

            MemoryBlockCount := 0;
            msFirmware.Seek( 0, soBeginning );
          end;

          MemoryAddr := MemoryAddr + MemroyPageSize;
          ProgressBar1.Position := I;
          Application.ProcessMessages;
        end;
      end;

      if NumToAppend > 0 then // < MemroyBlockSizeInByte
      begin
        HexFirmware.AppendBuffer( PAnsiChar( msFirmware.Memory ), MemroyBlockSizeInByte );
        NumToAppend := 0;

        MemoryBlockCount := 0;
        msFirmware.Seek( 0, soBeginning );
      end;

      if NumToRead > 0 then // < MemroyPageSize
      begin
        RetValue := JLINKARM_ReadMem( MemoryAddr, NumToRead, MemroyBuffer );
        msFirmware.Write( MemroyBuffer, NumToRead );
        HexFirmware.AppendBuffer( PAnsiChar( msFirmware.Memory ), NumToRead );
      end;

      if MemoryAddr >= $98000000 then
      begin
        RetValue := JLINKARM_WriteU32( $40000210, $00211157 );
      end;

      RetValue := JLINKARM_Reset( );

      RetValue := JLINKARM_Close( );

    finally
      msFirmware.Free;
    end;

  finally
    Reading := False;
    HexFirmware.SelStart := 0;
  end;
end;

procedure TForm1.btnSaveClick( Sender: TObject );
begin
  if HexFirmware.DataSize > 0 then
  begin
    if btnMemory.ItemIndex = 0 then
    begin
      DlgSave.FileName := 'RTL8710ROM.bin';
    end else if btnMemory.ItemIndex = 1 then
    begin
      DlgSave.FileName := 'RTL8710RAM.bin';
    end else if btnMemory.ItemIndex = 2 then
    begin
      DlgSave.FileName := 'RTL8710Flash.bin';
    end else begin
      DlgSave.FileName := 'RTL8710Custom_' + edtAddress.Text + '_' + edtSize.Text + '.bin';
    end;

    if DlgSave.Execute then
      HexFirmware.SaveToFile( DlgSave.FileName );
  end;
end;

procedure TForm1.edtAddressExit( Sender: TObject );
begin
  try
    MemoryAddr := StrToInt( '$' + edtAddress.Text );
  except
    on E: Exception do
      MemoryAddr := $10000000;
  end;
  edtAddress.Text := IntToHex( MemoryAddr, 8 );
end;

procedure TForm1.edtSizeExit( Sender: TObject );
begin
  try
    MemorySize := StrToInt( '$' + edtSize.Text );
  except
    on E: Exception do
      MemorySize := $100;
  end;
  edtSize.Text := IntToHex( MemorySize, 8 );
end;

procedure TForm1.FormCloseQuery( Sender: TObject; var CanClose: Boolean );
begin
  CanClose := not Reading;
end;

procedure TForm1.FormCreate( Sender: TObject );
begin
  Reading := False;
  btnMemory.ItemIndex := 0;
  btnMemoryClick( Self );
end;

end.
