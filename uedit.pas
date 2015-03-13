unit uedit;

{ winted by mnt - http://codeninja.de

}

interface

uses
   usettings,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, StdCtrls, ComCtrls, ExtCtrls, Menus, Mask, ToolEdit;

type
   TwEdit = class(TForm)
      pnBottom: TPanel;
      Panel1: TPanel;
      btOkay: TButton;
      btCancel: TButton;
      pcPages: TPageControl;
      tsGeneral: TTabSheet;
      tsDoDont: TTabSheet;
      lblName: TLabel;
      edName: TEdit;
      lblURL: TLabel;
      edSeason: TEdit;
      edEpisode: TEdit;
      lblEpisode: TLabel;
      Bevel1: TBevel;
      pmPredef: TPopupMenu;
      lblSeasonTip: TLabel;
      PreDefItem: TMenuItem;
      tbAdditional: TTabSheet;
      lblMaxSize: TLabel;
      lblMinSize: TLabel;
      lblMegabytes: TLabel;
      edMinSize: TEdit;
      edMaxSize: TEdit;
      cbDateLimit: TCheckBox;
      tpDateLimit: TDateTimePicker;
      sbPreDef: TSpeedButton;
      Bevel2: TBevel;
      cbSeason: TRadioButton;
      cbAnything: TRadioButton;
      Label3: TLabel;
      gbTitle: TGroupBox;
      btDelDo: TSpeedButton;
      btAddDo: TSpeedButton;
      Label1: TLabel;
      lbDo: TListBox;
      cbAllDo: TCheckBox;
      btDelDont: TSpeedButton;
      btAddDont: TSpeedButton;
      Label2: TLabel;
      lbDont: TListBox;
      GroupBox2: TGroupBox;
      btDelFDo: TSpeedButton;
      btAddFDo: TSpeedButton;
      Label4: TLabel;
      btRemFDont: TSpeedButton;
      btAddFDont: TSpeedButton;
      Label5: TLabel;
      lbFDo: TListBox;
      cbFAllDo: TCheckBox;
      lbFDont: TListBox;
      Label6: TLabel;
      Image1: TImage;
      Image2: TImage;
      Image3: TImage;
      Bevel3: TBevel;
      cbPause: TCheckBox;
      edPause: TComboBox;
      Label7: TLabel;
      Label8: TLabel;
      Image4: TImage;
      Label9: TLabel;
      Image5: TImage;
      Panel2: TPanel;
      hcURLs: THeaderControl;
      lbURLs: TListBox;
      sbDelURL: TSpeedButton;
      sbAddURL: TSpeedButton;
      Bevel4: TBevel;
      cbepguide: TCheckBox;
    edepguideurl: TEdit;
    Label10: TLabel;
    Image6: TImage;
    Label11: TLabel;
      procedure edSeasonKeyPress(Sender: TObject; var Key: Char);
      procedure btOkayClick(Sender: TObject);
      procedure sbPreDefClick(Sender: TObject);
      procedure btCancelClick(Sender: TObject);
      procedure PreDefItemClick(Sender: TObject);
      procedure edNameExit(Sender: TObject);
      procedure btAddDoClick(Sender: TObject);
      procedure btAddDontClick(Sender: TObject);
      procedure btDelDoClick(Sender: TObject);
      procedure btDelDontClick(Sender: TObject);
      procedure lbDoDblClick(Sender: TObject);
      procedure btAddFDoClick(Sender: TObject);
      procedure btAddFDontClick(Sender: TObject);
      procedure btDelFDoClick(Sender: TObject);
      procedure btRemFDontClick(Sender: TObject);
      procedure lbURLsDblClick(Sender: TObject);
      procedure sbAddURLClick(Sender: TObject);
      procedure sbDelURLClick(Sender: TObject);
      procedure lbURLsDrawItem(Control: TWinControl; Index: Integer;
         Rect: TRect; State: TOwnerDrawState);
      procedure hcURLsSectionResize(HeaderControl: THeaderControl;
         Section: THeaderSection);
   private
      ThisEntry: TEntry;
      function SettingsOkay: boolean;
   public
      procedure ReadFromEntry(entry: TEntry);
      procedure WriteToEntry(entry: TEntry);
      procedure ReadPresets;
   end;

var
   wEdit: TwEdit;
const
   _predeffile: string = 'rss-urls.txt';
   _wildcardstxt: string = 'You can use wildcards * and ?';
   _urladdtxt: string = 'Enter URL to add (including http://)';

implementation

uses umainwin, ustringtools2, math;

{$R *.DFM}

