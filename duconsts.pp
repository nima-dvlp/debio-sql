unit duConsts;

{$mode objfpc}{$H+}

interface

uses
  Classes, duTypes, Debio.Types, Debio.Utils;

const

  c_sql_objects_dropable = [dntTable, dntTablePmKey, dntTableFgKey, dntTableField,
     dntTableComtd, dntProcedure, dntSequence, dntView, dntException, dntUserDFunction, dntFunction,
     dntDomain, dntTriggerActive, dntTriggerInactive, dntIndexActive, dntIndexInActive];

  c_sql_objects_CommanetAble = c_sql_objects_dropable + [dntUserDFunctionArguments, dntFunctionArguments, dntProcedureParams];

  c_config_file: String = 'DSql.conf';

  c_DSqlWordtype: array[TDSqlWordtype] of String = (
      'uknown', 'type', 'domain', 'systable', 'table', 'view', 'field', 'all fields', 'list all fields', 'alias', 'procedure', 'function', 'udfunction',
      'reserved', 'sequence', 'variable', 'parameter', 'argument', 'retuns', 'charset', 'collation', 'index', 'trigger', 'exception'
    );

  c_DNodeImageIndex : array[TDNodeType]of SmallInt = (
    0,           // dntHome
    1,           // dntServer
    2,           // dntDatabase
    -1,          // dntMetaDataCollection
    3,           // dntTables
      4,         //   dntTable
      5,         //   dntTablePmKey
      6,         //   dntTableFgKey
      7,         //   dntTableField
      8,         //   dntTableComtd
    17,          // dntSysTables
      18,        //   dntSysTable
    14,          // dntProcedures
      9,         //   dntProcedure
      10,        //   dntProcedureParams
      11,        //   dntProcedureReturns
    29,          // dntSequenses
      30,        //   dntSequense
    12,          // dntViews
      13,        //  dntView
      8,         //  dntViewFields
    24,          // dntExceptions
      25,        //   dntException
    20,          // dntUserDFunctions
      19,        //   dntUserDFunction
      10,        //     dntUserDFunctionArguments
      11,        //     dntUserDFunctionReturns
    20,          // dntFunctions
      19,        //   dntFunction
      10,        //     dntFunctionArguments
      11,        //     dntFunctionReturns
    15,          // dntDomains
      16,        // dntDomain
    21,          // dntTriggers
      22,        //   dntTriggerActive
      23,        //   dntTriggerInactive
    26,          // dntIndices
      27,        //   dntIndexActive
      28         //   dntIndexInActive
  );

  Interbase6Functions = 'ABS,ACOS,ASCII_CHAR,ASCII_VAL,ASIN,ATAN,ATAN2,' +
    'BIN_AND,BIN_OR,BIN_SHL,BIN_SHR,BIN_XOR,BIT_LENGTH,CAST,CEIL,CEILING,' +
    'CHAR_LENGTH,CHARACTER_LENGTH,CHAR_TO_UUID,COALESCE,COS,COSH,COT,DATEADD,' +
    'DATEDIFF,DECODE,EXP,EXTRACT,FLOOR,GEN_ID,GEN_UUID,HASH,IIF,LN,LOG,' +
    'LOG10,LOWER,LPAD,MAXVALUE,MINVALUE,MOD,NULLIF,OCTET_LENGTH,OVERLAY,PI,' +
    'POSITION,POWER,RAND,RDB$GET_CONTEXT,RDB$SET_CONTEXT,REPLACE,REVERSE' +
    'ROUND,RPAD,SIGN,SIN,SINH,SQRT,SUBSTRING,TAN,TANH,TRIM,TRUNC,UPPER,UUID_TO_CHAR'+
    //MaMrEzO Add
    ',LIST';

  // keywords
  Interbase6KW = 'ACTIVE,ADD,AFTER,ALL,ALTER,AND,ANY,AS,ASC,' +
    'ASCENDING,AT,AUTO,AUTODDL,BASED,BASENAME,BASE_NAME,BEFORE,BEGIN,BETWEEN,' +
    'BLOBEDIT,BUFFER,BY,CACHE,CHECK,' +
    'CHECK_POINT_LEN,CHECK_POINT_LENGTH,COLLATE,COLLATION,COLUMN,COMMIT,' +
    'COMMITED,COMPILETIME,COMPUTED,CLOSE,CONDITIONAL,CONNECT,CONSTRAINT,' +
    'CONTAINING,CONTINUE,CREATE,CURRENT,CURRENT_DATE,CURRENT_TIME,' +
    'CURRENT_TIMESTAMP,CURSOR,DATABASE,DAY,DB_KEY,DEBUG,DEC,DECLARE,DEFAULT,' +
    'DELETE,DESC,DESCENDING,DESCRIBE,DESCRIPTOR,DISCONNECT,DISTINCT,DO,' +
    'DOMAIN,DROP,ECHO,EDIT,ELSE,END,ENTRY_POINT,ESCAPE,EVENT,EXCEPTION,' +
    'EXECUTE,EXISTS,EXIT,EXTERN,EXTERNAL,FETCH,FILE,FILTER,FOR,' +
    'FOREIGN,FOUND,FROM,FULL,FUNCTION,GDSCODE,GENERATOR,GLOBAL,GOTO,GRANT,' +
    'GROUP,GROUP_COMMIT_WAIT,GROUP_COMMIT_WAIT_TIME,HAVING,HELP,HOUR,IF,' +
    'IMMEDIATE,IN,INACTIVE,INDEX,INDICATOR,INIT,INNER,INPUT,INPUT_TYPE,' +
    'INSERT,INT,INTO,IS,ISOLATION,ISQL,JOIN,KEY,LC_MESSAGES,LC_TYPE,LEFT,' +
    'LENGTH,LEV,LEVEL,LIKE,LOGFILE,LOG_BUFFER_SIZE,LOG_BUF_SIZE,LONG,MANUAL,' +
    'MAXIMUM,MAXIMUM_SEGMENT,MAX_SEGMENT,MERGE,MESSAGE,MINIMUM,MINUTE,' +
    'MODULE_NAME,MONTH,NAMES,NATIONAL,NATURAL,NCHAR,NO,NOAUTO,NOT,NULL,' +
    'NUM_LOG_BUFFS,NUM_LOG_BUFFERS,OF,ON,ONLY,OPEN,OPTION,OR,' +
    'ORDER,OUTER,OUTPUT,OUTPUT_TYPE,OVERFLOW,PAGE,PAGELENGTH,PAGES,PAGE_SIZE,' +
    'PARAMETER,PASSWORD,PLAN,POST_EVENT,PRECISION,PREPARE,PROCEDURE,' +
    'PROTECTED,PRIMARY,PRIVILEGES,PUBLIC,QUIT,RAW_PARTITIONS,READ,REAL,' +
    'RECORD_VERSION,REFERENCES,RELEASE,RESERV,RESERVING,RETAIN,RETURN,' +
    'RETURNING_VALUES,RETURNS,REVOKE,RIGHT,ROLLBACK,RUNTIME,SCHEMA,SECOND,' +
    'SEGMENT,SELECT,SET,SHADOW,SHARED,SHELL,SHOW,SINGULAR,SIZE,SNAPSHOT,SOME,' +
    'SORT,SQL,SQLCODE,SQLERROR,SQLWARNING,STABILITY,STARTING,STARTS,' +
    'STATEMENT,STATIC,STATISTICS,SUB_TYPE,SUSPEND,TABLE,TERMINATOR,THEN,TO,' +
    'TRANSACTION,TRANSLATE,TRANSLATION,TRIGGER,TYPE,UNCOMMITTED,UNION,' +
    'UNIQUE,UPDATE,USER,USING,VALUE,VALUES,VARIABLE,VARYING,VERSION,VIEW,' +
    'WAIT,WEEKDAY,WHEN,WHENEVER,WHERE,WHILE,WITH,WORK,WRITE,YEAR,YEARDAY,' +
    'BLOCK,TERM,CASE,' + //MaMrEzO
    'CHARACTER,ROW,DELETING,UPDATING,INSERTING,COMMENT,SEQUENCE,'+
    'RECREATE,NEW,OLD,NEXT,BOTH,CROSS,CURRENT_CONNECTION,CURRENT_ROLE,'+
    'CURRENT_TRANSACTION,CURRENT_USER,LEADING,ROWS,SAVEPOINT,TRAILING,'+
    'STORED';

  // types
  Interbase6Types = 'BLOB,CHAR,DATE,DECIMAL,DOUBLE,FLOAT,INTEGER,' +
    'NUMERIC,SMALLINT,TIME,TIMESTAMP,VARCHAR,BIGINT';

