unit dufrmFBBackup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, EditBtn, Buttons, uib, duFrmLogin,
  duDSqlNodes;

type

  { TfrmFBBackup }

  TfrmFBBackup = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    chbIgnoreChecksum: TCheckBox;
    chbIgnoreLimbo: TCheckBox;
    chbMetadataOnly: TCheckBox;
    chbNoGrabageCollection: TCheckBox;
    chbOldMetaData: TCheckBox;
    chbNonTransportable: TCheckBox;
    chbConvertExtrenalTables: TCheckBox;
    Expand: TCheckBox;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
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
    UIBBackup1: TUIBBackup;
    procedure BitBtn1Click(Sender: TObject);
  private
    FDatabaseNode: TDDatabaseNode;

  public
    property DatabaseNode: TDDatabaseNode read FDatabaseNode write FDatabaseNode;
  end;

var
  frmFBBackup: TfrmFBBackup;

implementation

{$R *.lfm}

{ TfrmFBBackup }

procedure TfrmFBBackup.BitBtn1Click(Sender: TObject);
var
  LoginPrpmpt: TDFrmLogin;
begin
  LoginPrpmpt := TDFrmLogin.Create(DatabaseNode);
  try
    while True do
    begin
      if DFrmLogin.ShowModal = mrOK then
        try
          UIBBackup1.UserName := LoginPrpmpt.edUserName.Text;
          UIBBackup1.PassWord := LoginPrpmpt.edPassword.Text;
          UIBBackup1.Host := DatabaseNode.ServerNode.ServerAddress;
          //UIBBackup1.;
          UIBBackup1.Run;
          Break;
        except
          on E: Exception do
            ShowMessage(E.Message);
        end
      else
        Break;
    end;
  finally
    FreeAndNil(LoginPrpmpt);
  end;
end;

end.

