unit duFrmCopyTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  ComCtrls, Buttons, duFrmDSqlMain, duDSqlNodes, duTypes, Types, LCLType;

type

  { TFrmCopyTable }

  TDFieldKind = dntTableField..dntTableComtd;

  { TDField }

  TDField = class(TObject)
  private
    function GetAvailable: Boolean;
  public
    Name: String;
    Tagged: Boolean;
    Kind: TDFieldKind;
    property Available: Boolean read GetAvailable;
    constructor Create(AName: String; AKind: TDFieldKind);
  end;

  { TDCopyField }

  TDCopyField = class(TObject)
  public
    SourceIndex: Integer;
    DestIndex: Integer;
    constructor Create(ADestIndex: Integer; ASourceIndex: Integer);
  end;

  TFrmCopyTable = class(TForm)
    actConnect: TAction;
    aclActions: TActionList;
    cbDatabases: TComboBox;
    cbSourceTable: Tcombobox;
    Label1: Tlabel;
    Label2: Tlabel;
    Label3: TLabel;
    Label4: TLabel;
    lbDestFields: Tlistbox;
    lbSourceFields: TListBox;
    lbCopyFields: Tlistbox;
    SpeedButton1: TSpeedButton;
    procedure actConnectExecute(Sender: TObject);
    procedure cbDatabasesChange(Sender: TObject);
    procedure cbSourceTableChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbCopyFieldsDblClick(Sender: TObject);
    procedure lbDestFieldsDblClick(Sender: TObject);
    procedure lbDestFieldsDrawItem(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
    procedure lbSourceFieldsDblClick(Sender: TObject);
  private
    FDatabaseNode: TDDatabaseNode;
    FTableNode: TDObjectNode;
    procedure RefreshSourceTables;
  public
    property DatabaseNode: TDDatabaseNode read FDatabaseNode write FDatabaseNode;
    property TableNode: TDObjectNode read FTableNode write FTableNode;
    constructor Create(TheOwner: TComponent; ADatabaseNode: TDDatabaseNode; ATableNode: TDObjectNode);

  end;

var
  FrmCopyTable: TFrmCopyTable;

implementation

uses dudmMainModule;

{$R *.lfm}

type

  { TDListHelper }

  TDListHelper = class helper for TListBox
  public
    function SelectedField: TDField;
    function Field(Index: Integer):TDField;
    procedure ClearFields;
    procedure FillFields(Table: TDObjectNode);
    procedure SetTagged(Item: Integer; Tagged: Boolean);
    function SelectedCopy: TDCopyField;
  end;

{ TDListHelper }

function TDListHelper.SelectedField: TDField;
begin
  if ItemIndex > -1 then
    Result := TDField(Items.Objects[ItemIndex])
  else
    Result := Nil;
end;

function TDListHelper.Field(Index: Integer): TDField;
begin
  Result := TDField(Items.Objects[Index]);
end;

procedure TDListHelper.ClearFields;
var
  cou: Integer;
begin
  for cou := 0 to Count - 1 do
    Items.Objects[cou].Free;
  Clear;
end;

procedure TDListHelper.FillFields(Table: TDObjectNode);
var
  fld: TDTypedObjectNode;
  kind: TDNodeType;
begin
  ClearFields;
  for fld in Table.Fields do
  begin
    if fld.NodeSqlObjectType <> dntTableComtd then
      kind := dntTableField
    else
      kind := dntTableComtd;
    Items.AddObject(fld.ExactName, TDField.Create(fld.ExactName, kind));
  end;
end;

procedure TDListHelper.SetTagged(Item: Integer; Tagged: Boolean);
begin
  Field(Item).Tagged := Tagged;
  Invalidate;
end;

function TDListHelper.SelectedCopy: TDCopyField;
begin
  Result := TDCopyField(Items.Objects[ItemIndex]);
end;

{ TDField }

function TDField.GetAvailable: Boolean;
begin
  Result := (not Tagged) and (Kind <> dntTableComtd);
end;

constructor TDField.Create(AName: String; AKind: TDFieldKind);
begin
  inherited Create;
  Name := AName;
  Kind := AKind;
end;

{ TDCopyField }

constructor TDCopyField.Create(ADestIndex: Integer; ASourceIndex: Integer);
begin
  inherited Create;
  SourceIndex := ASourceIndex;
  DestIndex := ADestIndex;
end;

{ TFrmCopyTable }

procedure TFrmCopyTable.FormShow(Sender: TObject);
var
  itm: TTreeNode;
  srv, db: TDNodeInfo;
begin
  cbDatabases.Clear;
  for itm in FrmDSqlMain.TreeView1.Items do
  begin
    if TDNodeInfo(itm.Data).NodeSqlObjectType = dntDatabase then
    begin
      srv := TDNodeInfo(itm.Parent.Data);
      db := TDNodeInfo(itm.Data);
      cbDatabases.Items.AddObject(srv.Caption + ':' + db.Caption, db);
    end;
  end;
  lbDestFields.FillFields(FTableNode);
  lbSourceFields.ClearFields;
  lbCopyFields.ClearFields;
end;

procedure TFrmCopyTable.lbCopyFieldsDblClick(Sender: TObject);
var
  itm: Integer;
  selcop: TDCopyField;
begin
  itm := lbCopyFields.ItemIndex;
  if itm < 0 then
    Exit;
  selcop := lbCopyFields.SelectedCopy;
  lbDestFields.SetTagged(selcop.DestIndex, False);
  lbSourceFields.SetTagged(selcop.SourceIndex, False);
  selcop.Free;
  lbCopyFields.Items.Delete(itm);
end;

procedure TFrmCopyTable.lbDestFieldsDblClick(Sender: TObject);
var
  fld: TDField;
  SrcIdx: Integer;
begin
  fld := lbDestFields.SelectedField;
  if fld = Nil then
    Exit;
  SrcIdx := lbSourceFields.Items.IndexOf(fld.Name);
  if SrcIdx > -1 then
  begin
    lbCopyFields.Items.AddObject(
      '[Src]' + lbSourceFields.Items[SrcIdx] + '>' +
      '[Dest]' + lbDestFields.Items[lbDestFields.ItemIndex],
      TDCopyField.Create(lbDestFields.ItemIndex, lbSourceFields.ItemIndex)
    );
    lbDestFields.SetTagged(lbDestFields.ItemIndex, True);
    lbSourceFields.SetTagged(SrcIdx, True);
  end;
end;

procedure TFrmCopyTable.lbDestFieldsDrawItem(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
const
  Img: array[TDFieldKind] of Integer = (7, 8);
  BgColor: array[Boolean] of TColor = (clWindow, clHighlight);
  TxtColor: array[Boolean] of array [Boolean] of TColor = (
    ((clGrayText), (clWindowText)),
    ((clGrayText), (clHighlightedText))
  );
var
  can: TCanvas;
  list: TListBox;
  field: TDField;
  fieldAvail: Boolean;
begin
  list := TListBox(Control);
  can := list.Canvas;
  field := list.Field(Index);
  fieldAvail := field.Available;
  can.Pen.Style := psClear;

  //if odSelected in State then
  //begin
  //  can.Brush.Color := clHighlight;
  //  if not field.Available then
  //    can.Font.Color := clGrayText
  //  else
  //    can.Font.Color := clHighlightedText;
  //end
  //else
  //begin
  //  can.Brush.Color := clWindow;
  //  if not field.Available then
  //    can.Font.Color := clGrayText
  //  else
  //    can.Font.Color := clWindowText;
  //end;
  can.Brush.Color := BgColor[odSelected in State];
  can.Font.Color := TxtColor[odSelected in State][fieldAvail];

  can.FillRect(ARect);
  can.TextOut(ARect.Left + 20, ARect.Top, list.Field(Index).Name);

  dmMainModule.ilMainTree.Draw(can, ARect.Left + 2, ARect.Top + 2, Img[field.Kind], fieldAvail);
end;

procedure TFrmCopyTable.lbSourceFieldsDblClick(Sender: TObject);
begin
  if lbDestFields.ItemIndex < 0 then
    Exit;
  lbCopyFields.Items.AddObject(
    '[Src]' + lbSourceFields.Items[lbSourceFields.ItemIndex] + '>' +
    '[Dest]' + lbDestFields.Items[lbDestFields.ItemIndex],
    TDCopyField.Create(lbDestFields.ItemIndex, lbSourceFields.ItemIndex)
  );
  lbDestFields.SetTagged(lbDestFields.ItemIndex, True);
  lbSourceFields.SetTagged(lbSourceFields.ItemIndex, True);
end;

procedure TFrmCopyTable.RefreshSourceTables;
var
  dbn: TDDatabaseNode;
  tbl: TDObjectNode;
begin
  if cbDatabases.ItemIndex = -1 then
    Exit;
  dbn := TDDatabaseNode(cbDatabases.Items.Objects[cbDatabases.ItemIndex]);
  if not dbn.Connected then
    Exit;
  cbSourceTable.Clear;
  if dbn.Connected then
  begin
    for tbl in Dbn.TabelsNode.Tabels do
    begin
      cbSourceTable.Items.AddObject(Tbl.ExactName, Tbl);
    end;
  end;
end;

constructor TFrmCopyTable.Create(TheOwner: TComponent; ADatabaseNode: TDDatabaseNode; ATableNode: TDObjectNode);
begin
  inherited Create(TheOwner);
  FDatabaseNode := ADatabaseNode;
  FTableNode := ATableNode;
end;

procedure TFrmCopyTable.cbDatabasesChange(Sender: TObject);
Var
  Dbn: TDDatabaseNode;
  Tbl: TDObjectNode;
begin
  actConnect.Enabled := False;
  if cbDatabases.ItemIndex = -1 then
    Exit;
  dbn := TDDatabaseNode(cbDatabases.Items.Objects[cbDatabases.ItemIndex]);
  actConnect.Enabled := not dbn.Connected;
  RefreshSourceTables;
end;

procedure TFrmCopyTable.cbSourceTableChange(Sender: TObject);
var
  tbl: TDObjectNode;
  fld: TDTypedObjectNode;
begin
  if cbSourceTable.ItemIndex < 0 then
    Exit;
  tbl := TDObjectNode(cbSourceTable.Items.Objects[cbSourceTable.ItemIndex]);
  lbSourceFields.ClearFields;
  lbCopyFields.ClearFields;
  lbSourceFields.FillFields(tbl);
end;

procedure TFrmCopyTable.actConnectExecute(Sender: TObject);
var
  dbn: TDDatabaseNode;
begin
  try
    if cbDatabases.ItemIndex = -1 then
      Exit;
    dbn := TDDatabaseNode(cbDatabases.Items.Objects[cbDatabases.ItemIndex]);
    dbn.Connect;
    RefreshSourceTables;
  finally
    actConnect.Enabled := not dbn.Connected;
  end;
end;

end.

