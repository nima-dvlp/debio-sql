unit duFrmLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ButtonPanel, duDSqlNodes;

type

  { TDFrmLogin }

  TDFrmLogin = class(TForm)
    ButtonPanel1: TButtonPanel;
    edPassword: TEdit;
    edUserName: TEdit;
    Image1: TImage;
    lblPrompt: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    FDatabaseNode: TDDatabaseNode;
  public
    procedure ResetForm;
    constructor Create(DBNode: TDDatabaseNode);
  end;

var
  DFrmLogin: TDFrmLogin;

implementation

{$R *.lfm}

{ TDFrmLogin }

procedure TDFrmLogin.FormCreate(Sender: TObject);
var
  cap: String;
begin
  Caption := Format(Caption, [FDatabaseNode.DatabaseName, FDatabaseNode.ServerNode.Caption]);;
  lblPrompt.Caption := Format(lblPrompt.Caption, [FDatabaseNode.DatabaseName, FDatabaseNode.ServerNode.Caption]);
end;

procedure TDFrmLogin.ResetForm;
begin
  edUserName.Clear;
  edPassword.Clear;
end;

constructor TDFrmLogin.Create(DBNode: TDDatabaseNode);
begin
  inherited Create(Application);
  FDatabaseNode := DBNode;
end;

end.

