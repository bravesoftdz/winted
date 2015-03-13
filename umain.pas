unit umain;

interface

uses
   usettings, uedit, uscanthread,
   ImgList, Controls, Menus, ComCtrls, StdCtrls, Classes, ToolWin,
   Windows, Messages, SysUtils, Graphics, Forms, Dialogs, ExtCtrls;

type
   TwTed = class(TForm)
      mmMenu: TMainMenu;
      Bla1: TMenuItem;
      tbToolbar: TToolBar;
      tbAdd: TToolButton;
      tbEdit: TToolButton;
      tbDelete: TToolButton;
      tbScan: TToolButton;
      hcHeader: THeaderControl;
      lbList: TListBox;
      sbStatus: TStatusBar;
      ilToolbar: TImageList;
      ScanTimer: TTimer;
      procedure tbAddClick(Sender: TObject);
      procedure tbEditClick(Sender: TObject);
      procedure tbDeleteClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure lbListDrawItem(Control: TWinControl; Index: Integer;
         Rect: TRect; State: TOwnerDrawState);
      procedure hcHeaderResize(Sender: TObject);
      procedure lbListDblClick(Sender: TObject);
      procedure tbScanClick(Sender: TObject);
      procedure ScanTimerTimer(Sender: TObject);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
   private
      EntryList: TEntryList;
      ScanThread: TScanThread;
   public
    { Public declarations }
   end;

var
   wTed: TwTed;

const
   _settingsfile: string = 'winted.settings';
   _interval: integer = 20 * 60;

implementation

{$R *.DFM}

procedure TwTed.FormCreate(Sender: TObject);
var
   i: integer;
begin
   EntryList := TEntryList.Create;
   EntryList.Read(_settingsfile);
   ScanThread := TScanThread.Create(true);
   ScanThread.EntryList := EntryList;

   //add dummyentries to listbox, kludgy
   for i := 0 to pred(EntryList.Count) do
      lbList.Items.AddObject('-', EntryList.GetItem(i));
end;

procedure TwTed.FormDestroy(Sender: TObject);
begin
   ScanThread.Free;
   EntryList.Write(_settingsfile);
   EntryList.Free;
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
   with TwEdit.Create(self) do begin
      ReadFromEntry(TEntry(lbList.Items.Objects[lbList.ItemIndex]));
      Show;
   end;
end;

procedure TwTed.tbDeleteClick(Sender: TObject);
begin
   if (lbList.ItemIndex < 0) or (lbList.Items.Count <= lbList.ItemIndex) then exit;
   EntryList.Remove(TEntry(lbList.Items.Objects[lbList.ItemIndex]));
   lbList.Items.Delete(lbList.ItemIndex);
end;

procedure TwTed.lbListDrawItem(Control: TWinControl; Index: Integer;
   Rect: TRect; State: TOwnerDrawState);
var
   e: TEntry;
   r: TRect;
begin
   with lbList.Canvas do begin
      FillRect(Rect);

      if (index < 0) or (lbList.Items.Count <= Index) then exit;
      e := TEntry(lbList.Items.Objects[index]);
      if (e = nil) then exit;

      r := classes.Rect(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
      TextRect(r, r.Left, r.Top, e.name);

      r := classes.Rect(Rect.Left + hcHeader.Sections[1].Left, Rect.Top, Rect.Right + hcHeader.Sections[1].Right, Rect.Bottom);
      TextRect(r, r.Left, r.Top, inttostr(e.currseason));

      r := classes.Rect(Rect.Left + hcHeader.Sections[2].Left, Rect.Top, Rect.Right + hcHeader.Sections[2].Right, Rect.Bottom);
      TextRect(r, r.Left, r.Top, inttostr(e.currepisode));

      r := classes.Rect(Rect.Left + hcHeader.Sections[3].Left, Rect.Top, Rect.Right + hcHeader.Sections[3].Right, Rect.Bottom);
      TextRect(r, r.Left, r.Top, e.feedurl);
   end;
end;

procedure TwTed.hcHeaderResize(Sender: TObject);
begin
   lbList.Invalidate;
end;

procedure TwTed.lbListDblClick(Sender: TObject);
begin
   tbEdit.Click;
end;


procedure TwTed.ScanTimerTimer(Sender: TObject);
begin
   ScanTimer.Tag := ScanTimer.Tag + 1;
   if (ScanTimer.tag > _interval) then tbScan.Click;
   sbStatus.SimpleText := 'Next scan in ' + inttostr(_interval - ScanTimer.tag) + ' seconds.';
end;

procedure TwTed.tbScanClick(Sender: TObject);
begin
   tbScan.Enabled := False;
   ScanTimer.Enabled := False;

   sbStatus.SimpleText := 'Scanning...';
   EntryList.Write(_settingsfile);

   ScanThread.Suspended := False;
end;

procedure TwTed.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   ScanThread.stop := True;
end;

end.

