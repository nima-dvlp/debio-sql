unit duFrmDSqlMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Ipfilebroker, Forms, Controls, Graphics,
  Dialogs, ComCtrls, Menus, ExtCtrls, StdCtrls, duFrmServerProperties,
  duDSqlNodes, duTypes, duUtil, duConsts, Types, Debio.Types, Debio.JSON,
  Debio.JSON.Parser, duframFrame, duFrmBase, SynExportHTML, LCLIntf;

type


  { TFrmDSqlMain }

  TFrmDSqlMain = class(TDFrmBase)
    facebook: TImage;
    debio_sql: TImage;
    telegram: TImage;
    twitter: TImage;
    googleplus: TImage;
    IpHtmlDataProvider1: TIpHtmlDataProvider;
    IpHtmlPanel1: TIpHtmlPanel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    pnlWorld: TPanel;
    Shape1: TShape;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TreeView1: TTreeView;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);

      procedure IpHtmlDataProvider1CheckURL(Sender: TObject; const URL: string; var Available: Boolean; var ContentType: string);

        procedure IpHtmlDataProvider1GetImage(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
        procedure IpHtmlPanel1HotClick(Sender: TObject);

          procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure PageControl1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure TabControl1GetImageIndex(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
    procedure TreeView1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure TreeView1ShowHint(Sender: TObject; HintInfo: PHintInfo);
  private
    FLastTabIndex: Integer;
  public
    FLockPopup: Boolean;
    FServers: TTreeNode;
    //function ShowUP(AFrame: TFrame; ACaption: TCaption): TTabSheet;
    function ShowUP(AFrame: TdframBase; ACaption: TCaption): TWinControl; override;
    //FMonitor: TMonitor;
    { public declarations }
  end;

var
  FrmDSqlMain: TFrmDSqlMain;

implementation

uses duframEditor, dudmMainModule, duFrames;

{$R *.lfm}

{ TFrmDSqlMain }

procedure TFrmDSqlMain.TreeView1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := dmMainModule.PopupSqlMenu(TreeView1.Selected, Self);
end;

procedure TFrmDSqlMain.TreeView1ShowHint(Sender: TObject; HintInfo: PHintInfo);
var
  Nd: TTreeNode;
begin
  //Memo1.Append(HintInfo^.HintStr);
  with HintInfo^ do
  begin
    Nd := TreeView1.GetNodeAt(CursorPos.X, CursorPos.Y);
    if Nd <> Nil then
    begin
      HintStr := TDNodeInfo(Nd.Data).Hint;
    end
    else
      HintStr := '';
    Nd := Nil;
  end;
end;

function TFrmDSqlMain.ShowUP(AFrame: TdframBase; ACaption: TCaption): TWinControl;
var
  Sheet: TTabSheet;
begin
  Sheet := PageControl1.AddTabSheet;
  Sheet.Caption := ACaption;
  AFrame.Parent := Sheet;
  AFrame.Align := alClient;
  PageControl1.TabIndex := Sheet.TabIndex;
  dmMainModule.TabsChanged;
  AFrame.Showing;
end;

procedure TFrmDSqlMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  cou: Integer;
  ni: TDNodeInfo;
begin
  CanClose := TDDatabaseNode.CloseQuery;
end;

procedure TFrmDSqlMain.FormShow(Sender: TObject);
var
  ConfFl: TStringList;
  SCou: Integer;//Servers
  DCou, indexChange: Integer;//Databases
  srv: TTreeNode;
  dbs: TTreeNode;
  Confs: TDJSON;
  Servers, Databases: TDJSON;
  //vData: TData;
  //mon: Boolean;
begin
  FLockPopup := False;
  //FServers := TreeView1.Items.Add(Nil, '');
  //FServers.Data := Pointer(TDNodeInfo.Create('ConfFl', 'All of your ConfFl will listed bellow', dntHome, FServers));
  //if FileExists(c_config_file) then
  //begin
  //  ConfFl := TStringList.Create;
  //  ConfFl.LoadFromFile(c_config_file);
  //  Srvs := ConfFl.Values['Servers'];
  //  SrvList := SplitString(Srvs, '|');
  //  for SCou := 0 to Length(SrvList) - 1 do
  //  begin
  //    SrvInfo := SplitString(SrvList[SCou], ':');
  //    srv := TreeView1.Items.AddChild(FServers, '');
  //    srv.Data := Pointer(TDDatabaseNode.Create(SrvInfo[0], '', SrvInfo[1], dntServer, srv));
  //  end;
  //end;

  FServers := TreeView1.Items.Add(Nil, '');
  FServers.Data := Pointer(TDNodeInfo.Create('DSql', 'All of your Servers will listed bellow', dntHome, FServers));
  if FileExists(DFrames.ConfigPath + c_config_file) then
  begin
    ConfFl := TStringList.Create;
    ConfFl.LoadFromFile(DFrames.ConfigPath + c_config_file);
    Confs := Nil;
    try
      Confs := ParseJSON(PChar(ConfFl.Text));
      if Assigned(Confs) and Confs.ExistsProperty('Servers') then
      begin
        Servers := Confs['Servers'];
        indexChange := 0;
        //TODO: Remove nulls(Removed Servers/Databases)
        //for SCou := 0 to Servers.Count - 1 do
        //begin
        //  if Servers[SCou].IsNull then
        //    indexChange.Dec
        //  else if indexChange <> 0 then
        //    Servers[SCou].intIdentifier;
        //end;

        for SCou := 0 to Servers.Count - 1 do
        begin
          if Servers[SCou].IsNull then
            Continue;
          srv := TreeView1.Items.AddChild(FServers, '');
          srv.Data := Pointer(TDServerNode.Create(
            Servers[SCou]['Title'].AsString, '',
            Servers[SCou]['Address'].AsString,
            Servers[SCou]['Port'].AsString,
            Servers[SCou]['Library'].AsString,
            Servers[SCou]['LibPath'].AsString,
            Servers[SCou]['TmpDir'].AsString,
            Servers[SCou]['LockDir'].AsString,
            Servers[SCou]['Type'].AsString,
            SCou, srv));
          if Servers[SCou].ExistsProperty('Databases') and (Servers[SCou]['Databases'].Count > 0) then
          begin
            //db := TreeView1.Items.AddChild()
            //ShowMessage(Servers[SCou]['Databases'].ToJSONString);
            Databases := Servers[SCou]['Databases'];
            for DCou := 0 to Databases.Count - 1 do
            begin
              if Databases[DCou].IsNull then
                Continue;
              dbs := TreeView1.Items.AddChild(srv, '');
              dbs.Data := Pointer(TDDatabaseNode.Create(
                Databases[DCou]['Title'].AsString,
                Databases[DCou]['DatabaseName'].AsString,
                Databases[DCou]['CharSet'].AsString, '', DCou, dbs));
            end;
          end;
        end;
        if Servers.Count > 0 then
          FServers.Expand(True);
      end;
    finally
      if Assigned(Confs) then
        FreeAndNil(Confs);
      FreeAndNil(ConfFl);
    end;
  end;
  dmMainModule.TabsChanged;
  IpHtmlPanel1.SetHtmlFromStr(
    Format('<html><body bgcolor="%s">', [ColorToHTML(clForm)]) +
    '<a href="http://debio-sql.ariaian.com">Debio-Sql</a> <strong>0.8.6.10 by 2018-05-31</strong><br>' + lineEnding +
    '<h3>Call of testers!</h3>' + lineEnding +
    '<strong>Remember that we need testers to make it stable and work fine</strong>,<br> So report Bugs, Screen shots, or bad behaviors to MaMrEzO@GMail.Com or any one of social networks that we are on.<br>' + lineEnding +
    '<b>Or</b> you can one of our testers team, Let us know you, Send mail to us with above Mail address. We will send you every build in private, So you can test it before every release! <br>' + LineEnding +
    '<h3>Changes in 0.85.3 release:</h3>' + lineEnding +
    '<strong>New features:</strong>' + lineEnding +
    '<ul>' + lineEnding +
    ' 	<li>Exception Alter</li>' + lineEnding +
    ' 	<li>Views: Browse Data / Alter</li>' + lineEnding +
    ' 	<li>Tigers: Activate / Deactivate / Comment trigger code</li>' + lineEnding +
    ' 	<li>Sequence (Generator): Set Value / New Sequence</li>' + lineEnding +
    ' 	<li>Editor: Execute SQL code with Auto DDL added(Shift + F7)</li>' + lineEnding +
    '</ul>' + lineEnding +
    '<br><br>' + LineEnding +
    '<strong>Bug fixes</strong>' + lineEnding +
    '<ul>' + lineEnding +
    ' 	<li>Indexes: Prevent duplicate entries on load</li>' + lineEnding +
    ' 	<li>Stored procedures: DDL will shown correctly</li>' + lineEnding +
    ' 	<li>Code completion: Problem in (Variables, Input parameters, Returns)</li>' + lineEnding +
    ' 	<li>Main tree: On refresh database metadata, Sequence node remains and new ones add!</li>' + lineEnding +
    ' 	<li>Fetching data to grid: Reading blob fields</li>' + lineEnding +
    ' 	<li>Client library: Advise base of platform in Machine(Add/Properties) dialog</li>' + lineEnding +
    ' 	<li>Check for entries in the Machine(Add/Properties) dialog before save, Server / Localhost properties advise on the Client library</li>' + lineEnding +
    ' 	<li>Apply changes to Machine/Database after change without need to close and reopen the DSql</li>' + lineEnding +
    ' 	<li>Execute Sql code in popup window Sql editor(Windows platform)</li>' + lineEnding +
    ' 	<li>Clear data grid for empty recordset after close one of</li>' + lineEnding +
    '</ul>' + lineEnding +
    '<br><strong>Next milestones</strong>' + lineEnding +
    '<ul>' + lineEnding +
    ' 	<li>Fixing bugs, If we find or <strong>you report it!</strong></li>' + lineEnding +
    ' 	<li>Provide separated connection and connection library</li>' + lineEnding +
    ' 	<li>Master password for storing the password of connections</li>' + lineEnding +
    ' 	<li>Dependency chart</li>' + lineEnding +
    ' 	<li>Copy table wizard between connections</li>' + lineEnding +
    ' 	<li>User management</li>' + lineEnding +
    ' 	<li>Create/Alter Tables graphically</li>' + lineEnding +
    '</ul><br><br>' + lineEnding +
    '<strong>Help!</strong><br>' + lineEnding +
    'There is a plan to make a Html help that provide sepratly for the project.<br>' + lineEnding +
    'But it just in base plan, so if you have any sugestion to make it, Any component<br> library Help mechanism, Online or Offline let us know it. Please.<br><br>' + lineEnding +
    '<strong>Where to know news about this project?</strong><br>' + lineEnding +
    '' + lineEnding +
    '<a href="http://debio-sql.ariaian.com"> <img src="debio_sql"> </a>' + lineEnding +
    '' + lineEnding +
    '<a href="https://t.me/debiosql"> <img src="telegram"> </a>' + lineEnding +
    '' + lineEnding +
    '<a href="https://plus.google.com/100419075778299990734"> <img src="googleplus"> </a>' + lineEnding +
    '' + lineEnding +
    '<a href="https://fb.me/DebioSql"> <img src="facebook"> </a>' + lineEnding +
    '' + lineEnding +
    '<a href="https://twitter.com/debio_sql"> <img src="twitter"> </a>'{ + lineEnding +
    '<br>' + lineEnding +
    '<br>' + lineEnding +
    'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,<br>' + lineEnding +
    'INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR<br>' + lineEnding +
    'PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE<br>' + lineEnding +
    'FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,<br>' + lineEnding +
    'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR<br>' + lineEnding +
    'OTHER DEALINGS IN THE SOFTWARE.'}
  );
end;

procedure TFrmDSqlMain.IpHtmlDataProvider1CheckURL(Sender: TObject; const URL: string; var Available: Boolean; var ContentType: string);
begin
  ShowMessage(URL);
end;

procedure TFrmDSqlMain.IpHtmlDataProvider1GetImage(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
begin
  //ShowMessage(URL);
  Picture := TPicture.Create;
  case URL of
    'debio_sql':  Picture.Assign(debio_sql.Picture);
    'facebook':   Picture.Assign(facebook.Picture);
    'telegram':   Picture.Assign(telegram.Picture);
    'googleplus': Picture.Assign(googleplus.Picture);
    'twitter':    Picture.Assign(twitter.Picture);
  end;
end;

procedure TFrmDSqlMain.IpHtmlPanel1HotClick(Sender: TObject);
begin
  OpenURL(IpHtmlPanel1.HotURL);
end;

procedure TFrmDSqlMain.PageControl1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FLastTabIndex := PageControl1.ActivePage.TabIndex;
end;

procedure TFrmDSqlMain.PageControl1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PIdx: Integer;
begin
  //
  if Button = mbLeft then
  begin
    if FLastTabIndex <> PageControl1.ActivePage.TabIndex then
      dmMainModule.TabsChanged;
  end;
  if Button = mbRight then
  begin
    PIdx := PageControl1.IndexOfTabAt(X, Y);
    //PageControl1.ActivePageIndex := PIdx;
    //Application.ProcessMessages;
    dmMainModule.TabsPopup(PIdx);
  end
  else if Button = mbMiddle then
  begin
    PIdx := PageControl1.IndexOfTabAt(X, Y);
    if (PIdx > 0) and (PageControl1.Pages[PIdx].Controls[0] is TdframBase)
      and TdframBase(PageControl1.Pages[PIdx].Controls[0]).QueryDisconnect(True) then;
  end;
end;

procedure TFrmDSqlMain.TabControl1GetImageIndex(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
begin
  ImageIndex := TabIndex;
end;

end.

