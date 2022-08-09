unit duDSqlNodes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms, db, sqldb,
  //IBDatabase,
  //IBSQL,
  //IBQuery, IB, IBDatabaseInfo,
  uibase,
  uib, uiblib,
  ComCtrls,
  duTypes, duConsts, duUtil, Dialogs, Menus,
  SynHighlighterSQL, SynEdit, SynEditLines, Graphics,
  Debio.Types,
  Debio.Utils.RunTime;
type

  { TDNodeInfo }

  TDNodeInfo = class(TComponent)
  private
    class var
     VLockPopUP: Boolean;
  private
    FCaption: String;
    FHint: String;
    FNode: TTreeNode;
    FNodeSqlObjectType: TDNodeType;
    FIndex: Integer;
    procedure SetCaption(AValue: String);
    procedure SetHint(AValue: String);

  protected
    property Index: Integer read FIndex;

  public
    property Hint: String read FHint write SetHint;
    property Caption: String read FCaption write SetCaption;
    property Node: TTreeNode read FNode;
    property NodeSqlObjectType: TDNodeType read FNodeSqlObjectType;
    constructor Create(ACaption, AHint: String; ANodeType: TDNodeType; ANode: TTreeNode); virtual;
    procedure DeleteIt(Refresh: Boolean = False); virtual;
    destructor Destroy; override;
    class property LockPopup: Boolean read VLockPopUP;
  end;

  TDServerType = (dstServer, dstLocalhost, dstEmbedded);

const
  CDServerType : array[TDServerType] of String = ('Server', 'Localhost', 'Embedded');

operator :=(RT: String): TDServerType;
operator :=(RT: TDServerType): String;

type

  { TDServerNode }

  TDServerNode = class(TDNodeInfo)
  private
    FLibName: String;
    FLibPath: String;
    FLockDir: String;
    FTmpDir: String;
    FServerAddress: String;
    FServerPort: String;
    FMachineType: TDServerType;
    procedure SetServerAddress(AValue: String);
  public
    property Index;
    property ServerAddress: String read FServerAddress write SetServerAddress;
    property ServerPort: String read FServerPort write FServerPort;
    property LibName: String read FLibName write FLibName;
    property LibPath: String read FLibPath write FLibPath;
    property LockDir: String read FLockDir write FLockDir;
    property TmpDir: String read FTmpDir write FTmpDir;
    property MachineType: TDServerType read FMachineType write FMachineType;
    constructor Create(ACaption, AHint, AServerAddress, AServerPort, ALibName, ALibPath, ATmpDir, ALockDir: String; AMachineType: TDServerType; AIndex: Integer; ANode: TTreeNode); virtual;
  end;

  TDObjectCollectionNode = class;
  TDObjectNode = class;
  TDTypedObjectNode = class;
  TDObjectCollection = array of TDObjectNode;
  TDTypedObjectCollection = array of TDTypedObjectNode;

  { TDDatabaseNode }

  TDDatabaseNode = class(TDNodeInfo)
  private
    class var
      ConnectedDatabases : TList;
  private
    FDatabaseName: String;
    FServerNode: TDServerNode;
    //FConnection: TIBDataBase;
    //FConnectionInfo: TIBDatabaseInfo;
    FConnection: TUIBDataBase;
    //FConnectionInfo: TIBDatabaseInfo;
    //FTransaction: TIBTransaction;
    FTransaction: TUIBTransaction;
    FDomainsNode: TDObjectNode;
    FSequencesNode: TDObjectNode;
    FTabelsNode: TDObjectCollectionNode;
    FSysTabelsNode: TDObjectCollectionNode;
    FVersion: TDFirebirdVersion;
    FViewsNode: TDObjectCollectionNode;
    FProceduresNode: TDObjectCollectionNode;
    FFunctionsNode: TDObjectCollectionNode;
    FUFunctionsNode: TDObjectCollectionNode;
    FTriggersNode: TDObjectNode;
    FIndeciessNode: TDObjectNode;
    FExceptionsNode: TDObjectNode;
    FAvailables: TStringList;
    FAlisables: TStringList;
    FCharsets: TStringList;
    FCollations: TStringList;
    FReservedWords: TStringList;
    FFunctions: TStringList;
    FTypes: TStringList;
    FHighlighter: TSynSQLSyn;
    FHighlighterInUse: Integer;
    FCharSet: String;
    function GetConnected: Boolean;
    function GetConnection: TUIBDataBase;
    procedure SetConnected(AValue: Boolean);
    procedure RemoveMetadataNodes(RequestedMetaData: TDRetriveMetaData);
    procedure ProcessMessages; inline;
    procedure UpdateHighliter;
  public
    property Index;
    property ServerNode: TDServerNode read FServerNode;
    property DomainsNode: TDObjectNode read FDomainsNode;
    property TabelsNode: TDObjectCollectionNode read FTabelsNode;
    property TriggersNode: TDObjectNode read FDomainsNode;
    property SequensesNode: TDObjectNode read FDomainsNode;
    property IndicesNode: TDObjectNode read FDomainsNode;
    property SysTabelsNode: TDObjectCollectionNode read FSysTabelsNode;
    property ViewsNode: TDObjectCollectionNode read FViewsNode;
    property ExceptionsNode: TDObjectNode read FExceptionsNode;
    property ProceduresNode: TDObjectCollectionNode read FProceduresNode;
    property FunctionsNode: TDObjectCollectionNode read FFunctionsNode;
    property UFunctionsNode: TDObjectCollectionNode read FUFunctionsNode;
    //property Connection: TIBDataBase read FConnection;
    //property ConnectionInfo: TIBDatabaseInfo read FConnectionInfo;
    //property Transaction: TIBTransaction read FTransaction;
    property Connection: TUIBDataBase read GetConnection;
    //property ConnectionInfo: TIBDatabaseInfo read FConnectionInfo;
    property Transaction: TUIBTransaction read FTransaction;
    property DatabaseName: String read FDatabaseName write FDatabaseName;
    property CharSet: String read FCharSet write FCharSet;
    property Availables: TStringList read FAvailables;
    property Aliasables: TStringList read FAlisables;
    property Collations: TStringList read FCollations;
    property Charsets: TStringList read FCharsets;
    property Version: TDFirebirdVersion read FVersion;
    property ReservedWords: TStringList read FReservedWords;
    property Functions: TStringList read FFunctions;
    property Types: TStringList read FTypes;
    property Highlighter: TSynSQLSyn read FHighlighter write FHighlighter;
    procedure Connect;
    procedure Disconnect;
    procedure RetriveMetaData(RequestedMetaData: TDRetriveMetaData);
    procedure RefreshAvailables;

    function RetriveFunctionBody(Fn: String): String;
    function RetriveStoredProcedureBody(Fn: String): String;
    function RetriveTriggerBody(Trig: String): String;
    function RetriveViewBody(AView: String): String;
    function RetriveExceptionText(AException: String): String;
    function GetSequenceValue(SeqName: String): Integer;
    function ExactObjectName(ObjectName: String): String;

    property Connected: Boolean read GetConnected write SetConnected;
    procedure AddMetaData(List: TStringList);
    constructor Create(ACaption, ADatabaseName, ACharSet, AHint: String; AIndex: Integer; ANode: TTreeNode); virtual;
    destructor Destroy; override;
    procedure IncreaseHighlighterInuse;
    procedure DecreaseHighlighterInUse;
    class Function CloseQuery: Boolean;
    class function NewConnection(AServerNode: TDServerNode; AOwner: TComponent): TUIBDataBase;
  end;

  { TDDatabaseObjectNode }

  TDDatabaseObjectNode = class(TDNodeInfo)
  private
    FDatabseNode: TDDatabaseNode;
    FObjectName: String;
    constructor Create(ACaption, AHint: String; ANodeType: TDNodeType; ANode: TTreeNode); override;
    function GetExactName: String; inline;
    function GetSqlObjectType: String;
  public
    property DatabaseNode: TDDatabaseNode read FDatabseNode;
    property ObjectName: String read FObjectName;
    property NodeSqlObjectType;
    property ExactName: String read GetExactName;
    property SqlObjectType: String read GetSqlObjectType;
    constructor Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode); virtual;
  end;


  { TDObjectCollectionNode }

  TDObjectCollectionNode = class(TDDatabaseObjectNode)
  private
    FTabels: TDObjectCollection;
  public
    property Tabels: TDObjectCollection read FTabels;
    procedure DeleteIt(Refresh: Boolean = False); override;
    constructor Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode); override;
    destructor Destroy; override;
    function IndexOf(AObjectName: String): Integer;
  end;

  { TDObjectNode }

  TDObjectNode = class(TDDatabaseObjectNode)
  private
    FFields: TDTypedObjectCollection;
  public
    property Fields: TDTypedObjectCollection read FFields;
    function FieldByName(AName: String): TDTypedObjectNode;
    procedure DeleteIt(Refresh: Boolean = False); override;
    constructor Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode); override;
    destructor Destroy; override;
  end;

  { TDTypedObjectNode }

  TDTypedObjectNode = class(TDDatabaseObjectNode)
  private
    FObjectType: String;
    FExData: Pointer;
    property Name;
  public
    property ObjectType: String read FObjectType;
    property ExData: Pointer read FExData;
    constructor Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode); override;
    destructor Destroy; override;
  end;

function ExactSqlObjectName(ObjectName: String; ADatabaseNode: TDDatabaseNode): String;
implementation

uses dudmMainModule, duFrmDSqlMain, duFrmLogin, duFrames;

var
  //Keep the loaded embedded library
  EmbeddedLibraryLoaded: String = '';
  //Keep the loaded embedded library`s path
  EmbeddedLibraryPath: String = '';

  //Counting every usage of the above settings
  EmbeddedReferenceCount: Integer = 0;

  //This one just keep orginal PATH(Win)/LD_LIBRARY_PATH(Unix)
  //in case of embedded connection
  PATH_LD : String = '';

const
  //Name of the EnvVarName of the platform that needs modifying in case of
  //Embedded!
{$IfDef MSWINDOWS}
  CPATH_LD = 'PATH';
{$EndIf}
{$IfDef UNIX}
  CPATH_LD = 'LD_LIBRARY_PATH';
{$ENDIF}

type

  { TDMetaDatRetriver }

  TDMetaDatRetriver = class(TComponent)
  private
    DatanaseNode: TDDatabaseNode;
    Node: TTreeNode;
    //QSql: TIBSQL;
    //QTra: TIBTransaction;
    //QSqlF: TIBSQL;
    //QTraF: TIBTransaction;
    QSql:  TUIBQuery;
    QTra:  TUIBTransaction;
    QSqlF: TUIBQuery;
    QTraF: TUIBTransaction;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RetriveList(List: TStringList; Query: String; ObjectType: TDSqlWordtype);
    procedure RetriveObjects(var ANode: TDObjectNode; NodeName: String; NodeType, NodesType: TDNodeType; SqlNode, NodesSeprator: String; Refresh: Boolean);
    procedure RetriveObjects(var ANode: TDObjectNode; NodeName: String; NodeType: TDNodeType; NodesType: TDNodeForms; SqlNode, NodesSeprator: String; Refresh: Boolean);
    procedure RetriveTables(var ANode: TDObjectCollectionNode; NodeName: String; NodeType, NodesType: TDNodeType; FieldsType: TDNodeForms; SqlNode, NodesSeprator: String; Refresh: Boolean);
    destructor Destroy; override;
  end;

