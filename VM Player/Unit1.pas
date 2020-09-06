unit Unit1;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,bass,Vcl.ExtCtrls,WinInet,ExtActns,
  Vcl.StdCtrls,URLMon,IdBaseComponent, IdComponent, IdTCPConnection,WinHttp_TLB,
  IdTCPClient, IdHTTP, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdURI,
  Vcl.Samples.Spin, Vcl.CheckLst, Vcl.ComCtrls,System.StrUtils,Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage,TlHelp32,Vcl.Styles.ColorTabs,Vcl.Themes,ShellAPI, ID3v2Library,ClipBrd, httpapp, Security;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button8: TButton;
    Button9: TButton;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer4: TTimer;
    Button6: TButton;
    Edit2: TEdit;
    Button7: TButton;
    Button10: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Image9: TImage;
    Edit8: TEdit;
    Label9: TLabel;
    Button14: TButton;
    Button16: TButton;
    Edit9: TEdit;
    Button17: TButton;
    Button18: TButton;
    Edit10: TEdit;
    Button11: TButton;
    Button12: TButton;
    IdHTTP1: TIdHTTP;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox5: TListBox;
    Edit1: TEdit;
    CheckListBox1: TCheckListBox;
    TrackBar2: TTrackBar;
    Panel1: TPanel;
    Image1: TImage;
    TrackBar1: TTrackBar;
    가사: TMemo;
    ProgressBar1: TProgressBar;
    ListView1: TListView;
    Edit6: TEdit;
    Label5: TLabel;
    Label10: TLabel;
    Edit7: TEdit;
    Timer8: TTimer;
    Edit11: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ListView1Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Timer8Timer(Sender: TObject);
  private
  procedure 재생(Item: integer);
  procedure SteramingMP3(Item : integer);
    { Private declarations }
  public
    { Public declarations }
      procedure URL_OnDownloadProgress(Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean);
         function LoadAPIC(Index: Integer): Boolean;
  end;

var
  Form1: TForm1;
  stream: HSTREAM;
  ListIndex : Integer;
  base, list, down , ID , IDv: string;
  AdjustingPlaybackPosition: Boolean;
  A: TStringList;
  B: TStringList;
  C: TStringList;
  C1: DWORD;
  ID3v2Tag: TID3v2Tag = nil;
  CurrentAPICIndex: Integer = - 1;

implementation

{$R *.dfm}
function TForm1.LoadAPIC(Index: Integer): Boolean;
var
    PictureType: Integer;
    PictureStream: TStream;
    JPEGPicture: TJPEGImage;
    PNGPicture: TPNGImage;
    Success: Boolean;
    MIMEType: String;
    Description: String;
    i: Integer;
begin
    Result := False;
    try
        PictureStream := TMemoryStream.Create;
        try
            if Index = 0 then begin
                Index := ID3v2Tag.FrameExists('APIC');
            end;
            if Index < 0 then begin
                Exit;
            end;

            Success := ID3v2Tag.GetUnicodeCoverPictureStream(Index, PictureStream, MIMEType, Description, PictureType);

            if (PictureStream.Size = 0)
            OR (NOT Success)
            then begin
                Exit;
            end;


            if Index = 0 then begin
                for i := 0 to ID3v2Tag.FrameCount - 1 do begin
                    if IsSameFrameID(ID3v2Tag.Frames[i].ID, 'APIC') then begin
                        CurrentAPICIndex := i;
                        Break;
                    end;
                end;

            end else begin
                CurrentAPICIndex := Index;
            end;
            PictureStream.Seek(0, soFromBeginning);
            MIMEType := LowerCase(MIMEType);

            if (MIMEType = 'image/jpeg')
            OR (MIMEType = 'image/jpg')
            then begin
                JPEGPicture := TJPEGImage.Create;
                JPEGPicture.LoadFromStream(PictureStream);
                JPEGPicture.DIBNeeded;
                Image1.Picture.Assign(JPEGPicture);
                JPEGPicture.Free;
            end;

            if MIMEType = 'image/png' then begin
                PNGPicture := TPNGImage.Create;
                PNGPicture.LoadFromStream(PictureStream);
                Image1.Picture.Assign(PNGPicture);
                PNGPicture.Free;
            end;
            if MIMEType = 'image/bmp' then begin
                PictureStream.Seek(0, soFromBeginning);
                Image1.Picture.Bitmap.LoadFromStream(PictureStream);
            end;

            Result := True;
        finally
            PictureStream.Free;
        end;
    except
    end;