procedure TwEdit.ReadFromEntry(entry: TEntry); // if you add new items modify TEntry also
begin
   entry.beingedited := True;

   edName.Text := entry.name;
   lbURLs.Items.assign(entry.urls);
   edSeason.Text := inttostr(entry.currseason);
   edEpisode.Text := inttostr(entry.currepisode);
   edMinSize.Text := inttostr(entry.minsize);
   edMaxSize.Text := inttostr(entry.maxsize);
   cbAllDo.Checked := Entry.allwanted;
   cbAnything.Checked := Entry.downloadanything;
   cbSeason.Checked := not Entry.downloadanything;
   cbDateLimit.Checked := entry.usedatelimit;
   tpDateLimit.DateTime := Entry.datelimit;
   lbDo.Items.Assign(entry.wanted);
   lbDont.Items.Assign(entry.ignore);
   lbFDo.Items.Assign(entry.filenamewanted);
   lbFDont.Items.Assign(entry.filenameignore);
   cbFAllDo.Checked := entry.filenameallwanted;
   cbPause.Checked := entry.dopause;
   edPause.Text := inttostr(entry.pausedays);
   cbepguide.Checked := entry.useepguide;
   edepguideurl.text := entry.epguideurl;
   ThisEntry := entry;

   ReadPresets;
   pcPages.ActivePageIndex := 0;
   if (entry.virgin) then begin
      edName.SelectAll;
      edName.SetFocus;
   end;

   Show;
end;

procedure TwEdit.WriteToEntry(entry: TEntry);
begin
   entry.name := edName.Text;
   entry.urls.assign(lbURLs.Items);
   try
      entry.currseason := strtoint(edSeason.Text);
   except
      entry.currseason := 0;
   end;
   try
      entry.currepisode := strtoint(edEpisode.Text);
   except
      entry.currepisode := 0;
   end;
   try
      entry.minsize := strtoint(edMinSize.Text);
   except
      entry.minsize := 0;
   end;
   try
      entry.maxsize := strtoint(edMaxSize.Text);
   except
      entry.maxsize := maxint;
   end;
   entry.usedatelimit := cbDateLimit.Checked;
   entry.datelimit := tpDateLimit.DateTime;
   entry.wanted.Assign(lbDo.Items);
   entry.ignore.Assign(lbDont.Items);
   entry.allwanted := cbAllDo.checked;
   entry.downloadanything := cbAnything.Checked;
   entry.useepguide := cbepguide.checked;
   entry.epguideurl := edepguideurl.text;
   entry.filenamewanted.Assign(lbFDo.Items);
   entry.filenameignore.Assign(lbFDont.Items);
   entry.filenameallwanted := cbFAllDo.Checked;
   entry.dopause := cbPause.Checked;
   try
      entry.pausedays := strtoint(edPause.text);
   except
      entry.pausedays := 7;
   end;
   //and finally (so it is being synced)
   entry.beingedited := false;
end;

function TwEdit.SettingsOkay: boolean;
var
   i, validcnt: integer;
begin
   result := True;
   validcnt := 0;

   for i := 0 to pred(lbURLs.items.count) do begin
      if (copy(lbURLs.items.strings[i], 1, 7) = 'http://') and (length(lbURLs.items.strings[i]) > 9) then
         validcnt := validcnt + 1;
   end;

   if (validcnt < 1) then begin
      lbURLs.SetFocus;
      MessageDlg('Please supply a valid Feed-URL', mtError, [mbOK], 0);
      result := False;
      exit;
   end;
end;

procedure TwEdit.ReadPresets; // name (source): http://
var
   mi: TMenuItem;
   f: textfile;
   x: integeR;
   s: string;
begin
   pmPredef.Items.Clear;
   if (fileexists(_predeffile)) then begin
      AssignFile(f, _predeffile);
      try
         Reset(f);
         while (not Eof(f)) do begin
            readln(f, s);
            x := pos(':', s);
            if (x > 0) then begin
               mi := TMenuItem.Create(pmPredef);
               mi.Caption := Trim(copy(s, 1, x - 1));
               mi.hint := Trim(copy(s, x + 1, maxint));
               mi.OnClick := PreDefItemClick;
               pmPredef.Items.Add(mi);
            end;
         end;
      finally
         CloseFile(f);
      end;
   end;
end;

////////////////////////////////////////////////////////////////////////////////
// some functions to easy listbox handling

function validItem(listbox: TListBox): boolean;
begin
   result := True;
   if (listbox.itemindex < 0) then result := false;
   if (listbox.itemindex >= listbox.items.count) then result := False;
end;


procedure editlbEntry2(listbox: TListBox; msg: string);
begin
   if (validItem(listbox)) then
      listbox.Items.Strings[listbox.ItemIndex] := InputBox('Edit Entry', msg, listbox.Items.Strings[listbox.ItemIndex]);
