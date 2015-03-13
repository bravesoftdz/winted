unit usettings;

{ winted by mnt - http://codeninja.de

}

interface

uses classes, sysutils, inifiles, filectrl;

type
   TEntry = class // if you add new items, modify also TEntryList.read/write
   public
      beingscanned: boolean;
      beingedited: boolean;
      disabled: boolean;
      virgin: boolean; //freshly created. needed to kill a new entry if cancel was pressed
      xmltype: integer;

      name: string;
      urls: TStringList;

      currseason, currepisode: integer;
      lastseason, lastepisode: integer;
      minsize, maxsize: integer;
      wanted: TStringList;
      ignore: TStringList;
      allwanted: boolean;
      lastnew, lastpoll: TDateTime;
      datelimit: TDateTime;
      usedatelimit: boolean;
      downloadanything: boolean;
      probedanything: boolean; //if false build visited.txt, but dont download anything
      useepguide: boolean;
      epguideurl: string;

      filenamewanted: TStringList;
      filenameignore: TStringList;
      filenameallwanted: boolean;

      pauseuntil: TDateTime;
      dopause: boolean;
      pausedays: integer;

      warning: string;

      procedure WriteIni(ini: TIniFile; section: string);
      procedure ReadIni(ini: TIniFile; section: string);

      constructor Create;
      destructor Destroy; override;
   end;

   TEntryList = class
      procedure Write(name: string);
      procedure Read(name: string);

      function EntryFactory(): TEntry;
      procedure Remove(entry: TEntry);
      function Count: Integer;
      function GetItem(i: integer): TEntry;

      constructor Create;
      destructor Destroy; override;
   private
      FList: TList;
      procedure Clear;
   end;

const
   _listdelim = '|';

implementation

uses umainwin;

procedure stringtolist(str: string; list: TSTringList);
var
   x: integer;
begin
   list.Clear;
   repeat
      x := pos(_listdelim, str);
      if (x = 0) then break;
      list.Append(copy(str, 1, x - 1));
      delete(str, 1, x);
   until (x = 0);
end;

function listtostring(list: TSTringList): string;
var
   i: integer;
begin
   result := '';
   for i := 0 to pred(list.Count) do
      result := result + list.Strings[i] + _listdelim;
end;

{ TEntry }

constructor TEntry.Create;
begin
   name := 'New Item';

   urls := TStringList.Create;

   xmltype := -1;
   disabled := False;
   beingscanned := False;
   beingedited := False;

   wanted := TStringList.Create;
   ignore := TSTringList.Create;

   currseason := 0;
   currepisode := 0;
   lastseason := 0;
   lastepisode := 0;

   minsize := 0;
   maxsize := maxlongint;

   datelimit := Now;
   usedatelimit := False;

   lastnew := 0;
   downloadanything := False;
   probedanything := False;
   useepguide := False;
   epguideurl := '';

   filenamewanted := TStringList.Create;
   filenameignore := TStringList.Create;
   filenameallwanted := False;

   pauseuntil := 0;
   dopause := false;
   pausedays := 7;

   warning := '';
end;

destructor TEntry.Destroy;
begin
   wanted.Free;
   ignore.Free;
end;

procedure TEntry.ReadIni(ini: TIniFile; section: string);
var
   i: integer;
   urlname: string;
begin
   name := ini.ReadString(section, 'name', '');
   if (name = '') then exit;
   disabled := ini.ReadBool(section, 'disabled', false);
   for i := 0 to ini.ReadInteger(section, 'urls', 1) do begin
      urlname := 'url' + inttostr(i);
      if (urlname = 'url0') then urlname := 'url';

      if (ini.ReadString(Section, urlname, '') = '') then continue;

      urls.AddObject(ini.ReadString(Section, urlname, ''),
         TObject(
         round(ini.ReadDate(Section, urlname + 'visited', 0))));
   end;
   xmltype := ini.ReadInteger(Section, 'xmltype', -1);
   currseason := ini.ReadInteger(section, 'season', 0);
   currepisode := ini.ReadInteger(section, 'episode', 0);
   lastseason := ini.ReadInteger(section, 'lastseason', 0);
   lastepisode := ini.ReadInteger(section, 'lastepisode', 0);
   minsize := ini.ReadInteger(section, 'minsize', 0);
   maxsize := ini.ReadInteger(section, 'maxsize', maxint);
   lastnew := ini.ReadDate(section, 'lastnew', 0);
   lastpoll := ini.ReadDate(section, 'lastpoll', 0);
   datelimit := ini.ReadDate(section, 'datelimit', Now);
   usedatelimit := ini.Readbool(section, 'usedatelimit', false);
   allwanted := ini.ReadBool(section, 'alldo', false);
   downloadanything := ini.ReadBool(section, 'anything', false);
   probedanything := ini.ReadBool(section, 'probedanything', false);
   useepguide := ini.ReadBool(section, 'useepguide', false);
   epguideurl := ini.readstring(section, 'epguideurl', '');
   filenameallwanted := ini.ReadBool(section, 'filenamealldo', false);
   pauseuntil := ini.ReadDate(section, 'pauseuntil', 0);
   dopause := ini.ReadBool(section, 'pause', false);
   pausedays := ini.ReadInteger(section, 'pausedays', 7);
   stringtolist(ini.ReadString(section, 'do', ''), wanted);
   stringtolist(ini.ReadString(section, 'dont', ''), ignore);
   stringtolist(ini.ReadString(section, 'filenamedo', ''), filenamewanted);
   stringtolist(ini.ReadString(section, 'filenamedont', ''), filenameignore);
