unit dufrmSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LCLType, LCLIntf, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, ColorBox, Buttons,
  SynHighlighterSQL, SynEdit, SynEditHighlighter, SynEditMiscClasses,
  SynHighlighterPas, SynGutterChanges, SynEditStrConst, IpHtml, duFrames,
  Grids, EditBtn, duTypes, duUtil, duConsts, Debio.JSON, Debio.JSON.Parser,
  Debio.Utils.Files;

type

  TDEnabledControls = set of (decBackColor, decFontColor, decFontStyle, decFrameTyle);

  { TDFrmSettings }

  TDFrmSettings = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbBackColor: TColorBox;
    deDefaultPath: TDirectoryEdit;
    cbFontColor: TColorBox;
    cbFonts: TComboBox;
    cbLogFont: TComboBox;
    cbGridTtitleFontName: TComboBox;
    cbGridCelleFont: TComboBox;
    cbQuality1: TComboBox;
    cbGridTtitleFontQuality: TComboBox;
    cbGridCelleFontQuality: TComboBox;
    cbGridTitleStyle: TComboBox;
    cbLogFontSize: TSpinEdit;
    cbGridTtitleFontSize: TSpinEdit;
    cbGridCelleFontSize: TSpinEdit;
    cbTheme: TComboBox;
    cbQuality: TComboBox;
    cbSize: TSpinEdit;
    chbUnderLine: TCheckBox;
    chbStrikeOut: TCheckBox;
    chbBold: TCheckBox;
    chbItalic: TCheckBox;
    cbEditorTheme: TComboBox;
    chbTabToSpace: TCheckBox;
    chbAutoIndent: TCheckBox;
    chbShowLineNumber: TCheckBox;
    chbKeyWorsUpper: TCheckBox;
    chbAutoComplete: TCheckBox;
    deDefaultSavePath: TDirectoryEdit;
    hpLog: TIpHtmlPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbColorStyle: TListBox;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel2: TPanel;
    Panel20: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    pnlBkColor: TPanel;
    pnlFontColor: TPanel;
    pnlFontStyle: TPanel;
    sbNewFrom: TSpeedButton;
    sbSaveTheme: TSpeedButton;
    spTabSize: TSpinEdit;
    spLineNumbers: TSpinEdit;
    StringGrid1: TStringGrid;
    SynEdit1: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    General: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TreeView1: TTreeView;
    procedure BitBtn1Click(Sender: TObject);
    procedure cbFontNameChange(Sender: TObject);
    procedure cbBackColorChange(Sender: TObject);
    procedure cbLogFontChange(Sender: TObject);
    procedure cbThemeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbColorStyleClick(Sender: TObject);
    procedure OnGridProps(Sender: TObject);
    procedure sbSaveThemeClick(Sender: TObject);
    procedure sbNewFromClick(Sender: TObject);
    procedure SynEdit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SynEdit1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FUpdatingUI: Boolean;
    FLogAttri: TDLogStyle;
    FGridStyle: TDGridStyle;
    procedure ChangeFont;
    function ThemeName: String;
    procedure ThemeChanges;
    procedure ApplyGrid;
    procedure ApplyLog;
    procedure ThemeLoaded;
    procedure FillFont(List: TStrings; Attr: Integer);
  public
    class procedure LoadTheme(Editor: TSynEdit; Highlighter: TSynSQLSyn; var Log: TDLogStyle; var Grid: TDGridStyle; AThemeName: String);
    class procedure LoadTheme(Editor: TSynEdit; Highlighter: TSynSQLSyn; var Log: TDLogStyle; var Grid: TDGridStyle; ATheme: TDJSON; AThemeName: String);
    class procedure SaveTheme(Editor: TSynEdit; Highlighter: TSynSQLSyn; Log: TDLogStyle; Grid: TDGridStyle; AThemeName: String);
    class procedure LoadSettings(ConfigForm: TDFrmSettings);
    class procedure SaveSettings();
    class procedure SaveDefaultSettings;
  end;

var
  DFrmSettings: TDFrmSettings;

implementation

{$R *.lfm}

{ TDFrmSettings }

function EnumFontsMonoSpaceNoDups(var ELogFont: TEnumLogFontEx; var Metric: TNewTextMetricEx; FontType: Longint; Data: LParam): Longint; stdcall;
var
  L: TStringList;
  S: String;
begin
  L := TStringList(ptrint(Data));
  S := ELogFont.elfLogFont.lfFaceName;
  if L.IndexOf(S)<0 then
    L.Add(S);
  result := 1;
end;

procedure TDFrmSettings.FormShow(Sender: TObject);
var
  cou: Integer;
begin
  FillFont(cbFonts.Items, MONO_FONT);
  FillFont(cbLogFont.Items, 0);
  FillFont(cbGridTtitleFontName.Items, 0);
  FillFont(cbGridCelleFont.Items, 0);

  lbColorStyle.ItemIndex := 0;
  lbColorStyleClick(Nil);
  SynSQLSyn1.TableNames.Add('TABLE1');
  SynSQLSyn1.AddKeyword('P1', tkVariable);
  SynSQLSyn1.AddKeyword('COUNT_', tkVariable);
  SynSQLSyn1.AddKeyword('V1', tkVariable);
  SynSQLSyn1.AddKeyword('F1', tkVariable);
  SynSQLSyn1.AddKeyword('F2', tkVariable);
  SynSQLSyn1.AddKeyword('FAILED_TEST', tkException);
  SynSQLSyn1.AddKeyword('DOMAIN1', tkDatatype);
  cbTheme.Clear;
  FindAllFiles(cbTheme.Items, DFrames.ThemesDir, '', False);
  for cou := 0 to cbTheme.Items.Count - 1 do
  begin
    cbTheme.Items[cou] := ExtractFileName(cbTheme.Items[cou]);
  end;
  cbEditorTheme.Items.Assign(cbTheme.Items);
  if DFrames.EditorThemeName <> '' then
  begin
    cbEditorTheme.ItemIndex := cbEditorTheme.Items.IndexOf(DFrames.EditorThemeName);
    cbTheme.ItemIndex := cbTheme.Items.IndexOf(DFrames.EditorThemeName);
  end
  else
  begin
    cbEditorTheme.ItemIndex := cbEditorTheme.Items.IndexOf('DSql Dark');
    cbTheme.ItemIndex := cbTheme.Items.IndexOf('DSql Dark');
  end;
  if cbTheme.Items.Count > 0 then
  begin
    cbTheme.ItemIndex := 0;
    try
      FUpdatingUI := True;
      LoadTheme(SynEdit1, SynSQLSyn1, FLogAttri, FGridStyle, ThemeName);
      ThemeLoaded;
      Application.ProcessMessages;
    finally
      FUpdatingUI := False;
    end;
    //ApplyGrid;
    //ApplyLog;
  end
  else
  begin
    cbTheme.Items.Add('DSql Light');
    cbTheme.ItemIndex := 0;
    SaveTheme(SynEdit1, SynSQLSyn1, FLogAttri, FGridStyle, ThemeName);
    LoadTheme(SynEdit1, SynSQLSyn1, FLogAttri, FGridStyle, ThemeName);
    ThemeLoaded;
    //ApplyGrid;
    //ApplyLog;
  end;
