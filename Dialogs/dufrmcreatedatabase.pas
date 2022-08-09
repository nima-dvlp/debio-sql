unit dufrmCreateDatabase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  EditBtn, ButtonPanel, duDSqlNodes, uib, uiblib;

type

  { TDFrmCreateDatbase }

  TDFrmCreateDatbase = class(TForm)
    ButtonPanel1: TButtonPanel;
    cbCharacterSet: TComboBox;
    edAlias: TEdit;
    cbPageSize: TComboBox;
    edUserName: TEdit;
    edPassword: TEdit;
    feDatabase: TFileNameEdit;
    pnlClientLibrary: TPanel;
    pnlServerTitle: TPanel;
    pnlServerTitle1: TPanel;
    pnlServerTitle2: TPanel;
    pnlServerTitle3: TPanel;
    pnlServerTitle4: TPanel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure OKButtonClick(Sender: TObject);
  private
    FCon: TUIBDataBase;
    FServerNode: TDServerNode;
    FSuccess: Boolean;
  public
    class procedure CreateDatabase(ASN: TDServerNode);
  end;

{
NONE
ASCII
BIG_5
CYRL
DOS437
DOS850
DOS852
DOS857
DOS860
DOS861
DOS863
DOS865
EUCJ_0208
GB_2312
ISO8859_1
ISO8859_2
KSC_5601
NEXT
OCTETS
SJIS_0208
UNICODE_FSS
UTF8
WIN1250
WIN1251
WIN1252
WIN1253
WIN125
sDOS737
DOS775
DOS858
DOS862
DOS864
DOS866
DOS869
WIN1255
WIN1256
WIN1257
ISO8859_3
ISO8859_4
ISO8859_5
ISO8859_6
ISO8859_7
ISO8859_8
ISO8859_9
ISO8859_13

}

var
  DFrmCreateDatbase: TDFrmCreateDatbase;

implementation

uses
  dudmMainModule;
{$R *.lfm}

{ TDFrmCreateDatbase }

procedure TDFrmCreateDatbase.OKButtonClick(Sender: TObject);

  function CheckValue(Cap, Val: String; Ctrl: TWinControl): Boolean;
  begin
    if Val = '' then
    begin
      Ctrl.SetFocus;
      MessageDlg('Error', Cap + ' must be fill', mtError, [mbOK], '');
      Exit(True);
    end;
    Result := False;
  end;

begin
  if FileExists(feDatabase.FileName) then
  begin
    MessageDlg('Error', 'Database file already Exists!', mtError, [mbOK], '');
    Exit;
  end;
  if CheckValue('Database alias', edAlias.Text, edAlias) or
     CheckValue('Database file name', feDatabase.FileName, feDatabase) then
    Exit;

  if  FServerNode.MachineType = dstEmbedded then
  begin
    edUserName.Text := 'SYSDBA';
    edPassword.Text := '';
  end
  else if CheckValue('User name', edUserName.Text, edUserName) or
    CheckValue('Password', edPassword.Text, edPassword) then
    Exit;
  try
    try
      FCon.DatabaseName := feDatabase.FileName;
      FCon.CreateDatabase(TCharacterSet(cbCharacterSet.ItemIndex), StrToInt(cbPageSize.Text));
      if FileExists(feDatabase.FileName) then
      begin
        dmMainModule.AddDatabase(FServerNode, edAlias.Text, feDatabase.Text, cbCharacterSet.Text);
        FSuccess := True;
      end;
    except
      on E: EUIBError do
      begin
        ShowMessage(E.Message);
      end;
    end;
  finally

  end;
end;

procedure TDFrmCreateDatbase.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := (ModalResult = mrCancel) or FSuccess;
end;

class procedure TDFrmCreateDatbase.CreateDatabase(ASN: TDServerNode);
var
  tmpCrDb: TDFrmCreateDatbase;
begin
  tmpCrDb := TDFrmCreateDatbase.Create(Application);
  with tmpCrDb do
  begin
    FServerNode := ASN;
    FCon := TDDatabaseNode.NewConnection(ASN, tmpCrDb);
    FSuccess := False;
    ShowModal;
    Free;
  end;
end;

end.

