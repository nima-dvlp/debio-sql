//Debio Unit SqlInterface Firebird
unit duSIFirebird;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, duTypes, IBConnection;

type

  { TDSIFireird }

  TDSIFireird = class(TDSqlInterface)
  private
    function GetDatabase: TIBConnection;
    function SqlPrepare(Sql: String): Boolean;
    procedure SqlOpen;
    procedure SqlExecute;
  public
    class function GetDriverName: String; override;
    class function GetDriverConnectParameters: TStringDynArray; override;
    class function GetDriverCreateDatabaseParameters: TStringDynArray; override;

    function CheckDriverParameters(Params: TStrings): Boolean; override;
    function CheckDriverCreateDatabaseParameters(Params: TStrings): Boolean; override;
    function Connect: Boolean; override;
    function Disconnect: Boolean; override;

    property Database: TIBConnection read GetDatabase;
    property DBTransaction;

    function GetTreeNodes: TDSqlInterfaceNodes; override;

    function RetCollations: TStringDynArray; override;
    //function RetCharsets: TStringDynArray; override;
    //
    //function RetSequenses: TStringDynArray; override;

    //function RetTableList: TDSqlObjects; override;
    //function RetSysTableList: TDSqlObjects; override;
    //function RetViews: TDSqlObjects; override;
    //function RetFields(ObjectName: String; SysObject: Boolean = False): TDSqlFields; override;
    //function RetStoredprocedures: TDSqlObjects; override;
    //function RetTriggers: TDSqlObjects; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