//---Firebird3 Additon to Interbase6--------------------------------------------
  // functions
  Firebird3Functions = '';

  // keywords
  Firebird3KW = 'REGR_AVGX,SCROLL,CORR,REGR_AVGY,SQLSTATE,'+
    'COVAR_POP,REGR_COUNT,STDDEV_POP,COVAR_SAMP,REGR_INTERCEPT,STDDEV_SAMP,'+
    'DELETING,REGR_R2,TRUE,DETERMINISTIC,REGR_SLOPE,UNKNOWN,FALSE,REGR_SXX,'+
    'REGR_SXY,VAR_POP,OFFSET,REGR_SYY,VAR_SAMP,OVER,RETURN,RDB$RECORD_VERSION';

  // types
  Firebird3Types = 'BOOLEAN';

  FrebirdReserveds : array [TDFirebirdVersion] of String = (
    Interbase6KW ,
    Interbase6KW ,
    Interbase6KW + ',' + Firebird3KW
  );

  FrebirdFunctions : array [TDFirebirdVersion] of String = (
    Interbase6Functions ,
    Interbase6Functions ,
    Interbase6Functions //+ ',' + Firebird3Functions
  );

  FrebirdTypes : array [TDFirebirdVersion] of String = (
    Interbase6Types ,
    Interbase6Types ,
    Interbase6Types + ',' + Firebird3Types
  );

  //// types
  //c_DSql_Types = 'BLOB,CHAR,CHARACTER,DATE,DECIMAL,DOUBLE,FLOAT,INTEGER,' +
  //  'NUMERIC,SMALLINT,TIME,TIMESTAMP,VARCHAR,BIGINT';

  //From Reserved
  c_DSql_From_Reserveds = 'FROM,JOIN,INNER,OUTER,LEFT,RIGHT,ON';

  //Get FBServer Version
  C_DSql_Get_Server_Version = 'SELECT RDB$GET_CONTEXT(''SYSTEM'', ''ENGINE_VERSION'') CORE_VERSION FROM RDB$DATABASE;';

  C_Sql_Retrive_Sys_Tables =
    'SELECT RDB$RELATION_NAME AS "NAME", CAST(RDB$DESCRIPTION AS VARCHAR(2048)) AS "COMMENT"' + LineEnding +
    '  FROM RDB$RELATIONS' + LineEnding +
    'WHERE RDB$SYSTEM_FLAG = 1' + LineEnding +
    '   AND RDB$VIEW_BLR IS NULL;';

  C_Sql_Retrive_Tables =
    'SELECT RDB$RELATION_NAME AS "NAME", CAST(RDB$DESCRIPTION AS VARCHAR(2048)) AS "COMMENT"' + LineEnding +
    '  FROM RDB$RELATIONS' + LineEnding +
    'WHERE RDB$SYSTEM_FLAG = 0' + LineEnding +
    '   AND RDB$VIEW_BLR IS NULL;';

  C_Sql_Retrive_Views =
    'SELECT RDB$RELATION_NAME AS "NAME", CAST(RDB$DESCRIPTION AS VARCHAR(2048)) AS "COMMENT"' + LineEnding +
    '  FROM RDB$RELATIONS' + LineEnding +
    'WHERE RDB$SYSTEM_FLAG = 0' + LineEnding +
    '   AND RDB$VIEW_BLR IS NOT NULL;';

  C_Sql_Retrive_View_Source =
    'SELECT' + LineEnding +
    '  r.RDB$VIEW_SOURCE' + LineEnding +
    'FROM' + LineEnding +
    '  RDB$RELATIONS r' + LineEnding +
    'WHERE' + LineEnding +
    '  r.RDB$RELATION_NAME = :vw';

  C_Sql_Retrive_Procedures = 'SELECT P.RDB$PROCEDURE_NAME "NAME", CAST(P.RDB$DESCRIPTION AS VARCHAR(2048)) "COMMENT" FROM RDB$PROCEDURES P ORDER BY P.RDB$PROCEDURE_NAME;';

  C_Sql_Retrive_Functions = 'SELECT F.RDB$FUNCTION_NAME "NAME", CAST(F.RDB$DESCRIPTION AS VARCHAR(2048)) "COMMENT" FROM RDB$FUNCTIONS F WhERE F.RDB$MODULE_NAME IS NULL ORDER BY F.RDB$FUNCTION_NAME;';

  C_Sql_Retrive_UFunctions = 'SELECT F.RDB$FUNCTION_NAME "NAME", CAST(F.RDB$DESCRIPTION AS VARCHAR(2048)) "COMMENT" FROM RDB$FUNCTIONS F WHERE F.RDB$SYSTEM_FLAG = 0 AND  F.RDB$MODULE_NAME IS NOT NULL ORDER BY F.RDB$FUNCTION_NAME;';

  C_Sql_Retrive_Table_Fields =
    'SELECT' + LineEnding +
    '  RF.RDB$FIELD_NAME FIELD_NAME,' + LineEnding +
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
    '  WHEN 14 THEN ''CHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '  WHEN 16 THEN' + LineEnding +
    '    CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '      WHEN 0 THEN ''BIGINT''' + LineEnding +
    '      WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '      WHEN 2 THEN ''DECIMAL''' + LineEnding +
    '    END' + LineEnding +
    '  WHEN 27 THEN ''DOUBLE''' + LineEnding +
    '  WHEN 35 THEN ''TIMESTAMP''' + LineEnding +
    '  WHEN 37 THEN ''VARCHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '  WHEN 40 THEN ''CSTRING'' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '  WHEN 45 THEN ''BLOB_ID''' + LineEnding +
    '  WHEN 261 THEN ''BLOB '' ||' + LineEnding +
    '    CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '      WHEN 0 THEN ''BINARY''' + LineEnding +
    '      WHEN 1 THEN ''TEXT''' + LineEnding +
    '      WHEN 2 THEN ''BLR''' + LineEnding +
    '      ELSE ''SUB TYPE '' || F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '    END' + LineEnding +
    '    ELSE ''RDB$FIELD_TYPE: '' || F.RDB$FIELD_TYPE || ''?''' + LineEnding +
    '  END) FIELD_TYPE,' + LineEnding +
    '  F.RDB$COMPUTED_SOURCE "COMPUTED",' + LineEnding +
    '  IIF(RF.RDB$DESCRIPTION IS NULL, '''', CAST(RF.RDB$DESCRIPTION AS VARCHAR(2048))) "COMMENT"' + LineEnding +
    'FROM RDB$RELATION_FIELDS RF' + LineEnding +
    'JOIN RDB$FIELDS F ON (F.RDB$FIELD_NAME = RF.RDB$FIELD_SOURCE)' + LineEnding +
    'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)' + LineEnding +
    'LEFT OUTER JOIN RDB$COLLATIONS DCO ON ((DCO.RDB$COLLATION_ID = F.RDB$COLLATION_ID) AND (DCO.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID))' + LineEnding +
    'WHERE (RF.RDB$RELATION_NAME = :TBL) /*AND (COALESCE(RF.RDB$SYSTEM_FLAG, 0) = :SYS)*/' + LineEnding +
    'ORDER BY RF.RDB$FIELD_POSITION;';

  C_Sql_Retrive_Table_PF_Key =
(*
SELECT
  TRIM(s.RDB$FIELD_NAME) KEY_NAME,
  TRIM(rc.RDB$CONSTRAINT_TYPE) KEY_TYPE,
  i.RDB$FOREIGN_KEY,
  IIF(rc.RDB$CONSTRAINT_TYPE = 'FOREIGN KEY',
    TRIM((SELECT iii.RDB$RELATION_NAME from RDB$INDICES iii where iii.RDB$INDEX_NAME =
          (SELECT ii.RDB$FOREIGN_KEY FROM RDB$INDICES ii WHERE ii.RDB$INDEX_NAME = rc.RDB$INDEX_NAME))) || '.' ||
    TRIM((SELECT ids.RDB$FIELD_NAME FROM RDB$INDEX_SEGMENTS ids WHERE ids.RDB$FIELD_NAME = s.RDB$FIELD_NAME AND ids.RDB$INDEX_NAME = i.RDB$FOREIGN_KEY))
      /*(SELECT ii.RDB$FOREIGN_KEY FROM RDB$INDICES ii WHERE ii.RDB$INDEX_NAME = rc.RDB$INDEX_NAME))) /*|| ' (' ||
        TRIM((SELECT i.RDB$FOREIGN_KEY FROM RDB$INDICES ii WHERE ii.RDB$INDEX_NAME = rc.RDB$INDEX_NAME)) || ')'*/
  , NULL) REFERENCE,
  rc.*
FROM
    RDB$INDICES i
LEFT JOIN RDB$INDEX_SEGMENTS s on i.RDB$INDEX_NAME = s.RDB$INDEX_NAME
LEFT JOIN RDB$RELATION_CONSTRAINTS rc on rc.RDB$INDEX_NAME = i.RDB$INDEX_NAME
WHERE
    rc.RDB$CONSTRAINT_TYPE in ('PRIMARY KEY', 'FOREIGN KEY') AND i.RDB$RELATION_NAME = 'EMPLOYEE'
*)
    'SELECT' + LineEnding +
    '  TRIM(s.RDB$FIELD_NAME) KEY_NAME,' + LineEnding +
    '  TRIM(rc.RDB$CONSTRAINT_TYPE) KEY_TYPE' + LineEnding +
    'FROM' + LineEnding +
    '    RDB$INDICES i' + LineEnding +
    'LEFT JOIN RDB$INDEX_SEGMENTS s on i.RDB$INDEX_NAME = s.RDB$INDEX_NAME' + LineEnding +
    'LEFT JOIN RDB$RELATION_CONSTRAINTS rc on rc.RDB$INDEX_NAME = i.RDB$INDEX_NAME' + LineEnding +
    'WHERE' + LineEnding +
    '    rc.RDB$CONSTRAINT_TYPE in (''PRIMARY KEY'', ''FOREIGN KEY'') AND i.RDB$RELATION_NAME = :TBL';

  C_Sql_Retrive_Procedure_Parameters =
    'SELECT' + LineEnding +
    '  RF.RDB$PARAMETER_NAME PARAM_NAME,' + LineEnding +
    '  RF.RDB$PARAMETER_TYPE PARAM_IO,' + LineEnding +
    '  IIF(RF.RDB$PARAMETER_TYPE = 0, ''INPUT'', ''OUTPUT'') PARAM_IO_DESC,' + LineEnding +
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
    '    WHEN 8 THEN' + LineEnding +
    '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''INTEGER''' + LineEnding +
    '        WHEN 1 THEN ''NUMERIC(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
    '      END' + LineEnding +
    '    WHEN 9 THEN ''QUAD''' + LineEnding +
    '    WHEN 10 THEN ''FLOAT''' + LineEnding +
    '    WHEN 12 THEN ''DATE''' + LineEnding +
    '    WHEN 13 THEN ''TIME''' + LineEnding +
    '    WHEN 14 THEN ''CHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 16 THEN' + LineEnding +
    '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''BIGINT''' + LineEnding +
    '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
    '      END' + LineEnding +
    '    WHEN 27 THEN ''DOUBLE''' + LineEnding +
    '    WHEN 35 THEN ''TIMESTAMP''' + LineEnding +
    '    WHEN 37 THEN ''VARCHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 40 THEN ''CSTRING'' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 45 THEN ''BLOB_ID''' + LineEnding +
    '    WHEN 261 THEN ''BLOB '' ||' + LineEnding +
    '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''BINARY''' + LineEnding +
    '        WHEN 1 THEN ''TEXT''' + LineEnding +
    '        WHEN 2 THEN ''BLR''' + LineEnding +
    '        ELSE ''SUB TYPE '' || F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '      END' + LineEnding +
    '    ELSE ''RDB$FIELD_TYPE: '' || F.RDB$FIELD_TYPE || ''?''' + LineEnding +
    '  END) PARAM_TYPE,' + LineEnding +
    '  CAST(RF.RDB$DESCRIPTION AS VARCHAR(2048)) "COMMENT"' + LineEnding +
    'FROM RDB$PROCEDURE_PARAMETERS RF' + LineEnding +
    ' JOIN RDB$FIELDS F ON (F.RDB$FIELD_NAME = RF.RDB$FIELD_SOURCE)' + LineEnding +
    'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)' + LineEnding +
    'LEFT OUTER JOIN RDB$COLLATIONS DCO ON ((DCO.RDB$COLLATION_ID = F.RDB$COLLATION_ID) AND (DCO.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID))' + LineEnding +
    'WHERE (RF.RDB$PROCEDURE_NAME = :PRC) AND (COALESCE(RF.RDB$SYSTEM_FLAG, 0) = 0)' + LineEnding +
    'ORDER BY RF.RDB$PARAMETER_TYPE, RF.RDB$PARAMETER_NUMBER;';

  //Just FB3
  C_Sql_Retrive_Function_Arguments =
    'SELECT' + LineEnding +
    '  FF.RDB$ARGUMENT_NAME ARGUMENT_NAME,' + LineEnding +
    '  FF.RDB$ARGUMENT_POSITION ARGUMENT_IO,' + LineEnding +
    '  IIF(FF.RDB$ARGUMENT_POSITION = 0, ''RETURNS'', ''ARGUMENT'') ARGUMENT_IO_DESC,' + LineEnding +
    '  IIF (FF.RDB$FIELD_SOURCE NOT SIMILAR TO ''RDB$%'', FF.RDB$FIELD_SOURCE,' + LineEnding +
    '  CASE F.RDB$FIELD_TYPE' + LineEnding +
    '  WHEN 7 THEN' + LineEnding +
    '    IIF(F.RDB$FIELD_SUB_TYPE IS NULL, ''SMALLINT'',' + LineEnding +
    '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''SMALLINT''' + LineEnding +
    '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
    '      END' + LineEnding +
    '    )' + LineEnding +
    '    WHEN 8 THEN' + LineEnding +
    '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''INTEGER''' + LineEnding +
    '        WHEN 1 THEN ''NUMERIC(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
    '      END' + LineEnding +
    '    WHEN 9 THEN ''QUAD''' + LineEnding +
    '    WHEN 10 THEN ''FLOAT''' + LineEnding +
    '    WHEN 12 THEN ''DATE''' + LineEnding +
    '    WHEN 13 THEN ''TIME''' + LineEnding +
    '    WHEN 14 THEN ''CHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 16 THEN' + LineEnding +
    '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''BIGINT''' + LineEnding +
    '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
    '      END' + LineEnding +
    '    WHEN 27 THEN ''DOUBLE''' + LineEnding +
    '    WHEN 35 THEN ''TIMESTAMP''' + LineEnding +
    '    WHEN 37 THEN ''VARCHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 40 THEN ''CSTRING'' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 45 THEN ''BLOB_ID''' + LineEnding +
    '    WHEN 261 THEN ''BLOB '' ||' + LineEnding +
    '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''BINARY''' + LineEnding +
    '        WHEN 1 THEN ''TEXT''' + LineEnding +
    '        WHEN 2 THEN ''BLR''' + LineEnding +
    '        ELSE ''SUB TYPE '' || F.RDB$FIELD_SUB_TYPE' + LineEnding +
    '      END' + LineEnding +
    '    ELSE ''RDB$FIELD_TYPE: '' || F.RDB$FIELD_TYPE || ''?''' + LineEnding +
    '  END) ARGUMENT_TYPE,' + LineEnding +
    '  FF.RDB$DESCRIPTION "COMMENT"' + LineEnding +
    'FROM RDB$FUNCTION_ARGUMENTS FF' + LineEnding +
    ' JOIN RDB$FIELDS F ON (F.RDB$FIELD_NAME = FF.RDB$FIELD_SOURCE)' + LineEnding +
    'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)' + LineEnding +
    'LEFT OUTER JOIN RDB$COLLATIONS DCO ON ((DCO.RDB$COLLATION_ID = F.RDB$COLLATION_ID) AND (DCO.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID))' + LineEnding +
    'WHERE (FF.RDB$FUNCTION_NAME = :FUNC) AND (COALESCE(FF.RDB$SYSTEM_FLAG, 0) = 0)' + LineEnding +
    'ORDER BY FF.RDB$ARGUMENT_POSITION;';

  C_Sql_Retrive_UFunction_Arguments: array[TDFirebirdVersion] of String = (
  //dfb21
    'SELECT' + LineEnding +
    '  IIF(FF.RDB$ARGUMENT_POSITION = 0, ''Returns'', ''Arg#'' || FF.RDB$ARGUMENT_POSITION) ARGUMENT_NAME,' + LineEnding +
    '  FF.RDB$ARGUMENT_POSITION ARGUMENT_IO,' + LineEnding +
    '  IIF(FF.RDB$ARGUMENT_POSITION = 0, ''RETURNS'', ''ARGUMENT'') ARGUMENT_IO_DESC,' + LineEnding +
    '  CASE FF.RDB$FIELD_TYPE' + LineEnding +
    '    WHEN 7   THEN ''SMALLINT''' + LineEnding +
    '    WHEN 8   THEN ''INTEGER''' + LineEnding +
    '    WHEN 12  THEN ''DATE''' + LineEnding +
    '    WHEN 13  THEN ''TIME''' + LineEnding +
    '    WHEN 14  THEN ''CHAR('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 16  THEN ''BIGINT''' + LineEnding +
    '    WHEN 27  THEN ''DOUBLE PRECISION('' || FF.RDB$FIELD_PRECISION || '', '' || (-FF.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '    WHEN 35  THEN ''TIMESTAMP''' + LineEnding +
    '    WHEN 37  THEN ''VARCHAR('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 261 THEN ''BLOB''' + LineEnding +
    '    WHEN 40  THEN ''CSTRING('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 45  THEN ''BLOB_ID''' + LineEnding +
    '    WHEN 261 THEN ''BLOB'' ||' + LineEnding +
    '      CASE FF.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''BINARY''' + LineEnding +
    '        WHEN 1 THEN ''TEXT''' + LineEnding +
    '        WHEN 2 THEN ''BLR''' + LineEnding +
    '        ELSE ''SUB TYPE '' || FF.RDB$FIELD_SUB_TYPE' + LineEnding +
    '      END' + LineEnding +
    '  END ARGUMENT_TYPE' + LineEnding +
    ',  '' '' "COMMENT"' + LineEnding +
    'FROM RDB$FUNCTION_ARGUMENTS FF' + LineEnding +
    'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = FF.RDB$CHARACTER_SET_ID)' + LineEnding +
    ' WHERE (FF.RDB$FUNCTION_NAME = :FUNC)' + LineEnding +
    'ORDER BY FF.RDB$ARGUMENT_POSITION;',
    //dfb25
    'SELECT' + LineEnding +
    '  IIF(FF.RDB$ARGUMENT_POSITION = 0, ''Returns'', ''Arg#'' || FF.RDB$ARGUMENT_POSITION) ARGUMENT_NAME,' + LineEnding +
    '  FF.RDB$ARGUMENT_POSITION ARGUMENT_IO,' + LineEnding +
    '  IIF(FF.RDB$ARGUMENT_POSITION = 0, ''RETURNS'', ''ARGUMENT'') ARGUMENT_IO_DESC,' + LineEnding +
    '  CASE FF.RDB$FIELD_TYPE' + LineEnding +
    '    WHEN 7   THEN ''SMALLINT''' + LineEnding +
    '    WHEN 8   THEN ''INTEGER''' + LineEnding +
    '    WHEN 12  THEN ''DATE''' + LineEnding +
    '    WHEN 13  THEN ''TIME''' + LineEnding +
    '    WHEN 14  THEN ''CHAR('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 16  THEN ''BIGINT''' + LineEnding +
    '    WHEN 27  THEN ''DOUBLE PRECISION('' || FF.RDB$FIELD_PRECISION || '', '' || (-FF.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '    WHEN 35  THEN ''TIMESTAMP''' + LineEnding +
    '    WHEN 37  THEN ''VARCHAR('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 261 THEN ''BLOB''' + LineEnding +
    '    WHEN 40  THEN ''CSTRING('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 45  THEN ''BLOB_ID''' + LineEnding +
    '    WHEN 261 THEN ''BLOB'' ||' + LineEnding +
    '      CASE FF.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''BINARY''' + LineEnding +
    '        WHEN 1 THEN ''TEXT''' + LineEnding +
    '        WHEN 2 THEN ''BLR''' + LineEnding +
    '        ELSE ''SUB TYPE '' || FF.RDB$FIELD_SUB_TYPE' + LineEnding +
    '      END' + LineEnding +
    '  END ARGUMENT_TYPE' + LineEnding +
    '  , '' '' "COMMENT"' + LineEnding +
    'FROM RDB$FUNCTION_ARGUMENTS FF' + LineEnding +
    'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = FF.RDB$CHARACTER_SET_ID)' + LineEnding +
    ' WHERE (FF.RDB$FUNCTION_NAME = :FUNC)' + LineEnding +
    'ORDER BY FF.RDB$ARGUMENT_POSITION;',
    //dfb3
    'SELECT' + LineEnding +
    '  IIF(FF.RDB$ARGUMENT_POSITION = 0, ''Returns'', ''Arg#'' || FF.RDB$ARGUMENT_POSITION) ARGUMENT_NAME,' + LineEnding +
    '  FF.RDB$ARGUMENT_POSITION ARGUMENT_IO,' + LineEnding +
    '  IIF(FF.RDB$ARGUMENT_POSITION = 0, ''RETURNS'', ''ARGUMENT'') ARGUMENT_IO_DESC,' + LineEnding +
    '  CASE FF.RDB$FIELD_TYPE' + LineEnding +
    '    WHEN 7   THEN ''SMALLINT''' + LineEnding +
    '    WHEN 8   THEN ''INTEGER''' + LineEnding +
    '    WHEN 12  THEN ''DATE''' + LineEnding +
    '    WHEN 13  THEN ''TIME''' + LineEnding +
    '    WHEN 14  THEN ''CHAR('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 16  THEN ''BIGINT''' + LineEnding +
    '    WHEN 27  THEN ''DOUBLE PRECISION('' || FF.RDB$FIELD_PRECISION || '', '' || (-FF.RDB$FIELD_SCALE) || '')''' + LineEnding +
    '    WHEN 35  THEN ''TIMESTAMP''' + LineEnding +
    '    WHEN 37  THEN ''VARCHAR('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 261 THEN ''BLOB''' + LineEnding +
    '    WHEN 40  THEN ''CSTRING('' || (TRUNC(FF.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
    '    WHEN 45  THEN ''BLOB_ID''' + LineEnding +
    '    WHEN 261 THEN ''BLOB'' ||' + LineEnding +
    '      CASE FF.RDB$FIELD_SUB_TYPE' + LineEnding +
    '        WHEN 0 THEN ''BINARY''' + LineEnding +
    '        WHEN 1 THEN ''TEXT''' + LineEnding +
    '        WHEN 2 THEN ''BLR''' + LineEnding +
    '        ELSE ''SUB TYPE '' || FF.RDB$FIELD_SUB_TYPE' + LineEnding +
    '      END' + LineEnding +
    '  END ARGUMENT_TYPE' + LineEnding +
    '  ,  CAST(FF.RDB$DESCRIPTION AS VARCHAR(2048)) "COMMENT"' + LineEnding +
    'FROM RDB$FUNCTION_ARGUMENTS FF' + LineEnding +
    'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = FF.RDB$CHARACTER_SET_ID)' + LineEnding +
    ' WHERE (FF.RDB$FUNCTION_NAME = :FUNC) AND (COALESCE(FF.RDB$SYSTEM_FLAG, 0) = 0)' + LineEnding +
    'ORDER BY FF.RDB$ARGUMENT_POSITION;'
  );

  C_Sql_Retrive_Domains =
     'SELECT' + LineEnding +
     '  F.RDB$FIELD_NAME "NAME",' + LineEnding +
     '  CASE F.RDB$FIELD_TYPE' + LineEnding +
     '  WHEN 7 THEN' + LineEnding +
     '    IIF(F.RDB$FIELD_SUB_TYPE IS NULL, ''SMALLINT'',' + LineEnding +
     '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
     '        WHEN 0 THEN ''SMALLINT''' + LineEnding +
     '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
     '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
     '      END' + LineEnding +
     '    )' + LineEnding +
     '    WHEN 8 THEN' + LineEnding +
     '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
     '        WHEN 0 THEN ''INTEGER''' + LineEnding +
     '        WHEN 1 THEN ''NUMERIC(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
     '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
     '      END' + LineEnding +
     '    WHEN 9 THEN ''QUAD''' + LineEnding +
     '    WHEN 10 THEN ''FLOAT''' + LineEnding +
     '    WHEN 12 THEN ''DATE''' + LineEnding +
     '    WHEN 13 THEN ''TIME''' + LineEnding +
     '    WHEN 14 THEN ''CHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
     '    WHEN 16 THEN' + LineEnding +
     '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
     '        WHEN 0 THEN ''BIGINT''' + LineEnding +
     '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')''' + LineEnding +
     '        WHEN 2 THEN ''DECIMAL''' + LineEnding +
     '      END' + LineEnding +
     '    WHEN 23 THEN ''BOOLEAN''' + LineEnding +
     '    WHEN 27 THEN ''DOUBLE''' + LineEnding +
     '    WHEN 35 THEN ''TIMESTAMP''' + LineEnding +
     '    WHEN 37 THEN ''VARCHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
     '    WHEN 40 THEN ''CSTRING'' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '') @'' || TRIM(CH.RDB$DEFAULT_COLLATE_NAME)' + LineEnding +
     '    WHEN 45 THEN ''BLOB_ID''' + LineEnding +
     '    WHEN 261 THEN ''BLOB '' ||' + LineEnding +
     '      CASE F.RDB$FIELD_SUB_TYPE' + LineEnding +
     '        WHEN 0 THEN ''BINARY''' + LineEnding +
     '        WHEN 1 THEN ''TEXT''' + LineEnding +
     '        WHEN 2 THEN ''BLR''' + LineEnding +
     '        ELSE ''SUB TYPE '' || F.RDB$FIELD_SUB_TYPE' + LineEnding +
     '      END' + LineEnding +
     '    ELSE ''RDB$FIELD_TYPE: '' || F.RDB$FIELD_TYPE || ''?''' + LineEnding +
     '  END' + LineEnding +
     '  ||' + LineEnding +
     '  CASE F.RDB$NULL_FLAG' + LineEnding +
     '    WHEN 1 THEN '' NOT NULL''' + LineEnding +
     '    ELSE ''''' + LineEnding +
     '  END "TYPE",' + LineEnding +
     '  IIF(F.RDB$DESCRIPTION IS NULL, '''', CAST(F.RDB$DESCRIPTION AS VARCHAR(2048))) "COMMENT"' + LineEnding +
     '' + LineEnding +
     'FROM RDB$FIELDS F' + LineEnding +
     'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)' + LineEnding +
     'WHERE F.RDB$SYSTEM_FLAG = 0 and (NOT F.RDB$FIELD_NAME LIKE ''RDB$%'')' + LineEnding +
     'ORDER BY F.RDB$FIELD_NAME';

  C_Sql_Retrive_Charsets = 'SELECT cs.RDB$CHARACTER_SET_NAME TITLE FROM RDB$CHARACTER_SETS cs WHERE cs.RDB$CHARACTER_SET_NAME <> ''NONE'' AND cs.RDB$CHARACTER_SET_NAME <> '''' ORDER BY cs.RDB$CHARACTER_SET_NAME';

  C_Sql_Retrive_Collations = 'SELECT cs.RDB$COLLATION_NAME TITLE FROM RDB$COLLATIONS cs WHERE cs.RDB$COLLATION_NAME <> ''NONE'' AND cs.RDB$COLLATION_NAME <> '''' ORDER BY cs.RDB$COLLATION_NAME';

  C_Sql_Retrive_Function_Source = 'SELECT TRIM(F.RDB$FUNCTION_SOURCE) SRC FROM  RDB$FUNCTIONS F  WHERE F.RDB$FUNCTION_NAME = ';
  C_Sql_Retrive_StoredProcedure_Source = 'SELECT TRIM(P.RDB$PROCEDURE_SOURCE) SRC FROM  RDB$PROCEDURES P  WHERE P.RDB$PROCEDURE_NAME = :SPN';

  C_Sql_Retrive_Triggers = 'SELECT T.RDB$TRIGGER_NAME NAME, T.RDB$RELATION_NAME ON_OBJECT, T.RDB$DESCRIPTION "COMMENT", T.RDB$TRIGGER_INACTIVE IS_INACTIVE, T.RDB$TRIGGER_TYPE TRIGGER_TYPE FROM RDB$TRIGGERS T WHERE T.RDB$SYSTEM_FLAG = 0 ORDER BY T.RDB$RELATION_NAME, T.RDB$TRIGGER_NAME';
  C_Sql_Retrive_Trigger_Source =
    'SELECT ''ALTER TRIGGER '' || TRIM(T.RDB$TRIGGER_NAME) || '' /* FOR '' || TRIM(T.RDB$RELATION_NAME) || ' + LINEENDING +
    '    CASE T.RDB$TRIGGER_INACTIVE' + LineEnding +
    '      WHEN 0 THEN '' */ ACTIVE ''' + LineEnding +
    '      WHEN 1 THEN '' */ INACTIVE ''' + LineEnding +
    '    END || ASCII_CHAR(10)  || ' + LineEnding +
    '    CASE T.RDB$TRIGGER_TYPE ' + LineEnding +
    '      WHEN 1    THEN  ''BEFORE INSERT''' + LineEnding +
    '      WHEN 2    THEN  ''AFTER INSERT''' + LineEnding +
    '      WHEN 3    THEN  ''BEFORE UPDATE''' + LineEnding +
    '      WHEN 4    THEN  ''AFTER UPDATE''' + LineEnding +
    '      WHEN 5    THEN  ''BEFORE DELETE''' + LineEnding +
    '      WHEN 6    THEN  ''AFTER DELETE''' + LineEnding +
    '      WHEN 17   THEN  ''BEFORE INSERT OR UPDATE''' + LineEnding +
    '      WHEN 18   THEN  ''AFTER INSERT OR UPDATE''' + LineEnding +
    '      WHEN 25   THEN  ''BEFORE INSERT OR DELETE''' + LineEnding +
    '      WHEN 26   THEN  ''AFTER INSERT OR DELETE''' + LineEnding +
    '      WHEN 27   THEN  ''BEFORE UPDATE OR DELETE''' + LineEnding +
    '      WHEN 28   THEN  ''AFTER UPDATE OR DELETE''' + LineEnding +
    '      WHEN 113  THEN  ''BEFORE INSERT OR UPDATE OR DELETE''' + LineEnding +
    '      WHEN 114  THEN  ''AFTER INSERT OR UPDATE OR DELETE''' + LineEnding +
    '      WHEN 8192 THEN  ''ON CONNECT''' + LineEnding +
    '      WHEN 8193 THEN  ''ON DISCONNECT''' + LineEnding +
    '      WHEN 8194 THEN  ''ON TRANSACTION START''' + LineEnding +
    '      WHEN 8195 THEN  ''ON TRANSACTION COMMIT''' + LineEnding +
    '      WHEN 8196 THEN  ''ON TRANSACTION ROLLBACK''' + LineEnding +
    '    END ||' + LineEnding +
    '    '' POSITION '' || T.RDB$TRIGGER_SEQUENCE || ASCII_CHAR(10)  ||  T.RDB$TRIGGER_SOURCE' + LineEnding +
    'FROM RDB$TRIGGERS T WHERE T.RDB$TRIGGER_NAME = :TRIG';

  C_Sql_Retrive_Ecxeptions = 'SELECT E.RDB$EXCEPTION_NAME NAME, E.RDB$DESCRIPTION "COMMENT", E.RDB$MESSAGE MESSAGE FROM RDB$EXCEPTIONS E WHERE E.RDB$SYSTEM_FLAG = 0';
  C_Sql_Retrive_Ecxeption_Text = 'SELECT E.RDB$MESSAGE MESSAGE FROM RDB$EXCEPTIONS E WHERE E.RDB$SYSTEM_FLAG = 0 AND E.RDB$EXCEPTION_NAME = :ENAME';
  C_Sql_Retrive_Indices =
    'SELECT' + LineEnding +
    '  I.RDB$INDEX_NAME NAME,' + LineEnding +
    '  I.RDB$RELATION_NAME ON_TABLE,' + LineEnding +
    '  I.RDB$DESCRIPTION "COMMENT",' + LineEnding +
    '  I.RDB$INDEX_INACTIVE IS_INACTIVE' + LineEnding +
    'FROM' + LineEnding +
    '  RDB$INDICES I' + LineEnding +
    'WHERE' + LineEnding +
    '    RDB$UNIQUE_FLAG is DISTINCT FROM 1' + LineEnding +
    '  AND' + LineEnding +
    '    RDB$FOREIGN_KEY IS NULL' + LineEnding +
    '  AND' + LineEnding +
    '    I.RDB$SYSTEM_FLAG is DISTINCT from 1' + LineEnding +
    '  ORDER BY' + LineEnding +
    '    I.RDB$RELATION_NAME, I.RDB$INDEX_NAME;';
    //'SELECT' + LineEnding +
    //'    I.RDB$INDEX_NAME NAME,' + LineEnding +
    //'    I.RDB$RELATION_NAME ON_TABLE,' + LineEnding +
    //'    I.RDB$DESCRIPTION "COMMENT",' + LineEnding +
    //'    I.RDB$INDEX_INACTIVE IS_INACTIVE' + LineEnding +
    //'FROM' + LineEnding +
    //'    RDB$INDICES i' + LineEnding +
    //'LEFT JOIN RDB$INDEX_SEGMENTS s on i.RDB$INDEX_NAME = s.RDB$INDEX_NAME' + LineEnding +
    //'LEFT JOIN RDB$RELATION_CONSTRAINTS rc on rc.RDB$INDEX_NAME = i.RDB$INDEX_NAME' + LineEnding +
    //'WHERE' + LineEnding +
    //'    i.RDB$SYSTEM_FLAG = 0' + LineEnding +
    //'    AND rc.RDB$CONSTRAINT_TYPE is DISTINCT from ''PRIMARY KEY''' + LineEnding +
    //'    AND rc.RDB$CONSTRAINT_TYPE is DISTINCT from ''FOREIGN KEY''' + LineEnding +
    //'ORDER BY I.RDB$RELATION_NAME, I.RDB$INDEX_NAME';

  C_Sql_Retrive_Sequences = 'SELECT G.RDB$GENERATOR_NAME NAME, '''' AS NO_TYPE, G.RDB$DESCRIPTION "COMMENT" FROM RDB$GENERATORS G WHERE G.RDB$SYSTEM_FLAG = 0;';
  C_Sql_Retrive_Sequence_Value = 'SELECT GEN_ID(%s, 0) FROM RDB$DATABASE';
  C_Sql_Sequence_Set_Value = 'SET GENERATOR %s TO %i;';

  C_SQL_Retrive_Depend_OnField = 'SELECT * FROM RDB$DEPENDENCIES d where d.RDB$FIELD_NAME = :FLD';
  C_SQL_Retrive_Depend_FieldOn = 'SELECT * FROM RDB$RELATION_FIELDS rf where rf.RDB$FIELD_NAME = :FLD AND rf.RDB$RELATION_NAME = :TBL ;';


  C_Theme_Default_Dark =
    '{'+
    '"Theme Name":"DSql Dark",'+
    'Default:{'+
    'Background:"$00292623",'+
    'Foreground:"clWhite",'+
    '"Font Name":"Ubuntu Mono",'+
    '"Font Quality":"Antialiased",'+
    '"Font Size":9,'+
    '"Font Style":["Italic"]'+
    '},'+
    'Comments:{'+
    'Background:"clNone",'+
    'Foreground:"$0079FE52",'+
    '"Font Style":["Italic"]'+
    '},'+
    '"Data Types":{'+
    'Background:"clNone",'+
    'Foreground:"$0081CE00",'+
    '"Font Style":["Bold"]'+
    '},'+
    'Exceptions:{'+
    'Background:"clNone",'+
    'Foreground:"clRed",'+
    '"Font Style":["Italic"]'+
    '},'+
    'Functions:{'+
    'Background:"clNone",'+
    'Foreground:"clOlive",'+
    '"Font Style":["Bold"]'+
    '},'+
    'Identifiers:{'+
    'Background:"clNone",'+
    'Foreground:"$00FFA116",'+
    '"Font Style":[]'+
    '},'+
    'Keywords:{'+
    'Background:"clNone",'+
    'Foreground:"$002374FF",'+
    '"Font Style":[]'+
    '},'+
    '"Line Highlight":{'+
    'Background:"$0035312D",'+
    'Foreground:"clNone",'+
    '"Font Style":[]'+
    '},'+
    'Numbers:{'+
    'Background:"clNone",'+
    'Foreground:"$005963FF",'+
    '"Font Style":[]'+
    '},'+
    'Selection:{'+
    'Background:"$00542F00",'+
    'Foreground:"clNone",'+
    '"Font Style":[]'+
    '},'+
    'Strings:{'+
    'Background:"clNone",'+
    'Foreground:"$005963FF",'+
    '"Font Style":[]'+
    '},'+
    'Symbols:{'+
    'Background:"clNone",'+
    'Foreground:"$007FAAFF",'+
    '"Font Style":[]'+
    '},'+
    'Tables:{'+
    'Background:"clNone",'+
    'Foreground:"clGreen",'+
    '"Font Style":["Italic"]'+
    '},'+
    'Variables:{'+
    'Background:"clNone",'+
    'Foreground:"clTeal",'+
    '"Font Style":[]'+
    '},'+
    '"Line Number":{'+
    'Background:"$00292623",'+
    'Foreground:"$0069615A",'+
    '"Font Style":[]'+
    '},'+
    '"Modified Line":{'+
    'Modified:"$0000E9FC",'+
    'Saved:"clGray"'+
    '},'+
    'Gutter:{'+
    'Background:"$00292623",'+
    'Foreground:"$0069615A"'+
    '},'+
    'Grid:{'+
    '"Title Font":{'+
    'Name:"DejaVu Sans",'+
    'Size:9,'+
    '"Font Quality":"Antialiased",'+
    'Color:"clWhite",'+
    '"Font Style":[]'+
    '},'+
    '"Cell Font":{'+
    'Name:"DejaVu Sans",'+
    'Size:9,'+
    '"Font Quality":"Antialiased",'+
    'Color:"clWhite",'+
    '"Font Style":[]'+
    '},'+
    'Color:"$00292623",'+
    'OddRow:"$0035312D",'+
    '"Title Background":"$00292623",'+
    '"Title Style":"Standard"'+
    '},'+
    'Log:{'+
    'Font:{'+
    'Name:"Ubuntu Mono",'+
    'Size:1,'+
    '"Font Quality":"Antialiased",'+
    '"Font Style":[]'+
    '},'+
    'Background:"$00292623",'+
    'Detail:"$0000AA55",'+
    'Error:"$007F00FF",'+
    'Information:"$0000AAFF"'+
    '}'+
    '}';

  C_Theme_Default_Light =
    '{'+
    '"Theme Name":"DSql Light",'+
    'Default:{'+
    'Background:"clWhite",'+
    'Foreground:"clBlack",'+
    '"Font Name":"Ubuntu Mono",'+
    '"Font Quality":"Antialiased",'+
    '"Font Size":9,'+
    '"Font Style":["Italic"]'+
    '},'+
    'Comments:{'+
    'Background:"clNone",'+
    'Foreground:"$0000AA55",'+
    '"Font Style":["Italic"]'+
    '},'+
    '"Data Types":{'+
    'Background:"clNone",'+
    'Foreground:"$0081CE00",'+
    '"Font Style":["Bold"]'+
    '},'+
    'Exceptions:{'+
    'Background:"clNone",'+
    'Foreground:"clRed",'+
    '"Font Style":["Italic"]'+
    '},'+
    'Functions:{'+
    'Background:"clNone",'+
    'Foreground:"clOlive",'+
    '"Font Style":["Bold"]'+
    '},'+
    'Identifiers:{'+
    'Background:"clNone",'+
    'Foreground:"$00FFA116",'+
    '"Font Style":[]'+
    '},'+
    'Keywords:{'+
    'Background:"clNone",'+
    'Foreground:"$00FFAA00",'+
    '"Font Style":["Bold"]'+
    '},'+
    '"Line Highlight":{'+
    'Background:"$00E6FFFF",'+
    'Foreground:"clNone",'+
    '"Font Style":[]'+
    '},'+
    'Numbers:{'+
    'Background:"clNone",'+
    'Foreground:"$005963FF",'+
    '"Font Style":[]'+
    '},'+
    'Selection:{'+
    'Background:"$00542F00",'+
    'Foreground:"clNone",'+
    '"Font Style":[]'+
    '},'+
    'Strings:{'+
    'Background:"clNone",'+
    'Foreground:"$005963FF",'+
    '"Font Style":[]'+
    '},'+
    'Symbols:{'+
    'Background:"clNone",'+
    'Foreground:"$004F9AFF",'+
    '"Font Style":[]'+
    '},'+
    'Tables:{'+
    'Background:"clNone",'+
    'Foreground:"$007F00FF",'+
    '"Font Style":["Italic"]'+
    '},'+
    'Variables:{'+
    'Background:"clNone",'+
    'Foreground:"$009B6700",'+
    '"Font Style":[]'+
    '},'+
    '"Line Number":{'+
    'Background:"clWhite",'+
    'Foreground:"clGray",'+
    '"Font Style":[]'+
    '},'+
    '"Modified Line":{'+
    'Modified:"$0000E9FC",'+
    'Saved:"clGray"'+
    '},'+
    'Gutter:{'+
    'Background:"clWhite",'+
    'Foreground:"clSilver"'+
    '},'+
    'Grid:{'+
    '"Title Font":{'+
    'Name:"DejaVu Sans",'+
    'Size:8,'+
    '"Font Quality":"Antialiased",'+
    'Color:"clBlack",'+
    '"Font Style":["Bold"]'+
    '},'+
    '"Cell Font":{'+
    'Name:"DejaVu Sans",'+
    'Size:8,'+
    '"Font Quality":"Antialiased",'+
    'Color:"clBlack",'+
    '"Font Style":[]'+
    '},'+
    'Color:"clWhite",'+
    'OddRow:"clSilver",'+
    '"Title Background":"$00E6FFFF",'+
    '"Title Style":"Standard"'+
    '},'+
    'Log:{'+
    'Font:{'+
    'Name:"Ubuntu Mono",'+
    'Size:1,'+
    '"Font Quality":"Default",'+
    '"Font Style":[]'+
    '},'+
    'Background:"clWhite",'+
    'Detail:"clBlue",'+
    'Error:"clRed",'+
    'Information:"clGreen"'+
    '}'+
    '}';

  C_DFrames_Default =
    '{'+
    'General:{'+
    '"Scripts Dir":""'+
    '},'+
    'Editor:{'+
    'Theme:"DSql Dark",'+
    '"Tab Size":2,'+
    '"Tab To Space":True,'+
    '"Auto Indent":True,'+
    '"Auto Completion":True,'+
    '"Keywords Upper":True,'+
    '"Show Line Number":True,'+
    '"Show Line Number Every":5'+
    '}'+
    '}';

  C_DSql_Default = '{Servers:[{Title:"Local Host",Address:"localhost"}]}';

procedure AddItems(Itms: String; UpperCase: Boolean; List: TStrings; AType: TDSqlWordtype; Fill: Boolean = False);
implementation

procedure AddItems(Itms: String; UpperCase: Boolean; List: TStrings; AType: TDSqlWordtype; Fill: Boolean);
var
  wds: TStringArray;
  wd: String;
begin
  wds := SplitString(Itms, ',');
  if Fill then
    List.Clear;
  for wd in wds do
  begin
    if UpperCase then
      List.AddObject(wd, TObject(Pointer(PtrInt(Ord(AType)))))
    else
      List.AddObject(LowerCase(wd), TObject(Pointer(PtrInt(Ord(AType)))));
  end;
  wds := Nil;
end;

end.

