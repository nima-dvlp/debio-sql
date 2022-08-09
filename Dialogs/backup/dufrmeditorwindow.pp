unit duFrmEditorWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, duframEditor,
  duDSqlNodes, duFrmBase;

type

  { TFrmEditorWindow }

  TFrmEditorWindow = class(TDFrmBase)
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  public
    Editor: TdframEditor;
    constructor Create(TheOwner: TComponent; DatabaseNode: TDDatabaseNode);
  end;

var
  FrmEditorWindow: TFrmEditorWindow;

implementation

{$R *.lfm}

{ TFrmEditorWindow }

procedure TFrmEditorWindow.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := Editor.Leaving;
end;

procedure TFrmEditorWindow.FormShow(Sender: TObject);
begin
  Editor.Showing;
  Editor.Entering;
end;

constructor TFrmEditorWindow.Create(TheOwner: TComponent; DatabaseNode: TDDatabaseNode);
begin
  inherited Create(TheOwner);
  Editor := TdframEditor.Create(Self, DatabaseNode);
  Editor.Parent := Self;
  Editor.Align := alClient;
end;

end.