const
  c_DSql_Functions = 'ABS,ACOS,ASCII_CHAR,ASCII_VAL,ASIN,ATAN,ATAN2,' +
  'BIN_AND,BIN_OR,BIN_SHL,BIN_SHR,BIN_XOR,BIT_LENGTH,CAST,CEIL,CEILING,' +
  'CHAR_LENGTH,CHARACTER_LENGTH,CHAR_TO_UUID,COALESCE,COS,COSH,COT,DATEADD,' +
  'DATEDIFF,DECODE,EXP,EXTRACT,FLOOR,GEN_ID,GEN_UUID,HASH,IIF,LEFT,LN,LOG,' +
  'LOG10,LOWER,LPAD,MAXVALUE,MINVALUE,MOD,NULLIF,OCTET_LENGTH,OVERLAY,PI,' +
  'POSITION,POWER,RAND,RDB$GET_CONTEXT,RDB$SET_CONTEXT,REPLACE,REVERSE,RIGHT,' +
  'ROUND,RPAD,SIGN,SIN,SINH,SQRT,SUBSTRING,TAN,TANH,TRIM,TRUNC,UPPER,UUID_TO_CHAR';

  // keywords
  c_DSql_KW: string = 'ACTIVE,ADD,AFTER,ALL,ALTER,AND,ANY,AS,ASC,' +
  'ASCENDING,AT,AUTO,AUTODDL,BASED,BASENAME,BASE_NAME,BEFORE,BEGIN,BETWEEN,' +
  'BLOBEDIT,BUFFER,BY,CACHE,CHARACTER_LENGTH,CHAR_LENGTH,CHECK,' +
  'CHECK_POINT_LEN,CHECK_POINT_LENGTH,COLLATE,COLLATION,COLUMN,COMMIT,' +
  'COMMITED,COMPILETIME,COMPUTED,CLOSE,CONDITIONAL,CONNECT,CONSTRAINT,' +
  'CONTAINING,CONTINUE,CREATE,CURRENT,CURRENT_DATE,CURRENT_TIME,' +
  'CURRENT_TIMESTAMP,CURSOR,DATABASE,DAY,DB_KEY,DEBUG,DEC,DECLARE,DEFAULT,' +
  'DELETE,DESC,DESCENDING,DESCRIBE,DESCRIPTOR,DISCONNECT,DISTINCT,DO,' +
  'DOMAIN,DROP,ECHO,EDIT,ELSE,END,ENTRY_POINT,ESCAPE,EVENT,EXCEPTION,' +
  'EXECUTE,EXISTS,EXIT,EXTERN,EXTERNAL,EXTRACT,FETCH,FILE,FILTER,FOR,' +
  'FOREIGN,FOUND,FROM,FULL,FUNCTION,GDSCODE,GENERATOR,GLOBAL,GOTO,GRANT,' +
  'GROUP,GROUP_COMMIT_WAIT,GROUP_COMMIT_WAIT_TIME,HAVING,HELP,HOUR,IF,' +
  'IMMEDIATE,IN,INACTIVE,INDEX,INDICATOR,INIT,INNER,INPUT,INPUT_TYPE,' +
  'INSERT,INT,INTO,IS,ISOLATION,ISQL,JOIN,KEY,LC_MESSAGES,LC_TYPE,LEFT,' +
  'LENGTH,LEV,LEVEL,LIKE,LOGFILE,LOG_BUFFER_SIZE,LOG_BUF_SIZE,LONG,MANUAL,' +
  'MAXIMUM,MAXIMUM_SEGMENT,MAX_SEGMENT,MERGE,MESSAGE,MINIMUM,MINUTE,' +
  'MODULE_NAME,MONTH,NAMES,NATIONAL,NATURAL,NCHAR,NO,NOAUTO,NOT,NULL,' +
  'NUM_LOG_BUFFS,NUM_LOG_BUFFERS,OCTET_LENGTH,OF,ON,ONLY,OPEN,OPTION,OR,' +
  'ORDER,OUTER,OUTPUT,OUTPUT_TYPE,OVERFLOW,PAGE,PAGELENGTH,PAGES,PAGE_SIZE,' +
  'PARAMETER,PASSWORD,PLAN,POSITION,POST_EVENT,PRECISION,PREPARE,PROCEDURE,' +
  'PROTECTED,PRIMARY,PRIVILEGES,PUBLIC,QUIT,RAW_PARTITIONS,READ,REAL,' +
  'RECORD_VERSION,REFERENCES,RELEASE,RESERV,RESERVING,RETAIN,RETURN,' +
  'RETURNING_VALUES,RETURNS,REVOKE,RIGHT,ROLLBACK,RUNTIME,SCHEMA,SECOND,' +
  'SEGMENT,SELECT,SET,SHADOW,SHARED,SHELL,SHOW,SINGULAR,SIZE,SNAPSHOT,SOME,' +
  'SORT,SQL,SQLCODE,SQLERROR,SQLWARNING,STABILITY,STARTING,STARTS,' +
  'STATEMENT,STATIC,STATISTICS,SUB_TYPE,SUSPEND,TABLE,TERMINATOR,THEN,TO,' +
  'TRANSACTION,TRANSLATE,TRANSLATION,TRIGGER,TRIM,TYPE,UNCOMMITTED,UNION,' +
  'UNIQUE,UPDATE,USER,USING,VALUE,VALUES,VARIABLE,VARYING,VERSION,VIEW,' +
  'WAIT,WEEKDAY,WHEN,WHENEVER,WHERE,WHILE,WITH,WORK,WRITE,YEAR,YEARDAY,' +
  'BLOCK,TERM';

  // types
  c_DSql_Types = 'BLOB,CHAR,CHARACTER,DATE,DECIMAL,DOUBLE,FLOAT,INTEGER,' +
  'NUMERIC,SMALLINT,TIME,TIMESTAMP,VARCHAR,BIGINT';

  //From Reserved
  c_DSql_From_Reserveds = 'FROM,JOIN,INNER,OUTER,LEFT,RIGHT,ON';

  C_Sql_Retrive_Sys_Tables =
  'SELECT RDB$RELATION_NAME AS "NAME", RDB$DESCRIPTION AS "COMMENT"' + LineEnding +
  '  FROM RDB$RELATIONS' + LineEnding +
  'WHERE RDB$SYSTEM_FLAG = 1' + LineEnding +
  '   AND RDB$VIEW_BLR IS NULL;';

  C_Sql_Retrive_Tables =
  'SELECT RDB$RELATION_NAME AS "NAME", RDB$DESCRIPTION AS "COMMENT"' + LineEnding +
  '  FROM RDB$RELATIONS' + LineEnding +
  'WHERE RDB$SYSTEM_FLAG = 0' + LineEnding +
  '   AND RDB$VIEW_BLR IS NULL;';

  C_Sql_Retrive_Views =
  'SELECT RDB$RELATION_NAME AS "NAME", RDB$DESCRIPTION AS "COMMENT"' + LineEnding +
  '  FROM RDB$RELATIONS' + LineEnding +
  'WHERE RDB$SYSTEM_FLAG = 0' + LineEnding +
  '   AND RDB$VIEW_BLR IS NOT NULL;';

  C_Sql_Retrive_Procedures = 'SELECT P.RDB$PROCEDURE_NAME "NAME", P.RDB$DESCRIPTION "COMMENT" FROM RDB$PROCEDURES P ORDER BY P.RDB$PROCEDURE_NAME;';

  C_CSql_Field_Type =
  '  IIF (RF.RDB$FIELD_SOURCE NOT SIMILAR TO ''RDB$%'', RF.RDB$FIELD_SOURCE,' + LineEnding +
  '  CASE F.RDB$FIELD_TYPE' + LineEnding +
  '  WHEN 7 THEN' + LineEnding +
  '    IIF(F.RDB$FIELD_SUB_TYPE IS NULL, ''SMALLINT'',' + LineEnding +
  '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
  '        WHEN 0 THEN ''SMALLINT''' + LineEnding +
  '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
  '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
  '      END' + LineEnding +
  '    )' + LineEnding +
  '  WHEN 8 THEN' + LineEnding +
  '    IIF(F.RDB$FIELD_SUB_TYPE IS NULL, ''INTEGER'',' + LineEnding +
  '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
  '        WHEN 0 THEN ''INTEGER''' + LineEnding +
  '        WHEN 1 THEN ''NUMERIC(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
  '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
  '      END)' + LineEnding +
  '  WHEN 9 THEN ''QUAD''' + LineEnding +
  '  WHEN 10 THEN ''FLOAT''' + LineEnding +
  '  WHEN 12 THEN ''DATE''' + LineEnding +
  '  WHEN 13 THEN ''TIME''' + LineEnding +
  '  WHEN 14 THEN ''CHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || CH.RDB$DEFAULT_COLLATE_NAME' + LineEnding +
  '  WHEN 16 THEN' + LineEnding +
  '    CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
  '      WHEN 0 THEN ''BIGINT''' + LineEnding +
  '      WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
  '      WHEN 2 THEN ''DECIMAL''' + LineEnding +
  '    END' + LineEnding +
  '  WHEN 27 THEN ''DOUBLE''' + LineEnding +
  '  WHEN 35 THEN ''TIMESTAMP''' + LineEnding +
  '  WHEN 37 THEN ''VARCHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || CH.RDB$DEFAULT_COLLATE_NAME' + LineEnding +
  '  WHEN 40 THEN ''CSTRING'' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || CH.RDB$DEFAULT_COLLATE_NAME' + LineEnding +
  '  WHEN 45 THEN ''BLOB_ID''' + LineEnding +
  '  WHEN 261 THEN ''BLOB '' ||' + LineEnding +
  '    CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
  '      WHEN 0 THEN ''BINARY''' + LineEnding +
  '      WHEN 1 THEN ''TEXT''' + LineEnding +
  '      WHEN 2 THEN ''BLR''' + LineEnding +
  '      ELSE ''SUB TYPE '' || F.RDB$FIELD_SUB_TYPE' + LineEnding +
  '    END' + LineEnding +
  '    ELSE ''RDB$FIELD_TYPE: '' || F.RDB$FIELD_TYPE || ''?''' + LineEnding +
  '  END) "_TYPE_",' + LineEnding;

  C_Sql_Retrive_Table_Fields =
  'SELECT' + LineEnding +
  '  RF.RDB$FIELD_NAME FIELD_NAME,' + LineEnding +
  C_CSql_Field_Type +
  '  F.RDB$COMPUTED_SOURCE "COMPUTED",' + LineEnding +
  '  IIF(RF.RDB$DESCRIPTION IS NULL, '''', RF.RDB$DESCRIPTION) "COMMENT"' + LineEnding +
  'FROM RDB$RELATION_FIELDS RF' + LineEnding +
  'JOIN RDB$FIELDS F ON (F.RDB$FIELD_NAME = RF.RDB$FIELD_SOURCE)' + LineEnding +
  'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)' + LineEnding +
  'LEFT OUTER JOIN RDB$COLLATIONS DCO ON ((DCO.RDB$COLLATION_ID = F.RDB$COLLATION_ID) AND (DCO.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID))' + LineEnding +
  'WHERE (RF.RDB$RELATION_NAME = :TBL) AND (COALESCE(RF.RDB$SYSTEM_FLAG, 0) = :SYS)' + LineEnding +
  'ORDER BY RF.RDB$FIELD_POSITION;';

  C_Sql_Retrive_Table_PrimaryKey =
  'select' + LineEnding +
  '    --i.rdb$index_name,' + LineEnding +
  '    --i.RDB$RELATION_NAME,' + LineEnding +
  '    s.rdb$field_name as pm_key' + LineEnding +
  'from' + LineEnding +
  '    rdb$indices i' + LineEnding +
  'left join rdb$index_segments s on i.rdb$index_name = s.rdb$index_name' + LineEnding +
  'left join rdb$relation_constraints rc on rc.rdb$index_name = i.rdb$index_name' + LineEnding +
  'where' + LineEnding +
  '    rc.rdb$constraint_type = ''PRIMARY KEY'' and i.RDB$RELATION_NAME = :TBL';

  C_Sql_Retrive_Procedure_Parameters =
  'SELECT' + LineEnding +
  '  RF.RDB$PARAMETER_NAME PARAM_NAME,' + LineEnding +
  '  RF.RDB$PARAMETER_TYPE PARAM_IO,' + LineEnding +
  '  IIF(RF.RDB$PARAMETER_TYPE = 0, ''INPUT'', ''OUTPUT'') PARAM_IO_DESC,' + LineEnding +
  C_CSql_Field_Type +
  '  RF.RDB$DESCRIPTION "COMMENT"' + LineEnding +
  'FROM RDB$PROCEDURE_PARAMETERS RF' + LineEnding +
  ' JOIN RDB$FIELDS F ON (F.RDB$FIELD_NAME = RF.RDB$FIELD_SOURCE)' + LineEnding +
  'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)' + LineEnding +
  'LEFT OUTER JOIN RDB$COLLATIONS DCO ON ((DCO.RDB$COLLATION_ID = F.RDB$COLLATION_ID) AND (DCO.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID))' + LineEnding +
  'WHERE (RF.RDB$PROCEDURE_NAME = :PRC) AND (COALESCE(RF.RDB$SYSTEM_FLAG, 0) = 0)' + LineEnding +
  'ORDER BY RF.RDB$PARAMETER_TYPE;';

  C_Sql_Retrive_Domains =
  'SELECT' + LineEnding +
  '  F.RDB$FIELD_NAME "NAME",' + LineEnding +
  C_CSql_Field_Type +
  '  IIF(F.RDB$DESCRIPTION IS NULL, '''', F.RDB$DESCRIPTION) "COMMENT"' + LineEnding +
  '' + LineEnding +
  'FROM RDB$FIELDS F' + LineEnding +
  'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)' + LineEnding +
  'WHERE F.RDB$SYSTEM_FLAG = 0 and (NOT F.RDB$FIELD_NAME LIKE ''RDB$%'')' + LineEnding +
  'ORDER BY F.RDB$FIELD_NAME';

  C_Sql_Retrive_Charsets = 'SELECT cs.RDB$CHARACTER_SET_NAME TITLE FROM RDB$CHARACTER_SETS cs WHERE cs.RDB$CHARACTER_SET_NAME <> ''NONE'' AND cs.RDB$CHARACTER_SET_NAME <> '''' ORDER BY cs.RDB$CHARACTER_SET_NAME';

  C_Sql_Retrive_Collations = 'SELECT cs.RDB$COLLATION_NAME TITLE FROM RDB$COLLATIONS cs WHERE cs.RDB$COLLATION_NAME <> ''NONE'' AND cs.RDB$COLLATION_NAME <> '''' ORDER BY cs.RDB$COLLATION_NAME';

