unit duTypes;

{$mode objfpc}{$H+}

interface

uses SysUtils, Classes, SqlDB, Graphics, Grids;

type

  TDFirebirdVersion = (dfb21, dfb25, dfb3);

  TDSqlWordtype = (dswtUknown, dswtType, dswtDomain, dswtSysTable, dswtTable, dswtView, dswtField, dswtFieldAll, dswtFieldAllList,
      dswtAlias, dswtProcedure, dswtFunction, dswtUDFFunction, dswtReserved, dswtSequense, dswtVariable,
      dswtParameter, dswtArgument, dswtReturns, dswtCharset, dswtCollation, dswtIndex, dswtTrigger, dswtException);

  TDNodeType = (
    dntHome,
    dntServer,
    dntDatabase,
    dntMetaDataCollection,
    dntTables,
      dntTable,
      //Table Primary Key
      dntTablePmKey,
      //Table Foreing Key
      dntTableFgKey,
      //Table Field
      dntTableField,
      //Table Computed Field
      dntTableComtd,
    dntSysTables,
      dntSysTable,
    dntProcedures,
      dntProcedure,
      dntProcedureParams,
      dntProcedureReturns,
    dntSequences,
      dntSequence,
    dntViews,
     dntView,
     dntViewField,
    dntExceptions,
      dntException,
    dntUserDFunctions,
      dntUserDFunction,
      dntUserDFunctionArguments,
      dntUserDFunctionReturns,
    dntFunctions,
      dntFunction,
      dntFunctionArguments,
      dntFunctionReturns,
    dntDomains,
      dntDomain,
    dntTriggers,
      dntTriggerActive,
      dntTriggerInactive,
    dntIndices,
      dntIndexActive,
      dntIndexInActive);

  TDNodeForms = array [Boolean] of TDNodeType;

  TDSqlDFrameshowState = set of (dsesExecuteAfterShow, dsesItIsScript, dsesItIsScriptAutoDDL);

const
  //Procedure Param Type
  DC_ProcedureArgument: TDNodeForms = (dntProcedureParams, dntProcedureReturns);

  //Function Param Type
  DC_FunctionArgument: TDNodeForms = (dntFunctionReturns, dntFunctionArguments);

  //UserDefinedFunction Param Type
  DC_UserDefinedFunctionArgument: TDNodeForms = (dntUserDFunctionReturns, dntUserDFunctionArguments);

  //Table Fields Primary/Ordinal
  DC_TableFieldType   : TDNodeForms = (dntTableField, dntTablePmKey);
  DC_ViewFieldType   : TDNodeForms = (dntTableField, dntTableField);

  //Trigger Active State
  DC_TriggerState: array[Boolean] of TDNodeType = (dntTriggerActive, dntTriggerInactive);

  //Indecies Active State
  DC_IndexState: array[Boolean] of TDNodeType = (dntIndexActive, dntIndexInActive);

type

  TDRetriveMetaData = set of (
    drmdCollations,
    drmdCharsets,
    drmdTables,
    drmdSysTables,
    drmdProcedures,
    drmdSequences,
    drmdViews,
    drmdExceptions,
    drmdUserDFunctions,
    drmdFunctions,
    drmdDomains,
    drmdTriggers,
    drmdIndices);
const

  DC_AllMetaData: TDRetriveMetaData = [drmdCollations, drmdCharsets, drmdTables, drmdSysTables, drmdProcedures, drmdSequences,
    drmdViews, drmdExceptions, drmdUserDFunctions, drmdFunctions, drmdDomains, drmdTriggers, drmdIndices];

