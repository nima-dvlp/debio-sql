unit duFrmBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, duframFrame;

type

  { TDFrmBase }

  TDFrmBase = class(TForm)
  private

  public
    function ShowUP(Frame: TdframBase; ACaption: TCaption): TWinControl; virtual;
  end;

var
  DFrmBase: TDFrmBase;

implementation

{$R *.lfm}

{ TDFrmBase }

function TDFrmBase.ShowUP(Frame: TdframBase; ACaption: TCaption): TWinControl;
begin
  Result := Self;
  Frame.Parent := Self;
  Frame.Align := alClient;
  Caption := ACaption;
end;

end.

