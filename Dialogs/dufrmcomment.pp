unit duFrmComment;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, duFrames;

type

  { TFrmComment }

  TFrmComment = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    mmComment: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
  private

  public
    function GetComment: String;
  end;

var
  FrmComment: TFrmComment;

implementation

{$R *.lfm}

{ TFrmComment }

function TFrmComment.GetComment: String;
var
  line: String;
begin
  Result := '';
  for line in mmComment.Lines do
  begin
    if Result <> '' then
      Result += LineEnding;
    Result += line;
  end;
  Result := LineEnding + '''' + Result + '''';
end;

end.

