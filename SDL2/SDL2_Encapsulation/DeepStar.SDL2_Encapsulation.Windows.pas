﻿unit DeepStar.SDL2_Encapsulation.Windows;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}
{$ModeSwitch advancedrecords}
{$ModeSwitch implicitfunctionspecialization}
{$ModeSwitch anonymousfunctions}
{$ModeSwitch functionreferences}
{$ModeSwitch duplicatelocals}

interface

uses
  Classes,
  SysUtils,
  libSDL2,
  libSDL2_image,
  libSDL2_ttf,
  DeepStar.Utils,
  DeepStar.SDL2_Encapsulation.Texture;

type
  TMessageBoxType = type int32;

const
  MESSAGEBOX_ERROR = libSDL2.SDL_MESSAGEBOX_ERROR;
  MESSAGEBOX_WARNING = libSDL2.SDL_MESSAGEBOX_WARNING;
  MESSAGEBOX_INFORMATION = libSDL2.SDL_MESSAGEBOX_INFORMATION;

  SDL_COLOR_WHITE: TSDL_Color = (r: $FF; g: $FF; b: $FF; a: $FF);

type
  TWindow = class(TInterfacedObject)
  private
    _Context: TSDL_GLContext;

    //Window data
    _Window: PSDL_Window;
    _Renderer: PSDL_Renderer;
    _WindowID: uint32;

    //Window dimensions
    _Width: int32;
    _Height: int32;
    _Caption: string;

    function __CreateRenderer: PSDL_Renderer;
    function __CreateWindow(caption: string; winPosX, winPosY, Width, Height: int32;
      flags: uint32): PSDL_Window;
    function __GetCaption: string;
    function __GetClientBounds: TRect;
    function __GetHeight: int32;
    function __GetRenderer: PSDL_Renderer;
    function __GetWidth: int32;

    procedure __SDL_Init;
    procedure __IMG_Init;
    procedure __TTF_Init;
    procedure __SetHint;
    procedure __SetCaption(const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

    function ShowMessageBox(flag: TMessageBoxType; title, message: string): int32;
    // 获取鼠标相对窗口的坐标
    function GetMousePos: TPoint;

    // 返回PSDL_Window
    function ToPSDL_Window: PSDL_Window;

    procedure Init(caption: string; width, height: uint32);
    procedure Init(caption: string; winPosX, winPosY, width, height: int32; flags: uint32);
    procedure InitWithOpenGL(caption: string; width, height: uint32);

    procedure Display;

    procedure SetRenderDrawColorAndClear(color: PSDL_Color = nil);

    property Renderer: PSDL_Renderer read __GetRenderer;
    property Width: int32 read __GetWidth;
    property Height: int32 read __GetHeight;
    property caption: string read __GetCaption write __SetCaption;
    property ClientBounds: TRect read __GetClientBounds;
  end;

implementation

uses
  DeepStar.SDL2_Encapsulation.Utils;

  { TWindow }

constructor TWindow.Create;
begin
  inherited Create;

  _Window := PSDL_Window(nil);
  _Renderer := PSDL_Renderer(nil);
  _WindowID := 0;
  _Width := 0;
  _Height := 0;
end;

destructor TWindow.Destroy;
begin
  if _Renderer <> nil then
  begin
    SDL_DestroyRenderer(_Renderer);
    _Renderer := nil;
  end;

  if _Window <> nil then
  begin
    SDL_DestroyWindow(_Window);
    _Window := nil;
  end;

  TTF_Quit;
  IMG_Quit;
  SDL_Quit;

  inherited Destroy;
end;

procedure TWindow.Display;
begin
  SDL_RenderPresent(_Renderer);
end;

function TWindow.GetMousePos: TPoint;
var
  x, y: integer;
begin
  x := 0;
  y := 0;
  SDL_GetMouseState(@x, @y);

  Result := Point(x, y);
end;

procedure TWindow.Init(caption: string; winPosX, winPosY, width, height: int32; flags: uint32);
begin
  __SDL_Init;
  __SetHint;
  __IMG_Init;
  __TTF_Init;

  _Caption := caption;

  _Window := __CreateWindow(caption, winPosX, winPosY, width, height, flags);
  _Width := width;
  _Height := height;

  _Renderer := __CreateRenderer;
end;

procedure TWindow.Init(caption: string; width, height: uint32);
begin
  Self.Init(
    caption,
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    width,
    height,
    SDL_WINDOW_SHOWN);
end;

procedure TWindow.InitWithOpenGL(caption: string; width, height: uint32);
begin
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

  Self.Init(
    caption,
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    width,
    height,
    SDL_WINDOW_RESIZABLE or SDL_WINDOW_OPENGL);

  _Context := SDL_GL_CreateContext(_Window);
end;

procedure TWindow.SetRenderDrawColorAndClear(color: PSDL_Color);
var
  temp: TSDL_Color;
begin
  temp := TSDL_Color(TAlphaColors.White);
  if color <> nil then
  begin
    temp.a := color^.a;
    temp.r := color^.r;
    temp.g := color^.g;
    temp.b := color^.b;
  end;

  SDL_SetRenderDrawColor(_Renderer, temp.r, temp.g, temp.b, temp.a);
  SDL_RenderClear(_Renderer);
end;

function TWindow.ShowMessageBox(flag: TMessageBoxType; title, message: string): int32;
  function __SDL_MessageBoxColor__(r, g, b: uint8): TSDL_MessageBoxColor;
  var
    res: TSDL_MessageBoxColor;
  begin
    res := Default(TSDL_MessageBoxColor);

    res.r := r;
    res.b := b;
    res.g := g;

    Result := res;
  end;

var
  mbd: TSDL_MessageBoxData;
  mbts: array of TSDL_MessageBoxButtonData;
  i, buttonID, res: integer;
  // colorScheme: TSDL_MessageBoxColorScheme;
begin
  mbd := Default(TSDL_MessageBoxData);

  SetLength(mbts, 2);
  for i := 0 to High(mbts) do
    mbts[i] := Default(TSDL_MessageBoxButtonData);

  //// [SDL_MESSAGEBOX_COLOR_BACKGROUND] */
  //colorScheme.colors[0] := __SDL_MessageBoxColor__(200, 200, 200);
  //// [SDL_MESSAGEBOX_COLOR_TEXT] */
  //colorScheme.colors[0] := __SDL_MessageBoxColor__(0, 0, 0);
  //// [SDL_MESSAGEBOX_COLOR_BUTTON_BORDER] */
  //colorScheme.colors[0] := __SDL_MessageBoxColor__(255, 255, 255);
  //// [SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND] */
  //colorScheme.colors[0] := __SDL_MessageBoxColor__(150, 150, 150);
  //// [SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED] */
  //colorScheme.colors[0] := __SDL_MessageBoxColor__(255, 255, 255);

  //////////////////////////////////

  with mbts[0] do
  begin
    flags := SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT;
    buttonid := 2; {**< User defined button id (value returned via SDL_ShowMessageBox) *}
    Text := PAnsiChar('否(Esc)');
  end;

  with mbts[1] do
  begin
    flags := SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT;
    buttonid := 1; {**< User defined button id (value returned via SDL_ShowMessageBox) *}
    Text := '是(Enter)';
  end;

  mbd.flags := flag;
  mbd.title := title.ToPAnsiChar;
  mbd._message := message.ToPAnsiChar;
  mbd.window := Self.ToPSDL_Window;
  mbd.numbuttons := 2;
  mbd.Buttons := @mbts[0];
  mbd.colorScheme := nil;//@colorScheme;

  if SDL_ShowMessageBox(@mbd, @buttonID) >= 0 then
    res := buttonID
  else
    res := -1;

  Result := res;
end;

function TWindow.ToPSDL_Window: PSDL_Window;
begin
  Result := _Window;
end;

procedure TWindow.__IMG_Init;
var
  errStr: string;
begin
  if IMG_Init(IMG_INIT_PNG) < 0 then
  begin
    errStr := 'SDL_image could not initialize! SDL_image Error.';
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

procedure TWindow.__SetHint;
var
  errStr: string;
begin
  // Set texture filtering to linear
  if not SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, '1') then
  begin
    errStr := 'Warning: Linear texture filtering not enabled!';
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