operator := (RT: String): TDServerType;
begin
  case LowerCase(RT) of
    'server': Result := dstServer;
    'localhost': Result := dstLocalhost;
    'embedded': Result := dstEmbedded;
  end;
end;

operator := (RT: TDServerType): String;
begin
  case RT of
    dstServer: Result := 'Server';
    dstLocalhost: Result := 'Localhost';
    dstEmbedded: Result := 'Embedded';
  end;
end;

function ExactSqlObjectName(ObjectName: String; ADatabaseNode: TDDatabaseNode): String;
begin
  if (not (ObjectName[1] in ['A'..'Z', '$', '_'])) or (ObjectName <> UpperCase(ObjectName)) or (ADatabaseNode.ReservedWords.IndexOf(UpperCase(ObjectName)) > -1) then
  begin
    if (ObjectName[1] = '"') and (ObjectName[Length(ObjectName)] = '"') then
      Exit(ObjectName);
    if (ObjectName[1] = '"') and (ObjectName[Length(ObjectName)] <> '"') then
      Exit(ObjectName + '"');
    if (ObjectName[1] <> '"') and (ObjectName[Length(ObjectName)] = '"') then
      Exit('"' + ObjectName);
    if (ObjectName[1] <> '"') and (ObjectName[Length(ObjectName)] <> '"') then
      Exit('"' + ObjectName + '"');
  end
  else
  begin
    Result := ObjectName;
    if not DFrames.SQLIdentifireUpperCase then
      Result := LowerCase(Result);
  end;
end;

{ TDMetaDatRetriver }

constructor TDMetaDatRetriver.Create(AOwner: TComponent);
var
 mcou, scou, SC, IC, UC, DC: Integer;
 PTyp: LongInt;
 //cur, curf: IResultSet;
 ObjType: TDNodeType;
begin
  inherited Create(AOwner);
   DatanaseNode := TDDatabaseNode(Owner);
   Node := DatanaseNode.Node;
   //QTra := TIBTransaction.Create(Self);
   //QTra.DefaultDatabase := DatanaseNode.Connection;
   //QSql := TIBSQL.Create(Self);
   //QSql.DataBase := DatanaseNode.Connection;
   //QSql.Transaction := QTra;
   //
   //QTraF := TIBTransaction.Create(Self);
   //QTraF.DefaultDatabase := DatanaseNode.Connection;
   //QSqlF := TIBSQL.Create(Self);
   //QSqlF.DataBase := DatanaseNode.Connection;
   //QSqlF.Transaction := QTra;
   //
   //QTra.StartTransaction;
   //QTraF.StartTransaction;
   QTra := TUIBTransaction.Create(Self);
   QTra.DataBase := DatanaseNode.Connection;
   with QTra do
   begin
     AutoStart := True;
     AutoStop := False;
     DefaultAction := etmStayIn;
   end;
   QSql := TUIBQuery.Create(Self);
   QSql.DataBase := DatanaseNode.Connection;
   QSql.Transaction := QTra;
   QSql.CachedFetch := False;
   QSql.FetchBlobs := True;;

   QTraF := TUIBTransaction.Create(Self);
   QTraF.DataBase := DatanaseNode.Connection;
   with QTraF do
   begin
     AutoStart := True;
     AutoStop := False;
     DefaultAction := etmStayIn;
   end;
   QSqlF := TUIBQuery.Create(Self);
   QSqlF.DataBase := DatanaseNode.Connection;
   QSqlF.Transaction := QTra;
   QSqlF.CachedFetch := False;
   QSqlF.FetchBlobs := True;;

   //QTra.StartTransaction;
   //QTraF.StartTransaction;
end;

procedure TDMetaDatRetriver.RetriveList(List: TStringList; Query: String; ObjectType: TDSqlWordtype);
//var
//  cur: IResultSet;
var
  cur: TSQLResult;
begin
  try
    //QSql.SQL.Text := Query;
    //QSql.Prepare;
    //if QSql.Prepared then
    //begin
    //  cur := QSql.Statement.OpenCursor(QSql.Transaction.TransactionIntf);
    //  while cur.FetchNext do
    //    List.AddObject(Trim(cur.Data[0]{byname('TITLE')}.AsString), TObject(Pointer(PtrInt(ObjectType))));
    //  cur.Close;
    //end;
    QSql.SQL.Text := Query;
    QSql.Prepare;
    QSql.Open;
    while not QSql.Eof do
    begin
      cur := QSql.Fields;
      List.AddObject(Trim(QSql.Fields.AsString[0]), TObject(Pointer(PtrInt(ObjectType))));
      QSql.Next;
    end;
  finally
  end;
end;

procedure TDMetaDatRetriver.RetriveObjects(var ANode: TDObjectNode; NodeName: String; NodeType, NodesType: TDNodeType; SqlNode, NodesSeprator: String; Refresh: Boolean);
var
  mcou: Integer;
  ObjName, Hint: String;
  pnd, nd: TTreeNode;
  cur: TSQLResult;
  //cur: IResultSet;
begin
  mcou := 0;
  if not Refresh then
  begin
    pnd := Node.Owner.AddChild(Node, '');
    pnd.Data := TDObjectNode.Create(NodeName, NodeName, '', NodeType, pnd, DatanaseNode);
    ANode := TDObjectNode(pnd.Data);
    pnd.ImageIndex := c_DNodeImageIndex[NodeType];
    pnd.SelectedIndex := c_DNodeImageIndex[NodeType];
  end
  else
    pnd := ANode.Node;
  pnd.Selected :=  True;
  SetLength(ANode.FFields, 0);
  QSql.SQL.Text := SqlNode;
  QSql.CloseCursor;
  QSql.Prepare;
  QSql.Open;
  //if QSql.Prepared then
  //begin
    //cur := QSql.Statement.OpenCursor(QSql.Transaction.TransactionIntf);
    //while cur.FetchNext do
    cur := QSql.Fields;
    while not QSql.Eof do
    begin
      nd := Node.Owner.AddChild(pnd, '');
      //ObjName := Trim(cur.Data[0]{ByName('NAME')}.AsString);
      ObjName := Trim(cur.AsString[0]);
      Hint := '';
      //if not cur.Data[1].IsNull then
      if not cur.IsNull[1] then
      begin
        //Hint += Trim(cur.Data[1].AsString);
        Hint += Trim(cur.AsString[1]);
        if not Hint.IsEmpty then
          Hint := '--' + Hint;
      end;
      //if not cur.Data[2].IsNull then
      if not cur.IsNull[2] then
      begin
        Hint += LineEnding;
        Hint += Trim(cur.AsString[2]);
        //Hint += Trim(cur.Data[2].AsString);
      end;
      nd.Data := TDTypedObjectNode.Create(ObjName, ObjName, Trim(Hint), NodesType, nd, DatanaseNode);
      nd.ImageIndex := c_DNodeImageIndex[NodesType];
      nd.SelectedIndex := c_DNodeImageIndex[NodesType];
      SetLength(ANode.FFields, Length(ANode.FFields) + 1);

      ANode.FFields[mcou] := TDTypedObjectNode(nd.Data);
      //ANode.FFields[mcou].FObjectType := Trim(cur.Data[1]{ByName('TYPE')}.AsString);
      ANode.FFields[mcou].FObjectType := Trim(cur.AsString[1]);

      Inc(mcou);
      QSql.Next;
    end;
  //  cur.Close;
  //end;

  if not Refresh then
    pnd.Collapse(True)
  else
    pnd.Expand(True);
  pnd.Text := NodeName + '(' + mcou.ToString +')';
end;

procedure TDMetaDatRetriver.RetriveObjects(var ANode: TDObjectNode; NodeName: String; NodeType: TDNodeType; NodesType: TDNodeForms; SqlNode, NodesSeprator: String; Refresh: Boolean);
var
  pnd, nd: TTreeNode;
  //cur: IResultSet;
  ObjName: String;
  ObjType: TDNodeType;
  mcou: Integer;
  cur: TSQLResult;
begin
  mcou := 0;

  if not Refresh then
  begin
    pnd := Node.Owner.AddChild(Node, '');
    pnd.Data := TDObjectNode.Create(NodeName, NodeName, '', NodeType, pnd, DatanaseNode);
    ANode := TDObjectNode(pnd.Data);
    pnd.ImageIndex := c_DNodeImageIndex[NodeType];
    pnd.SelectedIndex := c_DNodeImageIndex[NodeType];
  end
  else
    pnd := ANode.Node;
  pnd.Selected :=  True;

  SetLength(ANode.FFields, 0);
  QSql.SQL.Text := SqlNode;
  QSql.Prepare;
  QSql.Open;
  //if QSql.Prepared then
  //begin
    //cur := QSql.Statement.OpenCursor(QSql.Transaction.TransactionIntf);
    cur := QSql.Fields;
    //while cur.FetchNext do
    while not QSql.Eof do
    begin
      nd := Node.Owner.AddChild(pnd, '');
      //ObjName := Trim(cur.Data[0]{ByName('NAME')}.AsString);
      //ObjType := NodesType[cur.Data[3].AsInteger = 1];
      //nd.Data := TDTypedObjectNode.Create(ObjName, Trim(cur.Data[1]{ByName('TYPE')}.AsString) + NodesSeprator + ObjName, Trim(cur.Data[2]{ByName('COMMENT')}.AsString), ObjType, nd, DatanaseNode);
      ObjName := Trim(cur.AsString[0]);
      ObjType := NodesType[cur.AsInt64[3] = 1];
      nd.Data := TDTypedObjectNode.Create(ObjName, Trim(cur.AsString[1]) + NodesSeprator + ObjName, Trim(cur.AsString[2]), ObjType, nd, DatanaseNode);
      nd.ImageIndex := c_DNodeImageIndex[ObjType];
      nd.SelectedIndex := c_DNodeImageIndex[ObjType];
      SetLength(ANode.FFields, Length(ANode.FFields) + 1);

      ANode.FFields[mcou] := TDTypedObjectNode(nd.Data);
      //ANode.FFields[mcou].FObjectType := Trim(cur.Data[1].AsString);
      //ANode.FFields[mcou].FExData := Pointer(PtrInt(cur.Data[3].AsInteger));
      ANode.FFields[mcou].FObjectType := Trim(cur.AsString[1]);
      ANode.FFields[mcou].FExData := Pointer(PtrInt(cur.AsInt64[3]));

      Inc(mcou);
      QSql.Next;
    end;
  //  cur.Close;
  //end;
  if not Refresh then
    pnd.Collapse(True)
  else
    pnd.Expand(True);
  pnd.Text := NodeName + '(' + mcou.ToString +')';
end;

procedure TDMetaDatRetriver.RetriveTables(var ANode: TDObjectCollectionNode; NodeName: String; NodeType, NodesType: TDNodeType; FieldsType: TDNodeForms; SqlNode, NodesSeprator: String; Refresh: Boolean);
var
  pnd, nd, fnd: TTreeNode;
  mcou, scou: Integer;
  //cur, curf: IResultSet;
  ObjName, fn: String;
  Keys: TStringList;
  ft: TDNodeType;
  cur, curf: TSQLResult;
