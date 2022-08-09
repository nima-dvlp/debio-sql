unit duframFuncProc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, duframFrame, duDSqlNodes;

type

  { TFrame1 }

  TFrame1 = class(TdframBase)
  private

  public
    constructor Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode); override;
  end;

implementation

{$R *.lfm}

{ TFrame1 }

constructor TFrame1.Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode);
begin
  inherited Create(Owenr, ADataBaseNode);
end;

end.

