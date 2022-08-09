unit DSql.SqlObject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, duTypes, IBConnection, ComCtrls;

type
  { TDSqlObject }

  TDSqlObject = class(TComponent)
  private
    FDatabae: TIBConnection;
    FName: String;
    FDescription: String;
    FObjectType: TDNodeType;
    FObjectTypeDetail: TDNodeType;
    FNode: TTreeNode;
    FParentSqlObject: TDSqlObject;
    function GetExcatName: String;
    constructor Create(AOwner: TComponent); override;
  protected
    property Database: TIBConnection read FDatabae;
    property ObjectType: TDNodeType read FObjectType;
    property ObjectTypeDetail: TDNodeType read FObjectTypeDetail;
    property Name: String read FName;
    property Description: String read FDescription;
    property ExcatName: String read GetExcatName;
    property Parent: TDSqlObject read FParentSqlObject;
    procedure SetObjectType(AObjectType: TDNodeType; AObjectTypeDetail: TDNodeType);
    constructor Create(ANode: TTreeNode; ADatabase: TIBConnection; AParent: TDSqlObject);virtual;
  end;

  TDSqlObjectClass = class of TDSqlObject;
  TDSqlObjectClasses = array of TDSqlObjectClass;

  { TDSqlObjectCollection }

  generic TDSqlObjectCollection<SQlObject> = class(TDSqlObject)
  public
    //type
      //TSOList = specialize TFPGList<SQlObject>;
  private
    FObjectClass: TDSqlObjectClass;
    //FList: TDSqlObjectCollection.TSOList;
    function GetCount: Integer;
  protected
    procedure SetItemClass(AClass: TDSqlObjectClass);
  public
    procedure RefreshObjects; virtual;
    property Count: Integer read GetCount;
    //property Items: TDSqlObjectCollection.TSOList read FList;
    constructor Create(ANode: TTreeNode; ADatabase: TIBConnection; AParent: TDSqlObject); override;
  end;

  TDSqlTypedObject = class(TDSqlObject)
  private
    FDataType: String;
    FDataTypeDescriptor: String;
  public
    property DataType: String read FDataType;
    property DataTypeDescriptor: String read FDataTypeDescriptor;
  end;

implementation

{ TDSqlObjectCollection }

function TDSqlObjectCollection.GetCount: Integer;
begin
  //Result := FList.Count;
end;

procedure TDSqlObjectCollection.SetItemClass(AClass: TDSqlObjectClass);
begin
  FObjectClass := AClass;
end;

procedure TDSqlObjectCollection.RefreshObjects;
begin

end;

constructor TDSqlObjectCollection.Create(ANode: TTreeNode; ADatabase: TIBConnection; AParent: TDSqlObject);
begin
  inherited Create(ANode, ADatabase, AParent);
  //FList := TSOList.Create;
end;

{ TDSqlObject }

function TDSqlObject.GetExcatName: String;
begin
  if UpperCase(FName) = FName then
    Result := FName
  else
    Result := '"' + FName + '"';
end;

constructor TDSqlObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TDSqlObject.SetObjectType(AObjectType: TDNodeType; AObjectTypeDetail: TDNodeType);
begin
  FObjectType := AObjectType;
  FObjectTypeDetail := AObjectTypeDetail;
end;

constructor TDSqlObject.Create(ANode: TTreeNode; ADatabase: TIBConnection; AParent: TDSqlObject);
begin
  inherited Create(AParent);
  FDatabae := ADatabase;
  FParentSqlObject := AParent;
  FNode := ANode;
end;

end.

