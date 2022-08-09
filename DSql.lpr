program DSql;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  sysutils,
  Interfaces, // this includes the LCL widgetset
  LazFileUtils,
  duConsts, duFrames, Controls,
  Forms, duFrmDSqlMain, dudmMainModule, duframTest, frmDlgConnectionRetrive,
  duSqlParser, duframFuncProc, dudMetadata, uiblaz, DSql.SqlObject,
  dsql.so.Table, duFrmDomain, dufrmcomment, duFrmDepend, duFrmInsertCode,
  duFrmCopyTable, dufrmSettings, duFrmtableReorderFields, dufrmConfigDsql,
  dufrmFBBackup, dufrmFBRestore
  { you can add units after this };


{$R *.res}
{
7z a  ./Release/DSql-0_8_5-Linux-x86_64-Gtk2.7z      DSql-0_8_5-Linux-x86_64-Gtk2
#7z a ./Release/DSql-0_8_5-Linux-x86_64-Gtk2_dbg.7z  DSql-0_8_5-Linux-x86_64-Gtk2.dbg
7z a  ./Release/DSql-0_8_5-Linux-x86_64-Qt4.7z       DSql-0_8_5-Linux-x86_64-Qt4
#7z a ./Release/DSql-0_8_5-Linux-x86_64-Qt4_dbg.7z   DSql-0_8_5-Linux-x86_64-Qt4.dbg
#7z a ./Release/DSql-0_8_5-Win32_dbg.7z              DSql-0_8_5-Win32.dbg
7z a  ./Release/DSql-0_8_5-Win32.7z                  DSql-0_8_5-Win32.exe
#7z a ./Release/DSql-0_8_5-Win64_dbg.7z              DSql-0_8_5-Win64.dbg
7z a  ./Release/DSql-0_8_5-Win64.7z                  DSql-0_8_5-Win64.exe
}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TFrmDSqlMain, FrmDSqlMain);
  Application.CreateForm(TDFrmConfig, DFrmConfig);
  Application.ShowHint := True;
  if ((not FileExistsUTF8(c_config_file)) and (not FileExistsUTF8(DFrames.UserPath + PathDelim + '.DSql' + PathDelim + c_config_file))) then
  begin
    if DFrmConfig.ShowModal = mrOK then
    begin
      case DFrmConfig.ComboBox1.ItemIndex of
        0:
          begin
            DFrames.ConfigPath := DFrames.UserPath + '.DSql' + PathDelim;
          end;
        1:
          begin
            DFrames.ConfigPath := '';
          end;
     end;
      TDFrmSettings.SaveDefaultSettings;
      TDFrmSettings.LoadSettings(Nil);
      Application.ShowMainForm := True;
    end
    else
      FrmDSqlMain.Close;
  end
  else
  begin
    if FileExistsUTF8(c_config_file) then
      DFrames.ConfigPath := ''
    else if FileExistsUTF8(DFrames.UserPath + PathDelim + '.DSql' + PathDelim + c_config_file) then
      DFrames.ConfigPath := DFrames.UserPath + '.DSql' + PathDelim;
    TDFrmSettings.LoadSettings(Nil);
    Application.ShowMainForm := True;
    Application.MainForm.ShowHint := True;
  end;
  Application.CreateForm(TdmMainModule, dmMainModule);
  //We Call FrmComments on the fly, So do not remove line below!
  Application.CreateForm(TFrmComment, FrmComment);
  Application.CreateForm(TFrmDepend, FrmDepend);
  Application.CreateForm(TFrmInsertCode, FrmInsertCode);
  Application.CreateForm(TFrmCopyTable, FrmCopyTable);
  Application.CreateForm(TDFrmSettings, DFrmSettings);
  Application.CreateForm(TFrmTableReorderFields, FrmTableReorderFields);
  Application.CreateForm(TfrmFBBackup, frmFBBackup);
  Application.CreateForm(TFrmFBRestore, FrmFBRestore);
  Application.Run;
end.