end;

procedure TForm1.URL_OnDownloadProgress(Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText:String; var Cancel: Boolean);
begin
  ProgressBar1.Max:= ProgressMax;
  ProgressBar1.Position:= Progress;

 label9.Caption:=(Format('%d/%d', [
                                        Progress,
                                        ProgressMax]));
Application.ProcessMessages;
end;



function BASS_StreamCreateURL(url: PAnsiChar; offset: DWORD; flags: DWORD; proc: DOWNLOADPROC; user: Pointer):HSTREAM; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF}; external bassdll;

 function Split(Main, First, Second: String): TStringList;
var
  sTmp: String;
  sData: TStringList;
begin
  sData := TStringList.Create;
  sTmp := Main;
  while Pos(First, sTmp) > 0 do begin
    sTmp := Copy(sTmp, Pos(First,sTmp) + Length(First), Length(sTmp));
    sData.Add(Copy(sTmp, 1, Pos(Second,sTmp)-1));
  end;
  Result := sData;
end;

Function Parsing(Const MainString,First,Second : String):String;
var
stmp: String;
begin
stmp := MainString;
stmp := Copy(stmp,POS(First,stmp) + length(First),length(stmp));
result := Copy(stmp,1,POS(Second,stmp)-1);
end;



procedure TForm1.FormCreate(Sender: TObject);
var MBI: Memory_Basic_Information;
begin
ID3v2Tag := TID3v2Tag.Create;
 if not BASS_Init(-1, 44100, 0, handle, nil) then
  begin
    MessageBox(0, '디바이스를 찾지못하였습니다. bass.dll 을 같이 놔주세요.', 0, 0);
    Halt;
  end;
end;

procedure TForm1.Image10Click(Sender: TObject);
begin
Button7.Click;
가사.Visible := false;
listbox3.Visible := True;
end;

procedure TForm1.Image11Click(Sender: TObject);
begin
Button8.Click;
end;

procedure TForm1.Image12Click(Sender: TObject);
begin
Checklistbox1.Visible := false;
가사.Visible := false;
listview1.Visible := true;
Button12.Click;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
try
Checklistbox1.Visible := false;
가사.Visible := false;
listview1.Visible := true;
Button9.Click;
except
end;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
button6.Click;
end;

procedure TForm1.Image4Click(Sender: TObject);
var
LanguageID : TLanguageID;
Description : String;
Error,i : integer;
begin
  try
   form1.ListView1.ItemIndex := form1.ListView1.ItemIndex + 1;
    SteramingMp3(listview1.ItemIndex);
  except
  end;
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
  try
    if ListView1.ItemIndex < ListView1.Items.Count - 1 then
    ListView1.ItemIndex := ListView1.ItemIndex - 1;
    if ListView1.Visible = True then
      SteramingMp3(listview1.ItemIndex)
     else
      Button4.Click;
  finally
  end;
end;

procedure TForm1.Image6Click(Sender: TObject);
var
i : integer;
begin
try
if edit6.Text = 'pause' then
button14.Click;
    if ListView1.ItemIndex < ListView1.Items.Count - 1 then
    if ListView1.Visible = True then
    SteramingMp3(listview1.ItemIndex);
    if ListView1.Visible = False then
    Button2.Click;
  finally
  end;
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
Button5.Click;
if MessageDlg('이어서 재생하시겠습니까?', mtInformation, [mbYes, mbNo], 0) <> mrNo
     then form1.button14.Click;
