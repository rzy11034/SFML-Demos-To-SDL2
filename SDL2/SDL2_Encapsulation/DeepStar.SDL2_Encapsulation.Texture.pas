unit DeepStar.SDL2_Encapsulation.Texture;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  LazUTF8,
  System.UITypes,
  DeepStar.Utils,
  libSDL2,
  libSDL2_image,
  libSDL2_ttf;

type
  TTexture = Class(TInterfacedObject)
  private type
    float = single;
    TColors = System.UITypes.TAlphaColorRec;

  public type
    TScale = record
    public
      x, y: single;
      class function Create: TScale; static;
      class operator initialize(var obj: TScale);
    end;

  private
    _Height: integer;
    _Width: integer;
    _Texture: PSDL_Texture;
    _Position: TPoint;
    _Scale: TScale;

    function __GetBoundsRect: TRect;
    function __GetData: PSDL_Texture;
    function __GetHeight: integer;
    function __GetPosition: TPoint;
    function __GetWidth: integer;

    procedure __Free;

  public
    constructor Create;
    destructor Destroy; override;

    // 新建一个空白 纹理
    function CreateBlank(win: PSDL_Window; width, Height: integer): Boolean;

    function GetScale: TTexture.TScale;
    function ToPSDL_Texture: PSDL_Texture;

    // 从当前 windowsWindoesSurface 生成纹理
    procedure CreateFormFromWindoesSurface(win: PSDL_Window);

    // 指定路径图像创建纹理
    procedure LoadFromFile(renderer: PSDL_Renderer; path: string);

    // 从字符串创建纹理
    procedure LoadFormString(renderer: PSDL_Renderer; ttfName: string; ttfSize: integer;
      Text: string; color: TSDL_Color);

    //将当前纹理设置为渲染目标
    procedure setAsRenderTarget(renderer: PSDL_Renderer);

    procedure SetPosition(ax, ay: integer);
    procedure SetPosition(ap: TPoint);
    procedure SetColor(color: TColors);
    procedure SetScale(x, y: float);

    property Width: integer read __GetWidth;
    property Height: integer read __GetHeight;
    property Position: TPoint read __GetPosition;
    property BoundsRect: TRect read __GetBoundsRect;
  end;

implementation

  { TTexture }

constructor TTexture.Create;
begin
  _Scale := TScale.Create;
end;

function TTexture.CreateBlank(win: PSDL_Window; width, Height: integer): Boolean;
var
  renderer: PSDL_Renderer;
  errString: String;
begin
  __Free;

  renderer := PSDL_Renderer(nil);
  renderer := SDL_GetRenderer(win);

  _Texture := SDL_CreateTexture
  (
    renderer,
    SDL_PIXELFORMAT_RGBA8888,
    SDL_TEXTUREACCESS_TARGET,
    Width,
    Height
  );

  if _Texture = nil then
  begin
    errString := Format
    (
      'Unable to create streamable blank texture! SDL Error: %s',
      [SDL_GetError()]
    ).ToUString;
    raise Exception.Create(errString.ToAnsiString);
  end
  else
  begin
    _Width := Width;
    _Height := Height;
  end;

  Result := _Texture <> nil;
end;

procedure TTexture.CreateFormFromWindoesSurface(win: PSDL_Window);
var
  surface: PSDL_Surface;
  renderer: PSDL_Renderer;
begin
  renderer := PSDL_Renderer(nil);
  renderer := SDL_GetRenderer(win);

  surface := PSDL_Surface(nil);
  surface := SDL_GetWindowSurface(win);

  _Width := surface^.w;
  _Height := surface^.h;
  _Texture := SDL_CreateTextureFromSurface(renderer, surface);
end;

destructor TTexture.Destroy;
begin
  __Free;
  inherited Destroy;
end;

function TTexture.GetScale: TTexture.TScale;
begin
  Result.x := _Scale.x;
  Result.y := _Scale.y;
end;

procedure TTexture.LoadFormString(renderer: PSDL_Renderer; ttfName: string;
  ttfSize: integer; Text: string; color: TSDL_Color);
var
  textSurface: PSDL_Surface;
  errStr: string;
  font: PTTF_Font;
  newTexture: PSDL_Texture;