end;

procedure TEntry.WriteIni(ini: TIniFile; section: string);
var
   i: integer;
   urlname: string;
begin
   ini.WriteString(section, 'name', name);
   ini.WriteBool(section, 'disabled', disabled);
   for i := 0 to pred(urls.count) do begin
      urlname := 'url' + inttostr(i);
      if (urlname = 'url0') then urlname := 'url';

      ini.WriteString(Section, urlname, urls.strings[i]);
      ini.WriteDate(Section, urlname + 'visited', Integer(urls.objects[i]));
   end;
   ini.WriteInteger(Section, 'urls', urls.count);
   ini.WriteIntegeR(Section, 'xmltype', xmltype);
   ini.WriteInteger(section, 'season', currseason);
   ini.WriteInteger(section, 'episode', currepisode);
   ini.WriteInteger(section, 'lastseason', lastseason);
   ini.WriteInteger(section, 'lastepisode', lastepisode);
   ini.WriteInteger(section, 'minsize', minsize);
   ini.WriteInteger(section, 'maxsize', maxsize);
   ini.WriteDate(section, 'lastnew', lastnew);
   ini.WriteDate(section, 'lastpoll', lastpoll);
   ini.WriteDate(section, 'datelimit', datelimit);
   ini.WriteBool(section, 'alldo', allwanted);
   ini.WriteBool(section, 'anything', downloadanything);
   ini.WriteBool(section, 'probedanything', probedanything);
   ini.WriteBool(section, 'useepguide', useepguide);
   ini.writestring(section, 'epguideurl', epguideurl);
   ini.WriteBool(section, 'usedatelimit', usedatelimit);
   ini.WriteBool(section, 'filenamealldo', filenameallwanted);
   ini.WriteDate(section, 'pauseuntil', pauseuntil);
   ini.WriteBool(section, 'pause', dopause);
   ini.WriteInteger(section, 'pausedays', pausedays);
   ini.WriteString(section, 'do', listtostring(wanted));
   ini.WriteString(section, 'dont', listtostring(ignore));
   ini.WriteString(section, 'filenamedo', listtostring(filenamewanted));
   ini.WriteString(section, 'filenamedont', listtostring(filenameignore));
end;

{ TEntryList }

procedure TEntryList.Clear;
var
   i: integer;
begin
   for i := 0 to pred(Flist.Count) do
      TEntry(FList.Items[i]).Free;
   FList.Clear;
end;

function TEntryList.Count: Integer;
begin
   result := Flist.Count;
end;

constructor TEntryList.Create;
begin
   FList := TList.Create;
end;

destructor TEntryList.Destroy;
begin
   Clear;
   FList.Free;
   inherited;
end;

function TEntryList.EntryFactory: TEntry;
var
   e: TEntry;
begin
   e := TEntry.Create;
   FList.Add(e);
   result := e;
end;

function TEntryList.GetItem(i: integer): TEntry;
begin
   if (i < 0) or (i >= FList.Count) then begin
      result := nil;
   end else begin
      result := TEntry(FList.Items[i]);
   end;
end;

procedure TEntryList.Read(name: string);
var
   ini: TIniFile;
   i, cnt: integer;
begin
   try
      ini := TIniFile.Create(name);
      cnt := ini.ReadInteger(umainwin._inisect, 'entries', 0);
      if (cnt > 0) then
         for i := 0 to pred(cnt) do
            EntryFactory.ReadIni(ini, 'entry' + inttostr(i));
   finally
      ini.Free;
   end;


end;

procedure TEntryList.Remove(entry: TEntry);
var
   i: integer;
begin
   i := FList.IndexOf(entry);
   if (i >= 0) then begin
      TEntry(FList.Items[i]).Free;
      FList.Items[i] := nil;
      FList.Delete(i);
   end;
end;

procedure TEntryList.Write(name: string);
var
   cnt, i: integer;
   ini: TIniFile;
begin
   try
      ini := TIniFile.Create(name);
      for i := 0 to (FList.Count + 10) do
         ini.EraseSection('entry' + inttostr(i)); //avoid file trashing, clumsy
      cnt := 0;
      for i := 0 to pred(FList.Count) do begin
         TEntry(Flist.Items[i]).WriteIni(ini, 'entry' + inttostr(cnt));
         inc(cnt);
      end;
      ini.WriteInteger('WinTED', 'entries', FList.Count);
   finally
      ini.Free;
   end;
end;

end.