end;

procedure TForm1.Image8Click(Sender: TObject);
begin
listview1.Clear;
가사.Visible := true;
Button1.Click;
Checklistbox1.Visible := true;
listview1.Visible := false;
end;

procedure TForm1.Image9Click(Sender: TObject);
begin
Button10.Click;
end;

procedure TForm1.ListView1Click(Sender: TObject);
var
i : integer;
ListItem : TListItem;
begin
try
i := Listview1.Selected.Index;
Edit2.Text := Listview1.Items.Item[i].SubItems.Strings[1];

Edit11.Text := IntToStr(Listview1.Selected.Index);
except
end;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
begin
try
 BASS_ChannelSetAttribute(Stream, BASS_ATTRIB_VOL, Form1.TrackBar1.Position  / 100);
steramingMP3(ListView1.ItemIndex);
  except
end;
end;


procedure ListBox출력(List:TListBox; GetBase, Str1, Str2, Str3, Str4 : String);
var
i : integer;
trim : string;
begin
i := 0;
List.Clear;
while (i <> 1) do begin
List.Items.Add(Parsing(GetBase, Str1, Str2));
GetBase := Parsing(GetBase, Str3, Str4) + Str4;
trim := List.Items.Strings[List.Count-1];

if trim = '' then begin
List.Items.Delete(List.Count-1);
i := 1;
end;
end;
end;

procedure Genie;
var
s : String;
base, list, down,GET,view: string;
ID,D,E : Tstringlist;
I : integer;
begin
try
form1.listview1.Clear;
s := UTF8Encode(Form1.Edit1.Text);
s := HTTPEncode(Form1.Edit1.Text);
Form1.IdHTTP1.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko';
base := Form1.IdHTTP1.Get('http://xn--2o2b15q.kr/music/index.php?SONG_NAME=' + s);
list := Parsing(base, '﻿<tr><td align="center">1</td><td align="center"><img src="', '</tbody>') + '';
down := list;
ID:= Split(list, '"></td><td align="left"><strong>', '</strong> - <a href="#"');
for I := 0 to ID.Count-1 do

E := Split(list, '<span class="t_point">', '</td><td align="center">');
for I := 0 to E.Count-1 do

