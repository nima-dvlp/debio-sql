unit duframFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls,
  duDSqlNodes, ComCtrls, Dialogs, LCLType, LMessages,
  Debio.Types, Debio.Utils.RunTime;

type

  { TdframBase }

  TdframBase = class(TFrame)
    pnlStatusbar: TPanel;
    Shape2: TShape;
    stCrtPos: TLabel;
    stInfo: TStaticText;
    stServer: TLabel;
  private
    FShownCounter: Integer;
    FShownOn: UInt64;
    FDatabaseNode: TDDatabaseNode;
    function GetTitle: TCaption;
    procedure SetTitle(AValue: TCaption);
    procedure WMShowWindow(var Message: TLMShowWindow); message LM_SHOWWINDOW;
    procedure WMWindowPosChanged(var Message: TLMWindowPosChanged); message
      LM_WINDOWPOSCHANGED;
    { private declarations }
  public
    property Title: TCaption read GetTitle write SetTitle;
    property DatabaseNode: TDDatabaseNode read FDatabaseNode write FDatabaseNode;

    constructor Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode); virtual;
    //Disconnecting database/Exiting Application
    function Leaving: Boolean; virtual;
    function QueryDisconnect(ReallyDisconnect: Boolean): Boolean; virtual;
    procedure Showing; virtual;
    //Entering in parent tabsheet(Tabsheet get focuse)
    procedure Entering; virtual;
    //Raise when tab change in main window to manage Actions...
    //Exiting from parent tabsheet(Tabsheet lost focuse)
    procedure Exiting; virtual;
    procedure ConfigChanged; virtual;
    procedure MetaDataChanged; virtual;
    procedure CheckActions; virtual;
  end;

implementation

{$R *.lfm}

var
  Counter: Integer;

{ TdframBase }

function TdframBase.GetTitle: TCaption;
begin
  if Parent is TTabSheet then
    Result := Parent.Caption
  else
    Result := Caption;
end;

procedure TdframBase.SetTitle(AValue: TCaption);
begin
  if Parent is TTabSheet then
    Parent.Caption := AValue
  else if Parent is TForm then
    TForm(Parent).Caption := AValue
  else
    Self.Caption := AValue;
end;

procedure TdframBase.WMShowWindow(var Message: TLMShowWindow);
begin
  {$ifdef LINUX}
    ////Tricky way to detect arrived dummy messages ....
    //FShownCounter.Inc;
    ////DriteLn(Format('WmShow - Trick', [GetTickCount64 - FShownOn]));
    //if GetTickCount64 - FShownOn > 300 then
    //begin;
    //  FShownOn := GetTickCount64;
    //  if FShownCounter = 1 then
    //  begin
    //    Showing;
    //    Entering;
    //  end
    //  else
    //    Entering;
    //end;
  {$EndIf}
end;

procedure TdframBase.WMWindowPosChanged(var Message: TLMWindowPosChanged);
begin
  {$IFDEF MSWINDOWS}
  ////Tricky way to detect arrived dummy messages ....
  //if (Message.WindowPos^.flags and SWP_SHOWWINDOW) = SWP_SHOWWINDOW then
  //begin
  //  FShownCounter.Inc;
  //  //DriteLn(Format('WmShow - Trick', [GetTickCount64 - FShownOn]));
  //  if GetTickCount64 - FShownOn > 300 then
  //  begin;
  //    FShownOn := GetTickCount64;
  //    if FShownCounter = 1 then
  //    begin
  //      Showing;
  //      Entering;
  //    end
  //    else
  //      Entering;          //Just print Hello world and nothing else
  //  end;
  //end;
  {$ENDIF}
end;

constructor TdframBase.Create(Owenr: TComponent; ADataBaseNode: TDDatabaseNode);
begin
  inherited Create(Owenr);
  FShownCounter := 0;
  Name := 'dframFrame' + IntToStr(Counter);
  FDatabaseNode := ADataBaseNode;
  stServer.Caption :=
    FDataBaseNode.Connection.Params.Values['user_name'] + '@' +
    FDataBaseNode.Connection.DatabaseName + '  (' +
      FDataBaseNode.Connection.Params.Values['lc_ctype'] +
    ')';
  Inc(Counter);
end;

function TdframBase.Leaving: Boolean;
begin
  ShowMessage('Unsafe Closing a tab!');
  Result := True;
end;

function TdframBase.QueryDisconnect(ReallyDisconnect: Boolean): Boolean;
begin
  Result := Leaving;
  if Result and ReallyDisconnect then
  begin
    if Parent is TForm then
      TForm(Parent).ModalResult := mrOK
    else
      Parent.Free;
    Free;
  end;
end;

procedure TdframBase.Showing;
begin
  //Nothing here but in descending class
end;

procedure TdframBase.Entering;
begin
  //Nothing here but in descending class
end;

procedure TdframBase.Exiting;
begin

end;

procedure TdframBase.ConfigChanged;
begin

end;

procedure TdframBase.MetaDataChanged;
begin

end;

procedure TdframBase.CheckActions;
begin

end;

end.