{ TDSIFireird }

function TDSIFireird.GetDatabase: TIBConnection;
begin
  Result := TIBConnection(FDatabase);
end;

function TDSIFireird.SqlPrepare(Sql: String): Boolean;
begin
  Result := False;
  if not FDBInternalTransaction.Active then
    FDBInternalTransaction.StartTransaction;
  if FDBInternalSqlQuery.Active then
    FDBInternalSqlQuery.Close;
  FDBInternalSqlQuery.SQL.Text := Sql;
  FDBInternalSqlQuery.Prepare;
  Result := FDBInternalSqlQuery.Prepared;
end;

procedure TDSIFireird.SqlOpen;
begin
  if not FDBInternalSqlQuery.Prepared then
    FDBInternalSqlQuery.Open;
end;

procedure TDSIFireird.SqlExecute;
begin
  if not FDBInternalSqlQuery.Prepared then
    FDBInternalSqlQuery.ExecSQL;
end;

class function TDSIFireird.GetDriverName: String;
begin
  Result := 'Firebird/Interbase';
end;

class function TDSIFireird.GetDriverConnectParameters: TStringDynArray;
var
  id: Integer;
begin
  Result := inherited GetDriverConnectParameters;
  id := Length(Result);
  SetLength(Result, id + 6);
  Result[id] := 'Database:Str|Req';
  Result[id + 1] := 'Server:Str|Req';
  Result[id + 2] := 'Port:Int|Req';
  Result[id + 3] := 'User:Str|Req';
  Result[id + 4] := 'Password:Pas|Req';
  Result[id + 5] := 'Dialect:Sel|ID=1|(1,3)';