D:= Split(list, 'download.php?id=', ''');');
for I := 0 to D.Count-1 do

with Form1.ListView1.Items.Add do
begin
Caption := (ID [I]);
SubItems.Add(E [I]);
SubItems.Add(D [I]);
end;
except

end;
end;

procedure TForm1.재생(Item: integer);
var
url : Ansichar;
begin
  BASS_StreamFree(Stream);
  stream := BASS_StreamCreateFile(False, PChar(Checklistbox1.Items.Strings[item]), 0, 0,BASS_SAMPLE_FX{$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  TrackBar2.Max := BASS_ChannelGetLength(Stream, BASS_POS_BYTE);
  if not (stream = 0) then
  BASS_ChannelPlay(Stream, False);
end;

procedure TForm1.SteramingMP3(Item : integer);   // 스트리밍 MP3
var SteramURI : Ansistring;
begin
try
  Button11.Click;
  Button18.Click;
  Button16.Click;
  BASS_ChannelSetAttribute(Stream, BASS_ATTRIB_VOL, Form1.TrackBar1.Position  / 100);
  BASS_StreamFree(Stream);
  SteramURI := ( form1.Edit4.Text);
  form1. Edit3.Text :=  form1.Listview1.Selected.Caption;
   form1.Edit8.Text :=  form1.Listview1.Items.Item[item].SubItems.Strings[0];
   form1.Label4.Caption := ( form1.Listview1.Selected.Caption);
  stream := BASS_StreamCreateUrl(PAnsiChar(SteramURI), 0,0, nil, 0 );
  Form1.TrackBar2.Max := BASS_ChannelGetLength(Stream, BASS_POS_BYTE);
  if not (stream = 0) then
  BASS_ChannelPlay(Stream, False);
except
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
i : integer;
begin
BASS_Channelplay(stream,false);
재생(Checklistbox1.ItemIndex);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
Checklistbox1.ItemIndex := Checklistbox1.ItemIndex +1 ;
재생(Checklistbox1.ItemIndex);

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Checklistbox1.ItemIndex := Checklistbox1.ItemIndex -1 ;
재생(Checklistbox1.ItemIndex);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
BASS_Channelpause(stream);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
hr: HRESULT;
UrlFile, SaveFile,Path: String;
Url : AnsiChar;
A : String;
I : integer;
begin
Path := extractFilePath(Application.exeName)+'ViewMatrixMusic\';
if not DirectoryExists(Path) then
ForceDirectories( Path );
DeleteUrlcacheEntry(PWideChar(Edit4.Text));
with TDownloadURL.Create(self) do
try
URL := (Edit4.Text);
FileName := ExtractFilePath(Application.ExeName)+'ViewMatrixMusic\' + (Edit3.Text) + (' - ') + (Edit8.Text) + ('.mp3');       //파일저장경로
OnDownloadProgress := URL_OnDownloadProgress;
ExecuteTarget(nil) ;
ShellExecute(Handle, 'open', PWideChar(Path), nil, nil, SW_SHOWNORMAL);
finally
end;
end;


procedure TForm1.Button7Click(Sender: TObject);    // 가사
var
I : integer;
IDv : TStringList;
Get,s,SplitString: String;
begin
Form1.Listbox3.Clear;

Get := Form1.IdHTTP1.Get( TIdURI.URLEncode('http://xn--2o2b15q.kr/music/lyrics.php?id=' + (Edit2.Text)));
list := Parsing(Get, '<html lang="ko">', '</body>') + '';   //전체 사이트 소스 가져옴
down := list;
//SplitString := StringReplace(StringReplace(down, '<br>', '  ', [rfReplaceAll]), '<br><br>', '  ', [rfReplaceAll]);
//showmessage(SplitString);

Form1.ListBox3.Items.ADD(down [I]);
ListBox출력(Form1.ListBox3, down,'	<div style="text-align:center">','<br>','',''); //맨앞 짤리는거 출력
IDv := Split(down,'<br>', '<br>');     //가사 다중출력
for I := 0 to IDv.Count-1 do
Form1.ListBox3.Items.ADD(IDv [I]);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
listview1.Clear;
ChecklistBox1.Items.Clear();
end;

procedure TForm1.Button9Click(Sender: TObject);   //검색
begin
genie;
end;


procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
Button9.Click;
end;

procedure TForm1.Timer1Timer(Sender: TObject);  // 노래 하나 끝나면 다음재생
var
i : integer;
begin

// Mp3 가 끝날시 2초 뒤 다음 음악 재생
//재생( form1.Checklistbox1.ItemIndex +1);
//form1.Checklistbox1.ItemIndex :=  form1.Checklistbox1.ItemIndex;
try       // 오류 메시지 무시
if (BASS_GetCPU < 0.00001) and  ( form1.label1.Caption =  form1.Label2.Caption) then
SteramingMP3(form1.ListView1.ItemIndex + 1);
Timer1.Enabled := false;
except
end;
end;



procedure TForm1.Timer2Timer(Sender: TObject);     // 노래 시간 트랙바
var
    Level: Cardinal;
begin
    Level := BASS_ChannelGetLevel(Stream);
    if BASS_ChannelIsActive(Stream) = BASS_ACTIVE_PLAYING then begin
    AdjustingPlaybackPosition := True;
    Form1.TrackBar2.Position := BASS_ChannelGetPosition(Stream, BASS_POS_BYTE);
    AdjustingPlaybackPosition := False;
    end;
end;


procedure TForm1.Timer4Timer(Sender: TObject);     // 노래 시간 표시
var
TrackLen: Double;
TrackPos: Double;
ValPos: Double;
ValLen: Double;
begin
  TrackPos:= BASS_ChannelBytes2Seconds(stream,BASS_ChannelGetPosition(stream, 0));
  trackLen:=BASS_ChannelBytes2Seconds(stream,BASS_ChannelGetLength(stream, 0));
  ValPos:=TrackPos / (24 * 3600);
  ValLen:=TrackLen / (24 * 3600);
  form1.Label1.Caption:= FormatDateTime('hh:mm:ss',ValPos);
  form1.label2.Caption:= FormatDateTime('hh:mm:ss',ValLen);
  if (ListView1.Items.Count-1 > -1) and  (form1.label1.Caption = form1.Label2.Caption) then
  begin
  //form1.ListView1.ItemIndex := form1.ListView1.ItemIndex +1;
  //SteramingMP3( form1.ListView1.ItemIndex+1);
  end;

end;


procedure TForm1.Timer8Timer(Sender: TObject);
begin
// 순차 재생 2018 7 5
 if (BASS_GetCPU < 0.00001) and ( form1.label1.Caption =  form1.Label2.Caption) then   // >
begin

end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);     // 볼륨
var
a : integer;
begin
  BASS_ChannelSetAttribute(Stream, BASS_ATTRIB_VOL, Form1.TrackBar1.Position  / 100);
  a:= Form1.TrackBar1.Position;
  Label5.caption := IntToStr(a);
end;

procedure TForm1.TrackBar2Change(Sender: TObject);               //노래 바 변경
begin
    if NOT AdjustingPlaybackPosition then begin
        BASS_ChannelSetPosition(Stream, Form1.TrackBar2.Position, BASS_POS_BYTE);
    end;
end;


procedure TForm1.Button10Click(Sender: TObject);      // 노래 스트리밍 듣기
var SteramURI : Ansistring;
begin
  BASS_StreamFree(Stream);
  SteramURI := (Edit4.Text);
  stream := BASS_StreamCreateUrl(PAnsiChar(SteramURI), 0,0, nil, 0 );
  Form1.TrackBar2.Max := BASS_ChannelGetLength(Stream, BASS_POS_BYTE);
  if not (stream = 0) then
  BASS_ChannelPlay(Stream, False);
end;

function DS(const S: String): String;
var i: Integer;
    Key: Word;
begin
  Key:= 1234;
  Result:= S;
  for i:= 1 to Length(S) do
  begin
   Result[i]:= Char(Byte(S[i]) xor (Key shr 8));
   Key:= (Byte(S[i]) + $A) * $B;
  end;
end;


procedure TForm1.Button11Click(Sender: TObject);
var
base, list, down,GET,view: string;
ID,D,E : Tstringlist;
I : integer;
begin
GET := Form1.IdHTTP1.Get( TIdURI.URLEncode('http://xn--2o2b15q.kr/music/stream.php?id=' + (Edit2.Text)));
view := Parsing(GET, '<html>', '</html>') + '';   //전체 사이트 소스 가져옴
down := view;

E:= Split(view, '<audio src="', '" type="audio/mp3"');     //URL
for I := 0 to E.Count-1 do
Edit4.Text := (E [I]);
end;

procedure TForm1.Button12Click(Sender: TObject);
var
base, list, down,GET,view: string;
ID,D,E, singer, Album : Tstringlist;
I : integer;
begin
listview1.Clear;
Form1.IdHTTP1.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko';
base := Form1.IdHTTP1.Get( TIdURI.URLEncode('http://xn--2o2b15q.kr/music/'));
list := Parsing(base, '<html>', '</html>') + '';   //전체 사이트 소스 가져옴
down := list;
ID:= Split(list, '><strong>', '</strong> -');   //제목
for I := 0 to ID.Count-1 do

D:= Split(list, 'stream.php?id=', ''',');     //아이디
for I := 0 to D.Count-1 do

Singer:=  Split(list, '</a></td><td align="center">', '</td><td align="center">');     //아이디
for I := 0 to singer.Count-1 do

with Form1.ListView1.Items.Add do
begin
Caption := (ID [I]);  // 순위
SubItems.Add(singer [I]);   // 가수
SubItems.Add(D [I]);   // id
end;
end;

procedure TForm1.Button13Click(Sender: TObject);
var
base, list, down,GET,view: string;
ID,D,E : Tstringlist;
I : integer;
begin
listview1.Clear;
Form1.IdHTTP1.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)';
base := Form1.IdHTTP1.Get( TIdURI.URLEncode('http://xn--2o2b15q.kr/music/'));
list := Parsing(base, '<html>', '</html>') + '';   //전체 사이트 소스 가져옴
down := list;