end;

procedure TDFrmSettings.lbColorStyleClick(Sender: TObject);
var
  eds: TDEnabledControls;
  BackColor, FontColor: String;

  procedure ApplyAttr(Attr: TSynHighlighterAttributes);
  begin
    cbBackColor.Selected := Attr.Background;
    cbFontColor.Selected := Attr.Foreground;
    chbItalic.Checked := fsItalic in Attr.Style;
    chbBold.Checked := fsBold in Attr.Style;
    chbStrikeOut.Checked := fsStrikeOut in Attr.Style;
    chbItalic.Checked := fsItalic in Attr.Style;
  end;

  procedure ApplyStyle(Style: TSynSelectedColor);
  begin
    cbBackColor.Selected := Style.Background;
    cbFontColor.Selected := Style.Foreground;
    chbItalic.Checked    := fsItalic    in Style.Style;
    chbBold.Checked      := fsBold      in Style.Style;
    chbStrikeOut.Checked := fsStrikeOut in Style.Style;
    chbItalic.Checked    := fsItalic    in Style.Style;
  end;

begin
  FUpdatingUI := True;
  try
    eds := [];
    BackColor := 'Back color';
    FontColor := 'Font Color';
    case lbColorStyle.Items[lbColorStyle.ItemIndex] of
      'Default':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          cbBackColor.Selected := SynEdit1.Color;
          cbFontColor.Selected := SynEdit1.Font.Color;
          chbItalic.Checked := fsItalic in SynEdit1.Font.Style;
          chbBold.Checked := fsBold in SynEdit1.Font.Style;
          chbStrikeOut.Checked := fsStrikeOut in SynEdit1.Font.Style;
          chbItalic.Checked := fsItalic in SynEdit1.Font.Style;
        end;
      'Comments':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.CommentAttri);
        end;
      'Data Types':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.DataTypeAttri);
        end;
      'Exceptions':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.ExceptionAttri);
        end;
      'Functions':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.FunctionAttri);
        end;
      'Identifiers':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.IdentifierAttri);
        end;
      'Keywords':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.KeywordAttribute);
        end;
      'Line Highlight':
        begin
          eds := [decBackColor];
          ApplyStyle(SynEdit1.LineHighlightColor);
        end;
      'Numbers':
        begin
          eds := [decBackColor, decFontColor];
          ApplyAttr(SynSQLSyn1.NumberAttri);
        end;
      'Selection':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyStyle(SynEdit1.SelectedColor);
        end;
      'Strings':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.StringAttri);

        end;
      'Symbols':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.SymbolAttri);
        end;
      'Tables':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.TableNameAttri);
        end;
      'Variables':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyAttr(SynSQLSyn1.VariableAttri);
        end;
      'Line Number':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          ApplyStyle(SynEdit1.Gutter.Parts[1].MarkupInfo);
        end;
      'Modified Line':
        begin
          eds := [decBackColor, decFontColor];
          BackColor := 'Chnges color';
          FontColor := 'Saved color';
          cbBackColor.Selected := TSynGutterChanges(SynEdit1.Gutter.Parts[2]).ModifiedColor;
          cbFontColor.Selected := TSynGutterChanges(SynEdit1.Gutter.Parts[2]).SavedColor;
        end;
      'Right Margin':
        begin
          eds := [decFontColor];
          FontColor := 'Color';
        end;
      'Gutter':
        begin
          eds := [decBackColor, decFontColor];
          FontColor := 'Color';
          cbBackColor.Selected := SynEdit1.Gutter.Color;
          cbFontColor.Selected := SynEdit1.Gutter.Parts[3].MarkupInfo.Foreground;
        end;
      'Log':
        begin
          eds := [decBackColor];
          FontColor := 'Background';
          cbBackColor.Selected := FLogAttri.Background;
        end;
      'Log Information':
        begin
          eds := [decFontColor];
          FontColor := 'Color';
          cbFontColor.Selected := FLogAttri.Information.Foreground;
        end;
      'Log Detial':
        begin
          eds := [decFontColor];
          FontColor := 'Color';
          cbFontColor.Selected := FLogAttri.Detail.Foreground;
        end;
      'Log Error':
        begin
          eds := [decFontColor];
          FontColor := 'Color';
          cbFontColor.Selected := FLogAttri.Error.Foreground;
        end;
      'Grid':
        begin
          eds := [decBackColor, decFontColor];
          BackColor := 'Grid Color';
          FontColor := 'Odd row Color';
          cbBackColor.Selected := FGridStyle.Background;
          cbFontColor.Selected := FGridStyle.OddRowColor;
        end;
      'Grid Title':
        begin
          eds := [decBackColor, decFontColor, decFontStyle];
          BackColor := 'Title bkg Color';
          FontColor := 'Color';
          cbBackColor.Selected := FGridStyle.Title_Background;
          cbFontColor.Selected := FGridStyle.Title_Font.Color;
          chbItalic.Checked    := fsItalic    in FGridStyle.Title_Font.Style;
          chbBold.Checked      := fsBold      in FGridStyle.Title_Font.Style;
          chbStrikeOut.Checked := fsStrikeOut in FGridStyle.Title_Font.Style;
          chbItalic.Checked    := fsItalic    in FGridStyle.Title_Font.Style;
        end;
      'Grid Cell':
        begin
          eds := [decFontColor, decFontStyle];
          FontColor := 'Color';
          cbFontColor.Selected := FGridStyle.CellFont.Color;
          chbItalic.Checked    := fsItalic    in FGridStyle.CellFont.Style;
          chbBold.Checked      := fsBold      in FGridStyle.CellFont.Style;
          chbStrikeOut.Checked := fsStrikeOut in FGridStyle.CellFont.Style;
          chbItalic.Checked    := fsItalic    in FGridStyle.CellFont.Style;
        end;
    end;
    pnlBkColor.Caption := BackColor;
    pnlFontColor.Caption := FontColor;
    pnlBkColor.Visible    := decBackColor  in eds;
    pnlFontColor.Visible  := decFontColor  in eds;
    //pnlFrontColor.Visible := decFrontColor in eds;
    pnlFontStyle.Visible  := decFontStyle  in eds;
    //pnlBkColor.Enabled := decBackColor in eds;
  finally
    FUpdatingUI := False;
  end;
end;

