unit dudmMainModule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Menus, ComCtrls, duConsts,
  duFrmServerProperties, duDSqlNodes, duTypes, dufrmDatabseProperties,
  duFrmEditorWindow, dufrmcomment, duFrmCopyTable, dufrmSettings,
  duFrmtableReorderFields, dufrmAbout, dufrmCreateDatabase, duFrmDomain,
  duFrames, Debio.Types, Debio.Utils, Debio.JSON, Debio.JSON.Parser, Dialogs,
  duframFrame, duframEditor, duframTable, SynHighlighterSQL, SynEdit,
  SynEditLines, Clipbrd, LazUTF8, strutils, uiblib,
  //IB,
  Debio.Utils.RunTime,
  duFrmBase,
  dufrmFBBackup,
  dufrmFBRestore;

type

  { TdmMainModule }

  TdmMainModule = class(TDataModule)
    ilMainTree: TImageList;
    ilActions: TImageList;
    ilTabs: TImageList;
    ilPopupMenu: TImageList;
    ilPopupEditor: TImageList;
    ilEditorBookMarks: TImageList;
    MenuItem1: TMenuItem;
    MenuItem12: TMenuItem;
    miDBBackup: TMenuItem;
    miDbRestore: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem6: TMenuItem;
    miViewAlterDDL: TMenuItem;
    miTableCopyTableWizard1: TMenuItem;
    miTablesNewTable1: TMenuItem;
    miTablesRefresh1: TMenuItem;
    miTable_AddColumn1: TMenuItem;
    miTable_Brows1: TMenuItem;
    miTable_QueryBuilder1: TMenuItem;
    miTable_ReorderFields1: TMenuItem;
    miTable_Sep1: TMenuItem;
    miTable_Utility1: TMenuItem;
    miTriggerCommentOutCode: TMenuItem;
    miTable_ReorderFields: TMenuItem;
    miTable_AddColumn: TMenuItem;
    miHomesep: TMenuItem;
    MenuItem2: TMenuItem;
    miSequense_SetValue: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    miSysTable_Brows: TMenuItem;
    miTriggerAlter: TMenuItem;
    miFunctionDDLEdit1: TMenuItem;
    miExceptionAlter: TMenuItem;
    pmFnsProcsUDFs_Parameter_Sep: TMenuItem;
    miTableSep3: TMenuItem;
    pmDomainsRefresh: TMenuItem;
    MenuItem16: TMenuItem;
    miEditorCreateNewView: TMenuItem;
    miSequences_NewSequense: TMenuItem;
    miSequences_Refresh: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    pmField_Sep: TMenuItem;
    miTable_Brows: TMenuItem;
    miTable_QueryBuilder: TMenuItem;
    miTable_Utility: TMenuItem;
    miTableCopyTableWizard: TMenuItem;
    miTable_Sep: TMenuItem;
    miTablesRefresh: TMenuItem;
    miStoredProcedureExecute: TMenuItem;
    miIndexReactivate: TMenuItem;
    miTriggerDeactivate: TMenuItem;
    miTriggerActivate: TMenuItem;
    miIndexDeactivate: TMenuItem;
    miIndexActivate: TMenuItem;
    miFunctionDDLEdit: TMenuItem;
    miEditorPastePascalString: TMenuItem;
    miStoredProcedureDDLEdit: TMenuItem;
    miTablesNewTable: TMenuItem;
    miDBNewQuery: TMenuItem;
    miSrvServerProperties: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    miEditorCopySqlCode_Pascal: TMenuItem;
    MenuItem13: TMenuItem;
    miDBConnect: TMenuItem;
    miDBRefreshMeta: TMenuItem;
    miDBDisconnect: TMenuItem;
    miEditorCut: TMenuItem;
    miSrvDeleteServer: TMenuItem;
    miEditorSelectAll: TMenuItem;
    miEditorCopy: TMenuItem;
    miEditorPaste: TMenuItem;
    miSrvAddDatabase: TMenuItem;
    miSrvCreateDatabase: TMenuItem;
    MenuItem5: TMenuItem;
    miDBDelete: TMenuItem;
    miDBProperties: TMenuItem;
    miServerAdd: TMenuItem;
    pmFnsProcsUDFs_Parameter: TPopupMenu;
    pmSysTable: TPopupMenu;
    pmView: TPopupMenu;
    pmViews: TPopupMenu;
    pmUDFunction: TPopupMenu;
    pmFunctions: TPopupMenu;
    pmDomain: TPopupMenu;
    pmDomains: TPopupMenu;
    pmException: TPopupMenu;
    pmUDFunctions: TPopupMenu;
    pmStoredProcedures: TPopupMenu;
    pmIndices: TPopupMenu;
    pmField: TPopupMenu;
    pmTriggers: TPopupMenu;
    pmTrigger: TPopupMenu;
    pmStoredProcedure: TPopupMenu;
    pmHome: TPopupMenu;
    pmServer: TPopupMenu;
    pmDatabase: TPopupMenu;
    pmEditor: TPopupMenu;
    pmTables: TPopupMenu;
    pmTabControl: TPopupMenu;
    pmFunction: TPopupMenu;
    pmIndex: TPopupMenu;
    pmTable: TPopupMenu;
    pmSequences: TPopupMenu;
    pmSequence: TPopupMenu;
    pmExceptions: TPopupMenu;
    procedure DataModuleCreate(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure miDBBackupClick(Sender: TObject);
    procedure miDbRestoreClick(Sender: TObject);
    procedure miExceptionAlterClick(Sender: TObject);
    procedure miViewAlterDDLClick(Sender: TObject);
    procedure miDBDeleteClick(Sender: TObject);
    procedure miSequences_NewSequenseClick(Sender: TObject);
    procedure miSequense_SetValueClick(Sender: TObject);
    procedure miSrvCreateDatabaseClick(Sender: TObject);
    procedure miSrvDeleteServerClick(Sender: TObject);
    procedure miTableCopyTableWizardClick(Sender: TObject);
    procedure miIndexReactivateClick(Sender: TObject);
    procedure miDBConnectClick(Sender: TObject);
    procedure miDBDisconnectClick(Sender: TObject);
    procedure miDBNewQueryClick(Sender: TObject);
    procedure miDBPropertiesClick(Sender: TObject);
    procedure miDBRefreshMetaClick(Sender: TObject);
    procedure miStoredProcedureDDLEditClick(Sender: TObject);
    procedure miFunctionDDLEditClick(Sender: TObject);
    procedure miSrvServerPropertiesClick(Sender: TObject);
    procedure miSrvAddDatabaseClick(Sender: TObject);
    procedure miEditorCopyClick(Sender: TObject);
    procedure miEditorCopySqlCode_PascalClick(Sender: TObject);
    procedure miEditorCreateNewViewClick(Sender: TObject);
    procedure miEditorPastePascalStringClick(Sender: TObject);
    procedure miEditorCutClick(Sender: TObject);
    procedure miEditorPasteClick(Sender: TObject);
    procedure miDFrameselectAllClick(Sender: TObject);
    procedure miServerAddClick(Sender: TObject);
    procedure miSqlCollectionRefreshClick(Sender: TObject);
    procedure miTable_BrowsClick(Sender: TObject);
    procedure miTablesNewTableClick(Sender: TObject);
    procedure miTable_ReorderFieldsClick(Sender: TObject);
    procedure miTriggerActivateClick(Sender: TObject);
    procedure miTriggerAlterClick(Sender: TObject);
    procedure miTriggerCommentOutCodeClick(Sender: TObject);
    procedure pmDatabasePopup(Sender: TObject);
    procedure pmEditorPopup(Sender: TObject);
    procedure pmIndexPopup(Sender: TObject);
    procedure pmPopupClose(Sender: TObject);
    procedure pmTablePopup(Sender: TObject);
    procedure pmTriggerPopup(Sender: TObject);
  private
    miSqlObjectDepend: TMenuItem;

    miSqlObjectSeprator: TMenuItem;
    miSqlObjectDrop: TMenuItem;
    miSqlObjectComment: TMenuItem;
    //Tabs Menu Manage
    TabsMenuItems: array of TMenuItem;
    TabToClose: Integer;
    TabToCloseExcept: Boolean;
    miCloseTabSeprator: TMenuItem;
    miCloseTab: TMenuItem;
    miCloseTabExcept: TMenuItem;

    procedure miSqlCommentClick(Sender: TObject);
    procedure miSqlObjectDependClick(Sender: TObject);
    procedure miSqlObjectDropClick(Sender: TObject);
    procedure miTabClick(Sender: TObject);
    procedure miTabCloseClick(Sender: TObject);
  public
    CurrentPopUpScop: TForm;
    CurrentPopUpObject: TDNodeInfo;
    CurrentPopUpMenu: TPopupMenu;
    procedure ReleaseStandardMneuItems;
    procedure AssignStandarsMenuItems(PMenu: TPopupMenu);
    procedure TabsChanged;
    procedure TabsPopup(aIndex: Integer);
    procedure AddDatabase(AServerNode:TDServerNode; AAlias, ADatabaseName, ACharSet: String);
    function  ExecuteOnTheFly(DatabaseNode: TDDatabaseNode; Title, Sql: String; ShowState: TDSqlDFrameshowState): TModalResult;
    procedure ExecuteOnEditor(DatabaseNode: TDDatabaseNode; Title, Sql: String; ShowState: TDSqlDFrameshowState);
    function PopupSqlMenu(Node: TTreeNode; Scop: TDFrmBase): Boolean;

  end;

var
  dmMainModule: TdmMainModule;

implementation

uses duFrmDSqlMain;

{$R *.lfm}

{ TdmMainModule }

procedure TdmMainModule.miServerAddClick(Sender: TObject);
var
  ConfFl: TStringList;
  srv: TTreeNode;
  Confs: TDJSON;
  Servers: TDJSON;
  JSrv: TDJSON;
begin
  with TFrmServerProperties.Create(Application) do
  begin
    Caption := 'Machine Properties (Add)';
    if ShowModal = mrOK then
    begin
      ConfFl := TStringList.Create;
      Confs := Nil;
      try
        if FileExists(DFrames.ConfigPath + c_config_file) then
        begin
          ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
          Confs := ParseJSON(PChar(ConfFl.Text));
        end;
        if not Assigned(Confs) then
        begin
          Confs := TDJSON.CreateObject;
          Servers := Confs['Servers'].InitAsArray;
        end
        else
          Servers := Confs['Servers'];
        JSrv := Servers[Servers.Count].InitAsObject;
        JSrv['Title'].AsString := edTitle.Text;
        JSrv['Type'].AsString := cbServerType.Text;
        JSrv['Address'].AsString := edAddress.Text;
        JSrv['Port'].AsString := edPort.Text;
        JSrv['Library'].AsString := feClientLibrary.FileName;
        JSrv['LibPath'].AsString := dePath.Directory;
        JSrv['TmpDir'].AsString := deTmpDir.Directory;
        JSrv['LockDir'].AsString := deLockDir.Directory;
        srv := FrmDSqlMain.TreeView1.Items.AddChild(FrmDSqlMain.FServers, '');
        srv.Data := Pointer(
          TDServerNode.Create(edTitle.Text, '', edAddress.Text, edPort.Text,
            feClientLibrary.FileName, dePath.Directory, deTmpDir.Directory,
            deLockDir.Directory, cbServerType.Text, JSrv.intIdentifier, srv));
        ConfFl.Text := Confs.TO_JSONString(0, True);
        ConfFl.SaveToFile(DFrames.ConfigPath + c_config_file);
        FreeAndNil(Confs);
      finally
        if Assigned(Confs) then
          FreeAndNil(Confs);
        FreeAndNil(ConfFl);
      end;
    end;
    Free;// TFrmServerProperties.Free
  end;
end;

procedure TdmMainModule.miSqlCollectionRefreshClick(Sender: TObject);
var
  ToRetrive: TDRetriveMetaData;
begin
  case CurrentPopUpObject.NodeSqlObjectType of
    dntTables:
        ToRetrive := [drmdTables];
    dntProcedures:
        ToRetrive := [drmdProcedures];
    dntSequences:
        ToRetrive := [drmdSequences];
    dntViews:
        ToRetrive := [drmdViews];
    dntExceptions:
        ToRetrive := [drmdExceptions];
    dntUserDFunctions:
        ToRetrive := [drmdUserDFunctions];
    dntFunctions:
        ToRetrive := [drmdFunctions];
    dntDomains:
        ToRetrive := [drmdDomains];
    dntTriggers:
        ToRetrive := [drmdTriggers];
    dntIndices:
        ToRetrive := [drmdIndices];
  end;
  TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode.RetriveMetaData(ToRetrive);
end;

procedure TdmMainModule.miTable_BrowsClick(Sender: TObject);
var
  ln, Sql, fields, indent: String;
  tbl: TDObjectNode;
  fld, lfld: TDTypedObjectNode;
begin
  tbl := TDObjectNode(CurrentPopUpObject);
  Sql := '';
  ln := LineDelimiter(tbl.Hint);
  if tbl.Hint <> '' then
    Sql += '--' + ReplaceStr(tbl.Hint, ln, '--' + ln) + ln;
  Sql := 'SELECT' + ln;
  indent := DFrames.Indent(1);
  fields := '';
  lfld := fld;
  for fld in tbl.Fields do
  begin
    if fields <> '' then
      fields += '/*' + lfld.ObjectType + '*/,' + ln;
    fields += indent + 't.' + fld.ExactName;
    lfld := fld;
  end;
  fields += '  /*' + fld.ObjectType + '*/' + ln;
  Sql += fields + 'FROM' + ln + indent + tbl.ObjectName + ' t;';
  ExecuteOnEditor(tbl.DatabaseNode, 'Select ' + tbl.ObjectName, sql, [dsesExecuteAfterShow]);
end;

procedure TdmMainModule.miTabCloseClick(Sender: TObject);
var
  cou, CloseTab: Integer;
  DontClose: TTabSheet;
begin
  if TabToClose = 0 then
    Exit;
  if Sender = miCloseTabExcept then
  begin
    cou := 1;
    DontClose := FrmDSqlMain.PageControl1.Pages[TabToClose];
    CloseTab := 1;
    while cou < FrmDSqlMain.PageControl1.PageCount do
    begin
      if CloseTab >= FrmDSqlMain.PageControl1.PageCount then
        Break;
      if FrmDSqlMain.PageControl1.Pages[CloseTab] = DontClose then
        CloseTab += 1
      else
      if TdframBase(FrmDSqlMain.PageControl1.Pages[CloseTab].Controls[0]).Leaving then
        FrmDSqlMain.PageControl1.Pages[CloseTab].Free;
    end;
    TabsChanged;
  end
  else
  begin
    if TdframBase(FrmDSqlMain.PageControl1.Pages[TabToClose].Controls[0]).Leaving then
    begin
      FrmDSqlMain.PageControl1.Pages[TabToClose].Free;
      TabsChanged;
    end;
  end;
end;

procedure TdmMainModule.ReleaseStandardMneuItems;
  procedure RemoveIt(Mi: TMenuItem);
  var
    PM: TMenuItem;
  begin
    PM := Mi.Parent;
    if Assigned(PM) then
      PM.Remove(Mi);
    //if CurrentPopUpMenu.Items.IndexOf(Mi) > 0 then
    //  CurrentPopUpMenu.Items.Remove(Mi)
  end;

begin
  RemoveIt(miSqlObjectSeprator);
  RemoveIt(miSqlObjectDrop);
  RemoveIt(miSqlObjectComment);
  RemoveIt(miSqlObjectDepend);
end;

procedure TdmMainModule.AssignStandarsMenuItems(PMenu: TPopupMenu);
var
  DropImgID: Integer;
  SqlObject: String;
  Obj, Parent: TDDatabaseObjectNode;
begin
  ReleaseStandardMneuItems;
  Obj := TDDatabaseObjectNode(CurrentPopUpObject);
  if Obj.NodeSqlObjectType in c_sql_objects_CommanetAble then
  begin
    Parent := TDDatabaseObjectNode(CurrentPopUpObject.Node.Parent.Data);
    case Obj.NodeSqlObjectType of
      dntTable:
        begin
          DropImgID := 18;
          SqlObject := ' Table ';
        end;
      dntTablePmKey,
      dntTableFgKey,
      dntTableField,
      dntTableComtd:
        begin
          DropImgID := 62;
          SqlObject := ' Field ';
        end;
      dntProcedure:
        begin
          DropImgID := 38;
          SqlObject := ' Stored Procedure ';
        end;
      dntSequence:
        begin
          DropImgID := 44;
          SqlObject := ' Sequense ';
        end;
      dntView:
        begin
          DropImgID := 56;
          SqlObject := ' View ';
        end;
      dntException:
        begin
          DropImgID := 48;
          SqlObject := ' Exception ';
        end;
      dntUserDFunction:
        begin
          DropImgID := 36;
          SqlObject := ' UDF ';
        end;
      dntFunction:
        begin
          DropImgID := 36;
          SqlObject := ' Function ';
        end;
      dntDomain:
        begin
          DropImgID := 52;
          SqlObject := ' Domain ';
        end;
      dntTriggerActive,
      dntTriggerInactive:
        begin
          DropImgID := 33;
          SqlObject := ' Trigger ';
        end;
      dntIndexActive,
      dntIndexInActive:
        begin
          DropImgID := 28;
          SqlObject := ' Index ';
        end;
      dntProcedureParams,
      dntFunctionArguments,
      dntUserDFunctionArguments:
      begin
        SqlObject := ' Parameter ';
        miSqlObjectComment.Visible := (Obj.DatabaseNode.Version >= dfb3) or (Obj.NodeSqlObjectType = dntProcedureParams);
      end;
    end;
    PMenu.Items.Add(miSqlObjectSeprator);

    PMenu.Items.Add(miSqlObjectComment);
    miSqlObjectComment.ImageIndex := 57;
    miSqlObjectComment.Caption := ' Comment On' + SqlObject;
    if Obj.NodeSqlObjectType in [dntUserDFunctionArguments, dntFunctionArguments,
      dntProcedureParams] then
       miSqlObjectComment.Caption := miSqlObjectComment.Caption + Parent.ExactName + '.' + Obj.ExactName
    else
      miSqlObjectComment.Caption := miSqlObjectComment.Caption + Obj.ExactName;
    if Obj.NodeSqlObjectType in c_sql_objects_dropable then
    begin
      PMenu.Items.Add(miSqlObjectDrop);
      PMenu.Items.Add(miSqlObjectDepend);
      miSqlObjectDrop.ImageIndex := DropImgID;
      miSqlObjectDrop.Caption := 'Drop ' + SqlObject + Obj.ExactName;
      miSqlObjectDepend.ImageIndex := 63;
      miSqlObjectDepend.Caption := SqlObject.Trim + ' ' + Obj.ExactName + ' ' + 'Depends';
    end;
  end;
end;

procedure TdmMainModule.miTablesNewTableClick(Sender: TObject);
var
  Frame: TdframTable;
begin
  if (not Assigned(FrmDSqlMain.TreeView1.Selected)) or
     (not(TObject(CurrentPopUpObject) is TDObjectCollectionNode)) then
    Exit;
  Frame := TdframTable.Create(FrmDSqlMain, TDObjectCollectionNode(CurrentPopUpObject).DatabaseNode);
  FrmDSqlMain.ShowUP(Frame, Frame.Caption);
end;

procedure TdmMainModule.miTable_ReorderFieldsClick(Sender: TObject);
var
  tbl, sql: String;
  cou: Integer;
begin
  FrmTableReorderFields.DatabaseNode := TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode;
  FrmTableReorderFields.TableNode := TDObjectNode(CurrentPopUpObject);
  if FrmTableReorderFields.ShowModal = mrOK then
  with FrmTableReorderFields do
  begin
    tbl := TableNode.ObjectName;
    sql := '';
    for cou := 0 to lbFields.Count - 1 do
    begin
      if sql <> '' then
        sql += LineEnding;
      sql += Format('ALTER TABLE %S ALTER %S POSITION %D;', [tbl, lbFields.Items[cou], cou + 1]);
    end;
    ExecuteOnTheFly(DatabaseNode, 'Reordering Fields of "' + tbl + '"', sql, [dsesItIsScript, dsesExecuteAfterShow]);
  end;
end;

procedure TdmMainModule.miTriggerActivateClick(Sender: TObject);
var
  trig: TDObjectNode;
  trigName, Sql: String;
  few: TFrmEditorWindow;

begin
  if (not Assigned(FrmDSqlMain.TreeView1.Selected)) or
    (not(TObject(CurrentPopUpObject) is TDTypedObjectNode)) then
    Exit;
  trig := TDObjectNode(TObject(CurrentPopUpObject));
  if not (trig.NodeSqlObjectType in [dntTriggerActive, dntTriggerInactive]) then
    Exit;

  trigName := trig.ObjectName;
  if trigName <> UpperCase(trigName) then
    trigName := '"' + trigName + '"';
  if Sender = miTriggerActivate then
    Sql := 'ALTER TRIGGER ' + trigName + ' ACTIVE;'
  else
    Sql := 'ALTER TRIGGER ' + trigName + ' INACTIVE;';
  if ExecuteOnTheFly(trig.DatabaseNode, TMenuItem(Sender).Caption, Sql, [dsesExecuteAfterShow]) = mrOK then
    trig.DatabaseNode.RetriveMetaData([drmdTriggers]);
end;

procedure TdmMainModule.miTriggerAlterClick(Sender: TObject);
var
  trig: TDObjectNode;
begin
  trig := TDObjectNode(TObject(CurrentPopUpObject));
  ExecuteOnEditor(trig.DatabaseNode, 'Trig ' + trig.ExactName+ ' DDL', trig.DatabaseNode.RetriveTriggerBody(trig.ExactName), []);
end;

procedure TdmMainModule.miTriggerCommentOutCodeClick(Sender: TObject);
var
  trig: TDObjectNode;
  trigSrc, trigSrcL: String;
  bp, ep: SizeInt;
begin
  trig := TDObjectNode(TObject(CurrentPopUpObject));
  trigSrc := trig.DatabaseNode.RetriveTriggerBody(trig.ExactName);
  trigSrcL := LowerCase(trigSrc);
  bp := UTF8Pos('begin', trigSrcL);
  ep := UTF8RPos('end', trigSrcL);
  Insert(LineEnding + '/*', trigSrc, bp + 5);
  Insert(LineEnding + '*/', trigSrc, Length(trigSrc) - 3);
  ExecuteOnEditor(trig.DatabaseNode, 'Trig ' + trig.ExactName+ ' DDL', trigSrc, []);
end;

procedure TdmMainModule.pmDatabasePopup(Sender: TObject);
var
  DI: TDDatabaseNode;
begin
  DI := TDDatabaseNode(CurrentPopUpObject);
  miDBConnect.Enabled := not DI.Connected;
  miDBDisconnect.Enabled := DI.Connected;
  miDBNewQuery.Enabled := DI.Connected;
  miDBRefreshMeta.Enabled := DI.Connected;
  miDBDelete.Enabled := not DI.Connected;
end;

procedure TdmMainModule.pmEditorPopup(Sender: TObject);
begin
  if Assigned(DFrames.CurrentEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    miEditorCopy.Enabled := synSqlEditor.SelStart <> synSqlEditor.SelEnd;
    miEditorCut.Enabled := miEditorCopy.Enabled and (not synSqlEditor.ReadOnly);
    miEditorSelectAll.Enabled := synSqlEditor.Text <> '';
    miEditorPaste.Enabled := synSqlEditor.CanPaste and (not synSqlEditor.ReadOnly);
    //miEditorCreateNewView.Enabled := qTrans.Active and
    //  (qQuery.QSelect.SQLStatementType in [SQLExecProcedure, {SQLSelectForUpdate,}SQLSelect]);
    miEditorCreateNewView.Enabled := qTrans.InTransaction and
      (qQuery.StatementType in [stExecProcedure, {stSelectForUpdate,}stSelect]);
  end;
end;

procedure TdmMainModule.pmIndexPopup(Sender: TObject);
var
  tg: TDTypedObjectNode;
begin
  tg := TDTypedObjectNode(CurrentPopUpObject);
  miIndexReactivate.Caption := 'Reactivate  "' + tg.ObjectName + '"';
  miIndexActivate.Visible := False;
  miIndexDeactivate.Visible := False;
  case tg.NodeSqlObjectType of
    dntIndexActive:
      begin
        miIndexDeactivate.Visible := True;
        miIndexDeactivate.Caption := 'Deactivate "' + tg.ObjectName + '"';
      end;
    dntIndexInActive:
      begin
        miIndexActivate.Visible := True;
        miIndexActivate.Caption := 'Activate "' + tg.ObjectName + '"';
      end;
  end;
end;

procedure TdmMainModule.pmPopupClose(Sender: TObject);
begin
  ReleaseStandardMneuItems;
end;

procedure TdmMainModule.pmTablePopup(Sender: TObject);
begin
  AssignStandarsMenuItems(CurrentPopUpMenu);
end;

procedure TdmMainModule.pmTriggerPopup(Sender: TObject);
var
  tg: TDTypedObjectNode;
begin
  tg := TDTypedObjectNode(CurrentPopUpObject);
  miTriggerActivate.Visible := False;
  miTriggerDeactivate.Visible := False;
  miTriggerAlter.Caption := 'Alter "' + tg.ExactName + '"';
  miTriggerCommentOutCode.Caption := 'Comment out "' + tg.ExactName + '" code';
  case tg.NodeSqlObjectType of
    dntTriggerActive:
      begin
        miTriggerDeactivate.Visible := True;
        miTriggerDeactivate.Caption := 'Deactivate "' + tg.ExactName + '"';
      end;
    dntTriggerInactive:
      begin
        miTriggerActivate.Visible := True;
        miTriggerActivate.Caption := 'Activate "' + tg.ExactName + '"';
      end;
  end;
end;

procedure TdmMainModule.miTabClick(Sender: TObject);
begin
  FrmDSqlMain.PageControl1.PageIndex := TMenuItem(Sender).Tag;
end;

procedure TdmMainModule.miSqlObjectDropClick(Sender: TObject);
var
  ToRetrive: TDRetriveMetaData;
  Parent, Obj: TDDatabaseObjectNode;
  DropSql: String;
begin
  Parent := TDDatabaseObjectNode(CurrentPopUpObject.Node.Parent.Data);
  Obj := TDDatabaseObjectNode(CurrentPopUpObject);
  case Obj.NodeSqlObjectType of
    dntTable:
      begin
        ToRetrive := [drmdTables];
        DropSql := 'DROP TABLE ' + Obj.ExactName + ';';
      end;
    dntTablePmKey,
      dntTableFgKey,
      dntTableField,
      dntTableComtd:
      begin
        ToRetrive := [drmdTables];
        DropSql := 'ALTER TABLE ' + Parent.ExactName + ' DROP ' + Obj.ExactName + ';';
      end;
    dntProcedure:
      begin
        ToRetrive := [drmdProcedures];
        DropSql := 'DROP STORED PROCEDURE ' + Obj.ExactName + ';';
      end;
    dntSequence:
      begin
        ToRetrive := [drmdSequences];
        DropSql := 'DROP SEQUENCE ' + Obj.ExactName + ';';
      end;
    dntView:
      begin
        ToRetrive := [drmdViews];
        DropSql := 'DROP VIEW ' + Obj.ExactName + ';';
      end;
    dntException:
      begin
        ToRetrive := [drmdExceptions];
        DropSql := 'DROP EXCEPTION ' + Obj.ExactName + ';';
      end;
    dntUserDFunction:
      begin
        ToRetrive := [drmdUserDFunctions];
        DropSql := 'DROP EXTERNAL FUNCTION ' + Obj.ExactName + ';'
      end;
    dntFunction:
      begin
        ToRetrive := [drmdFunctions];
        DropSql := 'DROP FUNCTION ' + Obj.ExactName + ';'
      end;
    dntDomain:
      begin
        ToRetrive := [drmdDomains];
        DropSql := 'DROP DOMAIN ' + Obj.ExactName + ';'
      end;
    dntTriggerActive,
    dntTriggerInactive:
      begin
        ToRetrive := [drmdTriggers];
        DropSql := 'DROP TRIGGER ' + Obj.ExactName + ';'
      end;
    dntIndexActive,
    dntIndexInActive:
      begin
        ToRetrive := [drmdIndices];
        DropSql := 'DROP INDEX ' + Obj.ExactName + ';'
      end;
  end;
  if ExecuteOnTheFly(TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode, TMenuItem(Sender).Caption, DropSql, [dsesExecuteAfterShow, dsesItIsScript]) = mrOK then
    TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode.RetriveMetaData(ToRetrive);
end;

procedure TdmMainModule.miSqlCommentClick(Sender: TObject);
var
  ToRetrive: TDRetriveMetaData;
  Parent, Obj: TDDatabaseObjectNode;
  CommentSql, Comment: String;
begin
  Parent := TDDatabaseObjectNode(CurrentPopUpObject.Node.Parent.Data);
  Obj := TDDatabaseObjectNode(CurrentPopUpObject);
  case Obj.NodeSqlObjectType of
    dntTablePmKey,
    dntTableFgKey,
    dntTableField,
    dntTableComtd,
    dntProcedureParams,
    dntFunctionArguments,
    dntUserDFunctionArguments:
      FrmComment.Panel2.Caption := 'Comment On ' + Parent.ExactName + '.' + Obj.ExactName;
    else
      FrmComment.Panel2.Caption := 'Comment On ' + Obj.ExactName;
  end;

  FrmComment.Caption := 'Comment On' + Obj.ExactName;
  FrmComment.Panel2.Caption := 'Comment text:';
  FrmComment.mmComment.Text := Obj.Hint;
  if not(FrmComment.ShowModal = mrOK) then
    Exit
  else
    Comment := FrmComment.GetComment;
  case Obj.NodeSqlObjectType of
    dntTable:
      begin
        ToRetrive := [drmdTables];
        CommentSql := 'COMMENT ON TABLE ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntTablePmKey,
    dntTableFgKey,
    dntTableField,
    dntTableComtd:
      begin
        ToRetrive := [drmdTables];
        CommentSql := 'COMMENT ON COLUMN ' + Parent.ExactName + '.' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntProcedure:
      begin
        ToRetrive := [drmdProcedures];
        CommentSql := 'COMMENT ON PROCEDURE ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntSequence:
      begin
        ToRetrive := [drmdSequences];
        CommentSql := 'COMMENT ON SEQUENCE ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntUserDFunctionArguments,
    dntFunctionArguments,
    dntProcedureParams:
      begin
        CommentSql := 'COMMENT ON PARAMETER ' + Parent.ExactName + '.' + Obj.ExactName + ' IS ' + Comment + ';';
        case Obj.NodeSqlObjectType of
          dntUserDFunctionArguments:
            ToRetrive := [drmdUserDFunctions];
          dntFunctionArguments:
            ToRetrive := [drmdFunctions];
          dntProcedureParams:
            ToRetrive := [drmdProcedures];
        end;
      end;
    dntView:
      begin
        ToRetrive := [drmdViews];
        CommentSql := 'COMMENT ON VIEW ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntException:
      begin
        ToRetrive := [drmdExceptions];
        CommentSql := 'COMMENT ON EXCEPTION ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntUserDFunction:
      begin
        ToRetrive := [drmdUserDFunctions];
        CommentSql := 'COMMENT ON EXTERNAL FUNCTION ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntFunction:
      begin
        ToRetrive := [drmdFunctions];
        CommentSql := 'COMMENT ON FUNCTION ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntDomain:
      begin
        ToRetrive := [drmdDomains];
        CommentSql := 'COMMENT ON DOMAIN ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntTriggerActive,
    dntTriggerInactive:
      begin
        ToRetrive := [drmdTriggers];
        CommentSql := 'COMMENT ON TRIGGER ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
    dntIndexActive,
    dntIndexInActive:
      begin
        ToRetrive := [drmdIndices];
        CommentSql := 'COMMENT ON INDEX ' + Obj.ExactName + ' IS ' + Comment + ';';
      end;
  end;
  if ExecuteOnTheFly(TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode, TMenuItem(Sender).Caption, CommentSql, [dsesExecuteAfterShow, dsesItIsScript]) = mrOK then
    TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode.RetriveMetaData(ToRetrive);
end;

procedure TdmMainModule.miSqlObjectDependClick(Sender: TObject);
begin
  //Wooooha
end;

procedure TdmMainModule.TabsChanged;
var
  citms, nitms, Cou: Integer;
begin
  if (FrmDSqlMain.PageControl1.PageCount > 1){ and (FrmDSqlMain.PageControl1.ActivePage.TabIndex > 0)} then
  begin
    //DriteLn(FrmDSqlMain.PageControl1.ActivePage.PageIndex);
    Application.ProcessMessages;
    FrmDSqlMain.PageControl1.ActivePage.SetFocus;
    for Cou := 0 to FrmDSqlMain.PageControl1.PageCount - 1 do
      if FrmDSqlMain.PageControl1.Pages[Cou].Controls[0] is TdframBase then
        case (FrmDSqlMain.PageControl1.Pages[Cou].TabIndex = FrmDSqlMain.PageControl1.ActivePage.TabIndex) of
          True: TdframBase(FrmDSqlMain.PageControl1.Pages[Cou].Controls[0]).Entering;
          False: TdframBase(FrmDSqlMain.PageControl1.Pages[Cou].Controls[0]).Exiting;
        end;

  end;
  citms := Length(TabsMenuItems);
  nitms := FrmDSqlMain.PageControl1.PageCount;
  //if Length(TabsMenuItems) > 0 then
  //begin
    //-4 : 3 Items Fixed and 1 for (Count - 1)
    for Cou := 0 to pmTabControl.Items.Count  -1 do
    begin
      pmTabControl.Items.Delete(0);
    end;
    //for Cou := 0 to pmTabControl.Items.Count - 4 do
    //begin
    //  WriteLn(pmTabControl.Items.Items[Cou].Caption);
    //  pmTabControl.Items.Delete(0);
    //end;
    if citms < nitms then
    begin
      SetLength(TabsMenuItems, nitms);
      for Cou := citms to nitms - 1 do
        TabsMenuItems[Cou] := TMenuItem.Create(FrmDSqlMain);
    end
    else//citms > nitms
    begin
      for Cou := citms - 1 downto nitms do
        FreeAndNil(TabsMenuItems[Cou]);
      SetLength(TabsMenuItems, nitms);
    end;
  //end;
  for Cou := nitms - 1 downto 0 do
  begin
    TabsMenuItems[Cou].OnClick := @miTabClick;
    //pmTabControl.Items.Insert(0, TabsMenuItems[Cou]);
  end;
end;

procedure TdmMainModule.TabsPopup(aIndex: Integer);
var
  Cou, citms, ctabi: Integer;
  ctab: String;
begin
  citms := Length(TabsMenuItems);
  ctabi := aIndex;//FrmDSqlMain.PageControl1.PageIndex;
  for Cou := citms - 1 downto 0 do
  begin
    if Cou = ctabi then
    begin
      ctab := FrmDSqlMain.PageControl1.Pages[Cou].Caption;
      TabsMenuItems[Cou].Caption := '[ ' + ctab + ' ]';
      TabsMenuItems[Cou].Checked := True;
      TabsMenuItems[Cou].Tag := Cou;
      miCloseTabExcept.Caption := 'Close all except "' + ctab + '"';
    end
    else
    begin
      TabsMenuItems[Cou].Caption := FrmDSqlMain.PageControl1.Pages[Cou].Caption;
      TabsMenuItems[Cou].Checked := False;
    end;
  end;
  miCloseTab.Caption := 'Close "' + ctab + '"';
  miCloseTabExcept.Visible := citms > 1;
  miCloseTabSeprator.Visible := citms > 0;
  TabToClose := ctabi;
  for Cou := 0 to pmTabControl.Items.Count - 1 do
    pmTabControl.Items.Delete(0);
  pmTabControl.Items.Add(TabsMenuItems);
  pmTabControl.Items.Add(miCloseTabSeprator);
  pmTabControl.Items.Add(miCloseTab);
  pmTabControl.Items.Add(miCloseTabExcept);
  pmTabControl.PopUp;
end;

procedure TdmMainModule.AddDatabase(AServerNode: TDServerNode; AAlias, ADatabaseName, ACharSet: String);
var
  ConfFl: TStringList;
  Confs, JSrv, JDB: TDJSON;
  dbsNode: TTreeNode;
  dbs: TDDatabaseNode;
begin
  try
    ConfFl := TStringList.Create;
    Confs := Nil;
    if FileExists(DFrames.ConfigPath + c_config_file) then
    begin
      ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
      Confs := ParseJSON(PChar(ConfFl.Text));
    end;
    if not Assigned(Confs) then
    begin
      raise Exception.Create('It`s seems Config file missed or currupted!');
      //Confs := TDJSONObject.Create('root');
    end;
    //else
    //  Servers := Confs['Servers'].ThisArray;
    dbsNode := FrmDSqlMain.TreeView1.Items.AddChild(AServerNode.Node, '');
    JSrv := Confs['Servers'][AServerNode.Index];
    if not JSrv.ExistsProperty('Databases') then
       Confs['Servers'][AServerNode.Index]['Databases'].InitAsArray;
    dbs := TDDatabaseNode.Create(
      AAlias,
      ADatabaseName,
      ACharSet,
      '', JSrv['Databases'].Count, dbsNode
    );
    dbsNode.Data := Pointer(dbs);
    JDB := JSrv['Databases'][JSrv['Databases'].Count].InitAsObject;
    JDB['Title'].AsString := dbs.Caption;
    JDB['DatabaseName'].AsString := dbs.DatabaseName;
    JDB['CharSet'].AsString := dbs.CharSet;
    ConfFl.Text := Confs.TO_JSONString(0, True);
    ConfFl.SaveToFile(DFrames.ConfigPath + c_config_file);
  finally
    if Assigned(Confs) then
      FreeAndNil(Confs);
    FreeAndNil(ConfFl);
  end;
end;

function TdmMainModule.ExecuteOnTheFly(DatabaseNode: TDDatabaseNode; Title, Sql: String; ShowState: TDSqlDFrameshowState): TModalResult;
var
  few: TFrmEditorWindow;
begin
  Result := mrCancel;
  few := TFrmEditorWindow.Create(Application, DatabaseNode);
  try
    with few do
    begin
      Editor.Title := Title;
      Editor.SetSql(Sql);
      Editor.actSqlScript.Checked := dsesItIsScript in ShowState;
      Editor.actSqlScriptAutoDDl.Checked := dsesItIsScriptAutoDDL in ShowState;
      Editor.ExecuteOnShow := dsesExecuteAfterShow in ShowState;
      Result := ShowModal;
    end;
  finally
    FreeAndNil(few);
  end;
end;

procedure TdmMainModule.ExecuteOnEditor(DatabaseNode: TDDatabaseNode; Title, Sql: String; ShowState: TDSqlDFrameshowState);
var
  Editor: TdframEditor;
begin
  if CurrentPopUpScop = FrmDSqlMain then
  begin
    Editor := TdframEditor.Create(FrmDSqlMain, DatabaseNode);
    Editor.actSqlScript.Checked := dsesItIsScript in ShowState;
    Editor.ExecuteOnShow := dsesExecuteAfterShow in ShowState;
    Editor.Title := Title;
    Editor.SetSql(Sql);
    FrmDSqlMain.ShowUP(Editor, Editor.Caption);
    //Editor.synSqlEditor.SetFocus;
  end
  else
    ExecuteOnTheFly(DatabaseNode, Title, Sql, ShowState);
end;

procedure TdmMainModule.miSrvServerPropertiesClick(Sender: TObject);
var
  SI: TDServerNode;
  ConfFl: TStringList;
  Confs, JSrv: TDJSON;
  Servers: TDJSON;
begin
  with TFrmServerProperties.Create(Application) do
  begin
    Caption := 'Server Properties (Edit)';
    SI := TDServerNode(CurrentPopUpObject);
    cbServerType.ItemIndex := Ord(SI.MachineType);
    cbServerTypeChange(nil);
    edTitle.Text := SI.Caption;
    edAddress.Text := SI.ServerAddress;
    edPort.Text := SI.ServerPort;
    feClientLibrary.Text := SI.LibName;
    dePath.Text := SI.LibPath;
    chbCustomTmpDir.Checked := SI.TmpDir <> '';
    deTmpDir.Directory := SI.TmpDir;
    chbCustomLockDir.Checked := SI.LockDir <> '';
    deLockDir.Directory := SI.LockDir;
    if ShowModal = mrOK then
    begin
      if {
       (edTitle.Text <> SI.Caption) or
          (edAddress.Text <> SI.ServerAddress)
      } True then
      begin
        ConfFl := TStringList.Create;
        Confs := Nil;
        try
          if FileExists(DFrames.ConfigPath + c_config_file) then
          begin
            ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
            Confs := ParseJSON(PChar(ConfFl.Text));
          end;
          if not Assigned(Confs) then
          begin
            Confs := TDJSON.Create;
            Servers := Confs['Servers'].InitAsArray;
          end
          else
            Servers := Confs['Servers'];
          JSrv := Servers[SI.Index];
          JSrv['Title'].AsString := edTitle.Text;
          JSrv['Type'].AsString := cbServerType.Text;
          JSrv['Address'].AsString := edAddress.Text;
          JSrv['Port'].AsString := edPort.Text;
          JSrv['Library'].AsString := feClientLibrary.FileName;
          JSrv['LibPath'].AsString := dePath.Directory;
          JSrv['TmpDir'].AsString := deTmpDir.Directory;
          JSrv['LockDir'].AsString := deLockDir.Directory;
          SI.Caption := edTitle.Text;
          SI.ServerAddress := edAddress.Text;
          SI.MachineType := TDServerType(cbServerType.ItemIndex);
          SI.ServerPort := edPort.Text;
          SI.LibName := feClientLibrary.Text;
          SI.LibPath := dePath.Text;
          SI.LockDir := deLockDir.Directory;
          SI.TmpDir := deTmpDir.Directory;

          ConfFl.Text := Confs.TO_JSONString(0, True);
          ConfFl.SaveToFile(DFrames.ConfigPath + c_config_file);
          FreeAndNil(Confs);
        finally
          if Assigned(Confs) then
            FreeAndNil(Confs);
          FreeAndNil(ConfFl);
        end;
      end;
    end;
    Free;
  end;
end;

procedure TdmMainModule.miEditorCopySqlCode_PascalClick(Sender: TObject);
var
  Text, tx: String;
  Clip: TStringList;
begin
  if Assigned(DFrames.CurrentEditor) and (DFrames.CurrentEditor is TdframEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    Text := synSqlEditor.SelText;
    if Text.IsEmpty then
      Text := synSqlEditor.Text;
    Clip := TStringList.Create;
    Clip.Text := Text;
    Text := '';
    for tx in Clip do
    begin
      if Text <> '' then
        Text += ' + LineEnding +' + LineEnding;
      Text += '''' + ReplaceStr(tx, '''', '''''') + '''';
    end;
    Text += ';';
    Clipboard.AsText := Text;
  end;
end;

procedure TdmMainModule.miTableCopyTableWizardClick(Sender: TObject);
begin
  FrmCopyTable.DatabaseNode := TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode;
  FrmCopyTable.TableNode := TDObjectNode(CurrentPopUpObject);
  FrmCopyTable.ShowModal;
end;

procedure TdmMainModule.miEditorCreateNewViewClick(Sender: TObject);
var
  Sql, Fields: String;
  cou: Integer;
begin
  if Assigned(DFrames.CurrentEditor) and (DFrames.CurrentEditor is TdframEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    //if qQuery.QSelect.SQLStatementType in [SQLExecProcedure, {SQLSelectForUpdate,}SQLSelect] then
    if qQuery.StatementType in [stExecProcedure, {stSelectForUpdate,}stSelect] then
    begin
      Sql := 'CREATE VIEW NEW_VIEW_NAME_HERE(' + LineEnding;
      Fields := '';
      //for cou := 0 to qQuery.Fields.Count - 1 do
      for cou := 0 to qQuery.Fields.FieldCount - 1 do
      begin
        if Fields <> '' then
          Fields += ',' + LineEnding;
        //Fields += DFrames.Indent(1) + qQuery.Fields.Fields[cou].FieldName;
        Fields += DFrames.Indent(1) + qQuery.Fields.AliasName[cou];
      end;
      Fields += ')' + LineEnding;
      Sql += Fields + 'AS' + LineEnding;
      Fields := '';
      for cou := 0 to qQuery.SQL.Count - 1 do
      begin
        if Fields <> '' then
          Fields += LineEnding;
        Fields += DFrames.Indent(1) + qQuery.SQL[cou].TrimRight;
      end;
      if Fields[Fields.Length] <> ';' then
        Fields += ';';
      Sql += Fields;
      ExecuteOnEditor(DatabaseNode, 'New View', Sql, []);
    end;
  end;
end;

procedure TdmMainModule.miIndexReactivateClick(Sender: TObject);
var
  idx: TDObjectNode;
  idxName, Sql: String;
  few: TFrmEditorWindow;

begin
  if (not Assigned(FrmDSqlMain.TreeView1.Selected)) or
    (not(TObject(CurrentPopUpObject) is TDTypedObjectNode)) then
    Exit;
  idx := TDObjectNode(TObject(CurrentPopUpObject));
  if not (idx.NodeSqlObjectType in [dntIndexActive, dntIndexInActive]) then
    Exit;

  idxName := idx.ObjectName;
  if idxName <> UpperCase(idxName) then
    idxName := '"' + idxName + '"';
  if (Sender = miIndexActivate) or (Sender = miIndexReactivate) then
    Sql := 'ALTER INDEX ' + idxName + ' ACTIVE;'
  else
    Sql := 'ALTER INDEX ' + idxName + ' INACTIVE;';
  if ExecuteOnTheFly(idx.DatabaseNode, TMenuItem(Sender).Caption, Sql, [dsesExecuteAfterShow]) = mrOK then
    idx.DatabaseNode.RetriveMetaData([drmdIndices]);
end;

procedure TdmMainModule.DataModuleCreate(Sender: TObject);
begin
  //SynSQLSynMain.IdentChars := SynSQLSynMain.IdentChars + '$';
  miCloseTabSeprator := TMenuItem.Create(FrmDSqlMain);
  miCloseTabSeprator.Caption := '-';
  miCloseTab := TMenuItem.Create(FrmDSqlMain);
  miCloseTab.OnClick := @miTabCloseClick;
  miCloseTab.Caption := 'Close';
  miCloseTabExcept := TMenuItem.Create(FrmDSqlMain);
  miCloseTabExcept.OnClick := @miTabCloseClick;
  miCloseTabExcept.Caption := 'Close Except';
  miSqlObjectSeprator := TMenuItem.Create(FrmDSqlMain);
  miSqlObjectSeprator.Caption := '-';
  miSqlObjectDrop := TMenuItem.Create(FrmDSqlMain);
  miSqlObjectDrop.OnClick := @miSqlObjectDropClick;
  miSqlObjectComment := TMenuItem.Create(FrmDSqlMain);
  miSqlObjectComment.OnClick := @miSqlCommentClick;
  miSqlObjectDepend := TMenuItem.Create(FrmDSqlMain);
  miSqlObjectDepend.OnClick := @miSqlObjectDependClick;
end;

procedure TdmMainModule.MenuItem16Click(Sender: TObject);
begin
  with TDFrmDomain.Create(Application, TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode) do
  begin
    try
      if ShowModal = mrOK then
      if ExecuteOnTheFly(TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode, TMenuItem(Sender).Caption, SqlCode, [dsesItIsScript, dsesItIsScriptAutoDDL]) = mrOK then
        TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode.RetriveMetaData([drmdDomains]);
    finally
      Free;
    end;
  end;
end;

procedure TdmMainModule.MenuItem2Click(Sender: TObject);
begin
  DFrmSettings.ShowModal;
end;

procedure TdmMainModule.MenuItem3Click(Sender: TObject);
begin
  with TDFrmAbout.Create(Application) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TdmMainModule.miDBBackupClick(Sender: TObject);
begin
  //DB Backup
  frmFBBackup.DatabaseNode := TDDatabaseNode(CurrentPopUpObject);
  frmFBBackup.ShowModal;
end;

procedure TdmMainModule.miDbRestoreClick(Sender: TObject);
begin
  //DB Restore
end;

procedure TdmMainModule.miExceptionAlterClick(Sender: TObject);
var
  ToRetrive: TDRetriveMetaData;
  Parent, Obj: TDDatabaseObjectNode;
  ExceptionsSql, ExceptText: String;
begin
  Parent := TDDatabaseObjectNode(CurrentPopUpObject.Node.Parent.Data);
  Obj := TDDatabaseObjectNode(CurrentPopUpObject);

  FrmComment.Caption := 'Alter Exception ' + Obj.ExactName;
  FrmComment.Panel2.Caption := 'Exception text:';
  FrmComment.mmComment.Text :=  Obj.DatabaseNode.RetriveExceptionText(Obj.ExactName); //Obj.Hint;
  if not(FrmComment.ShowModal = mrOK) then
    Exit
  else
    ExceptText := FrmComment.GetComment;

  ToRetrive := [drmdExceptions];
  ExceptionsSql := 'ALTER EXCEPTION ' + Obj.ExactName + ExceptText + ';';
  if ExecuteOnTheFly(TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode, TMenuItem(Sender).Caption, ExceptionsSql, [dsesExecuteAfterShow, dsesItIsScript]) = mrOK then
    TDDatabaseObjectNode(CurrentPopUpObject).DatabaseNode.RetriveMetaData(ToRetrive);
end;

procedure TdmMainModule.miViewAlterDDLClick(Sender: TObject);
var
  viw: TDObjectNode;
  Code: String;
begin
  viw := TDObjectNode(TObject(CurrentPopUpObject));
  Code :=
    'ALTER VIEW ' + viw.ExactName + ' AS' + LineEnding;{ + '(' + LineEnding ;
  for cou := 0 to Length(viw.Fields) - 1 do}
  Code += viw.DatabaseNode.RetriveViewBody(viw.ExactName);
  ExecuteOnEditor(viw.DatabaseNode, 'View ' + viw.ExactName+ ' DDL', Code, []);
end;

procedure TdmMainModule.miDBDeleteClick(Sender: TObject);
var
  DBNodeI: TDDatabaseNode;
  ConfFl: TStringList;
  Confs, JSrv: TDJSON;
  SrvNodeI: TDServerNode;
begin
  DBNodeI := TDDatabaseNode(CurrentPopUpObject);
  if MessageDlg('Delete Database Reistration',
    'Are you sure to remove database "' + DBNodeI.Caption +
    '" registration?', mtConfirmation, mbYesNo, 0) = mrNo then
    Exit;

  SrvNodeI := TDServerNode(DBNodeI.Node.Parent.Data);

  ConfFl := TStringList.Create;
  Confs := Nil;
  try
    if FileExists(DFrames.ConfigPath + c_config_file) then
    begin
      ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
      Confs := ParseJSON(PChar(ConfFl.Text));
    end;
    if not Assigned(Confs) then
    begin
      raise Exception.Create('It`s seems Config file missed or currupted!');
    end;
    JSrv := Confs['Servers'][SrvNodeI.Index]['Databases'][DBNodeI.Index];
    if Assigned(JSrv) then
    begin
      JSrv.Delete;
      DBNodeI.Node.Delete;
      ConfFl.Text := Confs.TO_JSONString(0, True);
      ConfFl.SaveToFile(DFrames.ConfigPath + c_config_file);
    end;
  finally
    if Assigned(Confs) then
      FreeAndNil(Confs);
    FreeAndNil(ConfFl);
  end;
end;

procedure TdmMainModule.miSequences_NewSequenseClick(Sender: TObject);
var
  vals: TStringArray;
  nvi64: Int64;
  Sql: String;
begin
  SetLength(vals, 2);
  vals[0] := 'SEQ_';
  vals[1] := '0';
  if InputQuery('New Sequence', ['New Sequence name', 'New Sequence value'], vals) then
  begin
    vals[0] := ExactSqlObjectName(vals[0], TDObjectNode(TObject(CurrentPopUpObject)).DatabaseNode);
    Sql := Format('CREATE GENERATOR %s;', [vals[0]]);
    if vals[1].TryToInt64(nvi64) then
      Sql += LineEnding + Format('SET GENERATOR %s TO %s;', [vals[0], vals[1]]);

    if ExecuteOnTheFly(TDObjectNode(TObject(CurrentPopUpObject)).DatabaseNode, TMenuItem(Sender).Caption, Sql, [dsesExecuteAfterShow, dsesItIsScript, dsesItIsScriptAutoDDL]) = mrOK then
      TDObjectNode(TObject(CurrentPopUpObject)).DatabaseNode.RetriveMetaData([drmdSequences]);
  end;
end;

procedure TdmMainModule.miSequense_SetValueClick(Sender: TObject);
var
  seq: TDObjectNode;
  seqName, Sql, newValue: String;
  few: TFrmEditorWindow;
  newValueI64: Int64;

begin
  if (not Assigned(FrmDSqlMain.TreeView1.Selected)) or
    (not(TObject(CurrentPopUpObject) is TDTypedObjectNode)) then
    Exit;
  seq := TDObjectNode(TObject(CurrentPopUpObject));
  if not (seq.NodeSqlObjectType in [dntSequence]) then
    Exit;

  seqName := seq.ExactName;
  newValue := '';
  repeat
    newValue := InputBox('Set Squence(Generator) value', 'Enter new sequence value:', seq.DatabaseNode.GetSequenceValue(seqName).ToString);
  until (newValue = '') or (newValue.TryToInt64(newValueI64));
  if newValue = '' then
    Exit;
  //Sql := Format(C_Sql_Sequence_Set_Value, [seqName, newValueI64]);
  Sql := 'SET GENERATOR ' + seqName + ' TO ' + newValue + ';';
  ExecuteOnTheFly(seq.DatabaseNode, TMenuItem(Sender).Caption, Sql, [dsesExecuteAfterShow]);
end;

procedure TdmMainModule.miSrvCreateDatabaseClick(Sender: TObject);
begin
  TDFrmCreateDatbase.CreateDatabase(TDServerNode(CurrentPopUpObject));
end;

procedure TdmMainModule.miSrvDeleteServerClick(Sender: TObject);
var
  ConfFl: TStringList;
  Confs, JSrv: TDJSON;
  SrvNodeI: TDServerNode;
begin
  SrvNodeI := TDServerNode(CurrentPopUpObject);
  if MessageDlg('Delete Server Reistration',
    'Are you sure to remove Server "' + SrvNodeI.Caption +
    '" registration and it`s registred databases?', mtConfirmation, mbYesNo, 0) = mrNo then
    Exit;

  ConfFl := TStringList.Create;
  Confs := Nil;
  try
    if FileExists(DFrames.ConfigPath + c_config_file) then
    begin
      ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
      Confs := ParseJSON(PChar(ConfFl.Text));
    end;
    if not Assigned(Confs) then
    begin
      raise Exception.Create('It`s seems Config file missed or currupted!');
    end;
    JSrv := Confs['Servers'][SrvNodeI.Index];
    if Assigned(JSrv) then
    begin
      //WriteLn(Confs.TO_JSONString(0, True));
      //WriteLn('----------------------');
      //WriteLn(JSrv.TO_JSONString(0, True));
      SrvNodeI.Node.Delete;
      JSrv.Delete;
      ConfFl.Text := Confs.TO_JSONString(0, True);
      //WriteLn('----------------------');
      //WriteLn(Confs.TO_JSONString(0, True));
      ConfFl.SaveToFile(DFrames.ConfigPath + c_config_file);
    end;

  finally
    if Assigned(Confs) then
      FreeAndNil(Confs);
    FreeAndNil(ConfFl);
  end;
end;
procedure TdmMainModule.miDBConnectClick(Sender: TObject);
begin
  FrmDSqlMain.FLockPopup := True;
  try
    try
      TDDatabaseNode(CurrentPopUpObject).Connect;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;       //sr2100-hd hyper
    end;
  finally
    FrmDSqlMain.FLockPopup := False;
  end;
end;

procedure TdmMainModule.miDBDisconnectClick(Sender: TObject);
begin
  FrmDSqlMain.FLockPopup := True;
  try
    TDDatabaseNode(CurrentPopUpObject).Disconnect;
  finally
    FrmDSqlMain.FLockPopup := False;
  end;
end;

procedure TdmMainModule.miDBNewQueryClick(Sender: TObject);
var
  Frame: TdframEditor;
begin
  if (not Assigned(FrmDSqlMain.TreeView1.Selected)) or
     (not(TObject(CurrentPopUpObject) is TDDatabaseNode)) then
    Exit;
  Frame := TdframEditor.Create(FrmDSqlMain, TDDatabaseNode(TDDatabaseNode(CurrentPopUpObject)));
  FrmDSqlMain.ShowUP(Frame, Frame.Caption);
  Frame.synSqlEditor.SetFocus;
end;

procedure TdmMainModule.miDBRefreshMetaClick(Sender: TObject);
begin
  if not TDDatabaseNode(CurrentPopUpObject).Connected then
    Exit;
  FrmDSqlMain.FLockPopup := True;
  try
    TDDatabaseNode(CurrentPopUpObject).RetriveMetaData([]);
  finally
    FrmDSqlMain.FLockPopup := False;
  end;
end;

procedure TdmMainModule.miStoredProcedureDDLEditClick(Sender: TObject);
var
  fn: TDObjectNode;
  Frame: TdframEditor;
  proc, ddl, params, returns: String;
  cou: Integer;
  par: TDTypedObjectNode;
begin
  if (not Assigned(FrmDSqlMain.TreeView1.Selected)) or
     (not(TObject(CurrentPopUpObject) is TDObjectNode)) then
    Exit;
  fn := TDObjectNode(TObject(CurrentPopUpObject));
  if fn.NodeSqlObjectType <> dntProcedure then
    Exit;
  Frame := TdframEditor.Create(FrmDSqlMain, fn.DatabaseNode);
  FrmDSqlMain.ShowUP(Frame, Frame.Caption);
  Frame.synSqlEditor.SetFocus;
  proc := '';
  if UpperCase(fn.ObjectName) <> fn.ObjectName then
    proc := '"' + fn.ObjectName + '"'
  else
    proc := fn.ObjectName;
  Frame.Title := 'StProc' + proc + ' DDL';
  ddl := 'CREATE OR ALTER PROCEDURE ' + proc + ' ';
  params := '';
  returns := '';
  for cou := 0 to Length(fn.Fields) - 1 do
  begin
    case PtrInt(fn.Fields[cou].ExData) of
      0:
        begin
          if params <> '' then
            params += ',' + LineEnding + '  ';
          par := fn.Fields[cou];
          if UpperCase(par.ObjectName) <> par.ObjectName then
            params += '"' + par.ObjectName + '"'
          else
            params += par.ObjectName;
          params += ' ' + ReplaceStr(par.ObjectType, '@', 'CHARACTER SET ');
        end;
      1:
        begin
          if returns <> '' then
            returns += ',' + LineEnding + '  ';
          par := fn.Fields[cou];
          if UpperCase(par.ObjectName) <> par.ObjectName then
            returns += '"' + par.ObjectName + '"'
          else
            returns += par.ObjectName;
          returns += ' ' + ReplaceStr(par.ObjectType, '@', 'CHARACTER SET ');
        end;
    end;
  end;
  if params <> '' then
    ddl += '(' + LineEnding + '  ' + params + ')' + LineEnding ;
  if returns <> '' then
    ddl += 'RETURNS ('+ LineEnding + '  ' + returns + LineEnding + ')';

  ddl +=  ' AS ' + LineEnding + fn.DatabaseNode.RetriveStoredProcedureBody(fn.ObjectName);
  Frame.SetSql(ddl);
end;

procedure TdmMainModule.miFunctionDDLEditClick(Sender: TObject);
var
  fn: TDObjectNode;
  Frame: TdframEditor;
  func, ddl, params: String;
  cou: Integer;
  par: TDTypedObjectNode;
begin
  if (not Assigned(FrmDSqlMain.TreeView1.Selected)) or
     (not(TObject(CurrentPopUpObject) is TDObjectNode)) then
    Exit;
  fn := TDObjectNode(TObject(CurrentPopUpObject));
  if fn.NodeSqlObjectType <> dntFunction then
    Exit;
  Frame := TdframEditor.Create(FrmDSqlMain, fn.DatabaseNode);
  FrmDSqlMain.ShowUP(Frame, Frame.Caption);
  Frame.synSqlEditor.SetFocus;
  func := '';
  if UpperCase(fn.ObjectName) <> fn.ObjectName then
    func := '"' + fn.ObjectName + '"'
  else
    func := fn.ObjectName;
  Frame.Title := 'Func' + func + ' DDL';
  ddl := 'CREATE OR ALTER FUNCTION ' + func;
  params := '';
  for cou := 1 to Length(fn.Fields) - 1 do
  begin
    if params <> '' then
      params += ',' + LineEnding + '  ';
    par := fn.Fields[cou];
    params += par.ExactName;
    params += ' ' + ReplaceStr(par.ObjectType, '@', 'CHARACTER SET ');
  end;
  if params <> '' then
    ddl += '(' + LineEnding + '  ' + params + ')' + LineEnding;
  Frame.SetSql(ddl + 'RETURNS ' + fn.Fields[0].ObjectType + LineEnding + 'AS ' + LineEnding + fn.DatabaseNode.RetriveFunctionBody(fn.ObjectName));
end;

procedure TdmMainModule.miEditorPastePascalStringClick(Sender: TObject);
var
  ClpTxt: TStringList;
  Cou, RPq: Integer;
  Str: String;
begin
  if Assigned(DFrames.CurrentEditor) and (DFrames.CurrentEditor is TdframEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    if not synSqlEditor.CanPaste then
      Exit;
    ClpTxt := TStringList.Create;
    ClpTxt.Text := Clipboard.AsText;
    for Cou := 0 to ClpTxt.Count - 1 do
    begin
      Str := ClpTxt[cou];
      RPq := RPos('''', Str);
      if RPq > 0 then
        Delete(Str, RPq, 1000);
      RPq := Pos('''', Str);
      if RPq > 0 then
        Delete(Str, 1, RPq);
      Str := ReplaceStr(Str, '''''', '''');
      ClpTxt[Cou] := Str;
    end;
    Clipboard.AsText := ClpTxt.Text;
    FreeAndNil(ClpTxt);
    synSqlEditor.PasteFromClipboard;
  end;
end;

procedure TdmMainModule.miSrvAddDatabaseClick(Sender: TObject);
var
  ConfFl: TStringList;
  Confs: TDJSON;
  Srv: TDServerNode;
  dbs: TDDatabaseNode;
  JSrv, JDB: TDJSON;
  dbsNode: TTreeNode;
begin
  with TFrmDatabseProperties.Create(Application) do
  begin
    Caption := 'Database Properties (Add|Register)';
    if ShowModal = mrOK then
    begin
      ConfFl := TStringList.Create;
      Confs := Nil;
      try
        if FileExists(DFrames.ConfigPath + c_config_file) then
        begin
          ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
          Confs := ParseJSON(PChar(ConfFl.Text));
        end;
        if not Assigned(Confs) then
        begin
          raise Exception.Create('It`s seems Config file missed or currupted!');
          //Confs := TDJSONObject.Create('root');
        end;
        //else
        //  Servers := Confs['Servers'].ThisArray;
        Srv := TDServerNode(CurrentPopUpObject);
        dbsNode := FrmDSqlMain.TreeView1.Items.AddChild(Srv.Node, '');
        JSrv := Confs['Servers'][Srv.Index];
        if not JSrv.ExistsProperty('Databases') then
           Confs['Servers'][Srv.Index]['Databases'].InitAsArray;
        dbs := TDDatabaseNode.Create(
          edTitle.Text,
          fneDatbaseName.FileName,
          edCharset.Text,
          '', JSrv['Databases'].Count, dbsNode
        );
        dbsNode.Data := Pointer(dbs);
        JDB := JSrv['Databases'][JSrv['Databases'].Count].InitAsObject;
        JDB['Title'].AsString := dbs.Caption;
        JDB['DatabaseName'].AsString := dbs.DatabaseName;
        JDB['CharSet'].AsString := dbs.CharSet;
        ConfFl.Text := Confs.TO_JSONString(0, True);
        ConfFl.SaveToFile(DFrames.ConfigPath + c_config_file);
      finally
        if Assigned(Confs) then
          FreeAndNil(Confs);
        FreeAndNil(ConfFl);
      end;

      //dbs := FrmDSqlMain.TreeView1.Items.AddChild(srv, '');
      //dbs.Data := Pointer(TDDatabaseNode.Create(
      //                edCharset.Text,
      //                fneDatbaseName.FileName,
      //                edTitle.Text, '',
      //                );
    end;
    Free;
  end;
end;

procedure TdmMainModule.miDBPropertiesClick(Sender: TObject);
var
  dbs: TDDatabaseNode;
  ConfFl: TStringList;
  Confs: TDJSON;
  JDB: TDJSON;
begin
  with TFrmDatabseProperties.Create(Application) do
  begin
    Caption := 'Database Properties (Edit)';
    dbs := TDDatabaseNode(CurrentPopUpObject);
    edTitle.Text := dbs.Caption;
    fneDatbaseName.FileName := dbs.DatabaseName;
    edCharset.Text := dbs.CharSet;
    if
        (ShowModal = mrOK)
      and
        ( (dbs.CharSet      <> edCharset.Text)
        or
          (dbs.DatabaseName <> fneDatbaseName.FileName)
        or
          (dbs.Caption      <> edTitle.Text))
    then
    begin
      dbs.CharSet      := edCharset.Text;
      dbs.DatabaseName := fneDatbaseName.FileName;
      dbs.Caption      := edTitle.Text;
      ConfFl := TStringList.Create;
      Confs := Nil;
      try
        if FileExists(DFrames.ConfigPath + c_config_file) then
        begin
          ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
          Confs := ParseJSON(PChar(ConfFl.Text));
        end;
        if not Assigned(Confs) then
        begin
          raise Exception.Create('It`s seems Config file missed or currupted!');
          //Confs := TDJSONObject.Create('root');
        end;
        //else
        //  Servers := Confs['Servers'].ThisArray;
        JDB := Confs['Servers'][dbs.ServerNode.Index]['Databases'][dbs.Index];
        JDB['Title'].AsString := dbs.Caption;
        JDB['DatabaseName'].AsString := dbs.DatabaseName;
        JDB['CharSet'].AsString := dbs.CharSet;
        ConfFl.Text := Confs.TO_JSONString(0, True);
        ConfFl.SaveToFile(DFrames.ConfigPath + c_config_file);
      finally
        if Assigned(Confs) then
          FreeAndNil(Confs);
        FreeAndNil(ConfFl);
      end;
    end;
    Free;
  end;
end;

procedure TdmMainModule.miEditorCopyClick(Sender: TObject);
begin
  if Assigned(DFrames.CurrentEditor) and (DFrames.CurrentEditor is TdframEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    synSqlEditor.CopyToClipboard;
  end;
end;

procedure TdmMainModule.miEditorCutClick(Sender: TObject);
begin
  if Assigned(DFrames.CurrentEditor) and (DFrames.CurrentEditor is TdframEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    synSqlEditor.CutToClipboard;
  end;
end;

procedure TdmMainModule.miEditorPasteClick(Sender: TObject);
begin
  if Assigned(DFrames.CurrentEditor) and (DFrames.CurrentEditor is TdframEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    synSqlEditor.PasteFromClipboard;
  end;
end;

procedure TdmMainModule.miDFrameselectAllClick(Sender: TObject);
begin
  if Assigned(DFrames.CurrentEditor) and (DFrames.CurrentEditor is TdframEditor) then
  with TdframEditor(DFrames.CurrentEditor) do
  begin
    synSqlEditor.SelectAll;
  end;
end;

function TdmMainModule.PopupSqlMenu(Node: TTreeNode; Scop: TDFrmBase): Boolean;
var
  NI: TDNodeInfo;
  PM: TPopupMenu;
begin
  if TDNodeInfo.LockPopup and (not Assigned(Node)) then
    Exit;
  NI := TDNodeInfo(Node.Data);
  PM := Nil;
  //WriteLn(Ord(NI.NodeSqlObjectType));
  case NI.NodeSqlObjectType of
    dntHome             : PM := pmHome;
    dntServer           : PM := pmServer;
    dntDatabase         : PM := pmDatabase;
    dntDomains          : PM := pmDomains;
    dntDomain           : PM := pmDomain;
    dntSequences        : PM := pmSequences;
    dntSequence         : PM := pmSequence;
    dntTables           : PM := pmTables;
    dntTable            : PM := pmTable;
    dntSysTable         : PM := pmSysTable;
    dntTablePmKey,
    dntTableFgKey,
    dntTableField,
    dntTableComtd       : PM := pmField;
    dntProcedures       : PM := pmStoredProcedures;
    dntProcedure        : PM := pmStoredProcedure;
    dntFunctions        : PM := pmFunctions;
    dntFunction         : PM := pmFunction;
    dntUserDFunctions   : PM := pmUDFunctions;
    dntUserDFunction    : PM := pmUDFunction;
    dntUserDFunctionArguments,
    dntFunctionArguments,
    dntProcedureParams  : PM := pmFnsProcsUDFs_Parameter;
    dntTriggers         : PM := pmTriggers;
    dntTriggerActive,
    dntTriggerInactive  : PM := pmTrigger;
    dntViews            : PM := pmViews;
    dntView             : PM := pmView;
    dntIndices          : PM := pmIndices;
    dntIndexActive,
    dntIndexInActive    : PM := pmIndex;
    dntExceptions       : PM := pmExceptions;
    dntException        : PM := pmException;
  end;
  if Assigned(PM) then
  with Mouse.CursorPos do
  begin
    dmMainModule.CurrentPopUpObject := NI;
    dmMainModule.CurrentPopUpMenu := PM;
    dmMainModule.CurrentPopUpScop := Scop;
    dmMainModule.AssignStandarsMenuItems(PM);
    PM.PopUp(X, Y);
  end;
  Result := True;
end;

end.

