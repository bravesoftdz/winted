unit xmlscan;

{ winted by mnt - http://codeninja.de
  uses libxmlparser from www.destructor.de
  uses htmlparser from www.spreendigital.de
  should handle most rss and atom feeds, because it gives a crap about formatting
}

interface

uses HTMLPars, LibXmlParser, classes, sysutils;

type
   TMemXMLParser = class(TXmlParser)
   public
//      function LoadExternalEntity(SystemId, PublicId, Notation: string): TXmlParser; override;
   end;

   TXmlItem = record
      title: string;
      url: string;
      content: string;
      pubdate: TDateTime;
   end;
   PXmlItem = ^TXmlItem;

   Tmntxmlscan = class
      function execute_with_url(xml, fromurl: string): integer;

      function Count: integer;
      function GetItem(i: integer): PXMLItem;
      function GetTitle(i: integer): string;

      constructor Create;
      destructor Destroy; override;
   private
      bInItem: Boolean;
      sCurrentTag: string;
      FItems: TList;
      FCurrentItem: PXmlItem;
      function ItemFactory: PXmlItem;
   end;

implementation

uses ustringtools2;

function pubdate2date(s: string): TDateTime; //Sun, 26 Mar 2006 19:04:29 -0800
var
   d, m, y: word;
   x: integer;
const
   _months: string = 'jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec|';
begin
   try
      x := pos(' ', s);
      d := strtoint(copy(s, x + 1, 2));
      delete(s, 1, x);

      x := pos(' ', s);
      m := (pos(lowercase(copy(s, x + 1, 3)), _months) div 4) + 1;
      delete(s, 1, x);

      x := pos(' ', s);
      y := strtoint(copy(s, x + 1, 4));

      result := EncodeDate(y, m, d);
   except
      result := Now;
   end;
end;

function published2date(s: string): TDateTime; //2006-03-31T10:41:30+01:00
var
   d, m, y: word;
begin
   try
      d := StrToInt(copy(s, 9, 2));
      m := StrToInt(copy(s, 6, 2));
      y := StrToInt(copy(s, 1, 4));
      result := EncodeDate(y, m, d);
   except
      result := Now;
   end;
end;


{ Tmntxmlscan }

constructor Tmntxmlscan.Create;
begin
   FItems := TList.Create;
end;

destructor Tmntxmlscan.Destroy;
var i:integer;
begin
   if Fitems.Count>0 then
      for i:=0 to pred(fitems.count) do
         dispose(PXmlItem(Fitems.Items[i]));

   FItems.Free;
end;

function Tmntxmlscan.execute_with_url(xml, fromurl: string): integer;
var
   FScanner: TMemXMLParser;
   FHScanner: THTMLParser;
   i, j: integer;

   function absoluteurl(url, absurl: string): string;
   var
      x: integer;
   begin
      result := url;
      if (copy(url, 0, 7) = 'http://') then exit;

      x := lastpos('/', absurl);
      if (x > 7) then absurl := copy(absurl, 1, x);
      result := absurl + url;
   end;

   procedure datahelper;
   begin
      if (not assigned(FCurrentItem)) then exit;

      if (sCurrentTag = 'a') then
         FCurrentItem.title := FCurrentItem.title + FScanner.CurContent + ' ';

      if (sCurrentTag = 'title') then FCurrentItem.title := FScanner.CurContent;
      if (sCurrentTag = 'link') then FCurrentItem.url := FScanner.CurContent;
      if (sCurrentTag = 'description') or (sCurrentTag = 'content') then FCurrentItem.content := FScanner.CurContent;
      if (sCurrentTag = 'pubDate') then FCurrentItem.pubdate := pubdate2date(FScanner.curContent);
      if (sCurrentTag = 'published') then FCurrentItem.pubdate := published2date(FScanner.curContent);
   end;

begin
   bInItem := False;
   sCurrentTag := '';
   FCurrentItem := nil;


   result := 2;

   //should probably be moved out of here, but i'm too lazy right now
   if (pos('<body', lowercase(xml)) <> 0) then begin //is html
      try
         FHScanner := THTMLParser.Create;
         FHScanner.Lines.Text := xml;
         FHScanner.Execute;

         for i := 0 to pred(FHScanner.parsed.Count) do begin
            if TObject(FHScanner.parsed[i]).classtype = THTMLTag then begin
               if (THTMLTAG(FHScanner.parsed[i]).Name = 'A') then begin
                  bInItem := True;
                  FCurrentItem := ItemFactory;
                  FItems.Add(FCurrentItem);

                  for j := 0 to pred(THTMLTAG(FHScanner.parsed[i]).Params.Count) do
                     if (THTMLParam(THTMLTAG(FHScanner.parsed[i]).Params[j]).Key = 'HREF')
                        then FCurrentItem.url := makeUrlAbsolute(THTMLParam(THTMLTAG(FHScanner.parsed[i]).Params[j]).Value, fromurl);
               end;

               if (THTMLTAG(FHScanner.parsed[i]).Name = '/A') then begin
                  bInItem := False;
               end;
            end;

            if (bInItem and (TObject(FHScanner.parsed[i]).classtype = THTMLText)) then
               FCurrentItem.title := FCurrentItem.title + THTMLText(FHScanner.parsed[i]).Line;
         end;

//      for i:=0 to pred(FItems.count) do
//               globalwritelog(getitem(i).title+' '+getitem(i).url);

      finally
         FHScanner.Free;
      end;
      Result := 0;
      exit;

   end; //html



   
   result := 1;

   try
      FScanner := TMemXMLParser.Create;
      FScanner.ReplaceCharacterEntities(xml);
      FScanner.LoadFromBuffer(Pchar(xml));

      try
         FScanner.StartScan;
         while FScanner.Scan do
            case FScanner.CurPartType of
               ptStartTag: begin
                     if (FScanner.CurName = 'item') or (FScanner.CurName = 'entry') then begin //entry=ATOM
                        bInItem := True;
                        FCurrentItem := ItemFactory;
                        FItems.Add(FCurrentItem);
                     end;

                     if (FScanner.CurName = 'link') then begin //ATOM
                        if (assigned(FCurrentItem)) then
                           FCurrentItem.url := FScanner.CurAttr.Value('href');
                     end;

                     sCurrentTag := FScanner.CurName;
                  end;
               ptEndTag: sCurrentTag := '';
               ptCData: datahelper;
               ptContent: datahelper;
            end;
         result := 0;
      except
         //well... result is already set to fail
      end;
   finally
      FScanner.Free;
   end;
end;

function Tmntxmlscan.ItemFactory: PXmlItem;
var
   xi: PXmlItem;
begin
   xi := New(PXmlItem);
   xi.pubdate := 0;
   result := xi;
end;

function Tmntxmlscan.GetItem(i: integer): PXMLItem;
begin
   result := FItems.Items[i];
end;

function Tmntxmlscan.Count: integer;
begin
   result := FItems.Count;
end;

function Tmntxmlscan.GetTitle(i: integer): string;
var
   xi: PXmlItem;
begin
   result := '';
   xi := FItems.items[i];
   if (xi = nil) then exit;
   result := xi.title;
end;

end.