end;

class function TDSIFireird.GetDriverCreateDatabaseParameters: TStringDynArray;
begin
  SetLength(Result, 6);
  Result[0] := 'Database:Str|Req';
  Result[1] := 'Server:Str|Req';
  Result[2] := 'Port:Int|(3050)';
  Result[3] := 'User:Str|Req';
  Result[4] := 'Password:Pas|Req';
  Result[5] := 'Dialect:Sel|ID=1|(1,3)';
end;

function TDSIFireird.CheckDriverParameters(Params: TStrings): Boolean;
begin

end;

function TDSIFireird.CheckDriverCreateDatabaseParameters(Params: TStrings): Boolean;
begin

end;

function TDSIFireird.Connect: Boolean;
begin
  FDatabase.Connected := True;
end;

function TDSIFireird.Disconnect: Boolean;
begin
  FDatabase.Connected := False;
end;

function TDSIFireird.GetTreeNodes: TDSqlInterfaceNodes;
begin
  Result := [dsinTables..dsinDomains];
end;

function TDSIFireird.RetCollations: TStringDynArray;
begin
  SqlPrepare(C_Sql_Retrive_Charsets);
  while not FDBInternalSqlQuery.EOF do
  begin
    FCharsets.AddObject(Trim(FDBInternalSqlQuery.FieldByName('TITLE').AsString), TObject(Pointer(PtrInt(dswtCharset))));
    FDBInternalSqlQuery.Next;
  end;
  FDBInternalSqlQuery.Close;
