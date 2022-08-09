unit duframTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, ExtCtrls, StdCtrls,
  Grids, EditBtn, Menus, ComCtrls, duframFrame, duFrames, duConsts, SynHighlighterSQL,
  duDSqlNodes, duTypes, dufrmSettings;

type

  { TdframTable }

  TdframTable = class(TdframBase)
    btnMoveColDown: TToolButton;
    btnMoveColUp: TToolButton;
    edTblName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    pnlToolbar: TPanel;
    sgFields: TStringGrid;
    sgFields1: TStringGrid;
    sgFields2: TStringGrid;
    sgFields3: TStringGrid;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    synSqlEditor: TSynEdit;
    SynSQLSynMain: TSynSQLSyn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolBar4: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;



    procedure btnMoveColDownClick(Sender: TObject);
    procedure btnMoveColUpClick(Sender: TObject);
    procedure edTblNameChange(Sender: TObject);
    procedure edTblNameExit(Sender: TObject);

    procedure sgFieldsCheckboxToggled(sender: TObject; aCol, aRow: Integer; aState: TCheckboxState);
    procedure sgFieldsColRowInserted(Sender: TObject; IsColumn: Boolean; sIndex, tIndex: Integer);
    procedure sgFieldsEditingDone(Sender: TObject);
    procedure sgFieldsSelection(Sender: TObject; aCol, aRow: Integer);

    procedure sgFieldsSetCheckboxState(Sender: TObject; ACol, ARow: Integer; const Value: TCheckboxState);
    procedure sgFieldsValidateEntry(sender: TObject; aCol, aRow: Integer; const OldValue: string; var NewValue: String);
  private
    { private declarations }
    ColRow: TGridColumn;
    ColPK: TGridColumn;
    ColFK: TGridColumn;
    ColName: TGridColumn;
    ColType: TGridColumn;
    ColCharset: TGridColumn;
    ColCollation: TGridColumn;
    ColSize: TGridColumn;
    ColScale: TGridColumn;
    ColNotNull: TGridColumn;
    ColAutoInc: TGridColumn;
    ColUnique: TGridColumn;
    FLogStyle: TDLogStyle;
    FGridStyle: TDGridStyle;

    procedure ClearGrigData;
    procedure ClearRow(RID: Integer);
    procedure MakeDDL;
    procedure ReorderRowID;
  public
    { public declarations }
    constructor Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode); override;
    procedure ConfigChanged; override;
  end;

implementation

{$R *.lfm}

var
  Counter: Integer;

const
  //CD_C_
  //CD_C_
  //CD_C_
  //CD_C_
  CD_C_Types = 4;
  //CD_C_
  //CD_C_
  //CD_C_
  //CD_C_
  //CD_C_
  //CD_C_
  //CD_C_
  //CD_C_
  //CD_C_


type
  TDFieldInfo = class
  public
    Name: String;
    FieldType: Integer;
    Nullable: Boolean;
    Collation: String;
    ValueCheck: String;
    ValueDefault: String;
    CalueComputed: String;
    Comment: String;

  end;

{ TdframTable }

procedure TdframTable.sgFieldsValidateEntry(sender: TObject; aCol, aRow: Integer; const OldValue: string; var NewValue: String);
begin
  if aCol = CD_C_Types then
    if ColType.PickList.IndexOf(NewValue) = -1 then
      NewValue := '';
  MakeDDL;
end;

procedure TdframTable.ClearGrigData;
var
  Row, Col: Integer;
  Value: String;
begin
  for Row := 1 to sgFields.RowCount - 1 do
  begin
    sgFields.Cells[0, Row] := IntToStr(Row);
    for Col := 1 to sgFields.Columns.Count - 1do
    begin
      case sgFields.Columns[Col].ButtonStyle of
        cbsCheckboxColumn: Value := '0';
        else Value := '';
      end;
      sgFields.Cells[Col, Row] := Value;
    end;
  end;
end;

procedure TdframTable.ClearRow(RID: Integer);
var
  Col: Integer;
  Value: String;
begin
  sgFields.Cells[0, RID] := IntToStr(RID);
  for Col := 1 to sgFields.Columns.Count - 1do
  begin
    case sgFields.Columns[Col].ButtonStyle of
      cbsCheckboxColumn: Value := '0';
      else Value := '';
    end;
    sgFields.Cells[Col, RID] := Value;
  end;
end;

procedure TdframTable.MakeDDL;
const
  NotNull: array[Boolean] of String = ('', ' NOT NULL');
var
  ddl, flds, nn: String;
  cou, pkcount: Integer;
begin
  if edTblName.Text = '' then
    Exit;
  ddl := 'CREATE TBALE ' + DatabaseNode.ExactObjectName(edTblName.Text) + '(' + LineEnding;
  flds := '';
  pkcount := 0;
  for cou := 1 to sgFields.RowCount - 1 do
    if sgFields.Cells[ColPK.Index, cou] <> '1' then
      pkcount += 1;
  for cou := 1 to sgFields.RowCount - 1 do
  begin
    if flds <> '' then flds += ',' + LineEnding;
    flds += sgFields.Cells[ColName.Index, cou] + ' ';
    flds += sgFields.Cells[ColType.Index, cou];
    nn := sgFields.Cells[ColNotNull.Index, cou];
    flds += NotNull[(nn <> '') and (nn[1] = '1')];
    //flds := ;
  end;
  synSqlEditor.Text := ddl + flds;
