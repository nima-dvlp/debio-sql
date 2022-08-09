unit dufrmFBRestore;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  EditBtn, Buttons, uib;

type

  { TFrmFBRestore }

  TFrmFBRestore = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    chbConvertExtrenalTables: TCheckBox;
    chbIgnoreChecksum: TCheckBox;
    chbIgnoreLimbo: TCheckBox;
    chbMetadataOnly: TCheckBox;
    chbNoGrabageCollection: TCheckBox;
    chbNonTransportable: TCheckBox;
    chbOldMetaData: TCheckBox;
    Expand: TCheckBox;
    FileNameEdit1: TFileNameEdit;
    FileNameEdit2: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mmVerbose: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    UIBRestore1: TUIBRestore;
    procedure BitBtn1Click(Sender: TObject);
    procedure UIBRestore1Verbose(Sender: TObject; Message: string);
  private

  public

  end;

var
  FrmFBRestore: TFrmFBRestore;

implementation

{$R *.lfm}

{ TFrmFBRestore }

procedure TFrmFBRestore.UIBRestore1Verbose(Sender: TObject; Message: string);
begin
  mmVerbose.Lines.Add(Message);
end;

procedure TFrmFBRestore.BitBtn1Click(Sender: TObject);
begin
  UIBRestore1.Run;
end;

end.

