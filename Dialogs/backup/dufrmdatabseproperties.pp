unit dufrmDatabseProperties;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ButtonPanel, EditBtn;

type

  { TFrmDatabseProperties }

  TFrmDatabseProperties = class(TForm)
    ButtonPanel1: TButtonPanel;
    edCharset: TComboBox;
    edTitle: TEdit;
    fneDatbaseName: TFileNameEdit;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmDatabseProperties: TFrmDatabseProperties;

implementation

{$R *.lfm}

end.