begin
  if not Refresh then
  begin;
    pnd := Node.Owner.AddChild(Node, '');
    pnd.Data := TDObjectCollectionNode.Create(NodeName, NodeName, '', NodeType, pnd, DatanaseNode);
    ANode := TDObjectCollectionNode(pnd.Data);
    pnd.ImageIndex := 3;
    pnd.SelectedIndex := 3;

    pnd.Selected := True;
    //ProcessMessages;
  end
  else
    pnd := ANode.Node;
  QSql.SQL.Text := SqlNode;
  QSql.Prepare;
  mcou := 0;
  //if QSql.Prepared then
  //begin
    QSql.Open;
    //cur := QSql.Statement.OpenCursor(QSql.Transaction.TransactionIntf);
    cur := QSql.Fields;
    //while cur.FetchNext do
    //while cur.FetchNext do
    while not QSql.Eof do
    begin
      nd := Node.Owner.AddChild(pnd, '');
      //ObjName := Trim(cur.ByName('NAME').AsString);
      ObjName := Trim(cur.ByNameAsString['NAME']);
      //nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByName('COMMENT').AsString), NodesType, nd, DatanaseNode);
      nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByNameAsString['COMMENT']), NodesType, nd, DatanaseNode);
      nd.ImageIndex := c_DNodeImageIndex[NodesType];
      nd.SelectedIndex := c_DNodeImageIndex[NodesType];
      SetLength(ANode.FTabels, Length(ANode.FTabels) + 1);
      ANode.FTabels[mcou] := TDObjectNode(nd.Data);
      Keys := Nil;
      QSqlF.SQL.Text := C_Sql_Retrive_Table_PF_Key;
      QSqlF.Prepare;
      //if QSqlF.Prepared then
      //begin
        //QSqlF.ParamByName('TBL').AsString := nd.Text;
        //curf := QSqlF.Statement.OpenCursor(QSqlF.Transaction.TransactionIntf);
        QSqlF.Params.ByNameAsString['TBL'] := nd.Text;
        //curf := QSqlF.Statement.OpenCursor(QSqlF.Transaction.TransactionIntf);
        QSqlF.Open;
        curf := QSqlF.Fields;
        //FK := Nil;
        //while curf.FetchNext do
        while not QSqlF.Eof do
        begin
          if not Assigned(Keys) then
            Keys := TStringList.Create;
          //case curf[1].AsString of
          case curf.AsString[1] of
            //'PRIMARY KEY': Keys.AddObject(curf[0].AsString + '=No Foreign :)', TObject(Pointer(PtrInt(Ord(dntTablePmKey)))));
            //'FOREIGN KEY': Keys.AddObject(curf[0].AsString + '=No matter yet ;)'{ + curf[2].AsString}, TObject(Pointer(PtrInt(Ord(dntTableFgKey)))));
            'PRIMARY KEY': Keys.AddObject(curf.AsString[0] + '=No Foreign :)', TObject(Pointer(PtrInt(Ord(dntTablePmKey)))));
            'FOREIGN KEY': Keys.AddObject(curf.AsString[0] + '=No matter yet ;)'{ + curf[2].AsString}, TObject(Pointer(PtrInt(Ord(dntTableFgKey)))));
          end;
          QSqlF.Next;
        end;
        //curf.Close;
      //end;

      QSqlF.SQL.Text := C_Sql_Retrive_Table_Fields;
      QSqlF.Prepare;
      //if QSqlF.Prepared then
      //begin
      //  QSqlF.ParamByName('TBL').AsString := nd.Text;
      //  curf := QSqlF.Statement.OpenCursor(QSqlF.Transaction.TransactionIntf);
        QSqlF.Params.ByNameAsString['TBL'] := nd.Text;
        QSqlF.Open;
        curf := QSqlF.Fields;
        SetLength(ANode.FTabels[mcou].FFields, 0);
        scou := 0;
        //while curf.FetchNext do
        while not QSqlF.Eof do
        begin
          fnd := Node.Owner.AddChild(nd, '');
          //fn := Trim(curf.ByName('FIELD_NAME').AsString);
          fn := Trim(curf.ByNameAsString['FIELD_NAME']);
          fnd.Data := TDTypedObjectNode.Create(fn,
            //fn + ':  ' + Trim(curf.ByName('FIELD_TYPE').AsString), Trim(curf.ByName('COMMENT').AsString), dntTableField, fnd, DatanaseNode);
            fn + ':  ' + Trim(curf.ByNameAsString['FIELD_TYPE']), Trim(curf.ByNameAsString['COMMENT']), dntTableField, fnd, DatanaseNode);
          SetLength(ANode.FTabels[mcou].FFields, Length(ANode.FTabels[mcou].FFields) + 1);
          ANode.FTabels[mcou].FFields[scou] := TDTypedObjectNode(fnd.Data);
          //if Assigned(Keys) then WriteLn(Keys.Text, Keys.IndexOf(fn));
          if Assigned(Keys) and (Keys.IndexOfName(fn) > -1) then
          begin
            ft := TDNodeType(PtrInt(Keys.Objects[Keys.IndexOfName(fn)]));
            //if ft = dntTableFgKey then
            //  ANode.FTabels[mcou].FFields[scou].FHint := Trim('--' + Keys.ValueFromIndex[Keys.IndexOfName(fn)] + '' + LineEnding +
            //    ANode.FTabels[mcou].FFields[scou].FHint);
          end
          else
            ft := dntTableField;
          //if not curf[2].IsNull then
          if not curf.IsNull[2] then
          begin
            ft := dntTableComtd;
            //ANode.FTabels[mcou].FFields[scou].FHint := Trim('--Computed By(' + Trim(curf[2].AsString) + ')' + LineEnding +
            ANode.FTabels[mcou].FFields[scou].FHint := Trim('--Computed By(' + Trim(curf.AsString[2]) + ')' + LineEnding +
              ANode.FTabels[mcou].FFields[scou].FHint);
          end;
          ANode.FTabels[mcou].FFields[scou].FNodeSqlObjectType := ft;
          //ANode.FTabels[mcou].FFields[scou].FObjectType := Trim(curf.ByName('FIELD_TYPE').AsString);
          ANode.FTabels[mcou].FFields[scou].FObjectType := Trim(curf.ByNameAsString['FIELD_TYPE']);
          fnd.ImageIndex := c_DNodeImageIndex[ft];
          fnd.SelectedIndex := c_DNodeImageIndex[ft];
          Inc(scou);
          QSqlF.Next;
        end;
      //  curf.Close;
      //end;
      if Assigned(Keys) then
        FreeAndNil(Keys);
      QTraF.CommitRetaining;
      Inc(mcou);
      QSql.Next;
    end;
  //  cur.Close;
  //end;
  pnd.Text := NodeName + '(' + mcou.ToString + ')';
  if not Refresh then
    pnd.Collapse(True)
  else
    pnd.Expand(False);
end;

destructor TDMetaDatRetriver.Destroy;
begin
  QSql.Free;
  QTra.RollBack;
  QTra.Free;
  QSqlF.Free;
  QTraF.RollBack;
  QTraF.Free;
  inherited Destroy;
end;

{ TDDatabaseObjectNode }

constructor TDDatabaseObjectNode.Create(ACaption, AHint: String; ANodeType: TDNodeType; ANode: TTreeNode);
begin
  //inherited Create(ACaption, AHint, ANodeType, ANode);
  raise Exception.Create('Databsae objects mus call their constructor`s!');
end;

function TDDatabaseObjectNode.GetExactName: String;
begin
  Result := ExactSqlObjectName(FObjectName, FDatabseNode);
end;

function TDDatabaseObjectNode.GetSqlObjectType: String;
begin
  case FNodeSqlObjectType of
    //dntHome: ;
    //dntServer: ;
    //dntDatabase: ;
    //dntMetaDataCollection: ;
    //dntTables: ;
    dntTable:           Result := 'TABLE';
    dntTablePmKey:      Result := '';
    dntTableFgKey:      Result := '';
    dntTableField:      Result := '';
    dntTableComtd:      Result := '';
    dntProcedure:       Result := 'PROCEDURE';
    dntSequence:        Result := 'SEQUENSE';
    dntView:            Result := 'VIEW';
    dntException:       Result := 'EXCEPTION';
    dntUserDFunction:   Result := 'EXTERNAL FUNCTION';
    dntFunction:        Result := 'FUNCTION';
    dntDomain:          Result := 'DOMAIN';
    dntTriggerActive,
    dntTriggerInactive: Result := 'TRIGGER';
    dntIndexActive,
    dntIndexInActive:   Result := 'INDEX';
  end;
end;

constructor TDDatabaseObjectNode.Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode);
begin
  inherited Create(ACaption, AHint, AObjectType, ANode);
  FObjectName := AObjectName;
  FDatabseNode := ADatabaseNode;
end;

{ TDTypedObjectNode }

constructor TDTypedObjectNode.Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode);
begin
  inherited Create(AObjectName, ACaption, AHint, AObjectType, ANode, ADatabaseNode);
  FExData := Nil;
end;

destructor TDTypedObjectNode.Destroy;
begin
  inherited Destroy;
end;

{ TDObjectNode }

function TDObjectNode.FieldByName(AName: String): TDTypedObjectNode;
var
  fld: TDTypedObjectNode;
begin
  for fld in FFields do
    if (fld.ObjectName = AName) or (fld.ExactName = AName) then
      Exit(fld);
  Exit(Nil);
end;

procedure TDObjectNode.DeleteIt(Refresh: Boolean);
var
  Field: TDTypedObjectNode;
begin
  for Field in FFields do
    Field.DeleteIt(False);
  FFields := Nil;
  inherited DeleteIt(Refresh);
end;

constructor TDObjectNode.Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode);
begin
  inherited Create(AObjectName, ACaption, AHint, AObjectType, ANode, ADatabaseNode);
  FFields := Nil;
end;

destructor TDObjectNode.Destroy;
begin
  inherited Destroy;
end;

{ TDObjectCollectionNode }

procedure TDObjectCollectionNode.DeleteIt(Refresh: Boolean);
var
  Tabel: TDObjectNode;
begin
  for Tabel in FTabels do
    Tabel.DeleteIt(Refresh);
  FTabels := Nil;
  inherited DeleteIt(Refresh);
end;

constructor TDObjectCollectionNode.Create(AObjectName, ACaption, AHint: String; AObjectType: TDNodeType; ANode: TTreeNode; ADatabaseNode: TDDatabaseNode);
begin
  inherited Create(AObjectName, ACaption, AHint, AObjectType, ANode, ADatabaseNode);
  FTabels := nil;
end;

destructor TDObjectCollectionNode.Destroy;
begin
  inherited Destroy;
end;

function TDObjectCollectionNode.IndexOf(AObjectName: String): Integer;
var
  cou: Integer;
begin
  Result := -1;
  for cou := 0 to Length(FTabels) -1 do
  begin
    if FTabels[cou].ObjectName = AObjectName then
      Exit(cou);
  end;
end;

{ TDNodeInfo }

procedure TDNodeInfo.SetHint(AValue: String);
begin
  if FHint = AValue then Exit;
  FHint := AValue;
