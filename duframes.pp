unit duFrames;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  FileUtil,
  duframFrame,
  duTypes, duFrmDSqlMain,
  strutils,
  ComCtrls,
  Debio.Types,
  Debio.Utils.Files,
  Debio.Utils.Date,
  Debio.Utils.SHA1,
  Debio.Utils,
  Debio.JSON;

type

  { DFrames }

  DFrames = class
  private
    class var
      _SQLReservesUpperCase: Boolean;
      _SQLIdentifireUpperCase: Boolean;
      _CurrentEditor: TdframBase;
      _DFrames: TList;
      _OneIndent: String;
      _Histories: TStringList;
      _EditorTheme: TDJSON;
      _EditorAutoComplete: Boolean;
      _EditorAutoIndent: Boolean;
      _EditorThemeName: String;
      _EditorTabSize: Integer;
      _EditorTabToSpace: Boolean;
      _DFrameshowLineNumbersEvery: Integer;
      _DFrameshowLineNumbers: Boolean;
      _ConfigPath: String;
      _ScriptDir: String;

  private
    class function GetDFrames(Index: Integer): TdframBase; static;
    class function GetDFramesCount: Integer; static;
    class function GetHistoryCount: Integer; static;
    class procedure SetCurrentEditor(AValue: TdframBase); static;
    class procedure SetDFrames(Index: Integer; AValue: TdframBase); static;
    class procedure ClearHistory;
    class procedure SetEditorTheme(AValue: TDJSON); static;
    class procedure SortHistories;

  public
    class function UserPath: String;
    class function HistoryPath: String;
    class function HistoryDir: String;
    class function ThemesPath: String;
    class function ThemesDir: String;
    class function ScriptsPath: String;
    class function ScriptsDir: String;
    class procedure SetScriptDir(ADir: String);
    class procedure UpdateConfigs;

    class property CurrentEditor: TdframBase read _CurrentEditor write SetCurrentEditor;

    class property SQLReservesUpperCase: Boolean read _SQLReservesUpperCase write _SQLReservesUpperCase;
    class property SQLIdentifireUpperCase: Boolean read _SQLIdentifireUpperCase write _SQLIdentifireUpperCase;
    class property DFrameshowLineNumbers: Boolean read _DFrameshowLineNumbers write _DFrameshowLineNumbers;
    class property DFrameshowLineNumbersEvery: Integer read _DFrameshowLineNumbersEvery write _DFrameshowLineNumbersEvery;
    class property EditorTabSize: Integer read _EditorTabSize write _EditorTabSize;
    class property EditorTabToSpace: Boolean read _EditorTabToSpace write _EditorTabToSpace;
    class property EditorAutoIndent: Boolean read _EditorAutoIndent write _EditorAutoIndent;
    class property EditorAutoComplete: Boolean read _EditorAutoComplete write _EditorAutoComplete;
    class property EditorThemeName: String read _EditorThemeName write _EditorThemeName;
    class property EditorTheme: TDJSON read _EditorTheme write SetEditorTheme;
    class function Indent(Count: Integer): String;

    //New editor created
    class procedure AddEditor(AEditor: TdframBase);

    //Editor destroied
    class procedure RemoveEditor(AEditor: TdframBase);

    //It will call SetCurrentEditor
    class procedure EditorEntered(AEditor: TdframBase);

    class property DFrames[Index: Integer]: TdframBase read GetDFrames write SetDFrames;
    class property DFramesCount: Integer read GetDFramesCount;

    //Do somthing if needed
    class procedure EditorLeaved(AEditor: TdframBase);

    class function QueryDisconnectFromMyDFrames(DatabaseNode: TObject): Boolean;
    class procedure AddToHistory(Content: String);
    class procedure ReloadHistories;
    class property HistoryCount: Integer read GetHistoryCount;
    class function GetHistory(Index: Integer): String;


    class property ConfigPath: String read _ConfigPath write _ConfigPath;
  end;

implementation

uses duConsts;

{ DFrames }

function DateSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  diff: TDateTime;
  d1, d2: TDFileAge;
begin
  d1 := PDFileAge(Pointer(List.Objects[Index1]))^;
  d2 := PDFileAge(Pointer(List.Objects[Index2]))^;
  diff :=
    d1.Modified -
    d2.Modified;
  if diff = 0 then
    Result := 0
  else if diff < 0 then
    Result := -1
  else if diff > 0 then
    Result := 1;
end;

class function DFrames.GetDFrames(Index: Integer): TdframBase; static;
begin
  Result := TdframBase(_DFrames[Index]);
end;

class function DFrames.GetDFramesCount: Integer; static;
begin
  Result := _DFrames.Count;
end;

class function DFrames.GetHistoryCount: Integer; static;
begin
  Result := _Histories.Count;
end;

class procedure DFrames.SetCurrentEditor(AValue: TdframBase);
begin
  if _CurrentEditor = AValue then Exit;
  _CurrentEditor := AValue;
end;

class procedure DFrames.SetDFrames(Index: Integer; AValue: TdframBase); static;
begin

end;

class procedure DFrames.ReloadHistories;
var
  Hs: TStrings;
  itm: String;
  dfa: PDFileAge;
