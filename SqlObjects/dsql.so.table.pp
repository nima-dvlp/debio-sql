unit dsql.so.Table;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, duTypes, dsql.SqlObject, IBConnection, ComCtrls;

type

  { TDSqlObjField }

  TDSqlObjField = class(TDSqlTypedObject)
  public
    property Name;
    property Database;
    property ObjectType;
    property DataType;
    property DataTypeDescriptor;
    property ExcatName;
    constructor Create(ANode: TTreeNode; ADatabase: TIBConnection; AParent: TDSqlObject); override;
  end;

  { TDSqlObjTable }

  TDSqlObjTable = class(specialize TDSqlObjectCollection<TDSqlObjField>)
  public
    procedure RefreshObjects; override;
  end;
implementation

{ TDSqlObjField }

constructor TDSqlObjField.Create(ANode: TTreeNode; ADatabase: TIBConnection; AParent: TDSqlObject);
begin
  inherited Create(ANode, ADatabase, AParent);
  //SetObjectType(dntTableField, dnt);
end;

{ TDSqlObjTable }

procedure TDSqlObjTable.RefreshObjects;
begin
  inherited RefreshObjects;
end;

end.