end;

constructor TDNodeInfo.Create(ACaption, AHint: String; ANodeType: TDNodeType; ANode: TTreeNode);
begin
  inherited Create(ANode.TreeView);
  if ACaption = '' then
    raise Exception.Create('Unamed Node?');
  FCaption := ACaption;
  FHint := AHint;
  FNode := ANode;
  FNodeSqlObjectType := ANodeType;
  Node.Text := FCaption;
  Node.ImageIndex := C_DNodeImageIndex[ANodeType];
  Node.SelectedIndex := C_DNodeImageIndex[ANodeType];
end;

procedure TDNodeInfo.DeleteIt(Refresh: Boolean);
begin
  if Refresh and (FNodeSqlObjectType in [dntTables, dntSysTables, dntProcedures,
      dntSequences, dntViews, dntExceptions, dntUserDFunctions, dntFunctions,
      dntDomains, dntTriggers, dntIndices]) then
    Exit;
  FNode.Free;
  FNode := Nil;
  Free;
end;

destructor TDNodeInfo.Destroy;
begin
  //Log('destructor', Self.ClassName + ' ~ ' + Caption);
  inherited Destroy;
end;

procedure TDNodeInfo.SetCaption(AValue: String);
begin
  if FCaption = AValue then Exit;
  FCaption := AValue;
  Node.Text := FCaption;
end;

{ TDDatabaseNode }

procedure TDServerNode.SetServerAddress(AValue: String);
begin
  if FServerAddress = AValue then Exit;
  FServerAddress := AValue;
end;

constructor TDServerNode.Create(ACaption, AHint, AServerAddress, AServerPort, ALibName, ALibPath, ATmpDir, ALockDir: String; AMachineType: TDServerType; AIndex: Integer; ANode: TTreeNode);
begin
  inherited Create(ACaption, AHint, dntServer, ANode);
  FIndex := AIndex;
  FServerAddress := AServerAddress;
  FMachineType := AMachineType;
  FServerPort := AServerPort;
  FLibName := ALibName;
  FLibPath := ALibPath;
  FTmpDir := ATmpDir;
  FLockDir := ALockDir;
end;

function TDDatabaseNode.GetConnected: Boolean;
begin
  Result := Assigned(FConnection) and FConnection.Connected;
end;

function TDDatabaseNode.GetConnection: TUIBDataBase;
var
  srv_port: String;
begin
  if ServerNode.MachineType = dstEmbedded then
  begin
    if EmbeddedLibraryLoaded + EmbeddedLibraryPath <> '' then
    begin
      if (ServerNode.LibName + ServerNode.LibPath) <> (EmbeddedLibraryLoaded +
      EmbeddedLibraryPath) then
      begin
        MessageDlg('Attention',
          'Different Embedded library are currently attached and connected!' + LineEnding+
          Format('It`s seems %i connection', [EmbeddedReferenceCount])  + LineEnding+
          '  -Disconnect it and try again.' + LineEnding +
          '  -Use/Run another instance of the DSql.', mtWarning, [mbOK], '');
        Exit;
      end
      else
      begin
        EmbeddedReferenceCount += 1;
      end;
    end
    else if EmbeddedLibraryLoaded + EmbeddedLibraryPath = '' then
    begin
      PATH_LD := GetEnvironmentVar(CPATH_LD);
      if AppendToEnvironmentVar(CPATH_LD, ServerNode.FLibPath) and
         SetEnvironmentVar('FIREBIRD', EmbeddedLibraryPath) then
      begin
        //FIREBIRD_TMP = temporary directory
        //FIREBIRD_LOCK = location for lockfiles
        //FIREBIRD_MSG = location of firebird.msg file
        SetEnvironmentVar('FIREBIRD_TMP', ServerNode.TmpDir);
        SetEnvironmentVar('FIREBIRD_LOCK', ServerNode.LockDir);
        EmbeddedLibraryLoaded := ServerNode.FLibName;
        EmbeddedLibraryPath := ServerNode.FLibPath;
        EmbeddedReferenceCount += 1;
      end;
    end
    else
    begin
      MessageDlg('Error', 'Update environment variable failed', mtError, [mbOK], '');
      Exit;
    end;
  end;

  if not Assigned(FConnection) then
  begin
    //FConnection := TIBDataBase.Create(Self);
    //FTransaction := TIBTransaction.Create(Self);
    //
    //FConnection.DefaultTransaction := FTransaction;
    FConnection := TUIBDataBase.Create(Self);
    FTransaction := TUIBTransaction.Create(Self);
    with FTransaction do
    begin
      AutoStart := True;
      AutoStop := False;
      DefaultAction := etmStayIn;
    end;
    FTransaction.DataBase := FConnection;
  end;

  //FConnection.HostName := FServerNode.FServerAddress;
  //FConnection.DatabaseName := FDatabaseName;
  //FConnection.CharSet := CharSet;
  //FConnection.LoginPrompt := False;

  if not FConnection.Connected then
  begin
    FConnection.LibraryName := ServerNode.LibName;
    case FServerNode.MachineType of
      dstServer, dstLocalhost:
        begin
          srv_port := ServerNode.ServerAddress;
          if ServerNode.ServerPort <> '' then
            srv_port += '/' + ServerNode.ServerPort;
          srv_port += ':';
        end;
      dstEmbedded:
        begin
          srv_port := '';
        end;
    end;
  end;
  FConnection.DatabaseName := srv_port + FDatabaseName;
  FConnection.Params.Values['lc_ctype'] := CharSet;
  Result := FConnection;
end;

procedure TDDatabaseNode.SetConnected(AValue: Boolean);
var
  LoginPrpmpt: TDFrmLogin;
  mr, II: Integer;
  Msg, srv_port: String;
  CPos: SizeInt;
begin
  GetConnection;

  LoginPrpmpt := TDFrmLogin.Create(Self);
  try
    while True do
    begin
      if FConnection.Connected then
        Break;
      LoginPrpmpt.ResetForm;
      if FServerNode.MachineType = dstEmbedded then
        LoginPrpmpt.edUserName.Text := 'SYSDBA';
      mr := LoginPrpmpt.ShowModal;
      if mr = mrCancel then
        Break;
      if mr = mrOK then
      try
        try
          //FConnection.UserName := LoginPrpmpt.edUserName.Text;
          //FConnection.passPassword := LoginPrpmpt.edPassword.Text;
          FConnection.Params.Values['user_name'] := LoginPrpmpt.edUserName.Text;
          FConnection.Params.Values['password'] := LoginPrpmpt.edPassword.Text;
          FConnection.Connected := True;
        except on E: Exception do
          begin
            Msg := E.Message;
            if Pos('Can''t load', Msg) > 0 then
            begin
              Msg += LineEnding;
              Msg += 'Lib Path: ' + EmbeddedLibraryPath + LineEnding;
              Msg += 'Lib :' + EmbeddedLibraryLoaded;
            end;
            //else
            //while true do
            //begin
            //  CPos := Pos(':', Msg);
            //  if CPos > 0 then
            //    Delete(Msg, 1, CPos)
            //  else
            //    Break;
            //end;
            ShowMessage(Msg);
          end;
        end;
      finally
        if FConnection.Connected then
        begin
          //FConnectionInfo := TIBDatabaseInfo.Create(Self);
          //FConnectionInfo.Database := FConnection;
          //case ConnectionInfo.ODSMajorVersion of
          //  11 :
          //    case ConnectionInfo.ODSMinorVersion of
          //      1: FVersion := dfb21;
          //      2: FVersion := dfb25;
          //    end;
          //  12:
          //    FVersion := dfb3;
          //end;
          case FConnection.InfoOdsVersion of
            11 :
              case FConnection.InfoOdsMinorVersion of
                1: FVersion := dfb21;
                2: FVersion := dfb25;
              end;
            12:
              FVersion := dfb3;
          end;
          case FVersion of
            dfb21: II := 31;
            dfb25: II := 32;
            dfb3:  II := 33;
          end;
          case FVersion of
            dfb21:
              begin
                FHighlighter.SQLDialect := sqlInterbase6;
              end;
            dfb25:
              begin
                FHighlighter.SQLDialect := sqlInterbase6;
              end;
            dfb3:
              begin
                FHighlighter.SQLDialect := sqlFirebird3;
              end;
          end;
          FReservedWords.Clear;
          FFunctions.Clear;
          FTypes.Clear;
          AddItems(FrebirdReserveds[FVersion], DFrames.SQLReservesUpperCase, FReservedWords, dswtReserved);
          AddItems(FrebirdFunctions[FVersion], DFrames.SQLReservesUpperCase, FFunctions    , dswtFunction);
          AddItems(FrebirdTypes[FVersion]    , DFrames.SQLReservesUpperCase, FTypes        , dswtType);
          FTypes.Sort;
          Node.ImageIndex := II;
          Node.SelectedIndex := II;
          //WriteLn(ConnectionInfo.ODSMajorVersion, '-', ConnectionInfo.ODSMinorVersion, '>', ConnectionInfo.Version);
          RetriveMetaData([]);
        end
        else if ServerNode.MachineType = dstEmbedded then
        begin
          EmbeddedReferenceCount -= 1;
          if EmbeddedReferenceCount = 0 then
          begin
            EmbeddedLibraryLoaded := '';
            EmbeddedLibraryPath := '';
            SetEnvironmentVar('FIREBIRD_TMP', '');
            SetEnvironmentVar('FIREBIRD_LOCK', '');
            SetEnvironmentVar(CPATH_LD, PATH_LD);
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(LoginPrpmpt);
  end;
end;

procedure TDDatabaseNode.RemoveMetadataNodes(RequestedMetaData: TDRetriveMetaData);
var
  mcou, scou: Integer;
  Refresh: Boolean;