ID:= Split(list, 'left"><strong>', '</strong> -');   //제목
for I := 0 to ID.Count-1 do

D:= Split(list, 'stream.php?id=', ',');     //아이디
for I := 0 to D.Count-1 do

with Form1.ListView1.Items.Add do
begin
Caption := (ID [I]);
SubItems.Add(D [I]);
end;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
BASS_ChannelPlay(Stream, False);
end;

procedure TForm1.Button16Click(Sender: TObject);
var
Stream: TMemoryStream;
JPEGImage: TJPEGImage;
imgstr : string;
imgStr2 : string;
pImage: TImage;
begin
    imgStr := Edit7.Text;
    Stream := TMemoryStream.Create;
    IdHttp1.Get(imgStr, Stream);
    JPEGImage := TJPEGImage.Create;
    Stream.Position := 0;
    JPEGImage.LoadFromStream(Stream);
    Image1.Picture.Assign(JPEGImage);
    JPEGImage.Free;
    Stream.Free;
  end;

procedure TForm1.Button18Click(Sender: TObject);
var
base, list, down,GET,view: string;
ID,D,E : Tstringlist;
I : integer;
begin
GET := Form1.IdHTTP1.Get( TIdURI.URLEncode('http://xn--2o2b15q.kr/music/stream.php?id=' + (Edit2.Text)));
view := Parsing(GET, '<html>', '</html>') + '';   //전체 사이트 소스 가져옴
down := view;

