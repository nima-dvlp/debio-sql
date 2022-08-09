unit duFrmInsertCode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  CheckLst, Menus;

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

  end;

var
  FrmInsertCode: TFrmInsertCode;

implementation

{$R *.lfm}

end.