begin
  Refresh:= RequestedMetaData <> DC_AllMetaData;
  if (drmdDomains in RequestedMetaData) and Assigned(FDomainsNode) then
  begin
    FDomainsNode.DeleteIt(Refresh);
    if not Refresh then
      FDomainsNode := Nil;
  end;

  if (drmdSequences in RequestedMetaData) and Assigned(FSequencesNode) then
  begin
    FSequencesNode.DeleteIt(Refresh);
    if not Refresh then
      FSequencesNode := Nil;
  end;

  if (drmdTables in RequestedMetaData) and Assigned(FTabelsNode) then
  begin
    FTabelsNode.DeleteIt(Refresh);
    if not Refresh then
      FTabelsNode := Nil;
  end;

  if (drmdSysTables in RequestedMetaData) and Assigned(FSysTabelsNode) then
  begin
    FSysTabelsNode.DeleteIt(Refresh);
    if not Refresh then
      FSysTabelsNode := Nil;
  end;

  if (drmdViews in RequestedMetaData) and Assigned(FViewsNode) then
  begin
    FViewsNode.DeleteIt(Refresh);
    if not Refresh then
      FViewsNode := Nil;
  end;

  if (drmdProcedures in RequestedMetaData) and Assigned(FProceduresNode) then
  begin
    FProceduresNode.DeleteIt(Refresh);
    if not Refresh then
      FProceduresNode := Nil;
  end;

  if (drmdFunctions in RequestedMetaData) and Assigned(FFunctionsNode) then
  begin
    FFunctionsNode.DeleteIt(Refresh);
    if not Refresh then
      FFunctionsNode := Nil;
  end;

  if (drmdUserDFunctions in RequestedMetaData) and Assigned(FUFunctionsNode) then
  begin
    FUFunctionsNode.DeleteIt(Refresh);
    if not Refresh then
      FUFunctionsNode := Nil;
  end;

  if (drmdTriggers in RequestedMetaData) and Assigned(FTriggersNode) then
  begin
    FTriggersNode.DeleteIt(Refresh);
    if not Refresh then
      FTriggersNode := Nil;
  end;

  if (drmdIndices in RequestedMetaData) and Assigned(FIndeciessNode) then
  begin
    FIndeciessNode.DeleteIt(Refresh);
    if not Refresh then
      FIndeciessNode := Nil;
  end;

  if (drmdExceptions in RequestedMetaData) and Assigned(FExceptionsNode) then
  begin
    FExceptionsNode.DeleteIt(Refresh);
    if not Refresh then
      FExceptionsNode := Nil;
  end;

  if (drmdCollations in RequestedMetaData) then
    FCollations.Clear;

  if (drmdCharsets in RequestedMetaData) then
    FCharsets.Clear;

  //if Assigned(FTabelsNode) then
  //for mcou := 0 to Length(FTabelsNode.FTabels) - 1 do
  //begin
  //  for scou := 0 to Length(FTabelsNode.FTabels[mcou].FFields) - 1 do
  //    FTabelsNode.FTabels[mcou].FFields[scou].Free;
  //  FTabelsNode.FTabels[mcou].Free;
  //end;
  //FTabelsNode := Nil;
end;

procedure TDDatabaseNode.ProcessMessages;
begin
  //Sleep(1);
  //Application.ProcessMessages;
end;

procedure TDDatabaseNode.UpdateHighliter;
var
  obj: TDObjectNode;
  expt, tobj: TDTypedObjectNode;
begin
  if FHighlighterInUse > 0 then
  begin
    //In case of updating/deleting/creating meta objects(tbl,fn,proc,...)
    //this cause of discarding deleted/updated object names
    FHighlighter.InitKeywords;
    for tobj in FDomainsNode.FFields do
      FHighlighter.AddKeyword(tobj.ExactName, tkDatatype);

    for obj in FTabelsNode.Tabels do
      FHighlighter.AddKeyword(obj.ExactName, tkTableName);

    for obj in FViewsNode.Tabels do
      FHighlighter.AddKeyword(obj.ExactName, tkTableName);

    for obj in FSysTabelsNode.Tabels do
      FHighlighter.AddKeyword(obj.ExactName, tkTableName);

    for obj in FProceduresNode.Tabels do
      FHighlighter.AddKeyword(obj.ExactName, tkFunction);

    for obj in FUFunctionsNode.Tabels do
      FHighlighter.AddKeyword(obj.ExactName, tkFunction);

    for tobj in FExceptionsNode.FFields do
    try
      FHighlighter.AddKeyword(tobj.ExactName, tkException);
    except
      on E: Exception do
      begin
        DriteLn(tobj.ExactName + ' is an exception that already is definded somewhere!');
      end;
    end;

    if Version = dfb3 then
    begin
      for obj in FFunctionsNode.Tabels do
        FHighlighter.AddKeyword(obj.ExactName, tkFunction);
    end;
  end;
end;

procedure TDDatabaseNode.Connect;
begin
  VLockPopUP := True;
  try
    SetConnected(True);
    if Connected then
    begin
      ConnectedDatabases.Add(Self);
    end;
  finally
    VLockPopUP := False;
  end;
end;

procedure TDDatabaseNode.Disconnect;
var
  editor: Pointer;
  cout, cous: Integer;
begin
  VLockPopUP := True;
  try
    if Connected then
    begin
      if not DFrames.QueryDisconnectFromMyDFrames(Self) then
        Exit;
      RemoveMetadataNodes(DC_AllMetaData);
      Node.DeleteChildren;
      try
        //FConnection.ForceClose;
        for cout := 0 to FConnection.TransactionsCount - 1 do
        begin
          if FConnection.Transactions[cout].StatementsCount = 0 then
          begin
            FConnection.Transactions[cout].RollBack;
            Continue;
          end;
          //for cous := 0 to FConnection.Transactions[cout].StatementsCount - 1 do
          //  WriteLn(FConnection.Transactions[cout].Statements[cous].SQL.Text);
        end;
        try
          FConnection.Connected := False;

        except
          on E: Exception do
          begin
            if FConnection.Connected then
              FConnection.Connected := False;
          end;
        end;
      except
        on E: Exception do
        begin
          ShowMessage(E.Message);
        end;
      end;
      //if dont save passwors
        //FConnection.Params.Values['user_name'] := '';
        //FConnection.Params.Values['password'] := '';
    end;
    if not Connected then
    begin
      ConnectedDatabases.Remove(Self);
      EmbeddedReferenceCount -= 1;
      if EmbeddedReferenceCount = 0 then
      begin
        EmbeddedLibraryLoaded := '';
        EmbeddedLibraryPath := '';
        SetEnvironmentVar('FIREBIRD_TMP', '');
        SetEnvironmentVar('FIREBIRD_LOCK', '');
        SetEnvironmentVar(CPATH_LD, PATH_LD);
      end;
    end;
  finally
    //FreeAndNil(FConnectionInfo);
    VLockPopUP := False;
    Node.ImageIndex := 2;
    Node.SelectedIndex := 2;
  end;
end;

procedure TDDatabaseNode.RetriveMetaData(RequestedMetaData: TDRetriveMetaData);
//const
//  //Table Primary Key
//  tp: array[Boolean] of TDNodeType = (dntTableField, dntTablePmKey);
//  //Procedure Param Type
//  pt: array[Boolean] of TDNodeType = (dntProcedureParams, dntProcedureReturns);
//  //Trigger Active State
//  ta: array[Boolean] of TDNodeType = (dntTriggerActive, dntTriggerInactive);
//  //Indecies Active State
//  ia: array[Boolean] of TDNodeType = (dntIndexActive, dntIndexInActive);
var
  pnd, nd, fnd: TTreeNode;
  PK, fn, pnt, pnc, ObjName, ft: String;
  //QSql: TIBSQL;
  //QTra: TIBTransaction;
  //QSqlF: TIBSQL;
  //QTraF: TIBTransaction;
  QSql: TUIBQuery;
  QTra: TUIBTransaction;
  QSqlF: TUIBQuery;
  QTraF: TUIBTransaction;
  mcou, scou: Integer;
  PTyp: LongInt;
  //cur, curf: IResultSet;
  cur, curf: TSQLResult;
  ObjType: TDNodeType;
  Retriver: TDMetaDatRetriver;
  tk: QWord;
  Refresh: Boolean;
