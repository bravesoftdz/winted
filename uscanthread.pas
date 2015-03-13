unit uscanthread;

{ winted by mnt - http://codeninja.de
  uses htmlparser from www.spreendigital.de

}

interface

uses
   xmlscan, usettings, uHttp, utorrentparse, ubasepath, messages,
   HttpProt, sysutils, Classes, filectrl, windows, shellapi, stdctrls,
   htmlpars;

type
   TURLSortType = (usToTop, usToBottom, usRemove);

   TScanThread = class(TThread)
      stop: boolean;
      EntryList: TEntryList;
      savedir: string;
      savemethod: integer;
      searchupdate: boolean;
      usecache: boolean;
      ProxyData: string;
   private
      entry: TEntry;
      pending: TStringList;
      FHttpCache: THttpCache;
      Fvisited: THistoryList;
      procedure WriteLog(s: string);
      procedure Finished;
      procedure UpdateAvailable;
      procedure SetStatus;
      procedure sorthelper(key: string; sorttype: TURLSortType);

      procedure WorkEntry(); //http-get
      procedure WorkXML(var xml: string; fromurl: string); //xml-parse
      function WorkItem(item: PXmlItem): boolean; //handle single item of xml-stream
      function WorkTorrent(url: string): boolean;
      function CheckTorrent(tempurl, origurl: string): boolean;
      procedure buildPending(var url: string; var currcontent: string);
      procedure findnewestepguide;
   protected
      procedure Execute; override;
   end;

const
   _bttype: string = 'bittorrent';

implementation

uses umainwin, ustringtools2;

{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TScanThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TScanThread }

procedure TScanThread.Execute;
var
   i: integer;
   tempversion: string;
const
   alphachars = ['0'..'9'];
begin
   repeat
      stop := false;
      FHttpCache := THttpCache.Create;
      if (ProxyData <> '') then
         FHttpCache.Proxy := ProxyData;
      Fvisited := THistoryList.Create;
      pending := TStringList.Create;

      if searchupdate then begin
         FHttpCache.Get('http://winted.sourceforge.net/version.php', false);
         tempversion := trim(FHttpCache.Content);
         if (copy(tempversion, 2, 1) = '.') then
            if (tempversion <> _wintedversion) then
               Synchronize(UpdateAvailable);
      end;

      if (EntryList = nil) then begin
         Synchronize(Finished);
         exit;
      end;

      for i := 0 to pred(EntryList.Count) do begin
         if (stop) then break;

         entry := EntryList.GetItem(i);
         if (entry = nil) then continue; //removed while scanning
         if (entry.beingedited) then continue; //is currently being edited
         if (entry.disabled) then continue;

         if (entry.pauseuntil <= Now) then begin
            entry.pauseuntil := 0;
         end else begin
            continue;
         end;

         entry.beingscanned := True;
         Synchronize(setstatus);
         WorkEntry;
         entry.beingscanned := False;
      end;

      pending.Free;
      FHttpCache.Free;
      Fvisited.Free;
      Synchronize(Finished);
      stop := False;
      Suspend;
   until (terminated);
end;


procedure TScanThread.Finished;
begin
   wTed.timeroffset := random(wTed.mmInterval.Tag div 10);

   wTed.tbScan.Enabled := True;
   wTed.ScanTimer.Tag := 0;
   wTed.ScanTimer.Enabled := True;
   EntryList.Write(umainwin._inifile);
   wTed.UpdateListbox(false);
   if (wTed.mmQuitafterscan.Checked) then
      PostMessage(wTed.Handle, WM_CLOSE, 0, 0);
end;


procedure TScanThread.UpdateAvailable;
begin
   wTed.pnlUpdate.Visible := True;
   wTed.mmUpdates.Tag := round(Now) + 7;
end;


procedure TScanThread.WriteLog(s: string);
begin
   globalWriteLog(TimeToStr(Now) + ' ' + DateToStr(Now) + ' ' + Entry.name + ': ' + s);
end;

////////////////////////////////////////////////////////////////////////////////


procedure TScanThread.WorkEntry;
var
   i: integer;
begin
   if (stop) then exit;

   Entry.warning := '';
   for i := 0 to pred(Entry.urls.count) do begin
      FHttpCache.Get(Entry.urls.strings[i], false);

      if (FHttpCache.status < 210) then begin
         workXML(FHttpCache.content, Entry.urls.strings[i]);
         Entry.lastpoll := Now;
         Entry.urls.Objects[i] := TObject(round(Now));
      end else begin
         WriteLog('Failed to read url ' + Entry.urls.strings[i] + ' (' + FHttpCache.statustext + ')');
         Entry.warning := 'Unable to poll url ' + Entry.urls.strings[i] + ' (' + FHttpCache.statustext + ')';
         exit;
      end;
   end;
