unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.ShellAPI, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Winapi.WinInet,
  Vcl.StdCtrls;

type
  TMain_Form = class(TForm)
    Image_Logo: TImage;
    Memo_Status: TMemo;
    procedure FormActivate(Sender: TObject);
    function RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID: PDWORD): Longword;
    function TerminateProcessByID(ProcessID: Cardinal): Boolean;
    function CheckUrl(Url: string): boolean;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  WM_ICONTRAY = WM_USER + 1;

var
  Main_Form: TMain_Form;
  NotifyIconData: TNotifyIconData;

implementation

{$R *.dfm}

function TMain_Form.CheckUrl(Url: string): boolean;
var
  hSession, hfile, hRequest: hInternet;
  dwindex, dwcodelen: dword;
  dwcode: array[1..20] of char;
  res: pchar;
begin
  if pos('http://', lowercase(Url)) = 0 then
    Url := 'http://' + Url;
  Result := false;
  hSession := InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if assigned(hSession) then
  begin
    hfile := InternetOpenUrl(hSession, pchar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);
    dwindex := 0;
    dwcodelen := 10;
    HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE, @dwcode, dwcodelen, dwindex);
    res := pchar(@dwcode);
    result := (res = '200') or (res = '302');
    if assigned(hfile) then
      InternetCloseHandle(hfile);
    InternetCloseHandle(hSession);
  end;

end;

procedure TMain_Form.FormActivate(Sender: TObject);
var
  serverID, appID: Cardinal;
begin
  serverID := 0;
  appID := 0;
  Memo_Status.Lines.Add('Server çalıştırılıyor...');
  RunProcess('server.exe', SW_HIDE, False, @serverID);
  while not CheckUrl('127.0.0.1:8000') do
  begin
    Application.ProcessMessages;
  end;

  Memo_Status.Lines.Add('Uygulama açılıyor...');
  RunProcess('JeFlow-win32-x64\JeFlow.exe', SW_SHOW, True, @appID);
  TerminateProcessByID(serverID);
  Application.Terminate;
end;

procedure TMain_Form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Shell_NotifyIcon(NIM_DELETE, @NotifyIconData)
end;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  Memo_Status.Lines.Clear;
  Image_Logo.Picture.LoadFromFile('img\logo.png');
  with NotifyIconData do
  begin
    hIcon := Icon.Handle;
    StrPCopy(szTip, Application.Title);
    Wnd := Handle;
    uCallbackMessage := WM_ICONTRAY;
    uID := 1;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    cbSize := System.SizeOf(TNotifyIconData);
  end;
  Shell_NotifyIcon(NIM_ADD, @NotifyIconData);
end;

function TMain_Form.RunProcess(FileName: string; ShowCmd: DWORD; wait: Boolean; ProcID: PDWORD): Longword;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
  StartupInfo.wShowWindow := ShowCmd;
  if not CreateProcess(nil, @FileName[1], nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
    Result := WAIT_FAILED
  else
  begin
    if wait = FALSE then
    begin
      if ProcID <> nil then
        ProcID^ := ProcessInfo.dwProcessId;
      result := WAIT_FAILED;
      exit;
    end;
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
  end;
  if ProcessInfo.hProcess <> 0 then
    CloseHandle(ProcessInfo.hProcess);
  if ProcessInfo.hThread <> 0 then
    CloseHandle(ProcessInfo.hThread);
end;

function TMain_Form.TerminateProcessByID(ProcessID: Cardinal): Boolean;
var
  hProcess: THandle;
begin
  Result := False;
  hProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessID);
  if hProcess > 0 then
  try
    Result := Win32Check(TerminateProcess(hProcess, 0));
  finally
    CloseHandle(hProcess);
  end;
end;

end.

