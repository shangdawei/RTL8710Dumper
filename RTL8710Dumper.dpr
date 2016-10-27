program RTL8710Dumper;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  jlinkarm in 'jlinkarm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'RTL8710 Dumper';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
