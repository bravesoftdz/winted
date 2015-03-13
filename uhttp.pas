unit uhttp;

{ winted by mnt - http://codeninja.de
  uses ICS from http://www.overbyte.be
}

interface

uses HttpProt, classes, sysutils, windows;

type
   TCacheItem = record
      Polled: TDateTime;
      Content: string;
      ContentType: string;
      URL: string;
   end;
   PCacheItem = ^TCacheItem;

   THttpCache = class
   public
      Status: integer;
      StatusText: string;
      Proxy, Content, ContentType: string;

      function Get(url: string; allowcached: boolean): boolean;
      function Visited(url: string): boolean;
      procedure SaveToFile(filename: string);

      constructor Create;
      destructor Destroy; override;
   private
      FCacheList: TStringList;
      procedure LoadCacheList;
      procedure SaveCacheList;
      function CacheItemFactory(url: string): PCacheItem;
      function SearchItem(url: string; create: boolean): PCacheItem;
      procedure Clear;
      procedure CleanUp;
      function SetProxy(http: THTTPCLi): boolean;
   end;

   THistoryList = class
   public
      procedure Add(url: string);
      function Find(url: string): integer;

      procedure Load;
      procedure Save;

      constructor Create;
      destructor Destroy; override;
   private
      FURLList: TStringList;
   end;

const
   _useragent: string = 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)';
   _cachefilename: string = 'winted.cache';
   _cachetime: integer = 7;
   _visitname: string = 'winted.visited';

implementation

uses ubasepath;

{ THttpCache }

function THttpCache.CacheItemFactory(url: string): PCacheItem;
var
   ci: PCacheItem;
begin
   ci := new(PCacheItem);
   FCacheList.AddObject(lowercase(url), TObject(ci));
   result := ci;
end;

procedure THttpCache.CleanUp;
var
   ci: PCacheItem;
   i: integeR;
   Limit: TDateTime;
begin
   Limit := Now - _cachetime;

   for i := pred(FCacheList.Count) downto 0 do begin
      ci := PCacheItem(FCacheList.Objects[i]);
      if ci^.Polled < Limit then begin
         dispose(ci);
         FCacheList.Delete(i);
      end;
   end;
end;

procedure THttpCache.Clear;
var
   i: integeR;
begin
   for i := 0 to pred(FCacheList.Count) do
      Dispose(PCacheItem(FCacheList.Objects[i]));
   FCacheList.Clear;
end;

constructor THttpCache.Create;
begin
   FCacheList := TStringList.Create;
   LoadCacheList;
end;

destructor THttpCache.Destroy;
begin
   CleanUp;
   SaveCacheList;
   Clear;
   FCacheList.Free;
   inherited;
end;

function THttpCache.Get(url: string; allowcached: boolean): boolean;
var
   Fhttp: THTTPCLi;
   ci: PCacheItem;
begin
   status := -1;
   statustext := '';
   content := '';
   contenttype := '';

   if debug then outputdebugstring(pchar(url));

   if (allowcached) then begin
      ci := SearchItem(url, False);
      if (ci <> nil) then begin
         status := 201;
         content := ci^.content;
         contenttype := ci^.contenttype;
         result := True;
         exit;
      end;
   end;


   try
      Fhttp := THTTPCli.Create(nil);
      if (Proxy <> '') then
         if (SetProxy(fhttp) = false) then begin
            Status := 600;
            StatusText := 'Proxy Error';
            exit;
         end;
      Fhttp.URL := url;
      Fhttp.MultiThreaded := True;
      Fhttp.Agent := _useragent;

      if (pos('mininova',url)=0) then Fhttp.Reference:=url;
      if (pos('mininova',url)=0) then Fhttp.Agent:=Fhttp.Agent+' winTED '+_wintedversion;

      try
         Fhttp.RcvdStream := TStringStream.Create('');
         try
            Fhttp.Get;

            contenttype := Fhttp.ContentType;

            TStringStream(Fhttp.RcvdStream).Seek(0, soFromBeginning);
            content := TStringStream(Fhttp.RcvdStream).ReadString(maxint);
         except
            on e: Exception do statustext := e.Message;
         end;
         status := Fhttp.StatusCode;
      finally
         Fhttp.RcvdStream.Free;
      end;
   finally
      Fhttp.Free;
   end;

   if (ContentType = '') then begin //grmpf
      status := 555;
      StatusText := 'Connection timed out';
   end;

   if (allowcached) then begin
      ci := SearchItem(url, true);
      ci^.Polled := Now;
      ci^.Content := content;
      ci^.ContentType := contenttype;
   end;

   if debug then outputdebugstring(pchar(contenttype));

   result := True;
