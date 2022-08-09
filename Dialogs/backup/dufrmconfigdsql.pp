unit dufrmConfigDsql;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TDFrmConfig }

  TDFrmConfig = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
  private

  public

  end;

var
  DFrmConfig: TDFrmConfig;

implementation

{$R *.lfm}

end.