procedure TDFrmSettings.OnGridProps(Sender: TObject);
begin
  //StringGrid1.TitleStyle := TTitleStyle(cbGridTitleStyle.ItemIndex + 1);
  //StringGrid1.Font.Name := cbGridCelleFont.Text;
  if FUpdatingUI then Exit;
  FGridStyle.Title_Font.Name := cbGridTtitleFontName.Text;
  FGridStyle.Title_Font.Size := cbGridTtitleFontSize.Value;
  FGridStyle.Title_Font.Quality := TFontQuality(cbGridTtitleFontQuality.ItemIndex);

  FGridStyle.CellFont.Name := cbGridCelleFont.Text;
  FGridStyle.CellFont.Size := cbGridCelleFontSize.Value;
  FGridStyle.CellFont.Quality := TFontQuality(cbGridCelleFontQuality.ItemIndex);

  FGridStyle.Title_Style := TTitleStyle(cbGridTitleStyle.ItemIndex);
  ApplyGrid;
  ThemeChanges;
end;

procedure TDFrmSettings.sbSaveThemeClick(Sender: TObject);
var
  tn: String;
begin
  SaveTheme(SynEdit1, SynSQLSyn1, FLogAttri, FGridStyle, ThemeName);
  tn := ThemeName;
  if tn[Length(tn)] = '*' then
    cbTheme.Items[cbTheme.ItemIndex] := Copy(tn, 1, Length(tn) - 1);
end;

procedure TDFrmSettings.sbNewFromClick(Sender: TObject);
var
  nct: String;
  ix: Integer;
begin
  nct := InputBox('Copy Theme', 'Enter name of new color theme', 'New ' + cbTheme.Items[cbTheme.ItemIndex]);
  if nct <> '' then
  begin
    ix := cbTheme.Items.Add(nct);
    cbTheme.ItemIndex := ix;
    SaveTheme(SynEdit1, SynSQLSyn1, FLogAttri, FGridStyle, ThemeName);
  end;
end;

procedure TDFrmSettings.SynEdit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SynEdit1MouseUp(Nil, mbLeft, [], 0, 0);
end;

procedure TDFrmSettings.SynEdit1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Attr: TSynHighlighterAttributes;
  tk: string;
begin
  //Panel1.Caption := Format('%d - %d ', [SynEdit1.CaretX, SynEdit1.CaretY]);
  if SynEdit1.GetHighlighterAttriAtRowCol(SynEdit1.CaretXY, tk, Attr) then
  begin
    case Attr.Caption^ of
      SYNS_XML_AttrComment:        lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Comments');
      SYNS_XML_AttrDataType:       lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Data Types');
      //SYNS_XML_AttrDefaultPackage: lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('');
      SYNS_XML_AttrException:      lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Exceptions');
      SYNS_XML_AttrFunction:       lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Functions');
      SYNS_XML_AttrIdentifier:     lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Identifiers');
      SYNS_XML_AttrReservedWord:   lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Keywords');
      SYNS_XML_AttrNumber:         lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Numbers');
      //SYNS_XML_AttrPLSQL:          lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('');
      SYNS_XML_AttrSpace:          lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Default');
      //SYNS_XML_AttrSQLPlus:        lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('');
      SYNS_XML_Attrstring:         lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Strings');
      SYNS_XML_AttrSymbol:         lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Symbols');
      SYNS_XML_AttrTableName:      lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Tables');
      SYNS_XML_AttrVariable:       lbColorStyle.ItemIndex := lbColorStyle.Items.IndexOf('Variables');
    end;
    if lbColorStyle.ItemIndex = -1 then
    begin
      //WriteLn(tk , '  ', Attr.Caption^);
      lbColorStyle.ItemIndex := 0;
    end;
    lbColorStyleClick(Nil);
  end;
end;

//function TDFrmSettings.ColorToHex(AColor: TColor): String;
//begin
//  Result := '$' + HexStr(AColor, 8);
//end;
//
//function TDFrmSettings.HexToColor(AColor: String): TColor;
//var
//  Code: Integer;
//begin
//  val(AColor, Result, Code);
//  if Code <> 0 then
//    Result := clNone;
//end;

procedure TDFrmSettings.cbFontNameChange(Sender: TObject);
begin
  ChangeFont;
end;

procedure TDFrmSettings.BitBtn1Click(Sender: TObject);
begin
  SaveTheme(SynEdit1, SynSQLSyn1, FLogAttri, FGridStyle, ThemeName);
  SaveSettings();
  DFrames.UpdateConfigs;
end;

procedure TDFrmSettings.cbBackColorChange(Sender: TObject);
var
  fs: TFontStyles;
  tn: String;

  procedure ApplyAttr(Attr: TSynHighlighterAttributes);
  begin
    Attr.Background := cbBackColor.Selected;
    Attr.Foreground := cbFontColor.Selected;
    fs := [];
    if chbBold.Checked then
      fs += [fsBold];
    if chbUnderLine.Checked then
      fs += [fsUnderline];
    if chbStrikeOut.Checked then
      fs += [fsStrikeOut];
    if chbItalic.Checked then
      fs += [fsItalic];
    Attr.Style := fs;
  end;

  procedure ApplyStyle(Style: TSynSelectedColor);
  begin
    Style.Background := cbBackColor.Selected;
    Style.Foreground := cbFontColor.Selected;
    fs := [];
    if chbBold.Checked then
      fs += [fsBold];
    if chbUnderLine.Checked then
      fs += [fsUnderline];
    if chbStrikeOut.Checked then
      fs += [fsStrikeOut];
    if chbItalic.Checked then
      fs += [fsItalic];
    Style.Style := fs;
  end;