end;


procedure TScanThread.WorkXML(var xml: string; fromurl: string);
var
   xmlscan: Tmntxmlscan;
   i: integer;
   success, findsuccess: boolean;
begin
   if (stop) then exit;

   success := False;

   try
      xmlscan := Tmntxmlscan.Create;
      case xmlscan.execute_with_url(xml, fromurl) of
         1: begin
               WriteLog('Could not Parse the Feeds XML');
               Entry.warning := 'Could not Parse the Feeds XML';
               exit;
            end;
         2: begin
               WriteLog('Could not extract any links from HTML');
               Entry.warning := 'Could not extract any links from HTML';
               exit;
            end;

         0: begin

               if xmlscan.Count > 0 then begin

                  //do we need to search for most recent s/e?
                  if (Entry.currseason = 0) and (Entry.currepisode = 0) and (not entry.downloadanything) then begin

                     Entry.currseason := 30;
                     Entry.currepisode := 30;

                     while (Entry.currseason > 0) do begin

                        findsuccess := False;
                        for i := 0 to pred(xmlscan.Count) do
                           if matchwrapper(Entry.currseason, Entry.currepisode, xmlscan.getTitle(i)) then
                              findsuccess := True;
                        if findsuccess then begin
                           Entry.currepisode := Entry.currepisode + 1;
                           break;
                        end;

                        Entry.currepisode := Entry.currepisode - 1;
                        if (Entry.currepisode = 0) then begin
                           entry.currseason := entry.currseason - 1;
                           if Entry.currseason > 0 then
                              Entry.currepisode := 30;
                        end;
                     end;

                  end; // end newest



                  if (entry.useepguide) then findnewestepguide;



                  for i := 0 to pred(xmlscan.Count) do
                     success := success or WorkItem(xmlscan.GetItem(i));



                  if (entry.downloadanything) then begin
                     if (not entry.probedanything) then begin
                        WriteLog('Built a list of recent items. I will start downloading as soon as new items arrive');
                        Entry.probedanything := true;
                     end;
                  end;

               end else begin //xml.count

                  Entry.warning := 'Feed contained 0 items (site currently down?)';

               end;
            end; //0

      end; //case
   finally
      xmlscan.Free;
   end;

   if success then begin
      Entry.lastseason := Entry.currseason;
      Entry.lastepisode := Entry.currepisode;
      if (not Entry.downloadanything) then Entry.currepisode := Entry.currepisode + 1;
      Entry.lastnew := Now;
      Entry.datelimit := Now;
      if (Entry.dopause) then
         Entry.pauseuntil := Now + Entry.pausedays - 0.05; //~1 hour
   end;
end;


// match title-filters, episode-filters and datelimit

function TScanThread.WorkItem(item: PXmlItem): boolean;
var
   i: integer;
   match: boolean;
begin
   result := False;
   if (stop) then exit;

   //already cached (=visited)? bail out
//   if (FHttpCache.Visited(item^.url)) then exit;
   if (Fvisited.Find(item^.url) >= 0) then exit;

   //bail if this is the very first time this entry is scanned
   if (Entry.downloadanything) and (not Entry.probedanything) then exit;

   //check dont list
   for i := 0 to pred(entry.ignore.Count) do
      if (matchwildcard(item^.title, entry.ignore.Strings[i])) then
         exit;

   //check do list
   if (Entry.allwanted = true) then begin //must match all wanted strings
      for i := 0 to pred(entry.wanted.Count) do
         if (not matchwildcard(item^.title, entry.wanted.Strings[i])) then exit;
   end else begin
      if (entry.wanted.Count > 0) then begin
         match := false;
         for i := 0 to pred(entry.wanted.Count) do
            if (matchwildcard(item^.title, entry.wanted.Strings[i])) then match := true;
         if (not match) then exit;
      end;
   end;


   //match episode/season
   if (not Entry.downloadanything) then begin

      item^.title := LowerCase(item^.title);

      if (Entry.currseason = 0) then begin

         if (pos(inttostr(Entry.currepisode), item^.title) = 0) then exit;

      end else begin

      //scan for hits for current episode/season or first episode of next seaon
         if (not matchwrapper(Entry.CurrSeason, Entry.CurrEpisode, item^.title)) then begin
            if (matchwrapper(Entry.CurrSeason + 1, 1, item^.title)) then begin
               Entry.currseason := Entry.currseason + 1;
               Entry.currepisode := 1;
            end else begin
               if (matchwrapper(Entry.CurrSeason + 2, 1, item^.title)) then begin
                  Entry.warning := 'Found episode after next. Maybe an episode is missing?';
               end;
               exit;
            end;
         end;

      end;

   end;

   if (Entry.usedatelimit) and (item^.pubdate <> 0) then
      if item^.pubdate < Entry.datelimit then
         exit;

   result := workTorrent(item^.url);
