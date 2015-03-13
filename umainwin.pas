unit umainwin;

{ winted by mnt - http://codeninja.de
  initially written in about 6 hours because ted (written in java) is just WAY too
  resource and cpu consuming for my low-power environment-friendly server.

}


interface

uses
   usettings, uedit, uscanthread,
   ImgList, Controls, Menus, ComCtrls, StdCtrls, Classes, ToolWin,
   Windows, Messages, SysUtils, Graphics, Forms, Dialogs, ExtCtrls,
   Inifiles, Math, shellapi;

type
   TwTed = class(TForm)
      mmMenu: TMainMenu;
      tmmFile: TMenuItem;
      tbToolbar: TToolBar;
      tbAdd: TToolButton;
      tbEdit: TToolButton;
      tbDelete: TToolButton;
      tbScan: TToolButton;
      hcHeader: THeaderControl;
      sbStatus: TStatusBar;
      ilToolbar: TImageList;
      ScanTimer: TTimer;
      mmQuit: TMenuItem;
      tmmSaveMethod: TMenuItem;
      mmTargetDir: TMenuItem;
      mmbreak1: TMenuItem;
      mmSave0: TMenuItem;
      mmSave1: TMenuItem;
      mmSave2: TMenuItem;
      mmAbout: TMenuItem;
      mmHomepage: TMenuItem;
      mmViewLog: TMenuItem;
      mmSettings: TMenuItem;
      mmInterval: TMenuItem;
      mmbreak2: TMenuItem;
      tbAddShow: TMenuItem;
      mmScan: TMenuItem;
      mmScanStartup: TMenuItem;
      mmMinTray: TMenuItem;
      mmMinimizeStartup: TMenuItem;
      N1: TMenuItem;
      N2: TMenuItem;
      pnlUpdate: TPanel;
      lblUpdate: TLabel;
      lblUpdateLink: TLabel;
      N3: TMenuItem;
      mmUpdates: TMenuItem;
      pnlColor: TPanel;
      lbList: TListBox;
      pmAction: TPopupMenu;
      pmDisableEntry: TMenuItem;
      pmEnableEntry: TMenuItem;
      pmUnpauseEntry: TMenuItem;
      pmReset: TMenuItem;
      ToolButton1: TToolButton;
      tbToolMenu: TToolButton;
      pmNothing: TMenuItem;
      pmPause: TMenuItem;
      pmReset2: TMenuItem;
      mmQuickstart: TMenuItem;
      N4: TMenuItem;
      mmProxy: TMenuItem;
      mmUseProxy: TMenuItem;
      mmQuitafterscan: TMenuItem;
      mmSave3: TMenuItem;
      mmUseCache: TMenuItem;
      procedure TrayMsg(var Msg: TMessage); message WM_USER + 1;
      procedure Minimized(Sender: TObject);
      procedure UpdateListbox(simple: boolean);
      procedure tbAddClick(Sender: TObject);
      procedure tbEditClick(Sender: TObject);
      procedure tbDeleteClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure lbListDrawItem(Control: TWinControl; Index: Integer;
         Rect: TRect; State: TOwnerDrawState);
      procedure lbListDblClick(Sender: TObject);
      procedure tbScanClick(Sender: TObject);
      procedure ScanTimerTimer(Sender: TObject);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
      procedure hcHeaderSectionResize(HeaderControl: THeaderControl;
         Section: THeaderSection);
      procedure mmTargetDirClick(Sender: TObject);
      procedure mmHomepageClick(Sender: TObject);
      procedure mmViewLogClick(Sender: TObject);
      procedure tbAddShowClick(Sender: TObject);
      procedure mmScanClick(Sender: TObject);
      procedure mmQuitClick(Sender: TObject);
      procedure mmIntervalClick(Sender: TObject);
      procedure mmScanStartupClick(Sender: TObject);
      procedure lbListClick(Sender: TObject);
      procedure lbListMeasureItem(Control: TWinControl; Index: Integer;
         var Height: Integer);
      procedure pmActionPopup(Sender: TObject);
      procedure mmSave2Click(Sender: TObject);
      procedure lbListMouseDown(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
      procedure pmDisableEntryClick(Sender: TObject);
      procedure pmEnableEntryClick(Sender: TObject);
      procedure pmUnpauseEntryClick(Sender: TObject);
      procedure pmResetClick(Sender: TObject);
      procedure tbToolMenuContextPopup(Sender: TObject; MousePos: TPoint;
         var Handled: Boolean);
      procedure pmPauseClick(Sender: TObject);
      procedure mmQuickstartClick(Sender: TObject);
      procedure hcHeaderDrawSection(HeaderControl: THeaderControl;
         Section: THeaderSection; const Rect: TRect; Pressed: Boolean);
      procedure hcHeaderSectionClick(HeaderControl: THeaderControl;
         Section: THeaderSection);
      procedure mmProxyClick(Sender: TObject);
      procedure tbToolMenuClick(Sender: TObject);
      procedure pmReset2Click(Sender: TObject);
   private
      EntryList: TEntryList;
      ScanThread: TScanThread;
      TrayIconData: TNotifyIconData;
      SortBy: integer;
      ShadedBackground: TColor;
      procedure ShowTrayIcon;
      procedure HideTrayIcon;
      procedure ShowWin;
   public
      ProxyData: string;
      timeroffset: integer;
   protected
      procedure WndProc(var Message: TMessage); override;
   end;

   TListBoxCracker = class(TListbox);

function _inifile: string;

var
   wTed: TwTed;
   WM_TASKBARCREATED: dword;
   WM_WAKEWINTED: dword;

const
   _interval: integer = 20 * 60;
   _inisect: string = 'WinTED';

implementation

uses ubasepath, upathdlg, ustringtools2;

function _inifile: string;
begin
   result := _basepath + 'winted.settings';
end;

{$R *.DFM}

procedure TwTed.FormCreate(Sender: TObject);
var
   ini: Tinifile;
   i: integer;
   shadedrgb: Longint;
begin
   shadedrgb := ColorToRGB(clWindow);
   ShadedBackground := RGB(max(GetRValue(shadedrgb) - 16, 0),
      max(GetGValue(shadedrgb) - 16, 0),
      max(GetBValue(shadedrgb) - 16, 0));

   timeroffset := 0;

   Caption := 'WINted' + ' ' + _wintedversion + ' by mnt';

   EntryList := TEntryList.Create;
   EntryList.Read(_inifile);

   ScanThread := TScanThread.Create(true);
   ScanThread.EntryList := EntryList;
   SetThreadPriority(ScanThread.Handle, THREAD_PRIORITY_BELOW_NORMAL);

   if (fileexists(_inifile)) then begin
      ini := Tinifile.Create(_inifile);
      wTed.Top := ini.ReadInteger(_inisect, 'top', 200);
      wTed.Left := ini.ReadInteger(_inisect, 'left', 200);
      wTed.Width := ini.ReadInteger(_inisect, 'width', 640);
      wTed.Height := ini.ReadInteger(_inisect, 'height', 350);
      wTed.WindowState := TWindowState(ini.ReadInteger(_inisect, 'state', integer(wsNormal)));

      mmUpdates.Tag := ini.ReadInteger(_inisect, 'nextupdate', 0);
      ProxyData := ini.ReadString(_inisect, 'proxy', '');
      mmUseProxy.Checked := ini.ReadBool(_inisect, 'useproxy', false);
      mmUseCache.Checked := ini.ReadBool(_inisect, 'usecache', true);

      hcHeader.Sections[0].Width := ini.ReadInteger(_inisect, 'sect0', 200);
//      hcHeader.Sections[1].Width := ini.ReadInteger(_inisect, 'sect1', 50);
//      hcHeader.Sections[2].Width := ini.ReadInteger(_inisect, 'sect2', 50);
//      hcHeader.Sections[3].Width := ini.ReadInteger(_inisect, 'sect3', 50);
//      hcHeader.Sections[4].Width := ini.ReadInteger(_inisect, 'sect4', 80);
      sortby := ini.ReadInteger(_inisect, 'sortby', 1);

      mmSave0.Checked := ini.ReadBool(_inisect, 'save0', true);
      mmSave1.Checked := ini.ReadBool(_inisect, 'save1', false);
      mmSave2.Checked := ini.ReadBool(_inisect, 'save2', false);
      mmSave3.Checked := ini.ReadBool(_inisect, 'save3', false);
      mmTargetDir.Hint := ini.ReadString(_inisect, 'save', mmTargetDir.Hint);

      mmInterval.Tag := ini.ReadInteger(_inisect, 'interval', 1200);

      mmScanStartup.Checked := ini.ReadBool(_inisect, 'scanstartup', false);
      mmQuitafterscan.Checked := ini.ReadBool(_inisect, 'quitafterscan', false);
      mmMinTray.Checked := ini.ReadBool(_inisect, 'tray', false);
      mmMinimizeStartup.Checked := ini.ReadBool(_inisect, 'traystartup', false);
      mmUpdates.Checked := ini.ReadBool(_inisect, 'searchupdates', true);
      ini.Free;
   end;

   for i := 0 to pred(EntryList.Count) do
      lbList.Items.AddObject('-', EntryList.GetItem(i));
   UpdateListbox(true);

   if mmMinimizeStartup.Checked then begin
      Application.ShowMainForm := False;
      ShowTrayIcon;
   end;
      WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');
      WM_WAKEWINTED := RegisterWindowMessage('WakeWinTED');

   if mmScanStartup.Checked then ScanTimer.tag := mmInterval.Tag;
   pnlUpdate.Visible := False;
end;

procedure TwTed.FormDestroy(Sender: TObject);
var
   ini: TIniFile;
   placement: TWindowPlacement;
begin
   ScanThread.Terminate;

   EntryList.Write(_inifile);
   EntryList.Free;

   placement.length := sizeof(placement);
   GetWindowPlacement(handle, @placement);

   ini := Tinifile.Create(_inifile);
   ini.WriteInteger(_inisect, 'top', placement.rcNormalPosition.Top);
   ini.WriteInteger(_inisect, 'left', placement.rcNormalPosition.Left);
   ini.WriteInteger(_inisect, 'width', placement.rcNormalPosition.Right - placement.rcNormalPosition.Left);
   ini.WriteInteger(_inisect, 'height', placement.rcNormalPosition.Bottom - placement.rcNormalPosition.Top);
   ini.WriteInteger(_inisect, 'state', integer(wTed.windowstate));

   ini.WriteInteger(_inisect, 'nextupdate', mmUpdates.Tag);
   ini.WriteString(_inisect, 'proxy', ProxyData);
   ini.WriteBool(_inisect, 'useproxy', mmUseProxy.Checked);
   ini.WriteBool(_inisect, 'usecache', mmUseCache.Checked);

   ini.WriteInteger(_inisect, 'sect0', hcHeader.Sections[0].Width);
//   ini.WriteInteger(_inisect, 'sect1', hcHeader.Sections[1].Width);
//   ini.WriteInteger(_inisect, 'sect2', hcHeader.Sections[2].Width);
//   ini.WriteInteger(_inisect, 'sect3', hcHeader.Sections[3].Width);
//   ini.WriteInteger(_inisect, 'sect4', hcHeader.Sections[4].Width);
   ini.WriteInteger(_inisect, 'sortby', sortby);

   ini.WriteBool(_inisect, 'save0', mmSave0.Checked);
   ini.WriteBool(_inisect, 'save1', mmSave1.Checked);
   ini.WriteBool(_inisect, 'save2', mmSave2.Checked);
   ini.WriteBool(_inisect, 'save3', mmSave3.Checked);
   ini.WriteString(_inisect, 'save', mmTargetDir.Hint);

   ini.WriteInteger(_inisect, 'interval', mmInterval.Tag);

   ini.WriteBool(_inisect, 'scanstartup', mmScanStartup.Checked);
   ini.WriteBool(_inisect, 'quitafterscan', mmQuitafterscan.Checked);
   ini.WriteBool(_inisect, 'tray', mmMinTray.Checked);
   ini.WriteBool(_inisect, 'traystartup', mmMinimizeStartup.Checked);
   ini.WriteBool(_inisect, 'searchupdates', mmUpdates.Checked);
   ini.Free;
end;

////////////////////////////////////////////////////////////////////////////////


procedure TwTed.WndProc(var Message: TMessage);
begin
   if (message.msg = wm_taskbarcreated) then begin
      ShowTrayIcon;
      message.Result := 0;
   end;

   if (message.msg = WM_WAKEWINTED) then begin
      ShowWin;
      message.Result := 0;
   end;

   inherited WndProc(Message);
end;


////////////////////////////////////////////////////////////////////////////////


procedure TwTed.TrayMsg(var Msg: TMessage);
begin
   case Msg.lParam of
      WM_LBUTTONDOWN: begin
            ShowWin;
         end;
   end;
end;

procedure TwTed.HideTrayIcon;
begin
   Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
end;

procedure TwTed.ShowTrayIcon;
begin
   with TrayIconData do begin
      cbSize := SizeOf(TrayIconData);
      Wnd := Handle;
      uID := 0;
      uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
      uCallbackMessage := WM_USER + 1;
      hIcon := Application.Icon.Handle;
      StrPCopy(szTip, Application.Title);
   end;

   Shell_NotifyIcon(NIM_ADD, @TrayIconData);
end;

procedure TwTed.Minimized(Sender: TObject);
begin
   if mmMinTray.Checked then begin
      ShowTrayIcon;
      wTed.Hide;
   end;
end;

procedure TwTed.ShowWin;
begin
   HideTrayIcon;
   wTed.Show;
   Application.Restore;
   Application.BringToFront;
end;

procedure TwTed.UpdateListbox(simple: boolean);
var
   i, j: integer;
   swap: boolean;
   a, b: TEntry;
begin
   if (lbList.Items.Count = 1) then exit;
   lbList.Items.BeginUpdate;

   for i := 0 to pred(lbList.Items.Count) do
      for j := 0 to pred(i) do begin
         swap := False;
         a := TEntry(lbList.Items.Objects[i]);
         b := TEntry(lbList.Items.Objects[j]);

         case sortby of
            -1: swap := a.name > b.name;
            1: swap := a.name < b.name;
            -2: swap := (a.currseason * 1000) + a.currepisode > (b.currseason * 1000) + b.currepisode;
            2: swap := (a.currseason * 1000) + a.currepisode < (b.currseason * 1000) + b.currepisode;
            -3: swap := a.lastnew > b.lastnew;
            3: swap := a.lastnew < b.lastnew;
            -4: swap := a.pauseuntil > b.pauseuntil;
            4: swap := a.pauseuntil < b.pauseuntil;
         end;

         if (swap) then lbList.Items.Exchange(i, j);
      end;

   lbList.Items.EndUpdate;

   if (simple) then lbList.Repaint
   else //TListBoxCracker(lblist).RecreateWnd;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TwTed.tbAddClick(Sender: TObject);
var
   E: TEntry;
begin
   e := EntryList.EntryFactory;
   lbList.Itemindex := lbList.Items.AddObject(e.name, e);
   tbEdit.Click;
end;

procedure TwTed.tbEditClick(Sender: TObject);
begin
   if (lbList.ItemIndex < 0) or (lbList.Items.Count <= lbList.ItemIndex) then exit;
   if (TEntry(lbList.Items.Objects[lbList.ItemIndex]).beingscanned) then begin
      MessageDlg('This entry is currently in use by the background scanner.', mtError, [mbOK], 0);
      exit;
   end;
   with TwEdit.Create(self) do
      ReadFromEntry(TEntry(lbList.Items.Objects[lbList.ItemIndex]));
   UpdateListbox(false);
end;

procedure TwTed.tbDeleteClick(Sender: TObject);
begin
   if (lbList.ItemIndex < 0) or (lbList.Items.Count <= lbList.ItemIndex) then exit;
   EntryList.Remove(TEntry(lbList.Items.Objects[lbList.ItemIndex]));
   lbList.Items.Delete(lbList.ItemIndex);
   UpdateListbox(false);
end;

procedure TwTed.lbListDrawItem(Control: TWinControl; Index: Integer;
   Rect: TRect; State: TOwnerDrawState);
var
   e: TEntry;
   r: TRect;
   swaitfor, slastnew, spaused: string;
   icon, Days: integer;
begin
   with lbList.Canvas do begin
      FillRect(Rect);

      if ((Brush.Color = clWindow) and (Index mod 2 = 1)) then
         Brush.Color := ShadedBackground;

      if (index < 0) or (lbList.Items.Count <= Index) then exit;
      e := TEntry(lbList.Items.Objects[index]);
      if (e = nil) then exit;

      slastnew := daystext(ceil(Now - e.lastnew));

      if e.downloadanything then begin
         swaitfor := 'anything';
      end else begin
         if (e.currseason = 0) and (e.currepisode = 0) then begin
            swaitfor := 'newest';
         end else begin
            if (e.currseason = 0) then swaitfor := Format('%.3d', [e.currepisode])
            else swaitfor := Format('s%.2d e%.2d', [e.currseason, e.currepisode]);
         end;
      end;

      spaused := '-';
      if (e.pauseuntil > 0) then begin
         days := ceil(e.pauseuntil - Now);
         if (days <= 1) then begin
            spaused := '1 day';
         end else begin
            spaused := inttostr(days) + ' days';
         end;
      end;

      icon := 5;
      if (e.pauseuntil > 0) then icon := 6;
      if (e.disabled) then icon := 7;

      r := classes.Rect(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);

      TextRect(r, r.Left + 18, r.Top + 1, e.name);

      r := classes.Rect(Rect.Left + hcHeader.Sections[1].Left, Rect.Top, Rect.Right + hcHeader.Sections[1].Right, Rect.Bottom);
      TextRect(r, r.Left + 1, r.Top + 1, swaitfor);

      r := classes.Rect(Rect.Left + hcHeader.Sections[2].Left, Rect.Top, Rect.Right + hcHeader.Sections[2].Right, Rect.Bottom);
      TextRect(r, r.Left + 1, r.Top + 1, slastnew);

      r := classes.Rect(Rect.Left + hcHeader.Sections[3].Left, Rect.Top, Rect.Right + hcHeader.Sections[3].Right, Rect.Bottom);
      TextRect(r, r.Left + 1, r.Top + 1, spaused);

      r := classes.Rect(Rect.Left + hcHeader.Sections[4].Left, Rect.Top, Rect.Right + hcHeader.Sections[4].Right, Rect.Bottom);
      if (e.warning <> '') then begin
         ilToolbar.Draw(lbList.Canvas, r.Left, r.top, 4);
         TextOut(r.Left + 18, r.Top + 1, e.warning);
      end else begin
         if (e.urls.count = 1) then begin
            TextOut(r.Left + 1, r.Top + 1, e.urls.Strings[0]);
         end else begin
            TextOut(r.Left + 1, r.Top + 1, inttostr(e.urls.count) + ' URLs');
         end;
      end;

      ilToolbar.draw(lbList.Canvas, Rect.Left, Rect.Top - 1, icon);
   end;
end;

procedure TwTed.lbListDblClick(Sender: TObject);
begin
   tbEdit.Click;
end;

procedure TwTed.ScanTimerTimer(Sender: TObject);
begin
   ScanTimer.Tag := ScanTimer.Tag + 1;
   if (ScanTimer.tag > mmInterval.Tag + timeroffset) then tbScan.Click
   else sbStatus.SimpleText := 'Next scan in ' + inttostr(mmInterval.Tag - ScanTimer.Tag) + ' seconds';
end;

procedure TwTed.tbScanClick(Sender: TObject);
begin
   tbScan.Enabled := False;
   ScanTimer.Enabled := False;

   sbStatus.SimpleText := 'Scan starting';
   EntryList.Write(_inifile);

   //we do it in a thread, so the GUI stays responsive
   ScanThread.searchupdate := (mmUpdates.Checked) and (mmUpdates.Tag < round(Now));
   ScanThread.savedir := mmTargetDir.Hint;
   if (mmUseProxy.checked) then
      ScanThread.ProxyData := ProxyData;
   ScanThread.savemethod := 0;
   if mmSave1.Checked then ScanThread.savemethod := 1;
   if mmSave2.Checked then ScanThread.savemethod := 2;
   if mmSave3.Checked then ScanThread.savemethod := 3;
   ScanThread.usecache := mmUseCache.Checked;

   ScanThread.Suspended := False;
end;

procedure TwTed.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   //application may continue to run (hidden) for several seconds
   //(considering http-timeouts even minutes)
   //and will only terminate if the thread cleanly finishes
   ScanThread.stop := True;
end;

procedure TwTed.hcHeaderSectionResize(HeaderControl: THeaderControl;
   Section: THeaderSection);
begin
   lbList.Invalidate;
end;

procedure TwTed.mmSave2Click(Sender: TObject);
begin
   TMenuItem(Sender).Checked := True;
end;

procedure TwTed.mmTargetDirClick(Sender: TObject);
var
   path: string;
begin
   if SelectPath('Torrent Output Directory', mmTargetDir.Hint, '', false, path) then
      mmTargetDir.Hint := IncludeTrailingBackslash(path);
end;

procedure TwTed.mmHomepageClick(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://sourceforge.net/projects/winted/'#0, nil, nil, SW_SHOWNORMAL);
end;

procedure TwTed.mmViewLogClick(Sender: TObject);
begin
   ShellExecute(Handle, 'open', pchar(_basepath + _logname), nil, nil, SW_SHOWNORMAL);
end;

procedure TwTed.mmQuickstartClick(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://winted.sourceforge.net/start/'#0, nil, nil, SW_SHOWNORMAL);
end;

procedure TwTed.tbAddShowClick(Sender: TObject);
begin
   tbAdd.Click;
end;

procedure TwTed.mmScanClick(Sender: TObject);
begin
   tbScan.Click;
end;

procedure TwTed.mmQuitClick(Sender: TObject);
begin
   Application.Terminate;
end;

procedure TwTed.mmIntervalClick(Sender: TObject);
var
   s: string;
begin
   s := inttostr(mmInterval.Tag);
   if InputQuery('Set Interval', 'Interval in minutes?', s) then
      mmInterval.Tag := StrToInt(s);
end;

procedure TwTed.mmScanStartupClick(Sender: TObject);
begin
   TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
end;

procedure TwTed.lbListClick(Sender: TObject);
begin
   tbDelete.Enabled := lbList.ItemIndex >= 0;
   tbEdit.Enabled := lbList.ItemIndex >= 0;
end;

procedure TwTed.lbListMeasureItem(Control: TWinControl; Index: Integer;
   var Height: Integer);
var
   e: TEntry;
begin
   Height := 16;

   e := EntryList.GetItem(index);
   if (e = nil) then exit;

   if (e.warning <> '') then Height := Height + 14;
end;

procedure TwTed.pmActionPopup(Sender: TObject);
begin
   if (lbList.ItemIndex < 0) or (lbList.Items.Count <= lbList.ItemIndex) then begin
      pmDisableEntry.Visible := False;
      pmEnableEntry.Visible := False;
      pmUnpauseEntry.Visible := False;
      pmPause.Visible := False;
      pmReset.Visible := False;
      pmReset2.visible := False;
      pmNothing.visible := True;
      exit;
   end;
   with TEntry(lbList.Items.Objects[lbList.Itemindex]) do begin
      pmDisableEntry.Visible := disabled = false;
      pmEnableEntry.Visible := disabled = true;
      pmUnpauseEntry.Visible := pauseuntil > 0;
      pmReset.Visible := (lastepisode > 0) and (not downloadanything);
      pmReset2.Visible := not downloadanything;
      pmReset.Caption := Format('Reset to s%.2d e%.2d', [lastseason, lastepisode]);
      pmPause.Visible := pauseuntil = 0;
      pmNothing.visible := False;
   end;
end;


procedure TwTed.lbListMouseDown(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer);
var
   p: TPoint;
begin
   if (button = mbRight) then begin
      lbList.ItemIndex := lbList.ItemAtPos(Point(x, y), true);
      lbListClick(Sender);
      p := lbList.ClientToScreen(Point(x, y));
      if (lbList.ItemIndex >= 0) then pmAction.Popup(p.x, p.y);
   end;
end;

procedure TwTed.pmDisableEntryClick(Sender: TObject);
begin
   TEntry(lbList.Items.Objects[lbList.Itemindex]).disabled := True;
   UpdateListbox(true);
end;

procedure TwTed.pmEnableEntryClick(Sender: TObject);
begin
   TEntry(lbList.Items.Objects[lbList.Itemindex]).disabled := False;
   UpdateListbox(true);
end;

procedure TwTed.pmUnpauseEntryClick(Sender: TObject);
begin
   TEntry(lbList.Items.Objects[lbList.Itemindex]).pauseuntil := 0;
   UpdateListbox(true);
end;

procedure TwTed.pmResetClick(Sender: TObject);
begin
   with TEntry(lbList.Items.Objects[lbList.Itemindex]) do begin
      pauseuntil := 0;
      currseason := lastseason;
      currepisode := lastepisode;
   end;
   UpdateListbox(true);
end;

procedure TwTed.pmReset2Click(Sender: TObject);
begin
   TEntry(lbList.Items.Objects[lbList.Itemindex]).currseason := 0;
   TEntry(lbList.Items.Objects[lbList.Itemindex]).currepisode := 0;
   UpdateListbox(true);
end;

procedure TwTed.tbToolMenuContextPopup(Sender: TObject; MousePos: TPoint;
   var Handled: Boolean);
begin
   pmActionPopup(Sender);
end;

procedure TwTed.pmPauseClick(Sender: TObject);
var
   s: string;
   d: integer;
   d2: TDateTime;
begin
   s := InputBox('Pause Entry', 'How many days you want to pause? (You can also give a date)', '');
   try
      try
         d := strtoint(s);
         with TEntry(lbList.Items.Objects[lbList.Itemindex]) do begin
            pauseuntil := now + d;
         end;
      except
         d2 := strtodate(s);
         with TEntry(lbList.Items.Objects[lbList.Itemindex]) do begin
            pauseuntil := d2;
         end;
      end;
      UpdateListbox(true);
   except
   end;
end;

procedure TwTed.hcHeaderDrawSection(HeaderControl: THeaderControl;
   Section: THeaderSection; const Rect: TRect; Pressed: Boolean);
var
   spc: integer;
   icon: integer;
   right: integer;
begin
   spc := 0;
   if (Pressed) then spc := 1;

   with hcHeader.Canvas do begin
      TextOut(Rect.Left + 3 + spc, Rect.Top + 2 + spc, Section.Text);
   end;

   icon := 10;
   if (sortby < 0) then icon := 11;

   right := rect.Right;
   if (Section.Index = 4) then right := hcHeader.Width;

   if (abs(sortby) = Section.Index + 1) then
      ilToolbar.draw(hcHeader.Canvas, right - 20 + spc, rect.top + 3 + spc, icon);
end;

procedure TwTed.hcHeaderSectionClick(HeaderControl: THeaderControl;
   Section: THeaderSection);
begin
   if (Section.Index > 4) then exit;

   if (Section.Index + 1 = abs(sortby)) then sortby := -sortby
   else sortby := Section.Index + 1;

   hcHeader.Repaint;
   UpdateListbox(false);
end;

procedure TwTed.mmProxyClick(Sender: TObject);
begin
   InputQuery('Set Proxy', 'http://username:password@some.host.tld:80/', ProxyData);
end;

procedure TwTed.tbToolMenuClick(Sender: TObject);
begin
   tbToolMenu.CheckMenuDropdown;
end;


end.