begin
  if FUpdatingUI then
    Exit;
  if cbTheme.Items.Count = 0 then
  begin
    cbTheme.Items.Add('Default');
    cbTheme.ItemIndex := 0;
  end;
  ThemeChanges;
  case lbColorStyle.Items[lbColorStyle.ItemIndex] of
     'Default':
       begin
         SynEdit1.Color := cbBackColor.Selected;
         SynEdit1.Font.Color := cbFontColor.Selected;
         fs := [];
         if chbBold.Checked then
           fs += [fsBold];
         if chbUnderLine.Checked then
           fs += [fsUnderline];
         if chbStrikeOut.Checked then
           fs += [fsStrikeOut];
         if chbItalic.Checked then
           fs += [fsItalic];
         SynEdit1.Font.Style := fs;
       end;
     'Comments':
       begin
         ApplyAttr(SynSQLSyn1.CommentAttri);
       end;
     'Data Types':
       begin
         ApplyAttr(SynSQLSyn1.DataTypeAttri);
       end;
     'Exceptions':
       begin
         ApplyAttr(SynSQLSyn1.ExceptionAttri);
       end;
     'Functions':
       begin
         ApplyAttr(SynSQLSyn1.FunctionAttri);
       end;
     'Identifiers':
       begin
         ApplyAttr(SynSQLSyn1.IdentifierAttri);
       end;
     'Keywords':
       begin
         ApplyAttr(SynSQLSyn1.KeywordAttribute);
       end;
     'Line Highlight':
       begin
         ApplyStyle(SynEdit1.LineHighlightColor);
       end;
     'Numbers':
       begin
         ApplyAttr(SynSQLSyn1.NumberAttri);
       end;
     'Selection':
       begin
         ApplyStyle(SynEdit1.SelectedColor);
       end;
     'Strings':
       begin
         ApplyAttr(SynSQLSyn1.StringAttri);
       end;
     'Symbols':
       begin
         ApplyAttr(SynSQLSyn1.SymbolAttri);
       end;
     'Tables':
       begin
         ApplyAttr(SynSQLSyn1.TableNameAttri);
       end;
     'Variables':
       begin
         ApplyAttr(SynSQLSyn1.VariableAttri);
       end;
     'Line Number':
       begin
         ApplyStyle(SynEdit1.Gutter.Parts[1].MarkupInfo);
       end;
     'Modified Line':
       begin
         TSynGutterChanges(SynEdit1.Gutter.Parts[2]).ModifiedColor := cbBackColor.Selected;
         TSynGutterChanges(SynEdit1.Gutter.Parts[2]).SavedColor := cbFontColor.Selected;
       end;
     'Gutter':
       begin
         SynEdit1.Gutter.Color := cbBackColor.Selected;
         SynEdit1.Gutter.Parts[3].MarkupInfo.Background := cbBackColor.Selected;
         SynEdit1.Gutter.Parts[3].MarkupInfo.Foreground := cbFontColor.Selected;
       end;
     'Log':
       begin
         FLogAttri.Background := cbBackColor.Selected;
         ApplyLog;
       end;
     'Log Information':
       begin
         FLogAttri.Information.Foreground := cbFontColor.Selected;
         ApplyLog;
       end;
     'Log Detial':
       begin
         FLogAttri.Detail.Foreground := cbFontColor.Selected;
         ApplyLog;
       end;
     'Log Error':
       begin
         FLogAttri.Error.Foreground := cbFontColor.Selected;
         ApplyLog;
       end;
     'Grid':
       begin
         FGridStyle.Background  := cbBackColor.Selected;
         FGridStyle.OddRowColor := cbFontColor.Selected;
         ApplyGrid;
       end;
     'Grid Title':
       begin
         FGridStyle.Title_Background := cbBackColor.Selected;
         FGridStyle.Title_Font.Color := cbFontColor.Selected;
         fs := [];
         if chbBold.Checked then
           fs += [fsBold];
         if chbUnderLine.Checked then
           fs += [fsUnderline];
         if chbStrikeOut.Checked then
           fs += [fsStrikeOut];
         if chbItalic.Checked then
           fs += [fsItalic];
         FGridStyle.Title_Font.Style := fs;
         ApplyGrid;
       end;
     'Grid Cell':
       begin
         FGridStyle.CellFont.Color := cbFontColor.Selected;
         fs := [];
         if chbBold.Checked then
           fs += [fsBold];
         if chbUnderLine.Checked then
           fs += [fsUnderline];
         if chbStrikeOut.Checked then
           fs += [fsStrikeOut];
         if chbItalic.Checked then
           fs += [fsItalic];
         FGridStyle.CellFont.Style := fs;
         ApplyGrid;
       end;
   end;
end;

procedure TDFrmSettings.cbLogFontChange(Sender: TObject);
begin
  if FUpdatingUI then Exit;
  FLogAttri.Font.Name := cbLogFont.Text;
  FLogAttri.Font.Size := cbLogFontSize.Value;
  ApplyLog;
  ThemeChanges;
end;

procedure TDFrmSettings.cbThemeChange(Sender: TObject);
begin
  if cbTheme.ItemIndex <> -1 then
  begin
    try
      FUpdatingUI := True;
      LoadTheme(SynEdit1, SynSQLSyn1, FLogAttri, FGridStyle, ThemeName);
      ThemeLoaded;
    finally
      FUpdatingUI := False;
    end;
    //ApplyGrid;
    //ApplyLog;
  end;
end;

procedure TDFrmSettings.ChangeFont;
begin
  SynEdit1.Font.Name := cbFonts.Items[cbFonts.ItemIndex];
  SynEdit1.Font.Quality := TFontQuality(cbQuality.ItemIndex);
  SynEdit1.Font.Size := cbSize.Value;
end;

function TDFrmSettings.ThemeName: String;
begin
  if cbTheme.ItemIndex <> - 1 then
    Result := cbTheme.Items[cbTheme.ItemIndex]
  else
    Result := '';
end;

procedure TDFrmSettings.ThemeChanges;
var
  tn: String;
begin
  if FUpdatingUI then
    Exit;
  tn := cbTheme.Items[cbTheme.ItemIndex];
  if tn[tn.Length] <> '*' then
    tn += '*';
  cbTheme.Items[cbTheme.ItemIndex] := tn;
end;

procedure TDFrmSettings.ApplyGrid;
var
  cou: Integer;
begin
  with FGridStyle, StringGrid1 do
  begin
    Font.Name := CellFont.Name;
    Font.Size := CellFont.Size;
    Font.Style := CellFont.Style;
    Font.Quality := CellFont.Quality;
    Font.Color := CellFont.Color;
    Color := Background;
    AlternateColor := OddRowColor;
    TitleFont.Color := Title_Font.Color;
    TitleFont.Size := Title_Font.Size;
    TitleFont.Style := Title_Font.Style;
    TitleFont.Quality := Title_Font.Quality;
    TitleFont.Name := Title_Font.Name;
    TitleStyle := Title_Style;
    for cou := 0 to StringGrid1.Columns.Count - 1 do
      StringGrid1.Columns[cou].Title.Color := FGridStyle.Title_Background;
  end;
end;

procedure TDFrmSettings.ApplyLog;
var
  log: String;
begin
  with FLogAttri do
  log := Format(
  '<html><body bgcolor="%s"><font face="%s" size="%d">'+
  '<font color="%s">Detaile looks like this<br></font>'+
  '<font color="%s">Information looks like this<br></font>'+
  '<font color="%s">Error looks like this<br></font>',
      [ColorToHTML(Background), Font.Name, Font.Size, ColorToHTML(Detail.Foreground), ColorToHTML(Information.Foreground), ColorToHTML(Error.Foreground)]);
  hpLog.SetHtmlFromStr(log);
  //WriteLn(log);
end;

