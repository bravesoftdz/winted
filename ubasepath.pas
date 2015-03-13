unit ubasepath;

interface

function _basepath: string;

const
   _wintedversion = '0.2.3';
   _atomname='wintedatom';
var
   debug: boolean;

implementation

uses sysutils;

function _basepath: string;
begin
   result := IncludeTrailingBackslash(ExtractFileDir(paramstr(0)));
end;

initialization
   debug := (paramstr(1) = 'DEBUG');
end.

