unit utorrentparse;

{ winted by mnt - http://codeninja.de

}

interface

uses sysutils, windows, classes;

function TorrentGetTotalSize(torrent: string): int64;
function TorrentGetSaveName(torrent: string): string;
function TorrentGetFilenames(torrent: string): TStringList;

implementation

function TorrentGetTotalSize(torrent: string): int64;
var
   x: integer;
begin
   result := 0;

   //snip till pieces
   x := pos(':pieces', torrent);
   if (x = 0) then exit;
   torrent := copy(torrent, 0, x);

   repeat
      x := pos(':lengthi', torrent);
      if (x = 0) then exit;
      delete(torrent, 1, x + 7);

      x := pos('e', torrent);
      if (x > 16) then exit;

      try
         result := result + strtoint64(copy(torrent, 1, x - 1));
      except
         exit;
      end;
   until (False);
end;



function TorrentGetSaveName(torrent: string): string;
var
   x, l: integeR;
begin
   result := inttostr(gettickcount) + '.torrent';

   //snip till pieces
   x := pos(':pieces', torrent);
   if (x = 0) then exit;
   torrent := copy(torrent, 0, x);

   x := pos(':name', torrent);
   if (x = 0) then exit;
   delete(torrent, 1, x + 4);
//   torrent := copy(torrent, x + 5, maxint);

   x := pos(':', torrent);
   try
      l := strtoint(copy(torrent, 1, x - 1));
   except
      exit;
   end;

   result := copy(torrent, x + 1, l) + '.torrent';
end;



function TorrentGetFilenames(torrent: string): TStringList;
var
   x, l: integer;
   s, buf: string;
begin
   result := TStringList.Create;
   buf := torrent;

   //snip till pieces
   x := pos(':pieces', torrent);
   if (x = 0) then exit;
   torrent := copy(torrent, 0, x);

   repeat
      x := pos(':pathl', torrent);
      if (x = 0) then break;
      delete(torrent, 1, x + 5);

      x := pos(':', torrent);
      if (x > 16) then break;
      if (x = 0) then break;

      l := strtoint(copy(torrent, 0, x - 1));

      s := copy(torrent, x + 1, l);
      if (pos('.', s) > 0) then result.Add(s);

      delete(torrent, 0, l + 1);
   until (False);

   if (result.count > 0) then exit;

   torrent := buf;

   x := pos(':name', torrent);
   if (x = 0) then exit;

   delete(torrent, 1, x + 4);
   x := pos(':', torrent);
   if (x = 0) or (x > 8) then exit;

   l := strtoint(copy(torrent, 0, x - 1));
   result.Add(copy(torrent, x + 1, l));
end;


end.