begin
  try
    tk := GetTickCount64;
    //FrmDSqlMain.TreeView1.BeginUpdate;
    if RequestedMetaData= [] then
      RequestedMetaData:= DC_AllMetaData;
    Refresh := RequestedMetaData <> DC_AllMetaData;
    RemoveMetadataNodes(RequestedMetaData);
    if Connected then
    begin
      Retriver := TDMetaDatRetriver.Create(Self);
      //QTra := TIBTransaction.Create(Self);
      //QTra.DefaultDatabase := Connection;
      //QSql := TIBSQL.Create(Self);
      QTra := TUIBTransaction.Create(Self);
      QTra.DataBase := Connection;
      with QTra do
      begin
        AutoStart := True;
        AutoStop := False;
        DefaultAction := etmStayIn;
      end;
      QSql := TUIBQuery.Create(Self);
      QSql.DataBase := Connection;
      QSql.Transaction := QTra;
      QSql.CachedFetch := False;
      QSql.FetchBlobs := True;;

      //QSql.UniDirectional := True;

      //QTraF := TIBTransaction.Create(Self);
      //QTraF.DefaultDatabase := Connection;
      //QSqlF := TIBSQL.Create(Self);
      QTraF := TUIBTransaction.Create(Self);
      QTraF.DataBase := Connection;
      with QTraF do
      begin
        AutoStart := True;
        AutoStop := False;
        DefaultAction := etmStayIn;
      end;
      QSqlF := TUIBQuery.Create(Self);
      QSqlF.DataBase := Connection;
      QSqlF.Transaction := QTra;
      QSqlF.CachedFetch := False;
      QSqlF.FetchBlobs := True;;

      //QSqlF.UniDirectional := True;

      QTra.StartTransaction;
      QTraF.StartTransaction;

      {$Region C_Sql_Retrive_Charsets}
      if drmdCharsets in RequestedMetaData then
        Retriver.RetriveList(FCharsets, C_Sql_Retrive_Charsets, dswtCharset);
      {$EndRegion}

      {$Region C_Sql_Retrive_Collations}
      if drmdCollations in RequestedMetaData then
        Retriver.RetriveList(FCollations, C_Sql_Retrive_Collations, dswtCollation);
      {$EndRegion}

      {$Region C_Sql_Retrive_Domains}
      if drmdDomains in RequestedMetaData then
      begin
        Retriver.RetriveObjects(FDomainsNode, 'Domains', dntDomains, dntDomain, C_Sql_Retrive_Domains, ':  ', Refresh);
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Sequences}
      if drmdSequences in RequestedMetaData then
      begin
        Retriver.RetriveObjects(FSequencesNode, 'Sequences', dntSequences, dntSequence, C_Sql_Retrive_Sequences, '', Refresh);
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Tables}
      if drmdTables in RequestedMetaData then
      begin
        Retriver.RetriveTables(FTabelsNode, 'Tables', dntTables, dntTable, DC_TableFieldType, C_Sql_Retrive_Tables, ':  ', Refresh);
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Indices}
      if drmdIndices in RequestedMetaData then
      begin
        Retriver.RetriveObjects(FIndeciessNode, 'Indecies', dntIndices, DC_IndexState, C_Sql_Retrive_Indices, '->', Refresh);
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Triggers}
      if drmdTriggers in RequestedMetaData then
      begin
        Retriver.RetriveObjects(FTriggersNode, 'Triggers', dntTriggers, DC_TriggerState, C_Sql_Retrive_Triggers, '->', Refresh);
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Views}
      if drmdViews in RequestedMetaData then
      begin
        Retriver.RetriveTables(FViewsNode, 'Views', dntViews, dntView, DC_ViewFieldType, C_Sql_Retrive_Views, ':  ', Refresh);
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Ecxeptions}
      if drmdExceptions in RequestedMetaData then
      begin
        Retriver.RetriveObjects(FExceptionsNode, 'Exceptions', dntExceptions, dntException, C_Sql_Retrive_Ecxeptions, '', Refresh);
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Functions}
      if drmdFunctions in RequestedMetaData then
      begin
        mcou := 0;
        pnt := 'Functions';
        if not Refresh then
        begin
          pnd := Node.Owner.AddChild(Node, '');
          pnd.Visible := Version >= dfb3;
          pnd.Data := TDObjectCollectionNode.Create(pnt, pnt, '', dntFunctions, pnd, Self);
          FFunctionsNode := TDObjectCollectionNode(pnd.Data);
          pnd.ImageIndex := c_DNodeImageIndex[dntFunctions];
          pnd.SelectedIndex := c_DNodeImageIndex[dntFunctions];
        end
        else
          pnd := FFunctionsNode.Node;

        pnd.Selected := True;
        ProcessMessages;

        SetLength(FFunctionsNode.FTabels, 0);
        QSql.SQL.Text := C_Sql_Retrive_Functions;
        QSql.Prepare;
        if {QSql.Prepared} True then
        begin
          //cur := QSql.Statement.OpenCursor(QSql.Transaction.TransactionIntf);
          QSql.Open;
          cur := QSql.Fields;
          //while cur.FetchNext do
          while not QSql.Eof do
          begin
            nd := Node.Owner.AddChild(pnd, '');
            //ObjName := Trim(cur.ByName('NAME').AsString);
            //nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByName('COMMENT').AsString), dntFunction, nd, Self);
            ObjName := Trim(cur.ByNameAsString['NAME']);
            nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByNameAsString['COMMENT']), dntFunction, nd, Self);
            nd.ImageIndex := c_DNodeImageIndex[dntFunction];
            nd.SelectedIndex := c_DNodeImageIndex[dntFunction];
            SetLength(FFunctionsNode.FTabels, Length(FFunctionsNode.FTabels) + 1);
            FFunctionsNode.FTabels[mcou] := TDObjectNode(nd.Data);

            //pnd.Text := pnt + ' (' + IntToStr(mcou) + ')';
            //ProcessMessages;

            QSqlF.SQL.Text := C_Sql_Retrive_Function_Arguments;
            QSqlF.Prepare;
            if {QSqlF.Prepared} True then
            begin
              //QSqlF.ParamByName('FUNC').AsString := nd.Text;
              QSqlF.Params.ByNameAsString['FUNC'] := nd.Text;
              //curf := QSqlF.Statement.OpenCursor(QSqlF.Transaction.TransactionIntf);
              QSqlF.Open;
              curf := QSqlF.Fields;
              SetLength(FFunctionsNode.FTabels[mcou].FFields, 0);
              scou := 0;
              //while curf.FetchNext do
              while not QSqlF.Eof do
              begin
                fnd := Node.Owner.AddChild(nd, '');
                //fn := Trim(curf.ByName('ARGUMENT_NAME').AsString);
                //PTyp := curf.ByName('ARGUMENT_IO').AsInteger;
                fn := Trim(curf.ByNameAsString['ARGUMENT_NAME']);
                PTyp := curf.ByNameAsInteger['ARGUMENT_IO'];
                if (fn = '') and (PTyp = 0) then
                  fn := 'Returns';
                fnd.Data := TDTypedObjectNode.Create(fn,
                  //fn + '   :' + Trim(curf.ByName('ARGUMENT_TYPE').AsString), Trim(curf.ByName('COMMENT').AsString), dntFunctionArguments, fnd, Self);
                  fn + '   :' + Trim(curf.ByNameAsString['ARGUMENT_TYPE']), Trim(curf.ByNameAsString['COMMENT']), dntFunctionArguments, fnd, Self);
                SetLength(FFunctionsNode.FTabels[mcou].FFields, Length(FFunctionsNode.FTabels[mcou].FFields) + 1);
                FFunctionsNode.FTabels[mcou].FFields[scou] := TDTypedObjectNode(fnd.Data);
                //FFunctionsNode.FTabels[mcou].FFields[scou].FObjectType := Trim(curf.ByName('ARGUMENT_TYPE').AsString);
                FFunctionsNode.FTabels[mcou].FFields[scou].FObjectType := Trim(curf.ByNameAsString['ARGUMENT_TYPE']);
                FFunctionsNode.FTabels[mcou].FFields[scou].FNodeSqlObjectType := DC_FunctionArgument[PTyp >= 1];
                //Writeln(Fn, '>', PTyp, '  >  ', DC_FunctionArgument[PTyp >= 1], '  >  ', c_DNodeImageIndex[DC_FunctionArgument[PTyp >= 1]]);
                fnd.ImageIndex := c_DNodeImageIndex[DC_FunctionArgument[PTyp >= 1]];
                fnd.SelectedIndex := c_DNodeImageIndex[DC_FunctionArgument[PTyp >= 1]];
                Inc(scou);
                QSqlF.Next;
              end;
              //curf.Close;
            end;
            QTraF.CommitRetaining;
            Inc(mcou);
            QSql.Next;
          end;
          //cur.Close;
        end;
        if not Refresh then
          pnd.Collapse(True)
        else
          pnd.Expand(False);
        pnd.Text := pnt + '(' + mcou.ToString + ')';

        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_User_Defined_Functions}
      if drmdUserDFunctions in RequestedMetaData then
      begin
        mcou := 0;
        pnt := 'UDF';
        if not Refresh then
        begin
          pnd := Node.Owner.AddChild(Node, '');
          pnd.Data := TDObjectCollectionNode.Create(pnt, pnt, '', dntUserDFunctions, pnd, Self);
          FUFunctionsNode := TDObjectCollectionNode(pnd.Data);
          pnd.ImageIndex := c_DNodeImageIndex[dntUserDFunctions];
          pnd.SelectedIndex := c_DNodeImageIndex[dntUserDFunctions];
        end
        else
          pnd := FUFunctionsNode.Node;

        pnd.Selected := True;
        ProcessMessages;

        SetLength(FUFunctionsNode.FTabels, 0);
        QSql.Close;
        QSql.SQL.Text := C_Sql_Retrive_UFunctions;
        QSql.Prepare;
        if {QSql.Prepared} True then
        begin
          //cur := QSql.Statement.OpenCursor(QSql.Transaction.TransactionIntf);
          QSql.Open;
          cur := QSql.Fields;

          //while cur.FetchNext do
          while not QSql.Eof do
          begin
            nd := Node.Owner.AddChild(pnd, '');
            //ObjName := Trim(cur.ByName('NAME').AsString);
            //nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByName('COMMENT').AsString), dntUserDFunction, nd, Self);
            ObjName := Trim(cur.ByNameAsString['NAME']);
            nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByNameAsString['COMMENT']), dntUserDFunction, nd, Self);
            nd.ImageIndex := c_DNodeImageIndex[dntFunction];
            nd.SelectedIndex := c_DNodeImageIndex[dntFunction];
            SetLength(FUFunctionsNode.FTabels, Length(FUFunctionsNode.FTabels) + 1);
            FUFunctionsNode.FTabels[mcou] := TDObjectNode(nd.Data);

            QSqlF.SQL.Text := C_Sql_Retrive_UFunction_Arguments[FVersion];
            QSqlF.Prepare;
            if {QSqlF.Prepared} True then
            begin
              SetLength(FUFunctionsNode.FTabels[mcou].FFields, 0);
              scou := 0;
              //QSqlF.ParamByName('FUNC').AsString := nd.Text;
              QSqlF.Params.ByNameAsString['FUNC'] := nd.Text;
              //curf := QSqlF.Statement.OpenCursor(QSqlF.Transaction.TransactionIntf);
              QSqlF.Open;
              curf := QSqlF.Fields;
              //while curf.FetchNext do
              while not QSqlF.Eof do
              begin
                fnd := Node.Owner.AddChild(nd, '');
                //fn := Trim(curf.ByName('ARGUMENT_NAME').AsString);
                //if (fn = '') and (curf.ByName('ARGUMENT_IO').AsInteger = 0) then
                fn := Trim(curf.ByNameAsString['ARGUMENT_NAME']);
                if (fn = '') and (curf.ByNameAsInteger['ARGUMENT_IO'] = 0) then
                  fn := 'Returns';
                fnd.Data := TDTypedObjectNode.Create(fn,
                  //fn + '   :' + Trim(curf.ByName('ARGUMENT_TYPE').AsString), Trim(curf.ByName('COMMENT').AsString), dntUserDFunctionArguments, fnd, Self);
                  fn + '   :' + Trim(curf.ByNameAsString['ARGUMENT_TYPE']), Trim(curf.ByNameAsString['COMMENT']), dntUserDFunctionArguments, fnd, Self);
                SetLength(FUFunctionsNode.FTabels[mcou].FFields, Length(FUFunctionsNode.FTabels[mcou].FFields) + 1);
                FUFunctionsNode.FTabels[mcou].FFields[scou] := TDTypedObjectNode(fnd.Data);
                //PTyp := curf.ByName('ARGUMENT_IO').AsInteger;
                PTyp := curf.ByNameAsInteger['ARGUMENT_IO'];
                FUFunctionsNode.FTabels[mcou].FFields[scou].FNodeSqlObjectType := DC_UserDefinedFunctionArgument[PTyp >= 1];
                fnd.ImageIndex := c_DNodeImageIndex[DC_UserDefinedFunctionArgument[PTyp >= 1]];
                fnd.SelectedIndex := c_DNodeImageIndex[DC_UserDefinedFunctionArgument[PTyp >= 1]];
                Inc(scou);
                QSqlF.Next;
              end;
              //curf.Close;
            end;
            QTraF.CommitRetaining;
            Inc(mcou);
            QSql.Next;
          end;
          //cur.Close;
        end;
        if not Refresh then
          pnd.Collapse(True)
        else
          pnd.Expand(False);
        pnd.Text := pnt + pnc;
        ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Procedures}
      if drmdProcedures in RequestedMetaData then
      begin
        mcou := 0;
        pnt := 'Procedures';
        if not Refresh then
        begin
          pnd := Node.Owner.AddChild(Node, '');
          pnd.Data := TDObjectCollectionNode.Create(pnt, pnt, '', dntProcedures, pnd, Self);
          FProceduresNode := TDObjectCollectionNode(pnd.Data);
          pnd.ImageIndex := c_DNodeImageIndex[dntProcedures];
          pnd.SelectedIndex := c_DNodeImageIndex[dntProcedures];
        end
        else
          pnd := FProceduresNode.Node;

        pnd.Selected := True;
        ProcessMessages;
        //Testy
        QSql.SQL.Text := C_Sql_Retrive_Procedures;
        QSql.Prepare;
        if {QSql.Prepared} True then
        begin
          SetLength(FProceduresNode.FTabels, 0);
          mcou := 0;
          //cur := QSql.Statement.OpenCursor(QSql.Transaction.TransactionIntf);
          QSql.Open;
          cur := QSql.Fields;
          //while cur.FetchNext do
          while not QSql.Eof do
          begin
            nd := Node.Owner.AddChild(pnd, '');
            //ObjName := Trim(cur.ByName('NAME').AsString);
            ObjName := Trim(cur.ByNameAsString['NAME']);
            //nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByName('COMMENT').AsString), dntProcedure, nd, Self);
            nd.Data := TDObjectNode.Create(ObjName, ObjName, Trim(cur.ByNameAsString['COMMENT']), dntProcedure, nd, Self);
            nd.ImageIndex := c_DNodeImageIndex[dntProcedure];
            nd.SelectedIndex := c_DNodeImageIndex[dntProcedure];
            SetLength(FProceduresNode.FTabels, Length(FProceduresNode.FTabels) + 1);
            FProceduresNode.FTabels[mcou] := TDObjectNode(nd.Data);

            QSqlF.SQL.Text := C_Sql_Retrive_Procedure_Parameters;
            QSqlF.Prepare;
            if {QSqlF.Prepared} True then
            begin
              //QSqlF.ParamByName('PRC').AsString := nd.Text;
              QSqlF.Params.ByNameAsString['PRC'] := nd.Text;
              //curf := QSqlF.Statement.OpenCursor(QSqlF.Transaction.TransactionIntf);
              QSqlF.Open;
              curf := QSqlF.Fields;
              SetLength(FProceduresNode.FTabels[mcou].FFields, 0);
              scou := 0;
              //while curf.FetchNext do
              while not QSqlF.Eof do
              begin
                fnd := Node.Owner.AddChild(nd, '');
                //fn := Trim(curf.ByName('PARAM_NAME').AsString);
                //ft := Trim(Trim(curf.ByName('PARAM_TYPE').AsString));
                fn := Trim(curf.ByNameAsString['PARAM_NAME']);
                ft := Trim(curf.ByNameAsString['PARAM_TYPE']);
                //fnd.Data := TDTypedObjectNode.Create(fn, fn + ':  ' + ft, Trim(curf.ByName('COMMENT').AsString), dntProcedureParams,
                fnd.Data := TDTypedObjectNode.Create(fn, fn + ':  ' + ft, Trim(curf.ByNameAsString['COMMENT']), dntProcedureParams,
                  fnd, Self);
                SetLength(FProceduresNode.FTabels[mcou].FFields, Length(FProceduresNode.FTabels[mcou].FFields) + 1);
                FProceduresNode.FTabels[mcou].FFields[scou] := TDTypedObjectNode(fnd.Data);
                //PTyp := curf.ByName('PARAM_IO').AsInteger;
                PTyp := curf.ByNameAsInteger['PARAM_IO'];
                FProceduresNode.FTabels[mcou].FFields[scou].FObjectType := ft;
                FProceduresNode.FTabels[mcou].FFields[scou].FNodeSqlObjectType := DC_ProcedureArgument[PTyp = 1];
                FProceduresNode.FTabels[mcou].FFields[scou].FExData := Pointer(PtrInt(PTyp));
                fnd.ImageIndex := c_DNodeImageIndex[DC_ProcedureArgument[PTyp = 1]];
                fnd.SelectedIndex := c_DNodeImageIndex[DC_ProcedureArgument[PTyp = 1]];
                Inc(scou);
                QSqlF.Next;
              end;
              //curf.Close;
            end;
            QTraF.CommitRetaining;
            Inc(mcou);
            QSql.Next;
          end;
          //cur.Close;
        end;

        if not Refresh then
          pnd.Collapse(True)
        else
          pnd.Expand(False);
        pnd.Text := pnt + '(' + mcou.ToString + ')';
        //ProcessMessages;
      end;
      {$EndRegion}

      {$Region C_Sql_Retrive_Sys_Tables}
      if drmdSysTables in RequestedMetaData then
      begin
        Retriver.RetriveTables(FSysTabelsNode, 'System Tables', dntSysTables, dntSysTable, DC_TableFieldType, C_Sql_Retrive_Sys_Tables, ':  ', Refresh);
        //ProcessMessages;
      end;
      {$EndRegion}

      QTra.Commit;

      if not Refresh then
      begin
        Node.Collapse(True);
        Node.Expand(False);
        Node.Selected := True;
      end;
      ProcessMessages;
      RefreshAvailables;
    end;
  finally
    //FrmDSqlMain.TreeView1.EndUpdate;
    FreeAndNil(QSql);
    FreeAndNil(QSqlF);
    QTra.RollBack;
    FreeAndNil(QTra);
    QTraF.RollBack;
    FreeAndNil(QTraF);
    FreeAndNil(Retriver);
    UpdateHighliter;
    //WriteLn('Meta:', GetTickCount64 - tk);
  end;
