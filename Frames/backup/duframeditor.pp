unit duframEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, SynPluginMultiCaret,
  SynEdit, SynHighlighterSQL, SynEditTypes, SynCompletion, LCLType, StdCtrls,
  Graphics, ComCtrls, DBGrids, ActnList,
  //IB, IBDatabase, IBSQL, IBQuery,
  //IBEvents, ibxscript, IBSQLMonitor, IBConnection, FBSQLData,
  sqldb, db, uibase, uib, uiblib, uibsqlparser, SynEditKeyCmds, SynExportHTML,
  SynGutterCodeFolding, SynEditHighlighter, IpHtml, Dialogs, Buttons,
  Grids, Menus, strutils, duTypes, duConsts, duLog, duDSqlNodes, duframFrame,
  Debio.Types, Debio.Utils, Types, Debio.Utils.Date, Debio.Utils.Files,
  Clipbrd, dufrmSettings, dufrmTransactionDecision,
  Debio.Utils.RunTime;

type

  TDColumnInfo = record
    Referenced: Boolean;
    Reference: String;
    FieldName: String;
  end;

  TDColumnsInfo = array of TDColumnInfo;

  { TdframEditor }

  TdframEditor = class(TdframBase)
    actCommit: TAction;
    actFindNex: TAction;
    actFindPervious: TAction;
    actExcuteSelection: TAction;
    actCopy: TAction;
    actHistoryPervious: TAction;
    actHistoryNext: TAction;
    actSqlScriptAutoDDl: TAction;
    actNewEditor: TAction;
    actSqlScript: TAction;
    actSaveAs: TAction;
    actOpen: TAction;
    actReplace: TAction;
    actFind: TAction;
    actRollback: TAction;
    actSave: TAction;
    actSqlGo: TAction;
    alActions: TActionList;
    edFind: TEdit;
    hpLog: TIpHtmlPanel;
    Label1: TLabel;
    dlgOpen: TOpenDialog;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem4: TMenuItem;
    miScriptSql: TMenuItem;
    miData_CopyAsWhereClause: TMenuItem;
    miCopyData_LineEndingLinux: TMenuItem;
    miCopyData_LineEndingMac: TMenuItem;
    miCopyData_LineEndingWindows: TMenuItem;
    miCopyData_TabSeprated: TMenuItem;
    miCopyData_SemicolonSeprated: TMenuItem;
    MenuItem3: TMenuItem;
    miCopyData_CopyTitles: TMenuItem;
    miData_Copy_Cells: TMenuItem;
    miCopyData_CommaSeprated: TMenuItem;
    miCopyDataOptions: TMenuItem;
    Panel1: TPanel;
    pnlFind: TPanel;
    pcPages: TPageControl;
    Panel2: TPanel;
    pmDataPopup: TPopupMenu;
    dlgSave: TSaveDialog;
    pmScriptSql: TPopupMenu;
    sbCloseFind: TSpeedButton;
    sbFindNext: TSpeedButton;
    sbFindPre: TSpeedButton;
    Splitter1: TSplitter;
    sgData: TStringGrid;
    saCompletion: TSynAutoComplete;
    sCompletion: TSynCompletion;
    stDataInfo: TLabel;
    synSqlEditor: TSynEdit;
    SynSQLSynMain: TSynSQLSyn;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton9: TToolButton;
    tsData: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    tbtnScript: TToolButton;      //Enter
    tsLog: TTabSheet;
    procedure actCommitExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actHistoryNextExecute(Sender: TObject);
    procedure actHistoryPerviousExecute(Sender: TObject);
    procedure actNewEditorExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSqlGoExecute(Sender: TObject);
    procedure actSqlScriptAutoDDlExecute(Sender: TObject);
    procedure actSqlScriptExecute(Sender: TObject);
    procedure edFindKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ibScriptErrorLog(Sender: TObject; Msg: string);
    procedure ibScriptOutputLog(Sender: TObject; Msg: string);
    procedure miData_CopyAsWhereClauseClick(Sender: TObject);
    procedure miData_Copy_CellsClick(Sender: TObject);

    procedure mmLogClick(Sender: TObject);
    procedure pmDataPopupPopup(Sender: TObject);
    procedure qQueryAfterClose(DataSet: TObject);
    procedure qQueryAfterOpen(DataSet: TDataSet);
    procedure qTransAfterTransactionEnd(Sender: TObject);
    procedure qTransStartTransaction(Sender: TObject);
    procedure sbCloseFindClick(Sender: TObject);
    procedure sbFindNextClick(Sender: TObject);
    procedure sbFindPreClick(Sender: TObject);
    procedure sCompletionExecute(Sender: TObject);
    procedure SQLQuery1dsRowNo1GetText(Sender: TField; var aText: string; DisplayText: Boolean);
    procedure sgDataSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
    procedure sgDataSelection(Sender: TObject; aCol, aRow: Integer);
    procedure sCompletionCodeCompletion(var Value: string; SourceValue: string; var SourceStart,
      SourceEnd: TPoint; KeyChar: TUTF8Char; Shift: TShiftState);

    function sCompletionPaintItem(const AKey: string; ACanvas: TCanvas; X,
      Y: integer; Selected: boolean; Index: integer): boolean;

    procedure sCompletionSearchPosition(var APosition: integer);
    procedure synSqlEditorChange(Sender: TObject);
    procedure synSqlEditorClickLink(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure synSqlEditorCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
    procedure synSqlEditorCutCopy(Sender: TObject; var AText: String; var AMode: TSynSelectionMode; ALogStartPos: TPoint; var AnAction: TSynCopyPasteAction);

    procedure synSqlEditorEnter(Sender: TObject);
    procedure synSqlEditorExit(Sender: TObject);

    procedure synSqlEditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure synSqlEditorKeyPress(Sender: TObject; var Key: char);
    procedure synSqlEditorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure synSqlEditorMouseLink(Sender: TObject; X, Y: Integer; var AllowMouseLink: Boolean);
    procedure synSqlEditorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
    Y: Integer);
    procedure synSqlEditorPaste(Sender: TObject; var AText: String; var AMode: TSynSelectionMode; ALogStartPos: TPoint; var AnAction: TSynCopyPasteAction);
    procedure synSqlEditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: integer; var ReplaceAction: TSynReplaceAction);
    procedure ToolButton13Click(Sender: TObject);
  private
    CompletionNameAlias: String;
    CompletionObject: TDObjectNode;
    //ExecCur: IResults;
    //ExecResults: TResults;
    //Controlling the aliases refresh
    FAliasTimeStamp: TDateTime;
    FetchCursor: Boolean;
    //Controlling the aliases refresh
    FModifiedTimeStamp: TDateTime;
    FExecuteOnShow: Boolean;
    fMultiCaret: TSynPluginMultiCaret;
    fTries: Integer;
    lastKey: Char;
    Variables: TStringList;
    Aliases: TStringList;
    AliasesSource: TStringList;
    FFileName: String;
    //RwColumnFiels: TLongintField;
    FLogging: Boolean;
    Fields: array of TField;
    Fetching: Boolean;
    FLinkPassed: Bool;
    FLinkObject: TDDatabaseObjectNode;
    FHistoryIndex: Integer;
    FLog: String;
    ColumnsInfo: TDColumnsInfo;
    FLogAttr: TDLogStyle;
    FGridAttr: TDGridStyle;
    function GetCurrentWord: String;
    procedure FilterCompList;

    procedure OnUIBScriptComment(sender: TObject; const comment: string; style: TCommentStyle);
    procedure OnUIBScriptExecError(Sender: TObject; Error: Exception; const SQLText: string; var Handled: Boolean);

    procedure OnUIBScriptParse(Sender: TObject; NodeType: TSQLStatement; const Statement: string);
    procedure OnUIBTransactionEnd(Sender: TObject; var Mode: TEndTransMode);
    procedure OnUIBTransactionStart(Sender: TObject);
    procedure RefreshDeclartions;
    procedure RefresAlias;
    function GetErorMessage(Msg: String): String;
    procedure CaretPos;

    function GetLines(APos: TPoint; RPos: Integer): String;

    function RepresentValueOfTextBlob(Val: String): String;

    procedure Fetch(fromFirst: Boolean = False);
    procedure CheckTransaction;
    procedure ShowLog;
    procedure ApplyGrid;
  public
    //ibScript: TIBXScript;
    //qQuery: TIBQuery;
    //qTrans: TIBTransaction;
    qQuery: TUIBQuery;
    qTrans: TUIBTransaction;
    Script: TUIBScript;

    property ExecuteOnShow: Boolean read FExecuteOnShow write FExecuteOnShow;
    procedure Showing; override;
    procedure Entering; override;
    procedure Exiting; override;
    function Leaving: Boolean; override;
    procedure SetSql(ASql: String);
    destructor Destroy; override;
    constructor Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode); override;
    procedure LogInfo(ALog: String);
    procedure LogDetail(ALog: String);
    procedure LogError(ALog: String);
    procedure CheckActions; virtual;
    procedure ConfigChanged; override;
    procedure MetaDataChanged; override;
  end;

implementation

uses dudmMainModule, duFrames;

{$R *.lfm}

var
  Counter: Integer = 1;

{ TdframEditor }

procedure TdframEditor.synSqlEditorEnter(Sender: TObject);
begin
  DFrames.EditorEntered(Self);
  //DatabaseNode.Connection.OnLog := @IBConnection1Log;
  //MonitorHook.RegisterMonitor(IBSQLMonitor1);
  CaretPos;
end;

function TdframEditor.sCompletionPaintItem(const AKey: string; ACanvas: TCanvas; X,
  Y: integer; Selected: boolean; Index: integer): boolean;
const
  LeftLeft = 70;
var

  stp: TDSqlWordtype;
  fcl, dtcl: TColor;
  colpos: SizeInt;
  txt, typ: String;