E:= Split(view, '<img src="', '" style="');     //URL
for I := 0 to E.Count-1 do
Edit7.Text := 'http:' + (E [I]);
end;

procedure TForm1.Button1Click(Sender: TObject);     //다중선택  2017 10 25
var
i: integer;
Error: Integer;
LanguageID: TLanguageID;
Description: String;
 begin
 if not OpenDialog1.Execute then
 Exit;
 for i := 0 to OpenDialog1.Files.Count - 1 do
   CheckListBox1.Items.Add(ExtractFileName(OpenDialog1.FileName + OpenDialog1.Files[i]));
  Edit10.Text := OpenDialog1.FileName;
  Error := ID3v2Tag.LoadFromFile(Edit10.Text);

    if Error <> ID3V2LIBRARY_SUCCESS then begin
        MessageDlg('Error loading ID3v2 tag, error code: ' + IntToStr(Error) + #13#10 + ID3v2TagErrorCode2String(Error), mtError, [mbOk], 0);
    end;
가사.Text := ID3v2Tag.GetUnicodeLyrics('USLT', LanguageID, Description);
LoadAPIC(0);
end;

initialization
TCustomStyleEngine.RegisterStyleHook(TCustomTabControl, TTabColorControlStyleHook);
TCustomStyleEngine.RegisterStyleHook(TTabControl, TTabColorControlStyleHook);
end.

