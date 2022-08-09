unit duUtil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, duTypes, IBConnection, Graphics, Grids, Debio.JSON;

function SplitString(Str: String; Spliter: Char): TStringArray;

procedure Log(Act, Desc: String);

procedure FromFontStyle(FS: TDJSON; From: TFontStyles);
function ToFontStyle(From: TDJSON): TFontStyles;

const
  FromFontQuality: array[TFontQuality] of String = ('Default','Draft','Proof','NonAntialiased','Antialiased','Cleartype','CleartypeNatural');
function ToFontQuality(From: String): TFontQuality;

const
  FromTitleStyle: array[TTitleStyle] of String = ('Lazarus', 'Standard', 'Native');
function ToTitleStyle(From: String): TTitleStyle;
function ColorToHTML(Cl: TColor): String;
implementation

function ColorToHTML(Cl: TColor): String;
begin
  Result := '#' + IntToHex(Red(Cl), 2) + IntToHex(Green(Cl), 2) + IntToHex(Blue(Cl), 2);
end;

function SplitString(Str: String; Spliter: Char): TStringArray;
var
  strs: TStringList;
  cou: Integer;
begin
  strs := TStringList.Create;
  strs.Delimiter := Spliter;
  strs.DelimitedText := Str;
  SetLength(Result, strs.Count);
  for cou := 0 to strs.Count - 1 do
  begin
    Result[cou] := strs[cou]
  end;
  FreeAndNil(strs);
end;

procedure Log(Act, Desc: String);
begin
  //WriteLn(Act, '  : ', Desc);
end;

procedure FromFontStyle(FS: TDJSON; From: TFontStyles);
begin
  with FS do
  begin
    if fsBold in From then
      I[-1].AsString := 'Bold';
    if fsItalic in From then
      I[-1].AsString := 'Italic';
    if fsUnderline in From then
      I[-1].AsString := 'Underline';
    if fsStrikeOut in From then
      I[-1].AsString := 'StrikeOut';
  end;
end;

function ToFontStyle(From: TDJSON): TFontStyles;
var
  cou: Integer;
begin
  Result := [];
  for cou := 0 to From.Count - 1 do
  begin
    case LowerCase(From.Props[cou].AsString) of
      'bold'      : Result += [fsBold];
      'italic'    : Result += [fsItalic];
      'underline' : Result += [fsUnderline];
      'strikeout' : Result += [fsStrikeOut];
    end;
  end;
end;

function ToFontQuality(From: String): TFontQuality;
begin
  Result := fqAntialiased;
  case LowerCase(From) of
    'default':          Result := fqDefault;
    'draft':            Result := fqDraft;
    'proof':            Result := fqProof;
    'nonantialiased':   Result := fqNonAntialiased;
    'antialiased':      Result := fqAntialiased;
    'cleartype':        Result := fqCleartype;
    'cleartypenatural': Result := fqCleartypeNatural;
  end;
end;

function ToTitleStyle(From: String): TTitleStyle;
begin
  Result := tsNative;
  case LowerCase(From) of
    'lazarus': Result := tsLazarus;
    'native': Result := tsNative;
    'standard': Result := tsStandard;
  end;
end;

end.

