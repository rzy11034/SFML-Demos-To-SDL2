unit DeepStar.SDL2_Encapsulation.ClassBase;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils,
  libSDL2,
  libSDL2_mixer,
  libSDL2_image,
  libSDL2_ttf;

type
  TWindowBase = class abstract(TInterfacedObject)
  protected class var
    _WindowRefCount: integer;

  private
    procedure __SetHint;
    procedure __SDL_Init;

  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TImageBase = class abstract(TInterfacedObject)
  protected class var
    _ImageRefCount: integer;

  private
    procedure __IMG_Init;
    procedure __TTF_Init;

  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TMixerBase = class abstract(TInterfacedObject)
  protected class var
    _MixerRefCount: integer;

  private
    procedure __MixerOpenAudio;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure LoadFromFile(fileName: string); virtual; abstract;
    procedure Play; virtual; abstract;
  end;

implementation

{ TWindowBase }

constructor TWindowBase.Create;
begin
  if _WindowRefCount = 0 then
  begin
    __SDL_Init;
    __SetHint;
  end;

  _WindowRefCount += 1;
end;

destructor TWindowBase.Destroy;
begin
  _WindowRefCount -= 0;

  if _WindowRefCount <= 0 then
    SDL_Quit;

  inherited Destroy;
end;

procedure TWindowBase.__SDL_Init;
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

procedure TWindowBase.__SetHint;
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

{ TImageBase }

constructor TImageBase.Create;
begin
  if _ImageRefCount = 0 then
  begin
    __IMG_Init;
    __TTF_Init;
  end;

  _ImageRefCount += 1;
end;

destructor TImageBase.Destroy;
begin
  _ImageRefCount -= 1;

  if _ImageRefCount <= 0 then
  begin
    IMG_Quit;
    TTF_Quit;
  end;

  inherited Destroy;
end;

procedure TImageBase.__IMG_Init;
var
  errStr: string;
begin
  if IMG_Init(IMG_INIT_PNG) < 0 then
  begin
    errStr := 'SDL_image could not initialize! SDL_image Error.';
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

procedure TImageBase.__TTF_Init;
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

{ TMixerBase }

constructor TMixerBase.Create;
begin
  if _MixerRefCount <= 0 then
    __MixerOpenAudio;

  _MixerRefCount += 1;
end;

destructor TMixerBase.Destroy;
begin
  _MixerRefCount -= 1;

  if _MixerRefCount <= 0 then
    Mix_CloseAudio;

  inherited Destroy;
end;

procedure TMixerBase.__MixerOpenAudio;
begin
  if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
      raise Exception.Create('SDL_mixer could not initialize! SDL_mixer Error');
end;

end.