end;


//if current url seems not to be an torrent-file: if current page is html,
//visit all links in page to find the torrent.

function TScanThread.WorkTorrent(url: string): boolean;
var
   tries, i: integer;
begin
   result := False;

   writelog('Searching ' + url + ' for torrent');
   if debug then outputdebugstring(pchar('search ' + url));
   for tries := 0 to 2 do begin
      FHttpCache.Get(url, usecache);
      if (FHttpCache.Status < 210) or (FHttpCache.Status = 404) then break;
   end;

   //is bittorrent file? save it, we are done.
   if (pos(_bttype, FHttpCache.contenttype) > 0) then begin
      if debug then outputdebugstring(pchar('torrent = ' + url));
      WriteLog('Found torrent (' + url + ')');
      result := CheckTorrent(url, url);
      Exit;
   end;

   //no bittorrent file. okay, then get all HREF if file is html
   if (FHttpCache.contenttype <> 'text/html') then begin
      Entry.Warning := 'No torrent found, no spiderable html found, cant continue';
      WriteLog('No torrent found at ' + url + ', also no spiderable html, cant continue');
      exit;
   end;

   buildPending(url, Fhttpcache.content);

   //now poll each file and check if it got the wanted content-type
   for i := 0 to pred(pending.count) do begin
      writelog('Probing ' + pending.Strings[i] + ' for torrent file');
      if debug then outputdebugstring(pchar('probe ' + url));

      for tries := 0 to 2 do begin
         FHttpCache.Get(pending.Strings[i], usecache);
         if (FHttpCache.Status < 210) or (FHttpCache.Status = 404) then break;
      end;

      if (pos(_bttype, FHttpCache.contenttype) > 0) then begin
         if debug then outputdebugstring(pchar('torrent = ' + pending.strings[i]));
         WriteLog('Found torrent (' + pending.Strings[i] + ')');
         result := CheckTorrent(pending.Strings[i], url);
         Exit;
      end;
   end;

   Entry.warning := 'Could not find any torrent file on Website (Website down?)';
end;


//check if torrent currently saved in fhttpcache matches criterias
//and save/execute it if yes

function TScanThread.CheckTorrent(tempurl, origurl: string): boolean;
var
   minsize, maxsize, size: int64;
   name: string;
   i, j: integer;
   filenames: TStringList;
   match: boolean;
const
   _megabyte: int64 = 1024 * 1024;
begin
   result := False;

   //check size
   minsize := Entry.minsize * _megabyte;
   maxsize := Entry.maxsize * _megabyte;
   size := TorrentGetTotalSize(FHttpCache.Content);
   if (size < minsize) or (size > maxsize) then exit;


   filenames := TorrentGetFilenames(FHttpCache.Content);
   if (filenames.count = 0) then begin
      WriteLog('Could not extract filename(s) from torrent ' + tempurl);
      exit;
   end;

   //check dont list
   if (entry.filenameignore.Count > 0) then
      for i := 0 to preD(entry.filenameignore.Count) do
         for j := 0 to pred(filenames.Count) do
            if (matchwildcard(filenames.Strings[j], entry.filenameignore.Strings[i])) then exit;


   if (entry.filenamewanted.Count > 0) then begin
      if (entry.filenameallwanted) then begin
         for i := 0 to preD(entry.filenamewanted.Count) do
            for j := 0 to pred(filenames.Count) do
               if (not matchwildcard(filenames.Strings[j], entry.filenamewanted.Strings[i])) then exit;
      end else begin
         match := False;
         for i := 0 to preD(entry.filenamewanted.Count) do
            for j := 0 to pred(filenames.Count) do
               if (matchwildcard(filenames.Strings[j], entry.filenamewanted.Strings[i])) then match := True;
         if (not match) then exit;
      end;
   end;


   name := TorrentGetSaveName(FHttpCache.Content);
   case savemethod of
      1: begin
            WriteLog('Torrent saved (as ' + name + ') and executed');
            FHttpCache.SaveToFile(savedir + name);
            ShellExecute(Handle, 'open', pchar(savedir + name), nil, nil, SW_SHOWNORMAL);
         end;
      2: begin
            ShellExecute(Handle, 'open', pchar(tempurl), nil, nil, SW_SHOWNORMAL);
            WriteLog('Torrent-url opened (' + tempurl + ')');
         end;
      3: begin
            WriteLog('Torrent saved (as ' + name + ', executed, will be deleted in 10 secs');
            FHttpCache.SaveToFile(savedir + name);
            ShellExecute(Handle, 'open', pchar(savedir + name), nil, nil, SW_SHOWNORMAL);
            sleep(10000);
            DeleteFile(pchar(savedir + name));
         end;
   else begin
         WriteLog('Torrent for entry ' + Entry.name + ' saved as ' + name);
         FHttpCache.SaveToFile(savedir + name);
      end;
   end;

   Fvisited.Add(origurl);
   result := True;
