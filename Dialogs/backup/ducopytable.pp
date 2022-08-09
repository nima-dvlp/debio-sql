unit duCopyTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  ComCtrls, Buttons, duFrmDSqlMain, duDSqlNodes, duTypes;

type

  { TFrmCopyTable }

  TFrmCopyTable = class(TForm)
    actConnect: TAction;
    aclActions: TActionList;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    procedure actConnectExecute(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FrmCopyTable: TFrmCopyTable;

implementation

uses dudmMainModule;

{$R *.lfm}

{ TFrmCopyTable }

procedure TFrmCopyTable.FormShow(Sender: TObject);
var
  itm: TTreeNode;
  srv, db: TDNodeInfo;
begin
  ComboBox1.Clear;
  for itm in FrmDSqlMain.TreeView1.Items do
  begin
    if TDNodeInfo(itm.Data).NodeSqlObjectType = dntDatabase then
    begin
      srv := TDNodeInfo(itm.Parent.Data);
      db := TDNodeInfo(itm.Data);
      ComboBox1.Items.AddObject(srv.Caption + ':' + db.Caption, db);
    end;
  end;
end;

procedure TFrmCopyTable.ComboBox1Change(Sender: TObject);
begin
  actConnect.Enabled := False;
  if ComboBox1.ItemIndex = -1 then
    Exit;
  actConnect.Enabled := not TDDatabaseNode(ComboBox1.Items.Objects[ComboBox1.ItemIndex]).Connected;
end;

procedure TFrmCopyTable.actConnectExecute(Sender: TObject);
begin
  if ComboBox1.ItemIndex = -1 then
    Exit;
  TDDatabaseNode(ComboBox1.Items.Objects[ComboBox1.ItemIndex]).Connect;
end;

end.