type

  TDSqlInterfaceNode = (dsinTables, dsinSysTables, dsinProcedures, dsinSequenses, dsinViews, dsinExceptions,
    dsinUserDFunctions, dsinFunctions, dsinDomains);

  TDSqlInterfaceNodes = set of TDSqlInterfaceNode;

  TDSqlType = (dstQuery, dstScritp, dstNotParsed);

  TDSqlField = record
    Name: String;
    FieldType: String;
    Comment: String;
    //FieldDefault: String;
    //FieldCheck: String;
    //FieldCompute: String;
    FieldDefault_Check_Compute: String;
    //FieldPK: Boolean;
    //FieldAI: Boolean;
    //FieldFK: Boolean
  end;

  //TDSqlParameter = record
  //  Name: String;
  //  ParamType: String;
  //  Comment: String;
  //  Input: Boolean
  //end;


  generic TDSqlObject<TDObj> = record
    Name: String;
    Comment: String;
    Details: array of TDObj;
  end;

  TDSqlTable = specialize TDSqlObject<TDSqlField>;
  TDSqlTables = array of TDSqlTable;
  TDSqlView = TDSqlTable;
  TDSqlViews = array of TDSqlView;

  //TDSqlStoredProcedure = specialize TDSqlObject<TDSqlParameter>;
  //TDSqlStoredProcedure = specialize TDSqlStoredProcedure;


  TDSqlDomain = record
    Name: String;
    DomainType: String;
    Comment: String;
  end;

  TDSqlDomains = array of TDSqlDomain;

  { TDSqlInterface }

  TDSqlInterface = class(TComponent)
  protected
    FDatabase: TSQLConnection;
    FDBTransaction: TSQLTransaction;
    FDBInternalSqlQuery: TSQLQuery;
    FDBInternalTransaction: TSQLTransaction;

    FCharSets: TStringList;
  public
    class function GetDriverName: String; virtual; abstract;
    class function GetDriverConnectParameters: TStringArray; virtual;
    class function GetDriverCreateDatabaseParameters: TStringArray; virtual; abstract;

    //This functions needed for creating Gui

    //Parameters needed for database connection
    function CheckDriverParameters(Params: TStrings): Boolean; virtual; abstract;
    //Parameters Needed for Creating Database
    function CheckDriverCreateDatabaseParameters(Params: TStrings): Boolean; virtual; abstract;

    function Connect: Boolean; virtual; abstract;
    function Disconnect: Boolean; virtual; abstract;

    property Database: TSQLConnection read FDatabase;
    property DBTransaction: TSQLTransaction read FDBTransaction;

    function GetTreeNodes: TDSqlInterfaceNodes; virtual; abstract;

    function RetCollations: TStringArray; virtual; abstract;
    function RetCharsets: TStringArray; virtual; abstract;

    function RetSequenses: TStringArray; virtual; abstract;
    //function RetTableList: TDSqlObjects; virtual; abstract;
    //function RetSysTableList: TDSqlObjects; virtual; abstract;
    //function RetTriggersOf(ATable: String): TDSqlObjects; virtual; abstract;
    //function RetViews: TDSqlObjects; virtual; abstract;
    //function RetFields(ObjectName: String; SysObject: Boolean = False): TDSqlFields; virtual; abstract;
    //function RetStoredprocedures: TDSqlObjects; virtual; abstract;
    //function RetTriggers: TDSqlObjects; virtual; abstract;
    //constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TDFont = record
    Name: String;
    Color: TColor;
    Size: Integer;
    Style: TFontStyles;
    Quality: TFontQuality;
  end;

  TDAppreanceAttribout = record
    Background: TColor;
    Foreground: TColor;
  end;

  TDLogStyle = record
    Background: TColor;
    Font: TDFont;
    Information: TDAppreanceAttribout;
    Detail: TDAppreanceAttribout;
    Error: TDAppreanceAttribout;
  end;

  TDGridStyle = record
    Title_Font: TDFont;
    Title_Background: TColor;
    CellFont: TDFont;
    Background: TColor;
    OddRowColor: TColor;
    Title_Style: TTitleStyle;
  end;

implementation

{ TDSqlInterface }

class function TDSqlInterface.GetDriverConnectParameters: TStringArray;
begin
  SetLength(Result, 1);
  Result[0] := 'Title:Str|Req';
end;

//constructor TDSqlInterface.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//  FCharSets := TStringList.Create;
//end;

destructor TDSqlInterface.Destroy;
begin
  FreeAndNil(FCharSets);
  inherited Destroy;
end;

end.

