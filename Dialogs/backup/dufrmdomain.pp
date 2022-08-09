unit duFrmDomain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, ValEdit, ButtonPanel, Buttons, duTypes, duDSqlNodes,
  duConsts;

type

  { TDFrmDomain }

  TDFrmDomain = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbCharSet: TComboBox;
    cbCollation: TComboBox;
    chbNotNull: TCheckBox;
    cbType: TComboBox;
    edDomainName: TEdit;
    edLenght: TEdit;
    edPrecision: TEdit;
    edScale: TEdit;
    mmComment: TMemo;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel2: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pnlCharTypes: TPanel;
    pnlDecimalTypes: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDatabaseNode: TDDatabaseNode;

  public
    SqlCode: String;
    constructor Create(TheOwner: TComponent; ADatabaseNode: TDDatabaseNode);
  end;

var
  DFrmDomain: TDFrmDomain;

implementation

{$R *.lfm}

{ TDFrmDomain }

procedure TDFrmDomain.FormShow(Sender: TObject);
var
  types: TStringList;
begin
  types := TStringList.Create;
  AddItems(FrebirdTypes[FDatabaseNode.Version], True, types, dswtType, True);
  types.Sort;
  cbType.Items.Assign(types);
  cbType.ItemIndex := 0;
  FreeAndNil(types);
  cbCharSet.Items.Assign(FDatabaseNode.Charsets);
  cbCharSet.ItemIndex := 0;
  cbCollation.Items.Assign(FDatabaseNode.Collations);
  cbCollation.ItemIndex := 0;
end;

procedure TDFrmDomain.cbTypeChange(Sender: TObject);
var
  charType, decimalType: Boolean;
begin
  charType := False;
  decimalType := False;
  case LowerCase(cbType.Text) of
    'char',
    'varchar':
      charType := True;
    'decimal',
    'numeric',
    'double':
      decimalType := True;
  end;
  pnlCharTypes.Visible := charType;
  pnlDecimalTypes.Visible := decimalType;
  SetAutoSize(False);
  SetAutoSize(True);
end;

procedure TDFrmDomain.BitBtn1Click(Sender: TObject);

  procedure ErrMsg(Err: String; Ctrl: TWinControl);
  begin
    MessageDlg('Error', Err, mtError, [mbOK], 0);
    Ctrl.SetFocus;
  end;

const
  NOT_NULL: array[Boolean]of String = ('', 'NOT NULL' + LineEnding);
var
  val: Longint;
  typeOption: String;
  typeEndOption: String;
begin
  if (not String(edDomainName.Text).IsEmpty) then
    edDomainName.Text := ExactSqlObjectName(edDomainName.Text, FDatabaseNode)
  else
  begin
    ErrMsg('Domain name not filled in!', edDomainName);
    Exit;
  end;
  typeEndOption := '';
  case LowerCase(cbType.Text) of
    'char',
    'varchar':
      begin
        if not TryStrToInt(edLenght.Text, val) then
        begin
          ErrMsg('Lenght of domain not filled or not integer!', edLenght);
          Exit;
        end;
        typeOption := cbType.Text + '(' + edLenght.Text + ') CHARACTER SET ' +
          cbCharSet.Text + LineEnding;
        typeEndOption := ' COLLATE ' + cbCollation.Text + LineEnding;
      end;
    'decimal',
    'numeric',
    'double':
      begin
        if not TryStrToInt(edPrecision.Text, val) then
        begin
          ErrMsg('Precision of domain not filled or not integer!', edPrecision);
          Exit;
        end;
        if not TryStrToInt(edScale.Text, val) then
        begin
          ErrMsg('Scale of domain not filled or not integer!', edScale);
          Exit;
        end;
        typeOption := cbType.Text + '(' + edPrecision.Text + ' ,' + edScale.Text +
          ')' + LineEnding;
      end;
    else
      begin
        typeOption := cbType.Text + LineEnding;
      end;
  end;
  SqlCode := 'CREATE DOMAIN ' + edDomainName.Text + ' AS' + LineEnding +
    typeOption +
    '--DEFAULT' + LineEnding +
    NOT_NULL[chbNotNull.Checked] +
    '--CHECK()' + LineEnding +
    typeEndOption +
    ';';
  if Trim(mmComment.Text) <> '' then
    SqlCode += LineEnding + 'COMMENT ON DOMAIN ' + edDomainName.Text + ' IS ' +
      '''' + mmComment.Text + ''';';
  ModalResult := mrOK;
end;

constructor TDFrmDomain.Create(TheOwner: TComponent; ADatabaseNode: TDDatabaseNode);
begin
  inherited Create(TheOwner);
  FDatabaseNode := ADatabaseNode;
end;

end.

