unit duFrmInsertCode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  CheckLst, Menus, duDSqlNodes, duFrames;

type

  { TFrmInsertCode }

  TFrmInsertCode = class(TForm)
    cbInsertIntoTable: TComboBox;
    cbFromTable: TComboBox;
    chbFromTable: TCheckBox;
    Insert: TCheckListBox;
    CheckListBox2: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pnlFromTable: TPanel;
  private

  public
    procedure ShowUP(Node: TDNodeInfo);
  end;

var
  FrmInsertCode: TFrmInsertCode;

implementation

{$R *.lfm}

{ TFrmInsertCode }

procedure TFrmInsertCode.ShowUP(Node: TDNodeInfo);
begin

end;

end.