procedure TDFrmSettings.ThemeLoaded;
begin
  FUpdatingUI := True;
  try
    ApplyLog;
    ApplyGrid;
    cbFonts.ItemIndex := cbFonts.Items.IndexOf(SynEdit1.Font.Name);
    cbSize.Value := SynEdit1.Font.Size;
    cbQuality.ItemIndex := Ord(SynEdit1.Font.Quality);

    cbLogFont.ItemIndex := cbLogFont.Items.IndexOf(FLogAttri.Font.Name);
    cbLogFontSize.Value := FLogAttri.Font.Size;
    //cblogfon

    cbGridCelleFont.ItemIndex := cbGridCelleFont.Items.IndexOf(FGridStyle.CellFont.Name);
    cbGridCelleFontSize.Value := FGridStyle.CellFont.Size;
    cbGridCelleFontQuality.ItemIndex := ord(FGridStyle.CellFont.Quality);

    cbGridTtitleFontName.ItemIndex := cbGridCelleFont.Items.IndexOf(FGridStyle.CellFont.Name);
    cbGridTtitleFontSize.Value := FGridStyle.Title_Font.Size;
    cbGridTtitleFontQuality.ItemIndex := ord(FGridStyle.Title_Font.Quality);

    cbGridTitleStyle.ItemIndex := ord(FGridStyle.Title_Style);
    //cbGridTitleStyle.ItemIndex := ord();
    Application.ProcessMessages;
    lbColorStyleClick(Nil);
  finally
    FUpdatingUI := False;
  end;
end;

procedure TDFrmSettings.FillFont(List: TStrings; Attr: Integer);
var
  DC: HDC;
  lf: TLogFont;
  iList: TStringList;
begin
  iList := TStringList.Create;
  lf.lfCharSet := DEFAULT_CHARSET;
  lf.lfFaceName := '';
  if Attr = MONO_FONT then
  {$IfDef GTK2}
    lf.lfPitchAndFamily := MONO_FONT   //Set this to MONO_FONT on Linux/GTK2
  {$ELSE}
    lf.lfPitchAndFamily := MONO_FONT   //Set this to MONO_FONT on Linux/GTK2
  {$EndIf}
  else
    lf.lfPitchAndFamily := Attr;
  DC := GetDC(0);
  try
    EnumFontFamiliesEX(DC, @lf, @EnumFontsMonoSpaceNoDups, ptrint(iList), 0);
    iList.Sort;
    List.Assign(iList);
  finally
    ReleaseDC(0, DC);
    FreeAndNil(iList);
  end;
end;

class procedure TDFrmSettings.LoadTheme(Editor: TSynEdit; Highlighter: TSynSQLSyn; var Log: TDLogStyle; var Grid: TDGridStyle; AThemeName: String);
var
  jsTheme, style: TDJSON;
  tn, theme: String;
  cou: Integer;

  procedure ApplyAttr(AName: String; Attr: TSynHighlighterAttributes);
  var
    cou: Integer;
    style: TDJSON;
  begin
    with jsTheme[AName] do
    begin
      Attr.Background := StringToColor(P['Background'].AsString);
      Attr.Foreground := StringToColor(P['Foreground'].AsString);
      Attr.Style := ToFontStyle(P['Font Style']);
    end;
  end;

  procedure ApplyStyle(AName: String; Attr: TSynSelectedColor);
  var
    style: TDJSON;
    cou: Integer;
  begin
    with jsTheme[AName] do
    begin
      Attr.Background := StringToColor(P['Background'].AsString);
      Attr.Foreground := StringToColor(P['Foreground'].AsString);
      Attr.Style := ToFontStyle(P['Font Style']);
    end;
  end;

begin
  tn := AThemeName;
  if tn[Length(tn)] = '*' then
    Delete(tn, Length(tn), 1);
  if FileExists(DFrames.ThemesPath + tn) then
  try
    tn := DFrames.ThemesPath + tn;
    theme := ReadFileToString(tn);
    jsTheme := ParseJSON(PChar(theme));
    //WriteLn(jsTheme.TO_JSONString(0, True));
    with jsTheme['Default'] do
    begin
      Editor.Color      := StringToColor(P['Background'].AsString);
      Editor.Font.Color := StringToColor(P['Foreground'].AsString);
      Editor.Font.Name  := P['Font Name'].AsString;
      Editor.Font.Size  := P['Font Size'].AsInteger;
      Editor.Font.Quality := ToFontQuality(P['Font Quality'].AsString);
      Editor.Font.Style := ToFontStyle(P['Font Style']);
    end;
    ApplyAttr('Comments', Highlighter.CommentAttri);
    ApplyAttr('Data Types', Highlighter.DataTypeAttri);
    ApplyAttr('Exceptions', Highlighter.ExceptionAttri);
    ApplyAttr('Functions', Highlighter.FunctionAttri);
    ApplyAttr('Identifiers', Highlighter.IdentifierAttri);
    ApplyAttr('Keywords', Highlighter.KeywordAttribute);
    ApplyStyle('Line Highlight', Editor.LineHighlightColor);
    ApplyAttr('Numbers', Highlighter.NumberAttri);
    ApplyStyle('Selection', Editor.SelectedColor);
    ApplyAttr('Strings', Highlighter.StringAttri);
    ApplyAttr('Symbols', Highlighter.SymbolAttri);
    ApplyAttr('Tables', Highlighter.TableNameAttri);
    ApplyAttr('Variables', Highlighter.VariableAttri);
    ApplyStyle('Line Number', Editor.Gutter.Parts[1].MarkupInfo);

    with jsTheme['Modified Line'] do
    begin
      TSynGutterChanges(Editor.Gutter.Parts[2]).ModifiedColor := StringToColor(P['Modified'].AsString);
      TSynGutterChanges(Editor.Gutter.Parts[2]).SavedColor    := StringToColor(P['Saved'].AsString);
    end;

    with jsTheme['Gutter'] do
    begin
      Editor.Gutter.Color                          := StringToColor(P['Background'].AsString);
      Editor.Gutter.Parts[3].MarkupInfo.Foreground := StringToColor(P['Foreground'].AsString);
    end;

    with jsTheme['Grid'] do
    begin
      with P['Title Font'] do
      begin
        Grid.Title_Font.Name := p['Name'].AsString;
        Grid.Title_Font.Size := p['Size'].AsInteger;
        Grid.Title_Font.Quality := ToFontQuality(p['Font Quality'].AsString);
        Grid.Title_Font.Color   := StringToColor(p['Color'].AsString);
        Grid.Title_Font.Style   := ToFontStyle(P['Font Style']);
      end;
      with P['Cell Font'] do
      begin
        Grid.CellFont.Name := p['Name'].AsString;
        Grid.CellFont.Size := p['Size'].AsInteger;

        Grid.CellFont.Quality := ToFontQuality(p['Font Quality'].AsString);
        Grid.CellFont.Color   := StringToColor(p['Color'].AsString);
        Grid.CellFont.Style   := ToFontStyle(P['Font Style']);
      end;
      Grid.Background  := StringToColor(P['Color'].AsString);
      Grid.OddRowColor := StringToColor(P['OddRow'].AsString);
      Grid.Title_Style := ToTitleStyle(P['Title Style'].AsString);
      Grid.Title_Background := StringToColor(P['Title Background'].AsString);
    end;

    with jsTheme['Log'] do
    begin
      with P['Font'] do
      begin
        Log.Font.Name                 := P['Name'].AsString;
        Log.Font.Size                 := P['Size'].AsInteger;
        Log.Font.Quality := ToFontQuality(P['Font Quality'].AsString);
        Log.Font.Style := ToFontStyle(P['Font Style']);
      end;
      Log.Background             := StringToColor(P['Background'].AsString);
      Log.Detail.Foreground      := StringToColor(P['Detail'].AsString);
      Log.Error.Foreground       := StringToColor(P['Error'].AsString);
      Log.Information.Foreground := StringToColor(P['Information'].AsString);
    end;     finally
    jsTheme.Free;
  end;
