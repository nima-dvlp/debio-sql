unit dufrmTransactionDecision;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel,
  ExtCtrls, Buttons;

type

  TDTransactionDecision = (dtdCommit, dtdRollback, dtdCancel);

  { TDFrmTransactionDecision }

  TDFrmTransactionDecision = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ButtonPanel1: TPanel;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

    FDecision: TDTransactionDecision;
  public

    class function MakeDesicion: TDTransactionDecision;
  end;

var
  DFrmTransactionDecision: TDFrmTransactionDecision;

implementation

{$R *.lfm}

{ TDFrmTransactionDecision }

procedure TDFrmTransactionDecision.FormCreate(Sender: TObject);
begin
  FDecision := dtdCancel;
end;

procedure TDFrmTransactionDecision.BitBtn2Click(Sender: TObject);
begin
  FDecision := dtdCommit;
  ModalResult := mrOK;
end;

procedure TDFrmTransactionDecision.BitBtn3Click(Sender: TObject);
begin
  FDecision := dtdCancel;
  ModalResult := mrClose;
end;

procedure TDFrmTransactionDecision.BitBtn1Click(Sender: TObject);
begin
  FDecision := dtdRollback;
  ModalResult := mrCancel;
end;

class function TDFrmTransactionDecision.MakeDesicion: TDTransactionDecision;
begin
  with TDFrmTransactionDecision.Create(Application) do
  begin
    ShowModal;
    Result := FDecision;
    Free;
  end;
end;

end.