end;

procedure TDDatabaseNode.RefreshAvailables;
var
  dmn: TDTypedObjectNode;
  tbl: TDObjectNode;
  itm: String;

begin
  FAvailables.Clear;
  FAlisables.Clear;
  for dmn in FDomainsNode.Fields do
  begin
    itm := ExactSqlObjectName(dmn.ObjectName, Self);
    FAvailables.AddObject(itm + ':  ' + dmn.ObjectType, TObject(Pointer(PtrInt(Ord(dswtDomain)))));
  end;

  for tbl in FTabelsNode.Tabels do
  begin
    itm := ExactSqlObjectName(tbl.Caption, Self);
    FAvailables.AddObject(itm, TObject(Pointer(PtrInt(Ord(dswtTable)))));
    FAlisables.AddObject(itm, tbl);
  end;

  for tbl in FSysTabelsNode.Tabels do
  begin
    itm := ExactSqlObjectName(tbl.Caption, Self);
    FAvailables.AddObject(itm, TObject(Pointer(PtrInt(Ord(dswtSysTable)))));
    FAlisables.AddObject(itm, tbl);
  end;

  for tbl in FViewsNode.Tabels do
  begin
    itm := ExactSqlObjectName(tbl.Caption, Self);
    FAvailables.AddObject(itm, TObject(Pointer(PtrInt(Ord(dswtView)))));
    FAlisables.AddObject(itm, tbl);
  end;

  for tbl in FProceduresNode.Tabels do
  begin
    itm := ExactSqlObjectName(tbl.Caption, Self);
    FAvailables.AddObject(itm, TObject(Pointer(PtrInt(Ord(dswtProcedure)))));
    FAlisables.AddObject(itm, tbl);
  end;

  for tbl in FFunctionsNode.Tabels do
  begin
    itm := ExactSqlObjectName(tbl.Caption, Self);
    FAvailables.AddObject(itm, TObject(Pointer(PtrInt(Ord(dswtFunction)))));
  end;

  for tbl in FUFunctionsNode.Tabels do
  begin
    itm := ExactSqlObjectName(tbl.Caption, Self);
    FAvailables.AddObject(tbl.ExactName, TObject(Pointer(PtrInt(Ord(dswtFunction)))));
  end;

  for dmn in FTriggersNode.Fields do
  begin
    //itm := ExactSqlObjectName(dmn.ObjectName, Self);
    FAvailables.AddObject(dmn.ExactName + ':  ' + dmn.ObjectType, TObject(Pointer(PtrInt(Ord(dswtTrigger)))));
  end;

  for dmn in FIndeciessNode.Fields do
  begin
    //itm := ExactSqlObjectName(dmn.ObjectName, Self);
    FAvailables.AddObject(dmn.ExactName + ':  ' + dmn.ObjectType, TObject(Pointer(PtrInt(Ord(dswtIndex)))));
  end;

  for dmn in FSequencesNode.Fields do
  begin
    //itm := ExactSqlObjectName(dmn.ObjectName, Self);
    FAvailables.AddObject(dmn.ExactName, TObject(Pointer(PtrInt(Ord(dswtSequense)))));
  end;

  for dmn in FExceptionsNode.Fields do
    FAvailables.AddObject(dmn.ExactName, TObject(Pointer(Ord(dswtException))));

  FAvailables.AddStrings(FReservedWords);
  FAvailables.AddStrings(FFunctions);
  FAvailables.AddStrings(FTypes);

  FAvailables.AddStrings(FCollations);
  FAvailables.AddStrings(FCharsets);
end;

function TDDatabaseNode.RetriveFunctionBody(Fn: String): String;
var
  //QTra: TIBTransaction;
  //QSql: TIBSQL;
  //cur: IResultSet;
  QTra: TUIBTransaction;
  QSql: TUIBQuery;
  cur: TSQLResult;
begin
  if not Connected then Exit('');
  //QTra := TIBTransaction.Create(Self);
  //QTra.DefaultDatabase := Connection;
  //QSql := TIBSQL.Create(Self);
  //QSql.DataBase := Connection;
  //QSql.Transaction := QTra;
  //QTra.StartTransaction;
  //QSql.SQL.Text := C_Sql_Retrive_Function_Source + '''' + Fn + ''';';
  //QSql.Prepare;
  //if QSql.Prepared then
  //begin
  //  cur := QSql.Statement.OpenCursor(QTra.TransactionIntf);
  //  if cur.FetchNext then
  //    Result := cur.Data[0].AsBlob.AsString;
  //end;
  QTra := TUIBTransaction.Create(Self);
  QTra.DataBase := Connection;
  with QTra do
  begin
    AutoStart := True;
    AutoStop := False;
    DefaultAction := etmStayIn;
  end;
  QSql := TUIBQuery.Create(Self);
  QSql.DataBase := Connection;
  QSql.Transaction := QTra;
  QSql.FetchBlobs := True;
  QSql.CachedFetch := False;
  QSql.SQL.Text := C_Sql_Retrive_Function_Source + '''' + Fn + ''';';
  QSql.Prepare;
  QSql.Open;
  cur := QSql.Fields;
  if cur.Bof then
    Result := cur.AsString[0];
  QTra.Commit;
  FreeAndNil(QSql);
  FreeAndNil(QTra);
end;

function TDDatabaseNode.RetriveStoredProcedureBody(Fn: String): String;
var
  //QTra: TIBTransaction;
  //QSql: TIBSQL;
  //cur: IResultSet;
  QTra: TUIBTransaction;
  QSql: TUIBQuery;
  cur: TSQLResult;
begin
  //select f.RDB$FUNCTION_SOURCE from  RDB$FUNCTIONS f  where f.RDB$FUNCTION_NAME = :FN
  if not Connected then Exit('');
  //QTra := TIBTransaction.Create(Self);
  //QTra.DefaultDatabase := Connection;
  //QSql := TIBSQL.Create(Self);
  //QSql.DataBase := Connection;
  //QSql.Transaction := QTra;
  //QTra.StartTransaction;
  //QSql.SQL.Text := C_Sql_Retrive_Function_Source + '''' + Fn + ''';';
  //QSql.Prepare;
  //if QSql.Prepared then
  //begin
  //  cur := QSql.Statement.OpenCursor(QTra.TransactionIntf);
  //  if cur.FetchNext then
  //    Result := cur.Data[0].AsBlob.AsString;
  //end;
  QTra := TUIBTransaction.Create(Self);
  QTra.DataBase := Connection;
  with QTra do
  begin
    AutoStart := True;
    AutoStop := False;
    DefaultAction := etmStayIn;
  end;
  QSql := TUIBQuery.Create(Self);
  QSql.DataBase := Connection;
  QSql.Transaction := QTra;
  QSql.FetchBlobs := True;
  QSql.CachedFetch := False;
  QSql.SQL.Text := C_Sql_Retrive_StoredProcedure_Source;
  QSql.Prepare;
  QSql.Params.ByNameAsString['SPN'] := Fn;
  QSql.Open;
  cur := QSql.Fields;
  if QSql.Bof then
    Result := cur.AsString[0];
  QTra.Commit;
  FreeAndNil(QSql);
  FreeAndNil(QTra);
end;

function TDDatabaseNode.RetriveTriggerBody(Trig: String): String;
var
  //QTra: TIBTransaction;
  //QSql: TIBSQL;
  //cur: IResultSet;
  QTra: TUIBTransaction;
  QSql: TUIBQuery;
  cur: TSQLResult;