begin
  stp := TDSqlWordtype(PtrUInt(Pointer(sCompletion.ItemList.Objects[Index])));
  ACanvas.Brush.Color := synSqlEditor.Color;
  ACanvas.FillRect(x, y, x + LeftLeft, y + sCompletion.FontHeight);
  dtcl := SynSQLSynMain.DataTypeAttri.Foreground;
  case stp of
    dswtFunction: fcl := SynSQLSynMain.FunctionAttri.Foreground;
    dswtType: fcl := dtcl;
    dswtReserved: fcl := SynSQLSynMain.KeyAttri.Foreground;
    dswtTable,
    dswtSysTable,
    dswtView,
    dswtField,
    dswtProcedure,
    dswtSequense:
      fcl := SynSQLSynMain.TableNameAttri.Foreground;
    dswtReturns,
    dswtVariable,
    dswtParameter:
      fcl := SynSQLSynMain.VariableAttri.Foreground;
  end;
  ACanvas.Font.Color := fcl;

  ACanvas.TextOut(x + 2, y, c_DSqlWordtype[stp]);

  if Selected then
  begin
    ACanvas.Brush.Color := synSqlEditor.SelectedColor.Background;
    ACanvas.Font.Color := synSqlEditor.SelectedColor.Foreground;
  end
  else
    ACanvas.Font.Color := fcl;// synSqlEditor.Font.Color;

  ACanvas.FillRect(x + LeftLeft, y, x + sCompletion.TheForm.Width, y + sCompletion.FontHeight);
  colpos := Pos(':', AKey);
  if colpos > 0 then
  begin
    txt := Copy(AKey, 1, colpos + 2);
    typ := AKey;
    Delete(typ, 1, colpos + 2);
    ACanvas.TextOut(x + LeftLeft, y, txt);
    ACanvas.Font.Color := dtcl;
    ACanvas.TextOut(x + LeftLeft + ACanvas.TextWidth(txt), y, typ);
  end
  else
    ACanvas.TextOut(x + LeftLeft, y, AKey);
  Result := True;
end;

procedure TdframEditor.sCompletionSearchPosition(var APosition: integer);
begin
  FilterCompList;
  if sCompletion.ItemList.Count > 0 then
  begin
    APosition := 0;
    //if sCompletion.ItemList[0] = '*' then
    //  APosition := 1;
  end
  else
    APosition := -1;
end;

procedure TdframEditor.synSqlEditorChange(Sender: TObject);
begin
  CaretPos;
  FModifiedTimeStamp := Now();
end;

