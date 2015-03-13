program winted;

{ winted by mnt - http://codeninja.de

}

uses
  Forms,
  windows,
  umainwin in 'umainwin.pas' {wTed},
  xmlscan in 'xmlscan.pas',
  usettings in 'usettings.pas',
  uedit in 'uedit.pas' {wEdit},
  uscanthread in 'uscanthread.pas',
  uhttp in 'uhttp.pas',
  utorrentparse in 'utorrentparse.pas',
  ubasepath in 'ubasepath.pas',
  upathdlg in 'upathdlg.pas',
  ustringtools2 in 'ustringtools2.pas';

{$R *.res}

begin
   Application.Initialize;


   if (GlobalFindAtom(_atomname) = 0) then begin
      GlobalAddAtom(_atomname);
      Application.Title := 'WinTED';
      Application.CreateForm(TwTed, wTed);
      Application.OnMinimize := wTed.Minimized;
      Application.Run;
      GlobalDeleteAtom(GlobalFindAtom(_atomname));
   end else begin
      SendMessage(HWND_BROADCAST, RegisterWindowMessage('WakeWinTED'), 0, 0);
   end;
end.

