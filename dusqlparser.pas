unit duSqlParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, duTypes, crc;

type

  TDAliase = record
    Index: Integer;

  end;

  TDToken = record
    Start: TPoint;
    Done: TPoint;
    TokenType: TDNodeType;
  end;

  TDTokens = array of TDToken;

  { TDSqlParser }

  TDSqlParser = class(TComponent)
  private
    FParsed: Boolean;
    FSqlType: TDSqlType;
    FStatement: TStringList;
    function GetSqlType: TDSqlType;
    procedure SetStatement(AValue: TStringList);
  published
  procedure Parse;
  property Statement: TStringList read FStatement write SetStatement;
  property SqlType: TDSqlType read GetSqlType;
  end;

implementation

{ TDSqlParser }

function TDSqlParser.GetSqlType: TDSqlType;
begin
  if FParsed then
    Result := FSqlType
  else
    Result := dstNotParsed;
end;

procedure TDSqlParser.SetStatement(AValue: TStringList);
begin
  if FStatement = AValue then Exit;
  FStatement.Assign(AValue);
end;

procedure TDSqlParser.Parse;
begin
  FParsed := False;
  if FStatement.Count = 0 then Exit;
  try
    try

    except

    end;
  finally

  end;
end;

end.

