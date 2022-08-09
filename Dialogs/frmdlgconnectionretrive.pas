unit frmDlgConnectionRetrive;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, dudmMainModule;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    lblDetail: TLabel;
    lblSubDetail: TLabel;
    lblServer: TLabel;
    Label3: TLabel;
    lblDatabase: TLabel;
    Label5: TLabel;
    lblUser: TLabel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Picture.Bitmap := TBitmap.Create;
  dmMainModule.ilMainTree.GetBitmap(1, Image1.Picture.Bitmap);
  Image2.Picture.Bitmap := TBitmap.Create;
  dmMainModule.ilMainTree.GetBitmap(2, Image2.Picture.Bitmap);
end;

destructor TForm1.Destroy;
begin
  Image1.Picture.Bitmap.Destroy;
  Image2.Picture.Destroy;
  inherited Destroy;
end;

end.