procedure TWindow.__SetCaption(const Value: string);
begin
  if _Caption = Value then Exit;

  _Caption := Value;
  SDL_SetWindowTitle(_Window, Value.ToPAnsiChar);
end;

procedure TWindow.__TTF_Init;
var
  errStr: string;
begin
  if TTF_Init() = -1 then
  begin
    errStr := 'SDL_ttf could not initialize! SDL_ttf Error: %s';
    errStr.Format([SDL_GetError()]);
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

procedure TWindow.__SDL_Init;
var
  errStr: string;
begin
  if SDL_Init(SDL_INIT_EVERYTHING) < 0 then
  begin
    errStr := 'SDL could not initialize! SDL_Error：%s';
    errStr.Format([SDL_GetError()]);
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

function TWindow.__CreateRenderer: PSDL_Renderer;
var
  errStr: string;
  res: PSDL_Renderer;
begin
  res := PSDL_Renderer(nil);

  // Create renderer for window
  res := SDL_CreateRenderer(_Window, -1, SDL_RENDERER_ACCELERATED);
  if res = nil then
  begin
    errStr := 'Renderer could not be created! SDL Error:';
    errStr.Format([SDL_GetError()]);
    raise Exception.Create(errStr.ToAnsiString);
  end;

  SDL_SetRenderDrawColor(res, $FF, $FF, $FF, $FF);

  Result := res;
end;

function TWindow.__CreateWindow(caption: string; winPosX, winPosY, Width, Height: int32;
  flags: uint32): PSDL_Window;
var
  errStr: string;
  res: PSDL_Window;
begin
  res := PSDL_Window(nil);

  // Create window
  res := SDL_CreateWindow(caption.ToPAnsiChar, winPosX, winPosY, Width, Height, flags);

  if res = nil then
  begin
    errStr := 'Window could not be created! SDL_Error: %s';
    errStr.Format([SDL_GetError()]);
    raise Exception.Create(errStr.ToAnsiString);
  end;

  // 获取窗口标识符
  _WindowID := SDL_GetWindowID(res);

  Result := res;
end;

function TWindow.__GetCaption: string;
begin
  Result := _Caption;
end;

function TWindow.__GetClientBounds: TRect;
begin
  Result := TRect.Create(0, 0, Self.Width, Self.Height);
end;

function TWindow.__GetHeight: int32;
begin
  _Height := _Window^.h;
  Result := _Height;
end;

function TWindow.__GetRenderer: PSDL_Renderer;
begin
  Result := _Renderer;
end;

function TWindow.__GetWidth: int32;
begin
  _Width := _Window^.w;
  Result := _Width;
end;

end.