end;

class procedure TDFrmSettings.LoadTheme(Editor: TSynEdit; Highlighter: TSynSQLSyn; var Log: TDLogStyle; var Grid: TDGridStyle; ATheme: TDJSON; AThemeName: String);
var
  jsTheme: TDJSON absolute ATheme;
  style: TDJSON;
  tn, theme: String;
  cou: Integer;

  procedure ApplyAttr(AName: String; Attr: TSynHighlighterAttributes);
  var
    cou: Integer;
    style: TDJSON;
  begin
    with jsTheme[AName] do
    begin
      Attr.Background := StringToColor(P['Background'].AsString);
      Attr.Foreground := StringToColor(P['Foreground'].AsString);
      Attr.Style := ToFontStyle(P['Font Style']);
    end;
  end;

  procedure ApplyStyle(AName: String; Attr: TSynSelectedColor);
  var
    style: TDJSON;
    cou: Integer;
  begin
    with jsTheme[AName] do
    begin
      Attr.Background := StringToColor(P['Background'].AsString);
      Attr.Foreground := StringToColor(P['Foreground'].AsString);
      Attr.Style := ToFontStyle(P['Font Style']);
    end;
  end;

begin
  tn := AThemeName;
  if tn[Length(tn)] = '*' then
    Delete(tn, Length(tn), 1);
  try
    if (ATheme = nil) and (FileExists(DFrames.ThemesPath + tn)) then
    begin
      tn := DFrames.ThemesPath + tn;
      theme := ReadFileToString(tn);
      jsTheme := ParseJSON(PChar(theme));
    end;
    with jsTheme['Default'] do
    begin
      Editor.Color      := StringToColor(P['Background'].AsString);
      Editor.Font.Color := StringToColor(P['Foreground'].AsString);
      Editor.Font.Name  := P['Font Name'].AsString;
      Editor.Font.Size  := P['Font Size'].AsInteger;
      Editor.Font.Quality := ToFontQuality(P['Font Quality'].AsString);
      Editor.Font.Style := ToFontStyle(P['Font Style']);
    end;
    ApplyAttr('Comments', Highlighter.CommentAttri);
    ApplyAttr('Data Types', Highlighter.DataTypeAttri);
    ApplyAttr('Exceptions', Highlighter.ExceptionAttri);
    ApplyAttr('Functions', Highlighter.FunctionAttri);
    ApplyAttr('Identifiers', Highlighter.IdentifierAttri);
    ApplyAttr('Keywords', Highlighter.KeywordAttribute);
    ApplyStyle('Line Highlight', Editor.LineHighlightColor);
    ApplyAttr('Numbers', Highlighter.NumberAttri);
    ApplyStyle('Selection', Editor.SelectedColor);
    ApplyAttr('Strings', Highlighter.StringAttri);
    ApplyAttr('Symbols', Highlighter.SymbolAttri);
    ApplyAttr('Tables', Highlighter.TableNameAttri);
    ApplyAttr('Variables', Highlighter.VariableAttri);
    ApplyStyle('Line Number', Editor.Gutter.Parts[1].MarkupInfo);

    with jsTheme['Modified Line'] do
    begin
      TSynGutterChanges(Editor.Gutter.Parts[2]).ModifiedColor := StringToColor(P['Modified'].AsString);
      TSynGutterChanges(Editor.Gutter.Parts[2]).SavedColor    := StringToColor(P['Saved'].AsString);
    end;

    with jsTheme['Gutter'] do
    begin
      Editor.Gutter.Color                          := StringToColor(P['Background'].AsString);
      Editor.Gutter.Parts[3].MarkupInfo.Foreground := StringToColor(P['Foreground'].AsString);
    end;

    with jsTheme['Grid'] do
    begin
      with P['Title Font'] do
      begin
        Grid.Title_Font.Name := p['Name'].AsString;
        Grid.Title_Font.Size := p['Size'].AsInteger;
        Grid.Title_Font.Quality := ToFontQuality(p['Font Quality'].AsString);
        Grid.Title_Font.Color := StringToColor(p['Color'].AsString);
        Grid.Title_Font.Style := ToFontStyle(P['Font Style']);
      end;
      with P['Cell Font'] do
      begin
        Grid.CellFont.Name                 := p['Name'].AsString;
        Grid.CellFont.Size                 := p['Size'].AsInteger;

        Grid.CellFont.Quality := ToFontQuality(p['Font Quality'].AsString);
        Grid.CellFont.Color := StringToColor(p['Color'].AsString);
        Grid.CellFont.Style := ToFontStyle(P['Font Style']);
      end;
      Grid.Background  := StringToColor(P['Color'].AsString);
      Grid.OddRowColor := StringToColor(P['OddRow'].AsString);
      Grid.Title_Style := ToTitleStyle(P['Title Style'].AsString);
      Grid.Title_Background := StringToColor(P['Title Background'].AsString);
    end;

    with jsTheme['Log'] do
    begin
      with P['Font'] do
      begin
        Log.Font.Name                 := P['Name'].AsString;
        Log.Font.Size                 := P['Size'].AsInteger;
        Log.Font.Quality := ToFontQuality(P['Font Quality'].AsString);
        Log.Font.Style := ToFontStyle(P['Font Style']);
      end;
      Log.Background             := StringToColor(P['Background'].AsString);
      Log.Detail.Foreground      := StringToColor(P['Detail'].AsString);
      Log.Error.Foreground       := StringToColor(P['Error'].AsString);
      Log.Information.Foreground := StringToColor(P['Information'].AsString);
    end;
  finally
    //Loaded theme in DFrames
    //jsTheme.Free;
  end;
end;


class procedure TDFrmSettings.SaveTheme(Editor: TSynEdit; Highlighter: TSynSQLSyn; Log: TDLogStyle; Grid: TDGridStyle; AThemeName: String);
//const
  //FontQuality: array[TFontQuality] of String = ('Default','Draft','Proof','NonAntialiased','Antialiased','Cleartype','CleartypeNatural');
