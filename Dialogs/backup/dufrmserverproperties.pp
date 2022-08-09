unit duFrmServerProperties;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  PopupNotifier, ExtCtrls, StdCtrls, ButtonPanel, Menus, EditBtn;

type

  { TFrmServerProperties }

  TFrmServerProperties = class(TForm)
    ButtonPanel1: TButtonPanel;
    cbServerType: TComboBox;
    chbCustomLockDir: TCheckBox;
    chbCustomTmpDir: TCheckBox;
    deLockDir: TDirectoryEdit;
    deTmpDir: TDirectoryEdit;
    edAddress: TEdit;
    edPort: TEdit;
    feClientLibrary: TFileNameEdit;
    dePath: TDirectoryEdit;
    edTitle: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    pnlLockDirecotry: TPanel;
    pnlTmpDirectory: TPanel;
    pnlServerTitle: TPanel;
    pnlServerAddress: TPanel;
    pnlServerPort: TPanel;
    pnlLibraryPath: TPanel;
    pnlClientLibrary: TPanel;
    Panel6: TPanel;
    pnlEmbeded: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    procedure cbServerTypeChange(Sender: TObject);
    procedure chbCustomLockDirChange(Sender: TObject);
    procedure chbCustomTmpDirChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmServerProperties: TFrmServerProperties;



implementation

{$R *.lfm}

{ TFrmServerProperties }

procedure TFrmServerProperties.cbServerTypeChange(Sender: TObject);
type
  TDCE = set of (dceSrvAdd, dceSrvPort, dceLibName, dceLibPath, dceCustomLock, dceCustomTmp);
//const
//  dceCase: array[0..2] of TDCE = (
//    [dceSrvAdd, dceSrvPort, dceLibName],
//    [dceSrvPort, dceLibName],
//    [dceLibName, dceLibPath]
//  );
var
  dce: TDCE;
begin
  dce := [];
  case cbServerType.ItemIndex of
    //Server
    0:
      begin
        dce := [dceSrvAdd, dceSrvPort, dceLibName];
        edAddress.Text := '';
      end;
    //Localhost
    1:
      begin
        dce := [dceSrvPort, dceLibName];
        edAddress.Text := 'localhost';
      end;
    //Embedded
    2:
      begin
        dce := [dceLibName, dceLibPath, dceCustomLock, dceCustomTmp];
        edAddress.Text := '';
      end;
  end;
  pnlServerAddress.Enabled := dceSrvAdd in dce;
  pnlServerPort.Enabled := dceSrvPort in dce;
  pnlClientLibrary.Enabled := dceLibName in dce;
  pnlLibraryPath.Enabled := dceLibPath in dce;
  pnlLockDirecotry.Enabled := dceCustomLock in dce;
  pnlTmpDirectory.Enabled := dceCustomTmp in dce;
end;

procedure TFrmServerProperties.chbCustomLockDirChange(Sender: TObject);
begin
  deLockDir.Directory := '';
  deLockDir.Enabled := chbCustomLockDir.Checked;
end;

procedure TFrmServerProperties.chbCustomTmpDirChange(Sender: TObject);
begin
  deTmpDir.Directory := '';
  deTmpDir.Enabled := chbCustomTmpDir.Checked;
end;

procedure TFrmServerProperties.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ModalResult = mrCancel then
  begin
    CanClose := True;
    Exit;
  end;
  CanClose := False;
  if String(edTitle.Text).IsEmpty then
  begin
    ShowMessage('Server title not filled in!');
    edTitle.SetFocus;
    Exit;
  end;
  if String(edAddress.Text).IsEmpty then
  begin
    if LowerCase(cbServerType.Text) = 'localhostt' then
    begin
      edAddress.Text := 'localhost';
    end
    else if LowerCase(cbServerType.Text) = 'embedded' then
    begin
      //nothing to do
    end else
    begin
      ShowMessage('Server address not filled in!');
      edAddress.SetFocus;
      Exit;
    end;
  end;
  if feClientLibrary.FileName.IsEmpty then
  begin
    ShowMessage('The client library not filled in!' + LineEnding +
       'In Windows in most cases it is "fbclient.dll"' + LineEnding +
       'In Linux in most release of the Firebird there is a SO named "libfbclient.so.2"');
    feClientLibrary.SetFocus;
    {$IfDef MSWINDOWS}
      feClientLibrary.Filter := 'Dynamic link library|*.dll';
      feClientLibrary.FileName := 'fbclient.dll';
    {$Else}
      feClientLibrary.Filter := 'Shared object|*.so';
      feClientLibrary.FileName := 'libfbclient.so.2';
    {$EndIf}
    Exit;
  end;
  CanClose := True;
end;

procedure TFrmServerProperties.FormCreate(Sender: TObject);
begin
  {$IfDef MSWINDOWS}
    feClientLibrary.Filter := 'Dynamic link library|*.dll';
    feClientLibrary.FileName := 'fbclient.dll';
  {$Else}
    feClientLibrary.Filter := 'Shared object|*.so';
    feClientLibrary.FileName := 'libfbclient.so.2';
  {$EndIf}
end;

procedure TFrmServerProperties.FormShow(Sender: TObject);
begin
  cbServerTypeChange(Nil);
end;

end.