end;


procedure TScanThread.SetStatus;
begin
   wTed.sbStatus.SimpleText := 'Scanning... ' + entry.name;
   wTed.UpdateListbox(false);
end;


//reorder list of urls to be probed to speed up finding process

procedure TScanThread.sorthelper(key: string; sorttype: TURLSortType);
var
   curr, dir, limit: integer;
begin
   if (pending.Count = 0) then exit;

   if (sorttype = usRemove) then begin
      for curr := pred(pending.Count) downto 0 do
         if (pos(key, pending.Strings[curr]) > 0) then
            pending.Delete(curr);
      exit;
   end;


   if (sorttype = usToTop) then begin
      curr := 0;
      dir := 1;
      limit := pred(pending.Count);
   end else begin
      curr := pred(pending.Count);
      dir := -1;
      limit := 0;
   end;


   while (curr <> limit) do begin
      if (pos(key, pending.Strings[curr]) > 0) then
         if (sorttype = usToTop) then begin
            pending.Move(curr, 0);
         end else begin
            pending.Move(curr, pred(pending.Count));
         end;

      curr := curr + dir;
   end;
end;


//parse all links out of the current (html) page

procedure TScanThread.buildPending(var url: string; var currcontent: string);
var
   currentcontent, host: string;
   i, j: integer;
   FHScanner: THTMLParser;
begin
   currentcontent := stringreplace(lowercase(FHttpCache.content), '''', #34, [rfReplaceAll]);
   pending.Clear;
   host := currenthost(url) + '/';

   try
      FHScanner := THTMLParser.Create;
      FHScanner.Lines.Text := currcontent;
      FHScanner.Execute;

      for i := 0 to pred(FHScanner.parsed.Count) do begin
         if TObject(FHScanner.parsed[i]).classtype = THTMLTag then begin
            if (THTMLTAG(FHScanner.parsed[i]).Name = 'A') then begin
               for j := 0 to pred(THTMLTAG(FHScanner.parsed[i]).Params.Count) do
                  if (THTMLParam(THTMLTAG(FHScanner.parsed[i]).Params[j]).Key = 'HREF')
                     then pending.append(makeUrlAbsolute(THTMLParam(THTMLTAG(FHScanner.parsed[i]).Params[j]).Value, url));
            end;
         end;
      end;

   finally
      FHScanner.Free;
   end;

   //presort pending to increase the chance of an early hit
   sorthelper('.css', usRemove);
   sorthelper('.exe', usRemove);
   sorthelper('.zip', usRemove);
   sorthelper('.rar', usRemove);
   sorthelper('.ico', usRemove);
   sorthelper('.xml', usRemove);
   sorthelper('.gif', usRemove);
   sorthelper('.png', usRemove);
   sorthelper('.jpg', usRemove);
   sorthelper('.jpeg', usRemove);

   sorthelper('magnet:', usRemove);
   sorthelper('javascript:', usRemove);

   sorthelper('firefox.com', usRemove);
   sorthelper('w3.org/', usRemove);
   sorthelper('http://ads.', usRemove);
   sorthelper('www.utorrent.com', usRemove);
   sorthelper('www.bitcomet.com', usRemove);

   sorthelper('/tor/', usToTop);
   sorthelper('/torrent/', usToTop);
   sorthelper('/popup.php?', usToTop);
   sorthelper('download', usToTop);
   sorthelper('/get/', usToTop);
   sorthelper('.torrent', usToTop);

   sorthelper('/cat', usToBottom);
   sorthelper('/search', usToBottom);
   sorthelper('/login', usToBottom);
   sorthelper('/faq', usToBottom);
   sorthelper('/upload', usToBottom);
end;

procedure TScanThread.findnewestepguide;
var
   sl: TStringList;
   i: integer;
begin
   FHttpCache.Get(entry.epguideurl, false);
   if (FHttpCache.Status > 210) then exit;

   try
      sl := TStringList.Create;
      sl.Text := FHttpCache.Content;

      for i := 0 to pred(sl.Count) do
         if (copy(sl.Strings[i], 4, 1) = '.') and
            (copy(sl.Strings[i], 9, 1) = '-') and
            (trim(copy(sl.strings[i], 35, 2)) <> '') then begin
            entry.currseason := StrToInt(trim(copy(sl.Strings[i], 6, 3)));
            entry.currepisode := StrToInt(trim(copy(sl.Strings[i], 10, 2)));
         end;
   finally
      sl.Free;
   end;
end;

end.