var
  jsTheme: TDJSON;
  tn: String;

  procedure AddAttr(AName: String; Attr: TSynHighlighterAttributes);
  begin
    with jsTheme[AName].InitAsObject do
    begin
      P['Background'].AsString := ColorToString(Attr.Background);
      P['Foreground'].AsString := ColorToString(Attr.Foreground);
      FromFontStyle(P['Font Style'].InitAsArray, Attr.Style);
      //with P['Font Style'].InitAsArray do
      //begin
      //  if fsBold in Attr.Style then
      //    I[-1].AsString := 'Bold';
      //  if fsItalic in Attr.Style then
      //    I[-1].AsString := 'Italic';
      //  if fsUnderline in Attr.Style then
      //    I[-1].AsString := 'Underline';
      //  if fsStrikeOut in Attr.Style then
      //    I[-1].AsString := 'StrikeOut';
      //end;
    end;
  end;

  procedure AddStyle(AName: String; Attr: TSynSelectedColor);
  begin
    with jsTheme[AName].InitAsObject do
    begin
      P['Background'].AsString := ColorToString(Attr.Background);
      P['Foreground'].AsString := ColorToString(Attr.Foreground);
      FromFontStyle(P['Font Style'].InitAsArray, Attr.Style);
      //with P['Font Style'].InitAsArray do
      //begin
      //  if fsBold in Attr.Style then
      //    I[-1].AsString := 'Bold';
      //  if fsItalic in Attr.Style then
      //    I[-1].AsString := 'Italic';
      //  if fsUnderline in Attr.Style then
      //    I[-1].AsString := 'Underline';
      //  if fsStrikeOut in Attr.Style then
      //    I[-1].AsString := 'StrikeOut';
      //end;
    end;
  end;

begin
  try
    jsTheme := TDJSON.CreateObject;
    tn := AThemeName;
    if tn[Length(tn)] = '*' then
      Delete(tn, Length(tn), 1);
    jsTheme['Theme Name'].AsString := tn;
    with jsTheme['Default'].InitAsObject do
    begin
      P['Background'].AsString := ColorToString(Editor.Color);
      P['Foreground'].AsString := ColorToString(Editor.Font.Color);
      P['Font Name'].AsString := Editor.Font.Name;
      P['Font Quality'].AsString := FromFontQuality[Editor.Font.Quality];
      P['Font Size'].AsInteger := Editor.Font.Size;
      FromFontStyle(P['Font Style'].InitAsArray, Editor.Font.Style);
      //with P['Font Style'].InitAsArray do
      //begin
      //  if fsBold in Editor.Font.Style then
      //    I[-1].AsString := 'Bold';
      //  if fsItalic in Editor.Font.Style then
      //    I[-1].AsString := 'Italic';
      //  if fsUnderline in Editor.Font.Style then
      //    I[-1].AsString := 'Underline';
      //  if fsStrikeOut in Editor.Font.Style then
      //    I[-1].AsString := 'StrikeOut';
      //end;
    end;
    AddAttr('Comments', Highlighter.CommentAttri);
    AddAttr('Data Types', Highlighter.DataTypeAttri);
    AddAttr('Exceptions', Highlighter.ExceptionAttri);
    AddAttr('Functions', Highlighter.FunctionAttri);
    AddAttr('Identifiers', Highlighter.IdentifierAttri);
    AddAttr('Keywords', Highlighter.KeywordAttribute);
    AddStyle('Line Highlight', Editor.LineHighlightColor);
    AddAttr('Numbers', Highlighter.NumberAttri);
    AddStyle('Selection', Editor.SelectedColor);
    AddAttr('Strings', Highlighter.StringAttri);
    AddAttr('Symbols', Highlighter.SymbolAttri);
    AddAttr('Tables', Highlighter.TableNameAttri);
    AddAttr('Variables', Highlighter.VariableAttri);
    AddStyle('Line Number', Editor.Gutter.Parts[1].MarkupInfo);

    with jsTheme['Modified Line'].InitAsObject do
    begin
      P['Modified'].AsString := ColorToString(TSynGutterChanges(Editor.Gutter.Parts[2]).ModifiedColor);
      P['Saved'].AsString := ColorToString(TSynGutterChanges(Editor.Gutter.Parts[2]).SavedColor);
    end;

    with jsTheme['Gutter'].InitAsObject do
    begin
      P['Background'].AsString := ColorToString(Editor.Gutter.Color);
      P['Foreground'].AsString := ColorToString(Editor.Gutter.Parts[3].MarkupInfo.Foreground);
    end;

    with jsTheme['Grid'].InitAsObject do
    begin
      with P['Title Font'].InitAsObject do
      begin
        p['Name'].AsString := Grid.Title_Font.Name;
        p['Size'].AsInteger := Grid.Title_Font.Size;
        p['Font Quality'].AsString := FromFontQuality[Grid.Title_Font.Quality];
        p['Color'].AsString := ColorToString(Grid.Title_Font.Color);
        FromFontStyle(P['Font Style'].InitAsArray, Grid.Title_Font.Style);
        //with P['Style'].InitAsArray do
        //begin
        //  if fsBold in Grid.Title_Font.Style then
        //    I[-1].AsString := 'Bold';
        //  if fsItalic in Grid.Title_Font.Style then
        //    I[-1].AsString := 'Italic';
        //  if fsUnderline in Grid.Title_Font.Style then
        //    I[-1].AsString := 'Underline';
        //  if fsStrikeOut in Grid.Title_Font.Style then
        //    I[-1].AsString := 'StrikeOut';
        //end;
      end;
      with P['Cell Font'].InitAsObject do
      begin
        p['Name'].AsString := Grid.CellFont.Name;
        p['Size'].AsInteger := Grid.CellFont.Size;
        p['Font Quality'].AsString := FromFontQuality[Grid.CellFont.Quality];
        p['Color'].AsString := ColorToString(Grid.CellFont.Color);
        FromFontStyle(P['Font Style'].InitAsArray, Grid.CellFont.Style);
        //with P['Style'].InitAsArray do
        //begin
        //  if fsBold in Grid.CellFont.Style then
        //    I[-1].AsString := 'Bold';
        //  if fsItalic in Grid.CellFont.Style then
        //    I[-1].AsString := 'Italic';
        //  if fsUnderline in Grid.CellFont.Style then
        //    I[-1].AsString := 'Underline';
        //  if fsStrikeOut in Grid.CellFont.Style then
        //    I[-1].AsString := 'StrikeOut';
        //end;
      end;
      P['Color'].AsString := ColorToString(Grid.Background);
      P['OddRow'].AsString := ColorToString(Grid.OddRowColor);
      P['Title Background'].AsString := ColorToString(Grid.Title_Background);
      P['Title Style'].AsString := FromTitleStyle[Grid.Title_Style];
    end;

    with jsTheme['Log'].InitAsObject do
    begin
      with P['Font'].InitAsObject do
      begin
        p['Name'].AsString := Log.Font.Name;
        p['Size'].AsInteger := Log.Font.Size;
        p['Font Quality'].AsString := FromFontQuality[Log.Font.Quality];
        FromFontStyle(P['Font Style'].InitAsArray, Log.Font.Style);
        //with P['Font Style'].InitAsArray do
        //begin
        //  if fsBold in Log.Font.Style then
        //    I[-1].AsString := 'Bold';
        //  if fsItalic in Log.Font.Style then
        //    I[-1].AsString := 'Italic';
        //  if fsUnderline in Log.Font.Style then
        //    I[-1].AsString := 'Underline';
        //  if fsStrikeOut in Log.Font.Style then
        //    I[-1].AsString := 'StrikeOut';
        //end;
      end;
      P['Background'].AsString := ColorToString(Log.Background);
      P['Detail'].AsString := ColorToString(Log.Detail.Foreground);
      P['Error'].AsString := ColorToString(Log.Error.Foreground);
      P['Information'].AsString := ColorToString(Log.Information.Foreground);
    end;
    WriteToFile(jsTheme.TO_JSONString(0, True), DFrames.ThemesPath + tn);
  finally
    jsTheme.Free;
  end;