end;

procedure addLbEntry2(listbox: TListBox; msg: string);
var
   txt: string;
begin
   txt := '';
   if InputQuery('Add Entry', msg, txt) then begin
      if (msg = _wildcardstxt) then
         if (pos('*', txt) = 0) and (pos('?', txt) = 0) then
            txt := '*' + txt + '*';
      listbox.items.append(txt);
   end;
end;

procedure editlbEntry(listbox: TListBox);
begin
   editlbEntry2(listbox, _wildcardstxt);
end;

procedure addLbEntry(listbox: TListBox);
begin
   addlbEntry2(listbox, _wildcardstxt);
end;

procedure dellbentry(listbox: TListBox);
begin
   if (validItem(listbox)) then
      listbox.items.Delete(listbox.itemindex);
end;


////////////////////////////////////////////////////////////////////////////////

procedure TwEdit.edSeasonKeyPress(Sender: TObject; var Key: Char);
begin
   if (key > #58) then key := #0;
end;

procedure TwEdit.btOkayClick(Sender: TObject);
begin
   if SettingsOkay then begin
      ThisEntry.virgin := False;
      WriteToEntry(ThisEntry);
      wTed.UpdateListbox(false);
      Close;
   end;
end;

procedure TwEdit.btCancelClick(Sender: TObject);
var
   i: integer;
begin
   ThisEntry.beingedited := False;
   if (ThisEntry.virgin) then begin
      i := wTed.lbList.Items.IndexOfObject(ThisEntry);
      if (i >= 0) then wTed.lbList.Items.Delete(i);
   end;
   Close;
end;

procedure TwEdit.PreDefItemClick(Sender: TObject);
begin
   edName.text := TMEnuItem(Sender).Caption;
   lbURLs.Items.clear;
   lbURLs.Items.Append(TMenuItem(Sender).Hint);
end;

procedure TwEdit.sbPreDefClick(Sender: TObject);
begin
   pmPredef.PopupComponent := sbPreDef;
   pmPredef.Popup(ClientOrigin.x + sbPreDef.Left, ClientOrigin.y + (sbPreDef.Top + sbPreDef.Height));
end;

procedure TwEdit.edNameExit(Sender: TObject);
begin
   wTed.lbList.Update;
end;

procedure TwEdit.btAddDoClick(Sender: TObject);
begin
   addlbEntry(lbDo);
end;

procedure TwEdit.btAddDontClick(Sender: TObject);
begin
   addlbEntry(lbDont);
end;

procedure TwEdit.btDelDoClick(Sender: TObject);
begin
   dellbentry(lbDo);
end;

procedure TwEdit.btDelDontClick(Sender: TObject);
begin
   dellbentry(lbDont);
end;

procedure TwEdit.lbDoDblClick(Sender: TObject);
begin
   editlbEntry(TListBox(Sender));
end;

procedure TwEdit.btAddFDoClick(Sender: TObject);
begin
   addLbEntry(lbFDo);
end;

procedure TwEdit.btAddFDontClick(Sender: TObject);
begin
   addLbEntry(lbFDont);
end;

procedure TwEdit.btDelFDoClick(Sender: TObject);
begin
   dellbentry(lbFDo);
end;

procedure TwEdit.btRemFDontClick(Sender: TObject);
begin
   dellbentry(lbFDont);
end;

procedure TwEdit.lbURLsDblClick(Sender: TObject);
begin
   editlbEntry2(lbURLs, _urladdtxt);
end;

procedure TwEdit.sbAddURLClick(Sender: TObject);
begin
   addLbEntry2(lbURLs, _urladdtxt);
end;

procedure TwEdit.sbDelURLClick(Sender: TObject);
begin
   dellbentry(lbURLs);
end;

procedure TwEdit.lbURLsDrawItem(Control: TWinControl; Index: Integer;
   Rect: TRect; State: TOwnerDrawState);
var
   s: string;
begin
   s := daystext(ceil(Now - Integer(lbURLs.Items.Objects[Index])));

   with lbURLs.Canvas do begin
      FillRect(Rect);
      TextRect(classes.Rect(Rect.Left, Rect.Top, hcURLs.Sections[0].Right - 3, Rect.bottom), Rect.left + 1, Rect.Top + 1, lbURLs.items.strings[Index]);
      TextOut(Rect.left + hcURLs.Sections.Items[1].Left, Rect.Top + 1, s);
   end;
end;

procedure TwEdit.hcURLsSectionResize(HeaderControl: THeaderControl;
   Section: THeaderSection);
begin
   lbURLs.Repaint;
end;

end.