begin
  Self.__Free;

  font := PTTF_Font(nil);
  font := TTF_OpenFont(CrossFixFileName(ttfName).ToPAnsiChar, ttfSize);
  if font = nil then
  begin
    errStr := 'Failed to load font! SDL_ttf Error: %s';
    errStr.Format([SDL_GetError()]);
    raise Exception.Create(errStr.ToAnsiString);
  end;

  textSurface := PSDL_Surface(nil);
  try
    textSurface := TTF_RenderUTF8_Blended(font, Text.ToPAnsiChar, color);

    if textSurface = nil then
    begin
      errStr := 'Unable to render text surface! SDL_ttf Error: %s';
      errStr.Format([SDL_GetError()]);
      raise Exception.Create(errStr.ToAnsiString);
    end;

    // Create texture from surface pixels
    newTexture := PSDL_Texture(nil);
    newTexture := SDL_CreateTextureFromSurface(renderer, textSurface);
    if newTexture = nil then
    begin
      errStr := 'Unable to create texture from rendered text! SDL Error: %s';
      errStr.Format([SDL_GetError()]);
      raise Exception.Create(errStr.ToAnsiString);
    end;

    // Get image dimensions
    _Width := textSurface^.w;
    _Height := textSurface^.h;
    _Texture := newTexture;
  finally
    TTF_CloseFont(font);
    SDL_FreeSurface(textSurface);
  end;
end;

procedure TTexture.LoadFromFile(renderer: PSDL_Renderer; path: string);
var
  fileName, errStr: string;
  loadedSurface: PSDL_Surface;
  newTexture: PSDL_Texture;
begin
  __Free;

  fileName := CrossFixFileName(path);
  // Load image at specified path
  loadedSurface := PSDL_Surface(nil);
  loadedSurface := IMG_Load(fileName.ToPAnsiChar);
  if loadedSurface = nil then
  begin
    errStr := 'Unable to load image %s! SDL_image Error.';
    errStr.Format([fileName]);
    raise Exception.Create(errStr.ToAnsiString);
  end
  else
  begin
    // The final texture
    // Create texture from surface pixels
    try
      newTexture := PSDL_Texture(nil);
      newTexture := SDL_CreateTextureFromSurface(renderer, loadedSurface);
      if newTexture = nil then
      begin
        errStr := 'Unable to create texture from %s! SDL Error: %s';
        errStr.Format([fileName, SDL_GetError()]);
        raise Exception.Create(errStr.ToAnsiString);
      end;

      _Width := loadedSurface^.w;
      _Height := loadedSurface^.h;
      _Texture := newTexture;
    finally
      // Get rid of old loaded surface
      SDL_FreeSurface(loadedSurface);
    end;
  end;
end;

procedure TTexture.setAsRenderTarget(renderer: PSDL_Renderer);
begin
  SDL_SetRenderTarget(renderer, _Texture);
end;

procedure TTexture.SetColor(color: TColors);
begin
  SDL_SetTextureColorMod(_Texture, color.R, color.G, color.B);
end;

procedure TTexture.SetPosition(ax, ay: integer);
begin
  _Position := TPoint.Create(ax, ay);
end;

procedure TTexture.SetPosition(ap: TPoint);
begin
  _Position := ap;
end;

procedure TTexture.SetScale(x, y: float);
begin
  _Scale.x := x;
  _Scale.y := y;
end;

function TTexture.ToPSDL_Texture: PSDL_Texture;
begin
  Result := _Texture;
end;

procedure TTexture.__Free;
begin
  if _Texture <> nil then
  begin
    SDL_DestroyTexture(_Texture);
    _Texture := nil;

    _Height := 0;
    _Width := 0;
  end;
end;

function TTexture.__GetBoundsRect: TRect;
begin
  Result := Rect(
    _Position.x,
    _Position.y,
    _Position.x + _Width,
    _Position.y + _Height);
end;

function TTexture.__GetData: PSDL_Texture;
begin
  Result := _Texture;
end;

function TTexture.__GetHeight: integer;
begin
  Result := _Height;
end;

function TTexture.__GetPosition: TPoint;
begin
  Result := _Position;
end;

function TTexture.__GetWidth: integer;
begin
  Result := _Width;
end;

{ TTexture.TScale }

class operator TTexture.TScale.initialize(var obj: TScale);
begin
  obj.x := 1;
  obj.y := 1;
end;

class function TTexture.TScale.Create: TScale;
begin
  initialize(Result);
end;

end.
