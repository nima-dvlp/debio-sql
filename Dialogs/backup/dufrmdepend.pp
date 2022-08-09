unit duFrmDepend;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  PairSplitter, ComCtrls, dudmMainModule, duDSqlNodes;

type

  { TFrmDepend }

  TFrmDepend = class(TForm)
    lblObject: TLabel;
    lblObject1: TLabel;
    lblObject2: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    tvDependencies: TTreeView;
    tvRequiredBy: TTreeView;
  private

  public
    procedure ShowUpBy(Depend: TDNodeInfo);

  end;

var
  FrmDepend: TFrmDepend;

implementation

uses duTypes;

{$R *.lfm}

{ TFrmDepend }

procedure TFrmDepend.ShowUpBy(Depend: TDNodeInfo);
begin
  tvDependencies.Items.Clear;
  tvRequiredBy.Items.Clear;
  case Depend.NodeSqlObjectType of
    dntTable:
      begin

      end;
    dntTablePmKey,
    dntTableFgKey,
    dntTableField,
    dntTableComtd:
      begin

      end;
    dntProcedure:;
    dntSequence:
      begin

      end;
    dntView:;
    dntException:;
    dntUserDFunction:;
    dntFunction:;
    dntDomain:;
    dntTriggerActive:;
    dntTriggerInactive:;
    dntIndexActive:;
    dntIndexInActive:;
  end;
end;

end.