begin
  if DirectoryExists(HistoryPath) then
  begin
    try
      ClearHistory;
      //Hs := TStringList.Create;
      Hs := FindAllFiles(HistoryDir, '*', False);
      for itm in Hs do
        if Length(ExtractFileName(itm)) = 40 then
        begin
          dfa := GetMem(SizeOf(TDFileAge));
          FillByte(dfa^, SizeOf(TDFileAge), 0);
          GetFileAge(itm, dfa^);
          _Histories.AddObject(itm, TObject(dfa));
        end;
      SortHistories;
      //WriteLn('Histories Count:', _Histories.Count);
    finally
      FreeAndNil(Hs);
    end;
  end;
end;

class procedure DFrames.ClearHistory;
var
  cou: Integer;
begin
  for cou := 0 to _Histories.Count - 1 do
    Freemem(Pointer(_Histories.Objects[cou]));
  _Histories.Clear;
end;

class procedure DFrames.SetEditorTheme(AValue: TDJSON);
begin
  if _EditorTheme = AValue then Exit;
  if Assigned(_EditorTheme) then
    FreeAndNil(_EditorTheme);
  _EditorTheme := AValue;
end;

class procedure DFrames.SortHistories;
begin
  _Histories.CustomSort(@DateSort);
end;

class function DFrames.UserPath: String;
begin
  Result := ExcludeTrailingPathDelimiter(GetUserDir) + PathDelim;
end;

class function DFrames.HistoryPath: String;
begin
  Result := HistoryDir + PathDelim;
end;

class function DFrames.HistoryDir: String;
begin
  Result := ConfigPath + 'History';
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
    //MakePath(Result);
end;

class function DFrames.ThemesPath: String;
begin
  Result := ThemesDir + PathDelim;
end;

class function DFrames.ThemesDir: String;
begin
  Result := ConfigPath + 'Themes' ;
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
    //MakePath(Result);
end;

class function DFrames.ScriptsPath: String;
begin
  Result := ScriptsDir + PathDelim;
end;

class function DFrames.ScriptsDir: String;
begin
  if _ScriptDir = '' then
    Result := ConfigPath + 'Scripts'
  else
    Result := _ScriptDir;
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

class procedure DFrames.SetScriptDir(ADir: String);
begin
  _ScriptDir := ADir;
end;

class procedure DFrames.UpdateConfigs;
var
  df: Pointer;
begin
  for df in _DFrames do
  begin
    TdframBase(df).ConfigChanged;
  end;
end;

class function DFrames.Indent(Count: Integer): String;
var
  cou: Integer;
begin
  Result := '';
  for cou := 0 to Count - 1 do
    Result += _OneIndent;
end;

class procedure DFrames.AddEditor(AEditor: TdframBase);
begin
  _DFrames.Add(AEditor);
end;

class procedure DFrames.RemoveEditor(AEditor: TdframBase);
begin
  _DFrames.Remove(AEditor);
end;

class procedure DFrames.EditorEntered(AEditor: TdframBase);
//var
//  ed: Pointer;
begin
  //_CurrentEditor := AEditor;
  //for ed in _DFrames do
  //begin
  //  if TdframBase(ed) = _CurrentEditor then
  //    Continue;
  //  TdframBase(ed).Exiting;
  //end;
  //We are doing somthing like this on the mainpagecontroller
end;

class procedure DFrames.EditorLeaved(AEditor: TdframBase);
begin

end;

class function DFrames.QueryDisconnectFromMyDFrames(DatabaseNode: TObject): Boolean;
var
  editor: Pointer;
  List: TList;
begin
  List := TList.Create;
  for editor in _DFrames do
  begin
    if TdframBase(editor).DatabaseNode = DatabaseNode then
      List.Add(editor);
  end;
  try
    Result := True;
    for editor in List do
    begin
      FrmDSqlMain.PageControl1.ActivePage := TTabSheet(TdframBase(editor).Parent);
      Result := TdframBase(editor).QueryDisconnect(True) and Result;
    end;
  finally
    FreeAndNil(List);
  end;
end;

class procedure DFrames.AddToHistory(Content: String);
var
  X: TStringList;
  cou: Integer;
  sha: String;
begin
  if DirectoryExists(HistoryPath) then
  begin
    X := TStringList.Create;
    try
      X.Text := Content;
      sha := Sha1Str(Content);
      X.SaveToFile(HistoryPath + sha);
    finally
      FreeAndNil(X);
    end;
  end;
  ReloadHistories;
  for cou := 0 to _DFrames.Count - 1 do
  begin
    TdframBase(_DFrames[cou]).CheckActions;
  end;
end;

class function DFrames.GetHistory(Index: Integer): String;
begin
  if Between(Index, 0, _Histories.Count - 1) then
    Result := ReadFileToString(_Histories[Index])
  else
    Result := '';
end;

var
  cou: Integer;
initialization
  DFrames._DFrames := TList.Create;
  DFrames._CurrentEditor := Nil;
  DFrames._SQLReservesUpperCase := True;
  DFrames._SQLIdentifireUpperCase := True;
  DFrames._OneIndent := '  ';
  DFrames._Histories := TStringList.Create;
finalization
  FreeAndNil(DFrames._DFrames);
  DFrames.ClearHistory;
  FreeAndNil(DFrames._Histories);
  //WriteLn(DFrames.EditorThemeName, '~', BoolToStr(Assigned(DFrames._EditorTheme), True));
  if (DFrames.EditorThemeName <> '') and (Assigned(DFrames.EditorTheme)) then
    FreeAndNil(DFrames._EditorTheme);
end.