end;

class procedure TDFrmSettings.LoadSettings(ConfigForm: TDFrmSettings);
var
  jSettings: TDJSON;
begin
  try
    jSettings := ParseJSON(PChar(ReadFileToString(DFrames.ConfigPath + 'Editor.conf')));
    with jSettings['General'], ConfigForm do
    begin
      DFrames.SetScriptDir(P['Scripts Dir'].AsString);
      if Assigned(ConfigForm) then
        deDefaultSavePath.Directory := DFrames.ScriptsDir;
    end;
    with jSettings['Editor'], ConfigForm do
    begin
      //DFrames.EditorTabSize := spTabSize.Value;
      //DFrames.EditorTabToSpace := chbTabToSpace.Checked;
      //DFrames.EditorAutoIndent := chbAutoIndent.Checked;
      //DFrames.EditorAutoComplete := chbAutoComplete.Checked;
      //DFrames.SQLReservesUpperCase := chbKeyWorsUpper.Checked;
      //DFrames.DFrameshowLineNumbers := chbShowLineNumber.Checked;
      //DFrames.DFrameshowLineNumbersEvery := spLineNumbers.Value;
      DFrames.EditorTabSize :=               P['Tab Size'].AsInteger;
      DFrames.EditorTabToSpace :=            P['Tab To Space'].AsBoolean;
      DFrames.EditorAutoIndent :=            P['Auto Indent'].AsBoolean;
      DFrames.EditorAutoComplete :=          P['Auto Completion'].AsBoolean;
      DFrames.SQLReservesUpperCase :=        P['Keywords Upper'].AsBoolean;
      DFrames.DFrameshowLineNumbers :=       P['Show Line Number'].AsBoolean;
      DFrames.DFrameshowLineNumbersEvery :=  P['Show Line Number Every'].AsInteger;

      DFrames.EditorThemeName := P['Theme'].AsString;
      DFrames.EditorTheme := ParseJSON(PChar(ReadFileToString(DFrames.ThemesPath + DFrames.EditorThemeName)));
      if Assigned(ConfigForm) then
      begin
        cbEditorTheme.Text        := DFrames.EditorThemeName;
        spTabSize.Value           := DFrames.EditorTabSize;
        chbTabToSpace.Checked     := DFrames.EditorTabToSpace;
        chbAutoIndent.Checked     := DFrames.EditorAutoIndent;
        chbAutoComplete.Checked   := DFrames.EditorAutoComplete;
        chbKeyWorsUpper.Checked   := DFrames.SQLReservesUpperCase;
        chbShowLineNumber.Checked := DFrames.DFrameshowLineNumbers;
        spLineNumbers.Value       := DFrames.DFrameshowLineNumbersEvery;
      end;
    end;
    DFrames.ReloadHistories;
  finally
    FreeAndNil(jSettings);
  end;
end;

class procedure TDFrmSettings.SaveSettings();
var
  jSettings: TDJSON;
  js: String;
begin
  try
    jSettings := TDJSON.CreateObject;
    with jSettings['General'].InitAsObject, DFrmSettings do
    begin
      P['Scripts Dir'].AsString := deDefaultSavePath.Directory;
    end;
    with jSettings['Editor'].InitAsObject, DFrmSettings do
    begin
      P['Theme'].AsString := cbEditorTheme.Text;
      P['Tab Size'].AsInteger := spTabSize.Value;
      P['Tab To Space'].AsBoolean := chbTabToSpace.Checked;
      P['Auto Indent'].AsBoolean := chbAutoIndent.Checked;
      P['Auto Completion'].AsBoolean := chbAutoComplete.Checked;
      P['Keywords Upper'].AsBoolean := chbKeyWorsUpper.Checked;
      P['Show Line Number'].AsBoolean := chbShowLineNumber.Checked;
      P['Show Line Number Every'].AsInteger := spLineNumbers.Value;

      DFrames.SQLReservesUpperCase := chbKeyWorsUpper.Checked;
      DFrames.EditorAutoIndent := chbAutoIndent.Checked;
      DFrames.EditorAutoComplete := chbAutoComplete.Checked;
      DFrames.EditorTabSize := spTabSize.Value;
      DFrames.EditorTabToSpace := chbTabToSpace.Checked;
      DFrames.DFrameshowLineNumbers := chbShowLineNumber.Checked;
      DFrames.DFrameshowLineNumbersEvery := spLineNumbers.Value;
      DFrames.EditorThemeName := cbEditorTheme.Text;
      DFrames.EditorTheme := ParseJSON(PChar(ReadFileToString(DFrames.ThemesPath + DFrames.EditorThemeName)));
    end;
    js := jSettings.TO_JSONString(0, True);
    WriteToFile(js, DFrames.ConfigPath + 'Editor.conf');
  finally
    FreeAndNil(jSettings);
  end;
end;

class procedure TDFrmSettings.SaveDefaultSettings;
begin
  WriteToFile(C_Theme_Default_Dark, DFrames.ThemesPath + 'DSql Dark');
  WriteToFile(C_Theme_Default_Light, DFrames.ThemesPath + 'DSql Light');
  WriteToFile(C_DFrames_Default, DFrames.ConfigPath + 'Editor.conf');
  WriteToFile(C_DSql_Default, DFrames.ConfigPath + 'DSql.conf');
  //DFrames.EditorTheme := ParseJSON(ReadFileToString());
end;

end.