procedure TdframEditor.synSqlEditorClickLink(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //if Parent is TDFrmBase then
  //  Scop := TDFrmBase(Parent)
  //else
  //  Scop := TDFrmBase(TTabSheet(Parent).PageControl.Parent);
  if FLinkPassed then
  begin
    FLinkObject.Node.Selected := True;
    //dmMainModule.PopupSqlMenu(FLinkObject.Node, Scop);
  end;
  //begin
  //  case Button of
  //    mbLeft: FLinkObject.Node.Selected := True;
  //    mbRight: dmMainModule.PopupSqlMenu(FLinkObject.Node, Scop);
  //    mbMiddle: ;
  //  end;
  //end;
end;

procedure TdframEditor.synSqlEditorCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
begin
  CaretPos;
end;

procedure TdframEditor.synSqlEditorCutCopy(Sender: TObject; var AText: String; var AMode: TSynSelectionMode; ALogStartPos: TPoint; var AnAction: TSynCopyPasteAction);
begin
  FModifiedTimeStamp := Now();
end;

procedure TdframEditor.actSqlGoExecute(Sender: TObject);
const
  StmType : array [TStatementType] of String = ('Unknown', 'Select', 'Insert', 'Update', 'Delete',
    'DDL', 'GetSegment', 'PutSegment', 'ExecProcedure',
    'artTrans', 'Commit', 'Rollback', 'SelectForUpd');

  CUIBFieldType : array[TUIBFieldType] of String = (
    'UnKnown',
    'Numeric',
    'Char',
    'Varchar',
    'Cstring',
    'Smallint',
    'Integer',
    'Quad',
    'Float',
    'DoublePrecision',
    'Timestamp',
    'Blob',
    'BlobId',
    'Date',
    'Time',
    'Int64',
    'Array',
    'Boolean',
    'Null'
    );
  //perfs : array[TPerfStats] of String = ('CurrentMemory', 'psMaxMemory',
  //              'Real Time', 'User Time', 'Buffers',
  //              'Reads', 'Writes', 'Fetches', 'DeltaMemory');
var
  _Error_: Boolean;
  SQLText, sstats, finfo: String;
  Sc, Ic, Uc, Dc, mcou: Cardinal;
  std: IscStmtHandle;
  //stats: TPerfCounters;
  //cou: TPerfStats;
  //md: IMetaData;
  //mdd: IColumnMetaData;

begin

  if Sender = actSqlGo then
  begin
    SQLText := synSqlEditor.Text;
  end
  else
  begin
    SQLText := synSqlEditor.SelText;
  end;

  if SQLText.IsEmpty then
    Exit;

  SQLText := Trim(SQLText);

  //if qQuery.Active then
  //  qQuery.Close;
  //if not qTrans.Active then
  //  qTrans.StartTransaction;
  //qQuery.Close(); //No need in UIB
  //if qQuery.CurrentState in [qsExecImme, qsStatement, qsPrepare, qsExecute] then
  //  qQuery.Close(etmRollbackRetaining);
  //UIB Transactions is in AutoStarts mode
  //if not qTrans.Active then
  //  qTrans.StartTransaction;

  CheckTransaction;

  qQuery.SQL.Text := Trim(SQLText);

  pcPages.TabIndex := 0;
  tsData.Visible := False;
  stDataInfo.Visible := False;
  tsLog.Visible := True;
  _Error_ := False;
  if not actSqlScript.Checked then
  try
    try
      LogInfo('Preparing statement:''' + SQLText + '''');
      //
      qQuery.Prepare(False);
      //UIB have not prepapred, Instead raieses exception and ends.....
      //if qQuery.Prepared then
      //begin
        //DFrames.AddToHistory(qQuery.QSelect.SQL.Text);
        //WriteLn('Statement type: ', qQuery.StatementType);
        DFrames.AddToHistory(qQuery.SQL.Text);
        //qQuery.QSelect.Statement.EnableStatistics(True);
        //UIB have direct Statistics access
        LogDetail('Successed');
        //Panel1.Caption := StmType[qQuery.StatementType];
        case qQuery.StatementType of
        //SQLExecProcedure,
        //SQLSelectForUpdate,
        //SQLSelect:
        //UIB once:
        stSelect,
        stSelectForUpdate,
        stExecProcedure:
          begin
            tsLog.Visible := True;
            pcPages.TabIndex := 1;
            //LogLn(qQuery.QSelect.Statement.GetPlan);
            FetchCursor := False;
            //if qQuery.StatementType in [SQLSelectForUpdate, SQLSelect] then
            if qQuery.StatementType in [stSelectForUpdate, stSelect] then
            begin
              LogDetail('Opening cursor');
              qQuery.Open;
              //qQueryAfterOpen(Nil);
            end
            else
            begin
              //FetchCursor := True;
              //ExecCur := qQuery.QSelect.Statement.Execute(qTrans.TransactionIntf);
              //ExecResults := (ExecCur as TResults);
              //Fetch(True);
              qQuery.Execute;
              //qQueryAfterOpen(Nil);
            end;
            if not qQuery.Eof then
            begin
              tsData.Visible := True;
              tsData.TabVisible := True;
              stDataInfo.Visible := True;
              qQueryAfterOpen(Nil);
            end;
            LogDetail('Stats: ');
            //sstats := '';
            //for cou := psBuffers to psFetches do
            //  stats[cou] := 0;
            //qQuery.QSelect.Statement.GetPerfStatistics(stats);
            //for cou := psBuffers to psFetches do
            //begin
            //  if sstats <> '' then
            //    sstats += ', ';
            //  sstats += perfs[cou] + ': ' + stats[cou].ToString;
            //end;
            //LogDetail(sstats);

            //qQuery.QSelect.Statement.GetRowsAffected(Sc, Ic, Uc, Dc);
            std := qQuery.StHandle;
            sc := 0;
            ic := 0;
            uc := 0;
            dc := 0;
            DatabaseNode.Connection.Lib.DSQLInfoRowsAffected2(std, sc, ic, uc, dc);
            LogDetail(Format('Selected: %d, Insertedt: %d, Updated: %d, Deletect: %d', [Sc, Ic, Uc, Dc]));
            sstats := '';
            SetLength(ColumnsInfo, qQuery.Fields.FieldCount);
            for mcou := 0 to qQuery.Fields.FieldCount - 1 do
            begin
              if sstats<> '' then
                sstats += LineEnding;
              finfo := '';
              if qQuery.Fields.RelName[mcou] <> '' then
              begin
                ColumnsInfo[mcou].Referenced := True;
                ColumnsInfo[mcou].Reference := qQuery.Fields.RelName[mcou];
                ColumnsInfo[mcou].FieldName := qQuery.Fields.AliasName[mcou];
                finfo := ColumnsInfo[mcou].Reference + '.' + ColumnsInfo[mcou].FieldName;
              end
              else
              begin
                ColumnsInfo[mcou].Referenced := False;
                finfo := qQuery.Fields.AliasName[mcou];
              end;
              finfo += ' ' + CUIBFieldType[qQuery.Fields.FieldType[mcou]];
              sstats += 'Field # ' + (mcou + 1).ToString  + ' : ' + finfo;
            end;
            //md := qQuery.QSelect.Statement.MetaData;
            ////for mcou := 0 to qQuery.Fields.Count - 1 do
            //for mcou := 0 to md.Count - 1 do
            //begin
            //  if sstats<> '' then
            //    sstats += LineEnding;
            //  mdd := md.getColumnMetaData(mcou);
            //  //sstats += 'Field #' + (mcou + 1).ToString + mdd.getName + ' Alias: ' + mdd.getAliasName + ' ' + mdd.GetSQLTypeName;
            //  finfo := '';
            //  if mdd.getRelationName <> '' then
            //  begin
            //    ColumnsInfo[mcou].Referenced := True;
            //    ColumnsInfo[mcou].Reference := mdd.getRelationName;
            //    ColumnsInfo[mcou].FieldName := mdd.getSQLName;
            //    finfo := ColumnsInfo[mcou].Reference + '.' + ColumnsInfo[mcou].FieldName;
            //  end
            //  else
            //  begin
            //    ColumnsInfo[mcou].Referenced := False;
            //    finfo := mdd.getSQLName;
            //  end;
            //  sstats += 'Field # ' + (mcou + 1).ToString  + ' : ' + finfo + ' Alias: ' + mdd.getAliasName;// + ' ' + mdd.GetSQLTypeName;;
            //  //case qQuery.Fields[mcou].DataType of ;
            //end;
            LogDetail(sstats);
          end;
        //stUnknown,
        stInsert,
        stUpdate,
        stDelete,
        stDDL:
          begin
            tsData.Visible := False;
            tsData.TabVisible := False;
            stDataInfo.Visible := False;
            tsLog.Visible := True;
            pcPages.TabIndex := 0;
            LogDetail('Executing statements');
            qQuery.ExecSQL;
            LogDetail('Stats: ');
            sstats := '';
            //for cou := psBuffers to psFetches do
            //  stats[cou] := 0;
            //qQuery.QSelect.Statement.GetPerfStatistics(stats);
            //for cou := psBuffers to psFetches do
            //begin
            //  if sstats <> '' then
            //    sstats += ', ';
            //  sstats += perfs[cou] + ': ' + stats[cou].ToString;
            //end;
            //LogDetail(sstats);
            //qQuery.QSelect.Statement.GetRowsAffected(Sc, Ic, Uc, Dc);
            //LogDetail(Format('Selected: %d, Insertedt: %d, Updated: %d, Deletect: %d', [Sc, Ic, Uc, Dc]));
            std := qQuery.StHandle;
            sc := 0;
            ic := 0;
            uc := 0;
            dc := 0;
            DatabaseNode.Connection.Lib.DSQLInfoRowsAffected2(std, sc, ic, uc, dc);
            LogDetail(Format('Selected: %d, Insertedt: %d, Updated: %d, Deletect: %d', [Sc, Ic, Uc, Dc]));
          end;
        end;
      //end;//if prepared!
      //mmLog.Text := qQuery.QSelect.Statement.GetPlan;
    //except on E: EDatabaseError do
    except on E: EUIBError do
      begin
        _Error_ := True;
        LogError('Failed with message: "' + E.Message + '"');// GetErorMessage(E.Message));
      end;
    end;
  finally
    CheckActions;
  end
  else
  try
    try
      //Script.Database := DatabaseNode.Connection;
      //Script.Transaction := qTrans;
      //if not qTrans.Active then
      //  qTrans.StartTransaction;
      //try
      //  ibScript.ExecSQLScript(SQLText);
      Script.Script.Text := SQLText;
      Script.AutoDDL := actSqlScriptAutoDDl.Checked;
      Script.ExecuteScript;
    except
      on E: Exception do
      begin
        _Error_ := True;
        LogError('Failed with message: "' + E.Message + '"');// GetErorMessage(E.Message));
      end;
    end;
  finally
    CheckActions;
  end;
end;

procedure TdframEditor.actSqlScriptAutoDDlExecute(Sender: TObject);
begin
  if actSqlScriptAutoDDl.Checked then
    actSqlScript.Checked := True;
  if actSqlScript.Checked then
    tbtnScript.ImageIndex := 18
  else
    tbtnScript.ImageIndex := 8;
  tbtnScript.Down := actSqlScript.Checked;
end;

procedure TdframEditor.actSqlScriptExecute(Sender: TObject);
var
  Confirm: TModalResult;
  exstate: Boolean;
begin
  //exstate := actSqlScript.Checked;
  //if qTrans.TrHandle <> Nil then
  //begin
  //  Confirm := MessageDlg(Title + ' Change executing mode! Transaction on "' + Title +
  //    '" is still open decide what happend to it' + LineEnding +
  //    'Yes: Commit' + LineEnding +
  //    'No: Rollback' + LineEnding +
  //    'Cancel: Do not close!',
  //    mtConfirmation, mbYesNoCancel, 0);
  //  case Confirm of
  //    mrYes:
  //      begin
  //        try
  //          actCommitExecute(Nil);
  //          actSqlScript.Checked := not actSqlScript.Checked;
  //        except
  //          on E: Exception do
  //          begin
  //            LogError(E.Message);
  //          end;
  //        end;
  //      end;
  //    mrNo:
  //      begin
  //        try
  //          actRollbackExecute(Nil);
  //          actSqlScript.Checked := not actSqlScript.Checked;
  //        except
  //          on E: Exception do
  //          begin
  //            LogError(E.Message);
  //          end;
  //        end;
  //      end;
  //  end;
  //end;
  //if exstate = actSqlScript.Checked then
  //  ShowMessage('Mode change not applied!');
  //tbtnScript.Down := actSqlScript.Checked;
  if not actSqlScript.Checked then
    actSqlScriptAutoDDl.Checked := False;
  if actSqlScript.Checked then
    tbtnScript.ImageIndex := 18
  else
    tbtnScript.ImageIndex := 8;
  tbtnScript.Down := actSqlScript.Checked;
end;

procedure TdframEditor.edFindKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        sbFindNextClick(Nil);
        synSqlEditor.SetFocus;
        pnlFind.Hide;
      end;
    VK_DOWN: sbFindNextClick(Nil);
    VK_UP: sbFindPreClick(Nil);
  end;
end;

procedure TdframEditor.ibScriptErrorLog(Sender: TObject; Msg: string);
begin
  LogError(Msg);
end;

procedure TdframEditor.ibScriptOutputLog(Sender: TObject; Msg: string);
begin
  LogInfo(Msg);
end;

procedure TdframEditor.miData_CopyAsWhereClauseClick(Sender: TObject);
var
  lc, rc, ccou, rcou: LongInt;
  rfc, code: String;
  CopyWhereEnabled: Boolean;
begin
  if tsData.Visible and (sgData.SelectedRangeCount = 1) then
  with sgData.SelectedRange[0] do
  begin
    lc := Left - 1;
    rc := Right - 1;
    rfc := ColumnsInfo[lc].Reference;
    code := 'SELECT' + LineEnding + '  t.*' + LineEnding + 'FROM' + LineEnding + '  ' + rfc + ' t' + LineEnding + 'WHERE';
    for rcou := Top to Bottom do
    begin
      code += LineEnding;
      rfc := '';
      for ccou := lc to rc do
      begin
        if rfc <> '' then
          rfc += ' AND ';
        rfc += 't.' + ColumnsInfo[ccou].FieldName + ' = ''' + sgData.Cells[ccou + 1, rcou] + '''';
      end;
      code += '  ' + rfc;
    end;
    Clipboard.AsText := code;
  end;
end;

procedure TdframEditor.miData_Copy_CellsClick(Sender: TObject);
var
  Data, Titles, LSep, Line, Lines: String;
  Sep: Char;
  cou, ccou, rcou: LongInt;
begin
  Titles := '';
  Data := '';
  if miCopyData_CommaSeprated.Checked then
    Sep := ','
  else if miCopyData_SemicolonSeprated.Checked then
    Sep := ';'
  else if miCopyData_TabSeprated.Checked then
    Sep := #9;

  if miCopyData_LineEndingLinux.Checked then
    LSep := #10
  else if miCopyData_LineEndingMac.Checked then
    LSep := #13
  else if miCopyData_LineEndingWindows.Checked then
    LSep := #13#10;

  if sgData.SelectedRangeCount = 1 then
  with sgData.SelectedRange[0] do
  begin
    //CellCou := ((Bottom - Top + 1) * (Right - Left + 1));
    if miCopyData_CopyTitles.Checked then
    for cou := Left to Right do
    begin
      if Titles <> '' then
        Titles += Sep;
      Titles += sgData.Cells[cou, 0];
    end;
    if Titles <> '' then
      Titles += LSep;
    Lines := '';
    for rcou := Top to Bottom do
    begin
      Line := '';
      for ccou := Left to Right do
      begin
        if Line <> '' then
          Line += Sep;
        Line += sgData.Cells[ccou, rcou];
      end;
      if Line <> '' then
        Line += LSep;
      Lines += Line;
    end;
    Clipboard.AsText := Titles + Lines;
  end;
end;

procedure TdframEditor.actCommitExecute(Sender: TObject);
var
  InError: Boolean;
begin
  InError := False;
  try
    try
      qTrans.Commit;
      tsData.Visible := False;
      stDataInfo.Visible := False;
      tsData.TabVisible := False;
    except on E: EDatabaseError do
      begin
        LogError(E.Message);// GetErorMessage(E.Message));
        InError := True;
      end;
    end;
  finally
    CheckTransaction;
    if (not InError) and (Parent is TForm) then
    begin
      TForm(Parent).ModalResult := mrOK;
    end;
  end;
end;

procedure TdframEditor.actCopyExecute(Sender: TObject);
begin
  if synSqlEditor.SelText = '' then
    synSqlEditor.SelectWord;
  synSqlEditor.CopyToClipboard;
end;

procedure TdframEditor.actFindExecute(Sender: TObject);
begin
  if not pnlFind.Visible then
  begin
    pnlFind.Show;
    Application.ProcessMessages;
    synSqlEditor.SelectWord;
    edFind.Text := synSqlEditor.SelText;
    edFind.SetFocus;
  end
  else
    sbFindNextClick(Nil);
end;

procedure TdframEditor.actHistoryNextExecute(Sender: TObject);
begin
  if FHistoryIndex = -1 then
    Exit;
  if FHistoryIndex < DFrames.HistoryCount - 1 then
    FHistoryIndex.Inc;
  if Debio.Utils.Between(FHistoryIndex, 0, DFrames.HistoryCount - 1) then
    synSqlEditor.Text := DFrames.GetHistory(FHistoryIndex);
  CheckActions;
end;

procedure TdframEditor.actHistoryPerviousExecute(Sender: TObject);
begin
  if FHistoryIndex = -1 then
    FHistoryIndex := DFrames.HistoryCount - 1
  else if FHistoryIndex > 0 then
    FHistoryIndex.Dec;
  if Debio.Utils.Between(FHistoryIndex, 0, DFrames.HistoryCount - 1) then
    synSqlEditor.Text := DFrames.GetHistory(FHistoryIndex);
  CheckActions;
end;

procedure TdframEditor.actNewEditorExecute(Sender: TObject);
var
  ss: TDSqlDFrameshowState;
begin
  ss := [];
  if actSqlScript.Checked then
    ss += [dsesItIsScript];
  dmMainModule.ExecuteOnEditor(DatabaseNode, 'New Query', synSqlEditor.SelText, ss);
end;

procedure TdframEditor.actOpenExecute(Sender: TObject);
begin
  with dlgOpen do
  if Execute then
  begin
    synSqlEditor.Lines.LoadFromFile(FileName);
    FFileName := FileName;
    Caption := ExtractFileName(FileName);
    TTabSheet(Self.Parent).Caption := Self.Caption;
  end;
end;

procedure TdframEditor.actRollbackExecute(Sender: TObject);
var
  InError: Boolean;
begin
  InError := False;
  try
    try
      qTrans.Rollback;
      tsData.Visible := False;
      tsData.TabVisible := False;
      stDataInfo.Visible := False;
    except on E: EDatabaseError do
      begin
        LogError(E.Message);// GetErorMessage(E.Message));
        InError := True;
      end;
    end;
  finally
    CheckTransaction;
    if (not InError) and (Parent is TForm) then
    begin
      TForm(Parent).ModalResult := mrCancel;
    end;
  end;
end;

procedure TdframEditor.actSaveAsExecute(Sender: TObject);
begin
  with dlgSave do
  begin
    Title := 'Save Sql file as';
    FileName := Self.Caption + '.sql';
    if Execute then
    begin
      FFileName := FileName;
      synSqlEditor.Lines.SaveToFile(FileName);
      Caption := ExtractFileName(FileName);
      TTabSheet(Self.Parent).Caption := Self.Caption;
    end;
  end;
end;

procedure TdframEditor.actSaveExecute(Sender: TObject);
begin
  if FFileName = '' then
    with dlgSave do
    begin
      Title := 'Save Sql file';
      FileName := Self.Caption + '.sql';
      if Execute then
      begin
        FFileName := FileName;
        synSqlEditor.Lines.SaveToFile(FileName);
        Caption := ExtractFileName(FileName);
        TTabSheet(Self.Parent).Caption := Self.Caption;
      end;
    end
  else
    synSqlEditor.Lines.SaveToFile(FFileName);
end;

procedure TdframEditor.mmLogClick(Sender: TObject);
var
  cp: TPoint;
  Line, Err: String;
  ch: Char;
  strsSrcCaret: TStringArray;
begin
  //cp := mmLog.CaretPos;
  ////Panel1.Caption := Format('%d-%d:%s', [cp.X, cp.Y, mmLog.Lines[cp.Y]]);
  //Line := mmLog.Lines[cp.Y];
  //if Pos('line', Line) <= 1 then
  //  Exit;
  //Err := '';
  //for ch in Line do
  //  if ch in ['0'..'9', ','] then
  //    Err += ch;
  //strsSrcCaret := SplitString(Err, ',');
  //cp := Point(StrToInt(strsSrcCaret[1]), StrToInt(strsSrcCaret[0]));
  //synSqlEditor.CaretXY := cp;
  //synSqlEditor.SetFocus;
end;

procedure TdframEditor.pmDataPopupPopup(Sender: TObject);
var
  lc, rc, ccou: LongInt;
  rfc: String;
  CopyWhereEnabled: Boolean;
begin
  CopyWhereEnabled := False;
  try
    if tsData.Visible and (sgData.SelectedRangeCount = 1) then
    with sgData.SelectedRange[0] do
    begin
      if (Left = 0) or (not ColumnsInfo[Left - 1].Referenced) then
        Exit;
      lc := Left - 1;
      rc := Right - 1;
      rfc := ColumnsInfo[lc].Reference;
      for ccou := lc + 1 to rc do
      begin
        if (not ColumnsInfo[ccou].Referenced) or (ColumnsInfo[ccou].Reference <> rfc) then
          Exit;
      end;
      CopyWhereEnabled := True;
    end;
  finally
    miData_CopyAsWhereClause.Enabled := CopyWhereEnabled;
  end;
end;

procedure TdframEditor.qQueryAfterClose(DataSet: TObject);
begin
  CheckTransaction;
  sgData.RowCount := 1;
  tsData.Hide;
end;

procedure TdframEditor.qQueryAfterOpen(DataSet: TDataSet);
var
  Cou, Row: Integer;
begin
  Fetching := False;
  Fetch(True);
  CheckTransaction;
end;

procedure TdframEditor.qTransAfterTransactionEnd(Sender: TObject);
begin
  LogDetail('Transaction ends.');
end;

procedure TdframEditor.qTransStartTransaction(Sender: TObject);
begin
  LogDetail('Starting transaction.');
end;

procedure TdframEditor.sbCloseFindClick(Sender: TObject);
begin
  pnlFind.Hide;
  synSqlEditor.SetFocus;
end;

procedure TdframEditor.sbFindNextClick(Sender: TObject);
begin
  if edFind.Text then
    Exit;
  synSqlEditor.SearchReplaceEx(edFind.Text, '', [], synSqlEditor.CaretXY);
end;

procedure TdframEditor.sbFindPreClick(Sender: TObject);
begin
  if edFind.Text then
    Exit;
  synSqlEditor.SearchReplaceEx(edFind.Text, '', [ssoBackwards], synSqlEditor.CaretXY);
end;

procedure TdframEditor.sCompletionExecute(Sender: TObject);
begin
  //WriteLn('sCompletion fired!');
end;

procedure TdframEditor.SQLQuery1dsRowNo1GetText(Sender: TField; var aText: string; DisplayText: Boolean);
begin
  //aText := IntToStr(qQuery.RecNo);
  //DisplayText := True;
end;

procedure TdframEditor.sgDataSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
begin
  CanSelect := True;
  if aRow = sgData.RowCount - 1 then
    Fetch;
end;

procedure TdframEditor.sgDataSelection(Sender: TObject; aCol, aRow: Integer);
var
  ccou, rcou: LongInt;
  CellCou: Integer;
  NumericalCell: Integer;
  Value, Sum: Double;
  cap: String;
begin
  if tsData.Visible and (sgData.SelectedRangeCount = 1) then
  with sgData.SelectedRange[0] do
  begin
    CellCou := ((Bottom - Top + 1) * (Right - Left + 1));
    NumericalCell := 0;
    cap := 'Count :' + CellCou.ToString;
    Sum := 0;
    for ccou := Left to Right do
    begin
      for rcou := Top to Bottom do
      begin
        Value := 0;
        TryStrToFloat(sgData.Cells[ccou, rcou], Value);
        if Value <> 0 then
        begin
          Sum += Value;
          NumericalCell.Inc;
        end;
      end;
    end;
    if NumericalCell > 0 then
    begin
      cap += '  Sum: ' + FormatFloat('#.##', Sum);
      stDataInfo.Caption := cap;
    end;
  end;
end;

procedure TdframEditor.sCompletionCodeCompletion(var Value: string; SourceValue: string; var SourceStart,
  SourceEnd: TPoint; KeyChar: TUTF8Char; Shift: TShiftState);
var
  cpos: SizeInt;
  fld: TDTypedObjectNode;
  indent, line, Seprator, wrd: String;
  x: LongInt;
  ch: Char;
begin
  cpos := Pos(':', Value);
  if cpos > 0 then
    Value := Copy(Value, 1, cpos - 1);

  try
    try
      if (LowerCase(Value) <> LowerCase(SourceValue)) and ((KeyChar = ' ') or (KeyChar = '.')) then
      begin
        Value := SourceValue;
        if KeyChar = '.' then;
          Value += KeyChar;
        Exit;
      end;
    except
      on E: Exception do
      begin
        //for ch in KeyChar do
        //  WriteLn(Ord(ch));
      end;
    end;
  finally
  end;
  indent := DFrames.Indent(1);
  wrd := GetCurrentWord;
  if ((wrd <>'') and  (wrd[Length(wrd)] = '"')) and (Value[1] = '"') and (Value[Value.Length] = '"') then
  begin
    Delete(Value, 1, 1);
    Exit;
  end;

  if Assigned(CompletionObject) and (
    (Value = 'X.[Fields List]') or
    (Value = 'X.[Fields List]\n') or
    (Value = '[Fields List]') or
    (Value = '[Fields List]\n')
  ) then
  begin
    line := synSqlEditor.Lines[SourceStart.y - 1];
    x := SourceStart.x;
    x.Dec;
    while (x - 1 > 0) and (line[x - 1] in ['_', 'A' .. 'Z', 'a'..'z', '0'..'9', '$', '"']) do
      x.Dec;
    Delete(line, x, SourceEnd.x - x);
    Insert(MakeLead(SourceEnd.x - x, ' ') + LineEnding, line, x);
    synSqlEditor.Lines[SourceStart.Y - 1] := line;
    CompletionNameAlias += '.';
    Seprator := '';
    case Value of
      'X.[Fields List]':
        begin
          Seprator := ', ';
          indent := '';
        end;
      'X.[Fields List]\n':
        begin
          Seprator := ',' + LineEnding;
        end;
      '[Fields List]':
        begin
          Seprator := ', ';
          indent := '';
          CompletionNameAlias := '';
        end;
      '[Fields List]\n':
        begin
          Seprator := ',' + LineEnding;
          CompletionNameAlias := '';
        end;
    end;
    Value := '';
    for fld in CompletionObject.Fields do
    begin
      if Value <> '' then
        Value += Seprator;
      Value += indent + CompletionNameAlias + fld.ExactName;
    end;
    Value := LineEnding + Value + LineEnding;
    Exit;
  end;
end;

procedure TdframEditor.synSqlEditorExit(Sender: TObject);
begin
  //DatabaseNode.Connection.OnLog := Nil;
  DFrames.EditorLeaved(Self);
  //SynSQLSynMain.TableNames.Clear;
end;

procedure TdframEditor.synSqlEditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Wrd: String;
  decl: Boolean;
  alis: Boolean;
begin
  if ((Key = VK_SPACE) and (ssCtrl in Shift)) or (Key = 110{.}) then
  begin
    Wrd := GetCurrentWord;
    decl := True;
    alis := True;
    if (Wrd <> '') and (Wrd[Length(Wrd)] = '.') then
    begin
      decl := False;
      alis := True;
    end;
    if decl then
      RefreshDeclartions;
    if alis then
      RefresAlias;
  end;
  lastKey := #0;
end;

procedure TdframEditor.synSqlEditorKeyPress(Sender: TObject; var Key: char);
begin
  lastKey := Key;
end;

procedure TdframEditor.synSqlEditorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  p: TPoint;
  wrd, tk: String;
  attr: TSynHighlighterAttributes;
begin
  try
    with synSqlEditor do
    if (lastKey in sCompletion.IdentifiresChars + ['.']) and (not sCompletion.TheForm.Visible) {and
      (not GetHighlighterAttriAtRowCol(CaretXY, tk, attr)) and (attr.Caption^ <> SYNS_AttrComment)
       and (attr.Caption^ <> SYNS_AttrString)} then
    begin
      wrd := GetCurrentWord;
      if (not (lastKey = '.')) and (Length(wrd) < 3) then
        Exit;
      p := ClientToScreen(Point(CaretXPix, CaretYPix + LineHeight + 1));
      FilterCompList;
      sCompletion.Execute(wrd, p.x, p.y);
    end;
  finally
    lastKey := #0;
  end;
end;

procedure TdframEditor.synSqlEditorMouseLink(Sender: TObject; X, Y: Integer; var AllowMouseLink: Boolean);
var
  Wrd, line, NWrd,
  //Alias Or Object Name
  SqlObj_Alias_Name: String;
  XTo, NX, SqlObjIndex: Integer;
  SqlObject: TDObjectNode;
  SqlTypedObject: TDTypedObjectNode;
begin
  Wrd := synSqlEditor.GetWordAtRowCol(Point(X, y));
  FLinkPassed := False;
  RefresAlias;
  XTo := X + Length(Wrd) - 1;
  line := synSqlEditor.Lines[Y - 1];
  SqlObject := Nil;
  SqlTypedObject := Nil;
  //Checking for dualquted Identifier
  if (X > 1) and (line[X - 1] = '"') and (line[XTo + 1] = '"') then
  begin
    X.Dec;
    XTo.Inc;
    Wrd := Copy(line, X, XTo - X + 1);
  end;
  //Checking for aliase/Known Object or not
  if (X > 2) and ((line[X - 1] = '.') or ((X > 3) and (line[X - 1] = '"') and (line[X - 2] = '.'))) then
  begin
    //We faced to Aliase
    NX := X;
    NX.Dec;
    while (NX - 1 > 0) and (line[NX - 1] in ['_', 'A' .. 'Z', 'a'..'z', '0'..'9', '$']) do
      NX.Dec;
    NWrd := Copy(line, NX, Xto - NX);
    SqlObj_Alias_Name := Copy(line, NX, X - 1 - NX);
    if SqlObj_Alias_Name[1] <> '"' then
      SqlObj_Alias_Name := Uppercase(SqlObj_Alias_Name);
    SqlObjIndex := AliasesSource.IndexOf(SqlObj_Alias_Name);
    if SqlObjIndex > -1 then
      SqlObject := TDObjectNode(AliasesSource.Objects[SqlObjIndex])
    else
    //Looking Database Objects instead of Alias
    begin
      SqlObjIndex := DatabaseNode.Aliasables.IndexOf(SqlObj_Alias_Name);
      if SqlObjIndex > -1 then
        SqlObject := TDObjectNode(DatabaseNode.Aliasables.Objects[SqlObjIndex])
    end;
    AllowMouseLink := Assigned(SqlObject) and (SqlObject.FieldByName(Wrd) <> Nil);
    FLinkPassed := AllowMouseLink;
    if FLinkPassed then
      FLinkObject := SqlObject.FieldByName(Wrd);
    Exit;
  end
  else
  begin
     SqlObjIndex := DatabaseNode.Aliasables.IndexOf(Wrd);
    if SqlObjIndex > -1 then
    begin
      SqlObject := TDObjectNode(DatabaseNode.Aliasables.Objects[SqlObjIndex]);
      AllowMouseLink := Assigned(SqlObject);
      FLinkPassed := AllowMouseLink;
      if FLinkPassed then
        FLinkObject := SqlObject;
    end
    else
    begin
      SqlTypedObject := DatabaseNode.DomainsNode.FieldByName(Wrd);
      if not Assigned(SqlTypedObject) then
        SqlTypedObject := DatabaseNode.SequensesNode.FieldByName(Wrd)
      else if not Assigned(SqlTypedObject) then
        SqlTypedObject := DatabaseNode.IndicesNode.FieldByName(Wrd)
      else if not Assigned(SqlTypedObject) then
        SqlTypedObject := DatabaseNode.TriggersNode.FieldByName(Wrd);
      AllowMouseLink := Assigned(SqlTypedObject);
      FLinkPassed := AllowMouseLink;
      if FLinkPassed then
        FLinkObject := SqlTypedObject;
    end;
  end;
end;

procedure TdframEditor.synSqlEditorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  CaretPos;
end;

procedure TdframEditor.synSqlEditorPaste(Sender: TObject; var AText: String; var AMode: TSynSelectionMode; ALogStartPos: TPoint; var AnAction: TSynCopyPasteAction);
begin
  FModifiedTimeStamp := Now();
end;

procedure TdframEditor.synSqlEditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: integer; var ReplaceAction: TSynReplaceAction);
begin
  FModifiedTimeStamp := Now();
end;

procedure TdframEditor.ToolButton13Click(Sender: TObject);
var
  nLines: TStrings;
  nLine: Integer;
begin
  LogInfo('Hello :)');
  nLines := synSqlEditor.Lines;
  for nLine := 0 to nLines.Count do
  begin

  end;

end;

function TdframEditor.GetCurrentWord: String;
var
  Ex, Sx: integer;
  cp: TPoint;
  lastCh: String;
begin
  cp := synSqlEditor.CaretXY;
  if cp.x = 0 then
    Exit('');

  lastCh := Copy(synSqlEditor.LineText, cp.X - 1, cp.X);
  if lastCh = '.' then
    cp.X -= 1;
  synSqlEditor.GetWordBoundsAtRowCol(cp, Sx, Ex);
  Result := Copy(synSqlEditor.LineText, sx, cp.X - sx);
  if lastCh = '.' then
    Result += '.';
end;

procedure TdframEditor.FilterCompList;
//var
//  wrd, word: String;
//  ic: Integer;
//begin
//  wrd := GetCurrentWord;
//  sCompletion.ItemList.Clear;
//  if wrd <> '' then
//  begin
//    for word in Availables do
//      if Pos(LowerCase(wrd), LowerCase(word)) = 1 then
//        sCompletion.ItemList.Add(word);
//  end
//  else
//    sCompletion.ItemList.Assign(Availables);
//  if sCompletion.ItemList.Count > 0 then
//    sCompletion.Position := 0
//  else
//    sCompletion.Position := -1;
var
  //Word under current list
  wd,
  //Current Word on Editor
  cw,
  //Alias
  al: String;
  cou: Integer;
  FieldContainer: TDObjectNode;
  Field: TDTypedObjectNode;
  ListedWords: TDSqlWordtype;
begin
  //RefreshDeclartions;
  //RefresAlias;
  sCompletion.ItemList.Clear;
  cw := LowerCase(sCompletion.CurrentString);
  //stServer.Caption := cw;
  if (cw <> '') and (cw[1] = ':') then
  begin
    Delete(cw, 1, 1);
    for cou := 0 to Variables.Count - 1 do
    begin
      wd := Variables[cou];
      if (cw = '') or (pos(cw, lowercase(wd)) = 1) then
        sCompletion.ItemList.AddObject(wd, Variables.Objects[cou]);
    end;
    Exit;
  end;
  CompletionObject := Nil;
  CompletionNameAlias := '';
  cou := Pos('.', cw);
  if (cw <> '') and (cou > 0) then
  begin
    al := Copy(cw, 1, cou - 1);
    Delete(cw, 1, cou);
    //mmLog.Append('Al: ' + al);
    //mmLog.Append('Cw: ' + cw);
    if DFrames.SQLIdentifireUpperCase then
      al := UpperCase(al);
    cou := DatabaseNode.Aliasables.IndexOf(al);
    if cou >= 0 then
    begin
      FieldContainer := TDObjectNode(DatabaseNode.Aliasables.Objects[cou]);
      CompletionObject := FieldContainer;
      CompletionNameAlias := FieldContainer.ExactName;
      case FieldContainer.NodeSqlObjectType of
        dntProcedure:
          ListedWords := dswtParameter;
        else
          ListedWords := dswtField;
      end;
      //sCompletion.ItemList.AddObject('*', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      for Field in FieldContainer.Fields do
        if ((cw = '') or (pos(cw, lowercase(Field.ExactName)) = 1)) and
          (Field.NodeSqlObjectType in [dntTablePmKey, dntTableField, dntTableFgKey, dntTableComtd, dntViewField, dntProcedureReturns]) then
            sCompletion.ItemList.AddObject(Field.ExactName + ':  ' + LowerCase(Field.ObjectType),
              TObject(Pointer(PtrInt(Ord(ListedWords)))));
      sCompletion.ItemList.AddObject('X.[Fields List]', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      sCompletion.ItemList.AddObject('X.[Fields List]\n', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      sCompletion.ItemList.AddObject('[Fields List]', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      sCompletion.ItemList.AddObject('[Fields List]\n', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
    end;
    cou := AliasesSource.IndexOf(al);
    if cou >= 0 then
    begin
      FieldContainer := TDObjectNode(AliasesSource.Objects[cou]);
      CompletionNameAlias := al;
      CompletionObject := FieldContainer;
      case FieldContainer.NodeSqlObjectType of
        dntProcedure:
          ListedWords := dswtParameter;
        else
          ListedWords := dswtField;
      end;
      //sCompletion.ItemList.AddObject('*', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      for Field in FieldContainer.Fields do
        if ((cw = '') or (pos(cw, lowercase(Field.ExactName)) = 1)) and
          (Field.NodeSqlObjectType in [dntTablePmKey, dntTableField, dntTableFgKey, dntTableComtd, dntViewField, dntProcedureReturns]) then
            sCompletion.ItemList.AddObject(Field.ExactName + ':  ' + LowerCase(Field.ObjectType),
              TObject(Pointer(PtrInt(Ord(ListedWords)))));
      sCompletion.ItemList.AddObject('X.[Fields List]', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      sCompletion.ItemList.AddObject('X.[Fields List]\n', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      sCompletion.ItemList.AddObject('[Fields List]', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
      sCompletion.ItemList.AddObject('[Fields List]\n', TObject(Pointer(PtrInt(Ord(dswtFieldAll)))));
    end;
    Exit;
  end;

  for cou := 0 to Aliases.Count - 1 do
  begin
    wd := Aliases[cou];
    if (cw = '') or (pos(cw, lowercase(wd)) = 1) then
      sCompletion.ItemList.AddObject(wd, TObject(Pointer(PtrInt(Ord(dswtAlias)))));
  end;

  for cou := 0 to Variables.Count - 1 do
  begin
    wd := Variables[cou];
    if (cw = '') or (pos(cw, lowercase(wd)) = 1) then
      sCompletion.ItemList.AddObject(wd, Variables.Objects[cou]);
  end;
  for cou := 0 to DatabaseNode.Availables.Count - 1 do
  begin
    wd := DatabaseNode.Availables[cou];
    if (cw = '') or (pos(cw, lowercase(wd)) = 1) then
      sCompletion.ItemList.AddObject(wd, DatabaseNode.Availables.Objects[cou]);
  end;

  //for cou := 0 to DFrames.SqlReserved.Count - 1 do
  //begin
  //  wd := DFrames.SqlReserved[cou];
  //  if (cw = '') or (pos(cw, lowercase(wd)) = 1) then
  //    sCompletion.ItemList.AddObject(wd, DFrames.SqlReserved.Objects[cou]);
  //end;
end;

procedure TdframEditor.OnUIBScriptComment(sender: TObject; const comment: string; style: TCommentStyle);
begin
  LogInfo(comment);
end;

procedure TdframEditor.OnUIBScriptExecError(Sender: TObject; Error: Exception; const SQLText: string; var Handled: Boolean);
begin
  LogError('Parsing failed :' + LineEnding + SQLText + LineEnding + Error.Message);
  Handled := True;
end;

procedure TdframEditor.OnUIBScriptParse(Sender: TObject; NodeType: TSQLStatement; const Statement: string);
begin
  LogDetail('Parsing: ' + LineEnding + Statement);
end;

procedure TdframEditor.OnUIBTransactionEnd(Sender: TObject; var Mode: TEndTransMode);
const
  det : array[TEndTransMode] of String =(
    'Default',
    'StayIn',
    'Commit',
    'CommitRetaining',
    'Rollback',
    'RollbackRetaining'
  );
begin
  LogInfo('Transaction Ends ' + det[Mode]);
end;

procedure TdframEditor.OnUIBTransactionStart(Sender: TObject);
begin
  CheckTransaction;
  LogInfo('Transaction Start');
end;

function RemoveComments(sql: String; LineE: String): String;
var
  cp: SizeInt;
  ecp: Integer;
begin
  Result := sql;
  if not LineE.IsEmpty then
  while True do
  begin
    cp := Pos('--', sql);
    if cp > 0 then
      ecp := PosEx(LineE, sql, cp)
    else
      Break;
    if ecp > 0 then
      Delete(sql, cp, ecp - cp);
  end;

  while True do
  begin
    cp := Pos('/*', sql);
    if cp > 0 then
      ecp := PosEx('*/', sql, cp)
    else
      Break;
    if ecp > 0 then
      Delete(sql, cp, ecp - cp + 2);
  end;

  Result := sql;
  if not LineE.IsEmpty then
    Result := ReplaceStr(sql, LineE, ' ');
end;

procedure TdframEditor.RefreshDeclartions;
var
  txt, ret, ltxt, stxt, sltxt, tmp: String;
  rtp,
  //Space ot Tab
  st: SizeInt;
  po, pc: Integer;
  rets, par: TStringArray;
  proc, func: Boolean;
begin
  Variables.Clear;
  txt := RemoveComments(synSqlEditor.Text, synSqlEditor.Lines.LineBreak);
  ltxt := LowerCase(txt);
  stxt :=  txt;
  sltxt := ltxt;
//Checking for Parameters, Returns, Variables...
  proc := False;
  func := False;
  rtp := Pos(' procedure ', ltxt);
  if rtp = 0 then
  begin
    rtp := Pos(' function ', ltxt);
    func := rtp <> 0;
  end
  else
    proc := True;
  if rtp > 0 then
  begin
    pc := Pos(' returns', ltxt);
    if pc = 0 then
      pc := Pos(' as ', ltxt);
    if pc > 0 then
    begin
      po := PosEx('(', ltxt, rtp) + 1;
      pc := RPosEx(')', ltxt, pc);
      ret := Copy(txt, po, pc - po);
      rets := SplitString(ret, ',');
      SetLength(par, 2);
      for ret in rets do
      begin
        //par := SplitString(Trim(ret), ' ');
        tmp := Trim(ret);
        st := Pos(' ', tmp);
        if st = 0 then
          st := Pos(#9, tmp);
        if st > 0 then
        begin
          par[0] := Trim(Copy(tmp, 1, st));
          par[1] := Trim(Copy(tmp, st + 1));
          Variables.AddObject(par[0] + ':  ' + LowerCase(par[1]), TObject(Pointer(PtrInt(Ord(dswtParameter)))));
        end;
      end;
    end;
  end;
  rtp := Pos(' returns', ltxt);
  if rtp > 0 then
  begin
    if proc then
    begin
      po := PosEx('(', ltxt, rtp);
      pc := PosEx(' as ', ltxt, rtp);
      pc := RPosEx(')', ltxt, pc);
      ret := Copy(txt, po + 1, pc - po - 1);
      if ret <> '' then
      begin
        rets := SplitString(ret, ',');
        SetLength(par, 2);
        for ret in rets do
        begin
          //par := SplitString(Trim(ret), ' ');
          //if Length(par) = 2 then
          //  Variables.AddObject(par[0] + ':  ' + par[1], TObject(Pointer(PtrInt(Ord(dswtReturns)))))
          //else
          //  Continue;
          tmp := Trim(ret);
          st := Pos(' ', tmp);
          if st = 0 then
            st := Pos(#9, tmp);
          if st > 0 then
          begin
            par[0] := Trim(Copy(tmp, 1, st));
            par[1] := Trim(Copy(tmp, st + 1));
            Variables.AddObject(par[0] + ':  ' + LowerCase(par[1]), TObject(Pointer(PtrInt(Ord(dswtReturns)))));
          end;
        end;
      end;
    end
    else if func then
    begin
      pc := PosEx(' as ', ltxt, rtp);
      ret := Trim(Copy(txt, rtp + 9, pc - (rtp + 9)));
      if ret <> '' then
      begin
        Variables.AddObject('RETURN:  ' + ret, TObject(Pointer(PtrInt(Ord(dswtReturns)))));
      end{
      else
        raise Exception.Create('Returns of the Function not defined!');}
    end;
  end;

  po := PosEx(' as ', ltxt) + 4;
  pc := PosEx(' begin ', ltxt);
  //if pc > 0 then
  //  pc := Length(ltxt);
  txt := Trim(Copy(txt, po, pc - po));
  po := RPos(';', txt);
  Delete(txt, po, 1000);
  ltxt := LowerCase(txt);
  if txt <> '' then
  begin
    while true do
    begin
      po := Pos('declare', ltxt);
      if po > 0 then
      begin
        Delete(ltxt, po, 7);
        Delete(txt, po, 7);
      end
      else
        Break;
    end;
    while true do
    begin
      po := Pos('variable', ltxt);
      if po > 0 then
      begin
        Delete(ltxt, po, 8);
        Delete(txt, po, 8);
      end
      else
        Break;
    end;
    if txt <> '' then
    begin
      rets := SplitString(txt, ';');
      SetLength(par, 2);
      for ret in rets do
      begin
        tmp := Trim(ret);
        st := Pos(' ', tmp);
        if st = 0 then
          st := Pos(#9, tmp);
        if st > 0 then
        begin
          par[0] := Trim(Copy(tmp, 1, st));
          par[1] := Trim(Copy(tmp, st + 1));
          Variables.AddObject(par[0] + ':  ' + LowerCase(par[1]), TObject(Pointer(PtrInt(Ord(dswtVariable)))))
        end;
      end;
    end
  end;

//Checking for aliases(Tables, Views, ...)

end;

procedure TdframEditor.RefresAlias;
var
  //Lines: TStringList;
  txt, utxt, token : String;
  //Line
  lin,
  //Select and pos
  sel, selp,
  //From and pos
  from, fromp,
  //On/Where/Do/Ordr By/Group By
  owdgo, owdgop,
  //Aliasable Index
  ai,
  fr, nLine: Integer;
  tokens, utokens: TStringArray;
  nLines: TStrings;

  function IsFromReserveds(wrd: String; var Index: Integer): Boolean;
  begin
    Index := DatabaseNode.ReservedWords.IndexOf(wrd);
    Result := Index >= 0;
  end;

  function IsAliasable(wrd: String; var Index: Integer): Boolean;
  begin
    Index := DatabaseNode.Aliasables.IndexOf(wrd);
    Result := Index >= 0;
  end;

begin
  //if FModifiedTimeStamp = FAliasTimeStamp then
  //begin
  //  //WriteLn('Ignoring refresh aliases');
  //  Exit;
  //end
  //else
  //  FAliasTimeStamp := FModifiedTimeStamp;
  Aliases.Clear;
  AliasesSource.Clear;
  sel := -1;
  selp := -1;
  from := -1;
  fromp := -1;
  owdgo := -1;
  owdgop := -1;


  //for lin := 0 to synSqlEditor.Lines.Count - 1 do
  //begin
  //  txt := LowerCase(synSqlEditor.Lines[lin]);
  //  if Pos('trigger', txt) > 0 then
  //  begin
  //
  //  end;
  //end;
  for lin := synSqlEditor.CaretY -1 downto 0 do
  begin
    txt := ' ' + LowerCase(synSqlEditor.Lines[lin]) + ' ';
    //if sel = - 1 then
    //begin
      selp := Pos(' select ', txt);
      if selp > 0 then
        sel := lin;
    //end;
    //if from = - 1 then
    //begin
      fromp := Pos(' from ', txt);
      if fromp > 0 then
        from := lin;
    //end;
  end;
  if sel > -1 then
  begin
    if from = -1 then
      for lin := synSqlEditor.CaretY - 1 to synSqlEditor.Lines.Count - 1 do
      begin
        txt := ' ' + LowerCase(synSqlEditor.Lines[lin]) + ' ';
        fromp := Pos(' from ', txt);
        if fromp > 0 then
        begin
          fromp += 5;
          from := lin;
          Break;
        end;
      end;
    if from > -1 then
    begin
      for lin := from to synSqlEditor.Lines.Count - 1 do
      begin
        txt := ' ' + LowerCase(synSqlEditor.Lines[lin]) + ' ';
        //owdgop := Pos(' on ', txt);
        //if owdgop > 0 then
        //begin
        //  owdgo := lin;
        //  Break;
        //end;
        owdgop := Pos(' where ', txt);
        if owdgop > 0 then
        begin
          owdgo := lin;
          Break;
        end;
        owdgop := Pos(' group ', txt);
        if owdgop > 0 then
        begin
          owdgo := lin;
          Break;
        end;
        owdgop := Pos(' order ', txt);
        if owdgop > 0 then
        begin
          owdgo := lin;
          Break;
        end;
        owdgop := Pos(' do ', txt);
        if owdgop > 0 then
        begin
          owdgo := lin;
          Break;
        end;
      end;
      if owdgo = -1 then
      begin
        owdgo := synSqlEditor.Lines.Count - 1;
        owdgop := Length(synSqlEditor.Lines[owdgo]);
      end
      else
        owdgop -= 1;

      txt := Copy(synSqlEditor.Lines[from] + ' ', fromp + 5, Length(synSqlEditor.Lines[from]));

      if owdgo > from then
      begin
        if owdgo - from > 1 then
          for lin := from + 1 to owdgo - 1 do
            txt += synSqlEditor.Lines[lin] + ' ';

        txt += Copy(synSqlEditor.Lines[owdgo] + ' ', 1, owdgop);
      end;

      RemoveComments(txt, '');//synSqlEditor.Lines.LineBreak);
      txt := ReplaceStr(txt, #9, ' ');
      txt := ReplaceStr(txt, ',', '');
      txt := ReplaceStr(txt, '(', ' ');
      txt := ReplaceStr(txt, ')', ' ');
      txt := ReplaceStr(txt, '  ', ' ');
      txt := ReplaceStr(txt, '  ', ' ');
      txt := ReplaceStr(txt, ';', '');
      txt := ReplaceStr(txt, synSqlEditor.Lines.LineBreak, ' ');
      tokens := SplitString(txt, ' ');
      utxt := UpperCase(txt);
      utokens := SplitString(utxt, ' ');
      lin := -1;
      while lin < Length(tokens) - 1 do
      begin
        //lin := DatabaseNode.Aliasables.IndexOf(token);
        Inc(lin);
        token := utokens[lin];
        if DatabaseNode.ReservedWords.IndexOf(token) > 0 then
          Continue
        else
        begin
          if IsAliasable(token, ai) and (lin + 1 <= Length(utokens) - 1) and (not IsFromReserveds(utokens[lin + 1], fr))
            and (not IsAliasable(utokens[lin + 1], fr)) then
          begin
            Aliases.AddObject(tokens[lin + 1] + ':  ' + token, TObject(Pointer(PtrInt(dswtAlias))));
            AliasesSource.AddObject(LowerCase(tokens[lin + 1]), DatabaseNode.Aliasables.Objects[ai]);
            Inc(lin);
          end;
        end;
      end;
      //mmLog.Lines.AddStrings(Aliases);
    end;
  end;

  tokens := Nil;
  utokens := Nil;
end;

function TdframEditor.GetErorMessage(Msg: String): String;
var
  temp: TStringList;
  cou: Integer;
begin
  Result := '';
  if Msg = '' then
    Exit;
  temp := TStringList.Create;
  temp.Text := Msg;
  temp.Delete(0);
  for cou := 0 to temp.Count - 1 do
  begin
    temp[cou] := Copy(temp[cou], 3, 1000);
  end;
  Result := temp.Text;
  FreeAndNil(temp);
end;

procedure TdframEditor.CaretPos;
begin
  with synSqlEditor.CaretXY do
  stCrtPos.Caption := Format('Line: %d,  Column: %d', [y, x]);
end;

function TdframEditor.GetLines(APos: TPoint; RPos: Integer): String;
var
  str: String;
  cou: Integer;
begin
  Result := '';
  RPos := 0;
  for cou := 0 to synSqlEditor.Lines.Count do
  begin
    str := synSqlEditor.Lines[cou];
    if cou + 1 = APos.Y then
      Insert('[-]', str, APos.X);
    Result += str + ' ';
  end;
  Result := ReplaceStr(Result, #9, ' ');
  Result := ReplaceStr(Result, '  ', ' ');
  Result := ReplaceStr(Result, '  ', ' ');

end;

function TdframEditor.RepresentValueOfTextBlob(Val: String): String;
begin
   Val := ReplaceStr(Val, #13#10, ' ');
   Val := ReplaceStr(Val, #13, ' ');
   Val := ReplaceStr(Val, #10, ' ');
   Result := Val;
end;

procedure TdframEditor.Fetch(fromFirst: Boolean);
var
  Cou, Row, RowMax, ValW: Integer;
  Val: String;
  cur: TSQLResult;
  //DtArea: TSQLDataArea;
begin
  if Fetching then Exit;
  if not (qQuery.CurrentState in [qsExecute]) then
    Exit;
  Fetching := True;
  cur := qQuery.Fields;
  try
    if fromFirst then
    begin
      if not FetchCursor then
      begin
        //SetLength(Fields, qQuery.FieldCount);
        //sgData.ColCount := qQuery.FieldCount + 1;
        SetLength(Fields, qQuery.Fields.FieldCount);
        sgData.ColCount := qQuery.Fields.FieldCount + 1;
      end;
      //else
      //begin
      //  SetLength(Fields, 0);
      //  sgData.ColCount := ExecCur.Count + 1;
      //  sgData.RowCount := 2;
      //end;

      sgData.RowCount := 1;
      sgData.FixedRows := 1;
      sgData.FixedCols := 0;
      sgData.Cells[0, 0] := '#';
      sgData.ColWidths[0] := 24;
      if not FetchCursor then
      begin
        //for Cou := 1 to qQuery.Fields.FieldCount do
        for Cou := 0 to qQuery.Fields.FieldCount - 1 do
        begin
          //Fields[Cou - 1] := qQuery.Fields[Cou - 1];
          //Val := Trim(Fields[Cou - 1].FieldName);
          Val := qQuery.Fields.AliasName[Cou];
          sgData.Cells[Cou + 1, 0] := Val;
          sgData.ColWidths[Cou + 1] := sgData.Canvas.TextWidth(Val) + 22;
          //sgData.Columns[Cou + 1].Alignment := taCenter;
        end;
        Row := 1;
        RowMax := 300;
      end
      //else
      //begin
      //  if Assigned(ExecResults) and (ExecCur.Count > 0) then
      //  begin
      //    DtArea := TSQLDataArea((ExecCur as TResults).Results);
      //    sgData.Cells[0, 1] := '1';
      //    try
      //      sgData.BeginUpdate;
      //      for cou := 0 to DtArea.Count - 1 do
      //      begin
      //        sgData.Cells[Cou + 1, 0] := DtArea.Column[cou].Name;
      //        sgData.Cells[Cou + 1, 1] := ExecCur[Cou].AsString;
      //        sgData.ColWidths[Cou + 1] := Max(
      //          sgData.Canvas.TextWidth(DtArea.Column[cou].Name) + 22,
      //          sgData.Canvas.TextWidth(ExecCur[Cou].AsString) + 22
      //        );
      //      end;
      //      Row := 2;
      //    finally
      //      sgData.EndUpdate();
      //    end;
      //  end;
      //end;
    end
    else
    begin
      Row := sgData.RowCount;
      RowMax := Row + 50;
    end;
    sgData.BeginUpdate;
    while (not qQuery.EOF) and (Row <= RowMax) do
    begin
      sgData.RowCount := Row + 1;
      sgData.Cells[0, Row] := IntToStr(Row);
      //for Cou := 1 to qQuery.FieldCount do
      for Cou := 0 to qQuery.Fields.FieldCount - 1 do
        //if Fields[cou].IsNull then
        //Val := '';
        if cur.IsNull[Cou] then
          sgData.Cells[Cou + 1, Row] := '[NULL]'
        else
        begin
          //if Fields[Cou - 1].DataType = ftDate then
          if cur.FieldType[Cou] = uftDate then
            //Val := FormatDateEs(Fields[Cou - 1].AsDateTime, [dYYYY, dDtsep, dMM, dDtsep, dDD], dcGregorian, dnEnglish)
              Val := FormatDateEs(cur.AsDateTime[Cou], [dYYYY, dDtsep, dMM, dDtsep, dDD], dcGregorian, dnEnglish)
          //else if Fields[Cou - 1].DataType = ftTime then
          else if cur.FieldType[Cou] = uftTime then
            //Val := FormatDateEs(Fields[Cou - 1].AsDateTime, [dHH, dTmSep, dNN, dTmSep, dSS], dcGregorian, dnEnglish)
            Val := FormatDateEs(cur.AsDateTime[Cou], [dHH, dTmSep, dNN, dTmSep, dSS], dcGregorian, dnEnglish)
          //else if Fields[Cou - 1].DataType = ftDateTime then
          else if cur.FieldType[Cou] = uftTimestamp then
            //Val := FormatDateEs(Fields[Cou - 1].AsDateTime, [dYYYY, dDtsep, dMM, dDtsep, dDD, dSpace, dHH, dTmSep, dNN, dTmSep, dSS], dcGregorian, dnEnglish)
            Val := FormatDateEs(cur.AsDateTime[Cou], [dYYYY, dDtsep, dMM, dDtsep, dDD, dSpace, dHH, dTmSep, dNN, dTmSep, dSS], dcGregorian, dnEnglish)
          //if Fields[Cou - 1].DataType = ftMemo then
          //  sgData.Cells[Cou, Row] := RepresentValueOfTextBlob(Fields[Cou - 1].AsString)
          else
            //Val := Fields[Cou - 1].AsString;
            Val := cur.AsString[Cou];
          Val := Trim(Val);
          sgData.Cells[Cou + 1, Row] := Val;
          ValW := sgData.Canvas.TextWidth(Val) + 22;
          if ValW > sgData.ColWidths[Cou + 1] then
            sgData.ColWidths[Cou + 1] := ValW;
        end;

      Inc(Row);
      if qQuery.StatementType = stExecProcedure then
      begin
        qQuery.Close(etmStayIn);
        Break;
      end;
      qQuery.Next;
    end;

  finally
    sgData.EndUpdate;
    Fetching := False;
  end;
  stInfo.Caption := 'Fetched rows: ' + IntToStr(Row - 1);
end;

procedure TdframEditor.CheckTransaction;
begin
  //actCommit.Enabled := qTrans.Active;
  //actRollback.Enabled := qTrans.Active;
  actCommit.Enabled := qTrans.TrHandle <> Nil;
  actRollback.Enabled := qTrans.TrHandle <> Nil;
end;

function TdframEditor.Leaving: Boolean;
var
  Confirm: TModalResult;
  TrConfirm: TDTransactionDecision;
begin
  //if qTrans.Active then
  if qTrans.TrHandle <> Nil then
  begin
    //Confirm := MessageDlg(Title + ' Closing...', 'Transaction on "' + Title +
    //  '" is still open' + LineEnding +
    //  'Yes: Commit' + LineEnding +
    //  'No: Rollback' + LineEnding +
    //  'Cancel: Do not close!',
    //  mtConfirmation, mbYesNoCancel, 0);
    TrConfirm := TDFrmTransactionDecision.MakeDesicion;
    //WriteLn(TrConfirm);
    case TrConfirm of
      dtdCommit:
        begin
          try
            //actCommitExecute(Nil);
            qTrans.Commit;
            Result := True;
          except
            on E: Exception do
            begin
              //WriteLn(E.Message);
              LogError(E.Message);
              Result := False;
            end;
          end;
        end;
      dtdRollback:
        begin
          try
            qTrans.RollBack;
            //actRollbackExecute(Nil);
            Result := True;
          except
            on E: Exception do
            begin
              //WriteLn(E.Message);
              LogError(E.Message);
              Result := False;
            end;
          end;
        end;
      dtdCancel: Result := False;
    end;
    //WriteLn(PtrInt(qTrans.TrHandle));
  end
  else
    Result := True;
  if Result and (not FFileName) and synSqlEditor.Modified then
  begin
    Confirm := MessageDlg(Title + ' Closing...', 'File "' + FFileName +
      '" has been modified!' + LineEnding +
      'Save changes and close it?',
      mtConfirmation, mbYesNoCancel, 0);
    case Confirm of
      mrYes:
        begin
          actSaveExecute(Nil);
          Result := True;
        end;
      mrNo:
        begin
          Result := True;
        end;
      mrCancel: Result := False;
    end;
  end;
end;

procedure TdframEditor.SetSql(ASql: String);
begin
  synSqlEditor.Text := ASql;
  FModifiedTimeStamp := Now();
end;

destructor TdframEditor.Destroy;
begin
  //if DatabaseNode.Connection.OnLog = @IBConnection1Log then
    //DatabaseNode.Connection.OnLog := Nil;
  FreeAndNil(Variables);
  FreeAndNil(Aliases);
  FreeAndNil(AliasesSource);
  DFrames.RemoveEditor(Self);
  inherited Destroy;
end;

constructor TdframEditor.Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode);
var
  tbl: String;
begin
  inherited Create(Owenr, ADataBaseNode);
  FAliasTimeStamp := 0;
  FModifiedTimeStamp := 0;
  fTries := 0;
  fMultiCaret := TSynPluginMultiCaret.Create(self);
  with fMultiCaret do begin
    Editor := synSqlEditor;
    with KeyStrokes do begin
      with Add do begin
        Command    := ecPluginMultiCaretSetCaret;
        Key        := VK_INSERT;
        Shift      := [ssShift, ssCtrl];
        ShiftMask  := [ssShift, ssCtrl, ssAlt];
      end;
      with Add do begin
        Command    := ecPluginMultiCaretUnsetCaret;
        Key        := VK_DELETE;
        Shift      := [ssShift, ssCtrl];
        ShiftMask  := [ssShift, ssCtrl, ssAlt];
      end;
      //with Add do
      //begin
      //  Command := emcPluginMultiCaretSelectionToCarets;
      //  Key := VK_INSERT;
      //  Shift      := [ssShift, ssCtrl];
      //  ShiftMask  := [ssShift, ssCtrl, ssAlt];
      //end;
    end;
  end;
  //synSqlEditor.MouseActions.AddCommand(emcPluginMultiCaretSelectionToCarets, True, mbLeft, 1, cdup, [ssShift, ssCtrl], [ssShift, ssCtrl]);
  Variables := TStringList.Create;
  Aliases := TStringList.Create;
  AliasesSource := TStringList.Create;
  sCompletion.TheForm.Color := synSqlEditor.Color;
  sCompletion.IdentifiresChars := sCompletion.IdentifiresChars + ['$', '"'];

  synSqlEditor.Highlighter := ADataBaseNode.Highlighter;
  ADataBaseNode.IncreaseHighlighterInuse;

  //dmMainModule.SynSQLSynMain.TableNames;
  FLogging := True;
  FFileName := '';
  Caption := 'New Query' + IntToStr(Counter);
  Script := TUIBScript.Create(Self);
  qQuery := TUIBQuery.Create(Self);
  qQuery.OnClose := @qQueryAfterClose;
  qTrans := TUIBTransaction.Create(Self);
  with qTrans do
  begin
    AutoStart := True;
    AutoStop := False;
    DefaultAction := etmStayIn;
    Name := 'UIBTransAction';
    Options := [tpConcurrency, tpWrite, tpWait];
    OnEndTransaction := @OnUIBTransactionEnd;
    OnStartTransaction := @OnUIBTransactionStart;
  end;

  qTrans.DataBase := ADataBaseNode.Connection;
  qQuery.DataBase := ADataBaseNode.Connection;
  qQuery.Transaction := qTrans;
  qQuery.FetchBlobs := True;
  qQuery.CachedFetch := False;
  qQuery.OnClose := @qQueryAfterClose;
  Script.Transaction := qTrans;
  with Script do
  begin
    OnComment := @OnUIBScriptComment;
    OnExecuteError := @OnUIBScriptExecError;
    OnParse := @OnUIBScriptParse;
  end;
  //qTrans.StartTransaction;
  Inc(Counter);
  DFrames.AddEditor(Self);
  FHistoryIndex := -1;
  ConfigChanged;
  MetaDataChanged;
end;

procedure TdframEditor.ShowLog;
var
  log: String;
begin
  with FLogAttr do
    log := Format(
    '<html><body bgcolor="%s"><font face="%s" size="%d">',
        [ColorToHTML(Background), Font.Name, Font.Size]);

  hpLog.SetHtmlFromStr(log + FLog);
  Application.ProcessMessages;
  //hpLog.Scroll(hsaEnd, 0);
  hpLog.MasterFrame.Viewer.Scroll(hsaEnd, 0);
  Application.ProcessMessages;
end;

procedure TdframEditor.ApplyGrid;
var
  cou: Integer;
begin
  with FGridAttr, sgData do
  begin
    Font.Name := CellFont.Name;
    Font.Size := CellFont.Size;
    Font.Style := CellFont.Style;
    Font.Quality := CellFont.Quality;
    Font.Color := CellFont.Color;
    Color := Background;
    AlternateColor := OddRowColor;
    TitleFont.Color := Title_Font.Color;
    TitleFont.Size := Title_Font.Size;
    TitleFont.Style := Title_Font.Style;
    TitleFont.Quality := Title_Font.Quality;
    TitleFont.Name := Title_Font.Name;
    TitleStyle := Title_Style;
    for cou := 0 to sgData.Columns.Count - 1 do
    begin
      sgData.Columns[cou].Title.Color := FGridAttr.Title_Background;
      sgData.Columns[cou].Alignment := taCenter;
    end;
  end;
end;

procedure TdframEditor.LogInfo(ALog: String);
begin
  ALog := ReplaceStr(ALog, LineEnding, '<br>');
  with FLogAttr do
    FLog += Format(
      '<font color="%s">%s<br></font>',
      [ColorToHTML(Information.Foreground), ALog]);
  ShowLog;
end;

procedure TdframEditor.LogDetail(ALog: String);
begin
  ALog := ReplaceStr(ALog, LineEnding, '<br>');
  with FLogAttr do
    FLog += Format(
      '<font color="%s">%s<br></font>',
      [ColorToHTML(Detail.Foreground), ALog]);
  ShowLog;
end;

procedure TdframEditor.LogError(ALog: String);
begin
  ALog := ReplaceStr(ALog, LineEnding, '<br>');
  with FLogAttr do
    FLog += Format(
      '<font color="%s">%s<br></font>',
      [ColorToHTML(Error.Foreground), ALog]);
  ShowLog;
end;

procedure TdframEditor.CheckActions;
begin
  CheckTransaction;
  actHistoryNext.Enabled := (FHistoryIndex <> -1) and (FHistoryIndex < DFrames.HistoryCount);
  actHistoryPervious.Enabled := DFrames.HistoryCount > 0;
end;

procedure TdframEditor.ConfigChanged;
begin
  //inherited ConfigChanged;
  TDFrmSettings.LoadTheme(synSqlEditor, TSynSQLSyn(synSqlEditor.Highlighter), FLogAttr, FGridAttr, DFrames.EditorTheme, DFrames.EditorThemeName);
  ApplyGrid;
end;

procedure TdframEditor.MetaDataChanged;
var
  obj: TDObjectNode;
  tobj: TDTypedObjectNode;
  typ: String;
begin
  //In case of updating/deleting/creating meta objects(tbl,fn,proc,...)
  //this cause of discarding deleted/updated object names
  with DatabaseNode do
  begin
    case Version of
      dfb21,
      dfb25: SynSQLSynMain.SQLDialect := sqlInterbase6;
      dfb3: SynSQLSynMain.SQLDialect := sqlFirebird3;
    end;
    SynSQLSynMain.InitKeywords;
    for tobj in DomainsNode.Fields do
      SynSQLSynMain.AddKeyword(tobj.ExactName, tkDatatype);

    for obj in TabelsNode.Tabels do
      SynSQLSynMain.AddKeyword(obj.ExactName, tkTableName);

    //for obj in ViewsNode.Tabels do
    //  SynSQLSynMain.AddKeyword(obj.ExactName, tkTableName);
    //
    //for obj in SysTabelsNode.Tabels do
    //  SynSQLSynMain.AddKeyword(obj.ExactName, tkTableName);

    for obj in ViewsNode.Tabels do
      SynSQLSynMain.TableNames.Add(obj.ExactName);

    for obj in SysTabelsNode.Tabels do
      SynSQLSynMain.TableNames.Add(obj.ExactName);

    for obj in ProceduresNode.Tabels do
      SynSQLSynMain.AddKeyword(obj.ExactName, tkFunction);

    for obj in UFunctionsNode.Tabels do
      SynSQLSynMain.AddKeyword(obj.ExactName, tkFunction);

    for tobj in ExceptionsNode.Fields do
    try
      SynSQLSynMain.AddKeyword(tobj.ExactName, tkException);
    except
      on E: Exception do
      begin
        DriteLn(tobj.ExactName + ' is an exception that already is definded somewhere!');
      end;
    end;

    //for typ in DatabaseNode.Types do
    //  SynSQLSynMain.AddKeyword(typ, tkDatatype);

    if Version = dfb3 then
    begin
      for obj in FunctionsNode.Tabels do
        SynSQLSynMain.AddKeyword(obj.ExactName, tkFunction);
    end;
  end;
end;

procedure TdframEditor.Showing;
begin
  ShowLog;
  if FExecuteOnShow then
  begin
    actSqlGoExecute(actSqlGo);
  end;
end;

procedure TdframEditor.Entering;
begin
  DFrames.CurrentEditor := Self;
  alActions.State := asNormal;
  ToolBar1.Enabled := True;
  synSqlEditor.SetFocus;
end;

procedure TdframEditor.Exiting;
begin
  alActions.State := asSuspended;
  ToolBar1.Enabled := False;
end;

end.
