unit dufrmAbout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, IpHtml;

type

  { TDFrmAbout }

  TDFrmAbout = class(TForm)
    Image1: TImage;
    IpHtmlPanel1: TIpHtmlPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure FormShow(Sender: TObject);

      procedure IpHtmlPanel1ControlClick(Sender: TIpHtmlCustomPanel; Frame: TIpHtmlFrame; Html: TIpHtml; Node: TIpHtmlNodeControl);
  private

  public

  end;

var
  DFrmAbout: TDFrmAbout;

implementation

{$R *.lfm}

{ TDFrmAbout }

procedure TDFrmAbout.FormShow(Sender: TObject);
begin
  IpHtmlPanel1.SetHtmlFromStr('<a href="https://www.freepascal.org/">Freepascal</a> compiler');
end;

procedure TDFrmAbout.IpHtmlPanel1ControlClick(Sender: TIpHtmlCustomPanel; Frame: TIpHtmlFrame; Html: TIpHtml; Node: TIpHtmlNodeControl);
begin
  WriteLn(Node.Title, Node.Props.PropA.);
end;

end.