begin
  //select f.RDB$FUNCTION_SOURCE from  RDB$FUNCTIONS f  where f.RDB$FUNCTION_NAME = :FN
  if not Connected then Exit('');
  try
    //QTra := TIBTransaction.Create(Self);
    //QTra.DefaultDatabase := Connection;
    //QSql := TIBSQL.Create(Self);
    //QSql.DataBase := Connection;
    //QSql.Transaction := QTra;
    //QTra.StartTransaction;
    //QSql.SQL.Text := C_Sql_Retrive_Function_Source + '''' + Fn + ''';';
    //QSql.Prepare;
    //if QSql.Prepared then
    //begin
    //  cur := QSql.Statement.OpenCursor(QTra.TransactionIntf);
    //  if cur.FetchNext then
    //    Result := cur.Data[0].AsBlob.AsString;
    //end;
    QTra := TUIBTransaction.Create(Self);
    QTra.DataBase := Connection;
    with QTra do
    begin
      AutoStart := True;
      AutoStop := False;
      DefaultAction := etmStayIn;
    end;
    QSql := TUIBQuery.Create(Self);
    QSql.DataBase := Connection;
    QSql.Transaction := QTra;
    QSql.FetchBlobs := True;
    QSql.CachedFetch := False;
    QSql.SQL.Text := C_Sql_Retrive_Trigger_Source;
    QSql.Prepare;
    QSql.Params.ByNameAsString['TRIG'] := Trig;
    QSql.Open;
    cur := QSql.Fields;
    if cur.Bof then
      Result := cur.AsString[0];
    QTra.Commit;
  finally
    FreeAndNil(QSql);
    FreeAndNil(QTra);
  end;
end;

function TDDatabaseNode.RetriveViewBody(AView: String): String;
var
  QTra: TUIBTransaction;
  QSql: TUIBQuery;
  cur: TSQLResult;
begin
  if not Connected then Exit('');
  try
    QTra := TUIBTransaction.Create(Self);
    QTra.DataBase := Connection;
    with QTra do
    begin
      AutoStart := True;
      AutoStop := False;
      DefaultAction := etmStayIn;
    end;
    QSql := TUIBQuery.Create(Self);
    QSql.DataBase := Connection;
    QSql.Transaction := QTra;
    QSql.FetchBlobs := True;
    QSql.CachedFetch := False;
    QSql.SQL.Text := C_Sql_Retrive_View_Source;
    QSql.Prepare;
    QSql.Params.ByNameAsString['VW'] := AView;
    QSql.Open;
    cur := QSql.Fields;
    if cur.Bof then
      Result := cur.AsString[0];
    QTra.Commit;
  finally
    FreeAndNil(QSql);
    FreeAndNil(QTra);
  end;
end;

function TDDatabaseNode.RetriveExceptionText(AException: String): String;
var
  QTra: TUIBTransaction;
  QSql: TUIBQuery;
  cur: TSQLResult;
begin
  if not Connected then Exit('');
  try
    QTra := TUIBTransaction.Create(Self);
    QTra.DataBase := Connection;
    with QTra do
    begin
      AutoStart := True;
      AutoStop := False;
      DefaultAction := etmStayIn;
    end;
    QSql := TUIBQuery.Create(Self);
    QSql.DataBase := Connection;
    QSql.Transaction := QTra;
    QSql.FetchBlobs := True;
    QSql.CachedFetch := False;
    QSql.SQL.Text := C_Sql_Retrive_Ecxeption_Text;
    QSql.Prepare;
    QSql.Params.ByNameAsString['ENAME'] := AException;
    QSql.Open;
    cur := QSql.Fields;
    if cur.Bof then
      Result := cur.AsString[0];
    QTra.Commit;
  finally
    FreeAndNil(QSql);
    FreeAndNil(QTra);
  end;
end;

function TDDatabaseNode.GetSequenceValue(SeqName: String): Integer;
var
  QTra: TUIBTransaction;
  QSql: TUIBQuery;
  cur: TSQLResult;
begin
  if not Connected then Exit(-1);
  QTra := TUIBTransaction.Create(Self);
  QTra.DataBase := Connection;
  with QTra do
  begin
    AutoStart := True;
    AutoStop := False;
    DefaultAction := etmStayIn;
  end;
  QSql := TUIBQuery.Create(Self);
  QSql.DataBase := Connection;
  QSql.Transaction := QTra;
  QSql.FetchBlobs := True;
  QSql.CachedFetch := False;
  QSql.SQL.Text := Format(C_Sql_Retrive_Sequence_Value, [SeqName]);
  QSql.Prepare;
  QSql.Open;
  cur := QSql.Fields;
  if QSql.Bof then
    Result := cur.AsInt64[0];
  FreeAndNil(QSql);
  FreeAndNil(QTra);
end;

function TDDatabaseNode.ExactObjectName(ObjectName: String): String;
begin
  Result := ExactSqlObjectName(ObjectName, Self);
end;

procedure TDDatabaseNode.AddMetaData(List: TStringList);
begin

end;

constructor TDDatabaseNode.Create(ACaption, ADatabaseName, ACharSet, AHint: String; AIndex: Integer; ANode: TTreeNode);
begin
  if TDNodeInfo(ANode.Parent.Data).NodeSqlObjectType <> dntServer then
    raise Exception.Create('Wrong place to create Database node!');
  inherited Create(ACaption, AHint, dntDatabase, ANode);
  FIndex := AIndex;
  FServerNode := TDServerNode(ANode.Parent.Data);
  FDatabaseName := ADatabaseName;
  FCharSet := ACharSet;
  FConnection := Nil;
  FTransaction := Nil;
  FAvailables := TStringList.Create;
  FAlisables := TStringList.Create;
  FReservedWords := TStringList.Create;
  FFunctions := TStringList.Create;
  FTypes := TStringList.Create;


  FDomainsNode := Nil;
  FTabelsNode := Nil;
  FSysTabelsNode := Nil;
  FViewsNode := Nil;
  FProceduresNode := Nil;

  FCollations := TStringList.Create;
  FCharsets := TStringList.Create;
  FHighlighter := TSynSQLSyn.Create(Self);
  with FHighlighter do
  begin
    DefaultFilter := 'SQL Files (*.sql)|*.sql';
    Enabled := True;
    CommentAttri.Foreground := 7994962;
    DataTypeAttri.Foreground := 8506880;
    DefaultPackageAttri.Foreground := clGray;
    FunctionAttri.Foreground := 3899381;
    IdentifierAttri.Foreground := 16752918;
    KeyAttri.Foreground := 2323711;
    KeyAttri.Style := [];
    NumberAttri.Foreground := 5858303;
    PLSQLAttri.Foreground := 50943;
    SQLPlusAttri.Foreground := clRed;
    StringAttri.Foreground := 5858303;
    SymbolAttri.Foreground := 5217023;
    TableNameAttri.Foreground := 5962745;
    TableNameAttri.Style := [fsItalic];
    VariableAttri.Foreground := 6908314;
    ExceptionAttri.Foreground := clRed;
    SQLDialect := sqlInterbase6;
  end;
  FHighlighterInUse := 0;
end;

destructor TDDatabaseNode.Destroy;
begin
  if Assigned(FConnection) then
  begin
    DFrames.QueryDisconnectFromMyDFrames(Self);
    //Disconnect;
    FreeAndNil(FTransaction);
    FreeAndNil(FConnection);
  end;
  FreeAndNil(FAvailables);
  FreeAndNil(FAlisables);
  FreeAndNil(FCollations);
  FreeAndNil(FCharsets);
  FreeAndNil(FReservedWords);
  FreeAndNil(FFunctions);
  FreeAndNil(FTypes);
  FreeAndNil(FHighlighter);
  inherited Destroy;
end;

procedure TDDatabaseNode.IncreaseHighlighterInuse;
begin
  //This mechanisem used to update syntax hilighter just when it is in use
  //otherwise updates will discarded by highlighter!
  FHighlighterInUse.Inc;
  if FHighlighterInUse > 0 then
    UpdateHighliter;
end;

procedure TDDatabaseNode.DecreaseHighlighterInUse;
begin

end;

class function TDDatabaseNode.CloseQuery: Boolean;
var
  dbn: Pointer;
begin
  Result := True;
  for dbn in ConnectedDatabases do
  begin
    if TDDatabaseNode(dbn).Connected then
    begin
      TDDatabaseNode(dbn).Disconnect;
    end;
    Result := (not TDDatabaseNode(dbn).Connected) and Result;
  end;
end;

class function TDDatabaseNode.NewConnection(AServerNode: TDServerNode; AOwner: TComponent): TUIBDataBase;
var
  srv_port: String;
begin
  if (AServerNode.MachineType = dstEmbedded) then
  begin
    if EmbeddedLibraryLoaded + EmbeddedLibraryPath <> '' then
    begin
      if (AServerNode.LibName + AServerNode.LibPath) <> (EmbeddedLibraryLoaded +
      EmbeddedLibraryPath) then
      begin
        MessageDlg('Attention',
          'Different Embedded library are currently attached and connected!' + LineEnding+
          Format('It`s seems %i connection', [EmbeddedReferenceCount])  + LineEnding+
          '  -Disconnect it and try again.' + LineEnding +
          '  -Use/Run another instance of the DSql.', mtWarning, [mbOK], '');
        Exit;
      end
      else
      begin
        EmbeddedReferenceCount += 1;
      end;
    end
    else if EmbeddedLibraryLoaded + EmbeddedLibraryPath = '' then
    begin
      PATH_LD := GetEnvironmentVar(CPATH_LD);
      if AppendToEnvironmentVar(CPATH_LD, AServerNode.FLibPath) and
         SetEnvironmentVar('FIREBIRD', EmbeddedLibraryPath) then
      begin
        EmbeddedLibraryLoaded := AServerNode.FLibName;
        EmbeddedLibraryPath := AServerNode.FLibPath;
        EmbeddedReferenceCount += 1;
      end;
    end
    else
    begin
      MessageDlg('Error', 'Update environment variable failed', mtError, [mbOK], '');
      Exit;
    end;
  end;

  Result := TUIBDataBase.Create(AOwner);
  //FTransaction := TUIBTransaction.Create(Self);
  //with FTransaction do
  //begin
  //  AutoStart := True;
  //  AutoStop := False;
  //  DefaultAction := etmStayIn;
  //end;
  //FTransaction.DataBase := vConnection;

  //vConnection.HostName := FServerNode.FServerAddress;
  //vConnection.DatabaseName := FDatabaseName;
  //vConnection.CharSet := CharSet;
  //vConnection.LoginPrompt := False;
  Result.LibraryName := AServerNode.LibName;
  //case FServerNode.MachineType of
  //  dstServer, dstLocalhost:
  //    begin
  //      srv_port := AServerNode.ServerAddress;
  //      if AServerNode.ServerPort <> '' then
  //        srv_port += '/' + AServerNode.ServerPort;
  //      srv_port += ':';
  //    end;
  //  dstEmbedded:
  //    begin
  //      srv_port := '';
  //    end;
  //end;
  //vConnection.DatabaseName := srv_port + FDatabaseName;
  //vConnection.Params.Values['lc_ctype'] := CharSet;
end;

initialization
  TDDatabaseNode.ConnectedDatabases := TList.Create;
finalization
  TDDatabaseNode.ConnectedDatabases.Free;
end.