end;

procedure TdframTable.ReorderRowID;
var
  cou: Integer;
begin
  for cou := 1 to sgFields.RowCount - 1 do
    sgFields.Cells[0, cou] := cou.ToString;
end;

procedure TdframTable.sgFieldsColRowInserted(Sender: TObject; IsColumn: Boolean; sIndex, tIndex: Integer);
begin
  if not IsColumn then
  begin
    ClearRow(sIndex);
    //sgFields.Row := sIndex;
    //sgFields.Col := 3;
    //sgFields.SetFocus;
    //sgFields.Options := sgFields.Options + [goRangeSelect];
    sgFields.Selection := TGridRect(Rect(3, sIndex, 3, sIndex));
    sgFields.SetFocus;
    //sgFields.Options := sgFields.Options - [goRangeSelect];
    sgFields.EditorMode := True;
  end;
end;

procedure TdframTable.sgFieldsEditingDone(Sender: TObject);
begin
  MakeDDL;
end;

procedure TdframTable.edTblNameChange(Sender: TObject);
begin
  MakeDDL;
end;

procedure TdframTable.edTblNameExit(Sender: TObject);
//var
//  tblName: TCaption;
begin
  //tblName := edTblName.Text;
  //if tblName.IsEmpty then
  //  Exit;
  //if tblName[1] = '"' then
  //begin
  //  if edTblName.Text[edTblName.Text] = '"';
  //end;
end;

procedure TdframTable.btnMoveColDownClick(Sender: TObject);
var
  rc: TRect;
begin
  rc := sgFields.SelectedRange[0];
  sgFields.MoveColRow(False, rc.Top, rc.Top + 1);
  btnMoveColDown.Enabled := rc.Top + 2 < sgFields.RowCount;
  ReorderRowID;
end;

procedure TdframTable.btnMoveColUpClick(Sender: TObject);
var
  rc: TRect;
begin
  rc := sgFields.SelectedRange[0];
  sgFields.MoveColRow(False, rc.Top, rc.Top - 1);
  btnMoveColUp.Enabled := rc.Top - 1 > 1;
  ReorderRowID;
end;

procedure TdframTable.sgFieldsCheckboxToggled(sender: TObject; aCol, aRow: Integer; aState: TCheckboxState);
begin
  MakeDDL;
end;

procedure TdframTable.sgFieldsSelection(Sender: TObject; aCol, aRow: Integer);
begin
  btnMoveColUp.Enabled := aRow > 1;
  btnMoveColDown.Enabled := aRow < sgFields.RowCount - 1;
end;

procedure TdframTable.sgFieldsSetCheckboxState(Sender: TObject; ACol, ARow: Integer; const Value: TCheckboxState);
const
  Vl: array[TCheckBoxState]of String = ('0', '1', '0');
begin
  sgFields.Cells[ACol, ARow] := Vl[Value];
end;

constructor TdframTable.Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode);
var
  col: TCollectionItem;
  fld: TDTypedObjectNode;
  tbl: TDObjectNode;
begin
  inherited Create(Owenr, ADataBaseNode);
  Caption := 'UNamed Table' + IntToStr(Counter);
  Inc(Counter);
  for col in sgFields.Columns do
  case TGridColumn(col).Title.Caption of
    '#':
      ColRow := TGridColumn(col);
    'PK':
      ColPK := TGridColumn(col);
    'FK':
      ColFK := TGridColumn(col);
    'Name':
      ColName:= TGridColumn(col);
    'Type':
      ColType := TGridColumn(col);
    'Charset':
      ColCharset := TGridColumn(col);
    'Collation':
      ColCollation := TGridColumn(col);
    'Size':
      ColSize := TGridColumn(col);
    'Scale':
      ColScale := TGridColumn(col);
    'NN':
      ColNotNull := TGridColumn(col);
    'AI':
      ColAutoInc := TGridColumn(col);
    'Unique':
      ColUnique := TGridColumn(col);
  end;
  for fld in DatabaseNode.DomainsNode.Fields do
  begin
    ColType.PickList.AddObject(fld.ObjectName + ':  ' + fld.ObjectType, TObject(Pointer(PtrInt(dswtDomain))));
  end;
  //AddItems(c_DSql_Types, True, ColType.PickList, dswtType);
  ColType.PickList.AddStrings(DatabaseNode.Types);
  if DatabaseNode.Version = dfb3 then
  for tbl in DatabaseNode.TabelsNode.Tabels do
  begin
    for fld in tbl.Fields do
      ColType.PickList.Add(tbl.ExactName + '.' + fld.ExactName);
  end;

  ColCharset.PickList.AddStrings(DatabaseNode.Charsets);
  ColCollation.PickList.AddStrings(DatabaseNode.Collations);
  //ColTypes.PickList.AddStrings(ComboBox1.Items);
  TComboBox(sgFields.EditorByStyle(cbsPickList)).AutoComplete := True;
  TComboBox(sgFields.EditorByStyle(cbsPickList)).Font.Assign(sgFields.Font);
  ClearRow(1);
  ConfigChanged;
end;

procedure TdframTable.ConfigChanged;
begin
  inherited ConfigChanged;
  TDFrmSettings.LoadTheme(synSqlEditor, TSynSQLSyn(synSqlEditor.Highlighter), FLogStyle, FGridStyle, DFrames.EditorTheme, DFrames.EditorThemeName);
end;

initialization
  Counter := 1;
end.