end;

//function TDSIFireird.RetCharsets: TStringDynArray;
//begin
//
//end;
//
//function TDSIFireird.RetSequenses: TStringDynArray;
//begin
//
//end;
//
//function TDSIFireird.RetTableList: TDSqlObjects;
//begin
//
//end;
//
//function TDSIFireird.RetSysTableList: TDSqlObjects;
//begin
//
//end;
//
//function TDSIFireird.RetViews: TDSqlObjects;
//begin
//
//end;
//
//function TDSIFireird.RetFields(ObjectName: String; SysObject: Boolean): TDSqlFields;
//begin
//
//end;
//
//function TDSIFireird.RetStoredprocedures: TDSqlObjects;
//begin
//
//end;
//
//function TDSIFireird.RetTriggers: TDSqlObjects;
//begin
//
//end;

constructor TDSIFireird.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDatabase := TIBConnection.Create(Self);
  FDBTransaction := TSQLTransaction.Create(Self);
  FDatabase.Transaction := FDBTransaction;

  FDBInternalTransaction := TSQLTransaction.Create(Self);
  FDBInternalTransaction.DataBase := FDatabase;

  FDBInternalSqlQuery := TSQLQuery.Create(Self);
  FDBInternalSqlQuery.DataBase := FDatabase;
  FDBInternalSqlQuery.Transaction := FDBInternalTransaction;

end;

end.

