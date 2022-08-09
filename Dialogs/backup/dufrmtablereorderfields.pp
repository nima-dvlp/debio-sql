unit duFrmtableReorderFields;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ActnList, duDSqlNodes;

type

  { TFrmTableReorderFields }

  TFrmTableReorderFields = class(TForm)
    actMoveToTop: TAction;
    actMoveUp: TAction;
    actMoveDown: TAction;
    actMoveToBottom: TAction;
    actlreorderFields: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lbFields: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    sbRefresh: TSpeedButton;
    sbMovetoTop: TSpeedButton;
    sbMoveToBottom: TSpeedButton;
    sbMoveDown: TSpeedButton;
    sbMoveUp: TSpeedButton;
    procedure lbFieldsSelectionChange(Sender: TObject; User: boolean);
    procedure sbMoveDownClick(Sender: TObject);
    procedure sbMoveUpClick(Sender: TObject);
    procedure sbRefreshClick(Sender: TObject);
    procedure sbMoveToBottomClick(Sender: TObject);
    procedure sbMovetoTopClick(Sender: TObject);
  private
    FDatabaseNode: TDDatabaseNode;
    FTableNode: TDObjectNode;
    procedure SetTableNode(AValue: TDObjectNode);
  public
    property DatabaseNode: TDDatabaseNode read FDatabaseNode write FDatabaseNode;
    property TableNode: TDObjectNode read FTableNode write SetTableNode;
  end;

var
  FrmTableReorderFields: TFrmTableReorderFields;

implementation

{$R *.lfm}

{ TFrmTableReorderFields }

procedure TFrmTableReorderFields.lbFieldsSelectionChange(Sender: TObject; User: boolean);
var
  idx: Integer;
begin
  idx := lbFields.ItemIndex;
  sbMoveToTop.Enabled := idx > 0;
  sbMoveUp.Enabled := idx > 0;
  sbMoveDown.Enabled := idx < lbFields.Count - 1;
  sbMoveToBottom.Enabled := idx < lbFields.Count - 1;
  //WriteLn('actMoveToTop.Enabled    ', actMoveToTop.Enabled   , ' ', sbMovetoTop.Enabled);
  //WriteLn('actMoveUp.Enabled       ', actMoveUp.Enabled      , ' ', sbMoveUp.Enabled);
  //WriteLn('actMoveDown.Enabled     ', actMoveDown.Enabled    , ' ', sbMoveDown.Enabled);
  //WriteLn('actMoveToBottom.Enabled ', actMoveToBottom.Enabled, ' ', sbMoveToBottom.Enabled);
end;

procedure TFrmTableReorderFields.sbMoveDownClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lbFields.ItemIndex;
  lbFields.Items.Move(idx, idx + 1);
  lbFields.ItemIndex := idx + 1;
end;

procedure TFrmTableReorderFields.sbMoveUpClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lbFields.ItemIndex;
  lbFields.Items.Move(idx, idx - 1);
  lbFields.ItemIndex := idx - 1;
end;

procedure TFrmTableReorderFields.sbRefreshClick(Sender: TObject);
var
  cou: Integer;
begin
  lbFields.Clear;
  if FDatabaseNode.Connected then
  begin
    Panel3.Caption := 'Redorder Fields of table "' + FTableNode.ObjectName + '";';
    for cou := 0 to Length(FTableNode.Fields) - 1 do
      lbFields.Items.Add(FTableNode.Fields[cou].ExactName);
  end;
end;

procedure TFrmTableReorderFields.sbMoveToBottomClick(Sender: TObject);
begin
  lbFields.Items.Move(lbFields.ItemIndex, lbFields.Count - 1);
  lbFields.ItemIndex := lbFields.Count - 1;
end;

procedure TFrmTableReorderFields.sbMovetoTopClick(Sender: TObject);
begin
  lbFields.Items.Move(lbFields.ItemIndex, 0);
  lbFields.ItemIndex := 0;
end;

procedure TFrmTableReorderFields.SetTableNode(AValue: TDObjectNode);
var
  cou: Integer;
begin
  FTableNode := AValue;
  sbRefreshClick(sbRefresh);
end;

end.