end;

procedure THttpCache.LoadCacheList;
var
   fs: TFileStream;
   rd: TReader;
   ci: PCacheItem;
begin
   if (not fileexists(_basepath + _cachefilename)) then exit;

   try
      fs := TFileStream.Create(_Basepath + _cachefilename, fmOpenRead);
      try
         rd := TReader.Create(fs, 256);
         Clear;
         while (fs.Position < fs.Size) do begin
            ci := CacheItemFactory(rd.ReadString);
            ci^.Polled := rd.ReadDate;
            ci^.Content := rd.ReadString;
            ci^.ContentType := rd.ReadString;
         end;
      finally
         rd.Free;
      end;
   finally
      fs.free;
   end;
end;

procedure THttpCache.SaveCacheList;
var
   fs: TFileStream;
   wr: TWriter;
   ci: PCacheItem;
   i: integer;
begin
   CleanUp;

   try
      fs := TFileStream.Create(_basepath + _cachefilename, fmCreate);
      try
         wr := TWriter.Create(fs, 256);
         for i := 0 to preD(fCacheList.Count) do begin
            wr.WriteString(FCAcheList.Strings[i]);
            ci := PCacheItem(FCacheList.Objects[i]);
            wr.WriteDate(ci^.Polled);
            wr.WriteString(ci^.Content);
            wr.WriteString(ci^.ContentType);
         end;
      finally
         wr.Free;
      end;
   finally
      fs.Free;
   end;
end;

procedure THttpCache.SaveToFile(filename: string);
var
   f: text;
begin
   AssignFile(f, filename);
   Rewrite(f);
   Write(f, content);
   Close(f);
end;

function THttpCache.SearchItem(url: string; create: boolean): PCacheItem;
var
   i: integer;
   ci: pCacheItem;
begin
   result := nil;

   i := FCacheList.IndexOf(lowercasE(url));
   if (i >= 0) then begin
      result := PCAcheItem(FCacheList.Objects[i]);
      exit;
   end;

   if (not create) then exit;

   ci := New(PcacheItem);
   FCacheList.AddObject(lowercase(url), TObject(ci));
   result := ci;
end;

function THttpCache.SetProxy(http: THTTPCLi): boolean;
var
   x: integer;
   tempproxy: string;
begin
   if (copy(proxy, 1, 7) <> 'http://') then begin
      result := False;
      exit;
   end;

   tempproxy := proxy;

   if (copy(tempproxy, length(tempproxy), 1) <> '/') then tempproxy := tempproxy + '/';

   tempproxy := copy(tempproxy, 8, 1024);

   x := pos(':', tempproxy);
   if ((x > 0) and (x < pos('@', tempproxy))) then begin
      http.proxyUsername := copy(tempproxy, 1, x - 1);
      tempproxy := copy(tempproxy, x + 1, 1024);
   end;

   x := pos('@', tempproxy);
   if (x > 0) then begin
      http.proxyPassword := copy(tempproxy, 1, x - 1);
      tempproxy := copy(tempproxy, x + 1, 1024);
   end;

   x := pos(':', tempproxy);
   if (x > 0) then begin
      http.proxy := copy(tempproxy, 1, x - 1);
      tempproxy := copy(tempproxy, x + 1, 1024);
   end;

   if (tempproxy <> '/') then
      http.proxyPort := copy(tempproxy, 1, length(tempproxy) - 1);

   result := True;
end;

function THttpCache.Visited(url: string): boolean;
begin
   result := FCacheList.IndexOf(lowercase(url)) >= 0;
end;

{ THistoryList }

procedure THistoryList.Add(url: string);
begin
   if (Find(url) = -1) then
      FUrlList.Add(url);
end;

constructor THistoryList.Create;
begin
   FURLList := TStringList.Create;
   Load;
end;

destructor THistoryList.Destroy;
begin
   Save;
   FURLList.Free;
   inherited;
end;

function THistoryList.Find(url: string): integer;
var
   i: integer;
begin
//   outputdebugstring(pchar(url));
   result := -1;
   for i := 0 to pred(furllist.count) do begin
      if (FURLList.Strings[i] = url) then result := i;
//      outputdebugstring(pchar(furllist.strings[i]));
   end;
end;

procedure THistoryList.Load;
begin
   if FileExists(_basepath + _visitname) then
      FURLList.LoadFromFile(_basepath + _visitname);
end;

procedure THistoryList.Save;
begin
   FURLList.SaveToFile(_basepath + _visitname);
end;

end.

