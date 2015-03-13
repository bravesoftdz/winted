unit upathdlg;

interface

uses forms, windows, shlobj, activex;

// from a usenet post by Mike Lischke <public@lischke-online.de>

function SelectPath(const Caption, InitialDir: string; const Root:
   WideString; ShowStatus: Boolean; out Directory: string): Boolean;

implementation


function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;

// callback function used in SelectDirectory to set the status text and choose an initial dir

var
   Path: array[0..MAX_PATH] of Char;

begin
   case uMsg of
      BFFM_INITIALIZED:
         begin
        // Initialization has been done, now set our initial directory which is passed in lpData
        // (and set btw. the status text too).
        // Note: There's no need to cast lpData to a PChar since the following call needs a
        //       LPARAM parameter anyway.
            SendMessage(hwnd, BFFM_SETSELECTION, 1, lpData);
            SendMessage(hwnd, BFFM_SETSTATUSTEXT, 0, lpData);
         end;
      BFFM_SELCHANGED:
         begin
        // Set the status window to the currently selected path.
            if SHGetPathFromIDList(Pointer(lParam), Path) then
               SendMessage(hwnd, BFFM_SETSTATUSTEXT, 0, Integer(@Path));
         end;
   end;
   Result := 0;
end;

//------------------------------------------------------------------------------

function SelectPath(const Caption, InitialDir: string; const Root:
   WideString; ShowStatus: Boolean;
   out Directory: string): Boolean;

// Another (overloaded) browse-for-folder function with the ability to select an intial directory
// (other SelectDirectory functions are in FileCtrl.pas).
// I had to make this overloading unambiguous in its parameter list so I included a flag which
// indicates whether or not to show a status text line in the dialog (which will receive the
// currently selected path if enabled).

var
   BrowseInfo: TBrowseInfo;
   Buffer: PChar;
   RootItemIDList,
      ItemIDList: PItemIDList;
   ShellMalloc: IMalloc;
   IDesktopFolder: IShellFolder;
   Eaten, Flags: LongWord;
   Windows: Pointer;
   Path: string;

begin
   Result := False;
   Directory := '';
   Path := InitialDir;
   if (Length(Path) > 0) and (Path[Length(Path)] = '\') then
      Delete(Path, Length(Path), 1);
   FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
   if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
   begin
      Buffer := ShellMalloc.Alloc(MAX_PATH);
      try
         SHGetDesktopFolder(IDesktopFolder);
         IDesktopFolder.ParseDisplayName(Application.Handle, nil, PWideChar(Root),
            Eaten, RootItemIDList, Flags);
         with BrowseInfo do
         begin
            hwndOwner := Application.Handle;
            pidlRoot := RootItemIDList;
            pszDisplayName := Buffer;
            lpszTitle := PChar(Caption);
            ulFlags := BIF_RETURNONLYFSDIRS;
            if ShowStatus then
               ulFlags := ulFlags or BIF_STATUSTEXT;
            lParam := Integer(PChar(Path));
            lpfn := BrowseCallbackProc;
         end;

      // Make the browser dialog modal.
         Windows := DisableTaskWindows(Application.Handle);
         try
            ItemIDList := ShBrowseForFolder(BrowseInfo);
         finally
            EnableTaskWindows(Windows);
         end;

         Result := ItemIDList <> nil;
         if Result then
         begin
            ShGetPathFromIDList(ItemIDList, Buffer);
            ShellMalloc.Free(ItemIDList);
            Directory := Buffer;
         end;
      finally
         ShellMalloc.Free(Buffer);
      end;
   end;
end;

end.

