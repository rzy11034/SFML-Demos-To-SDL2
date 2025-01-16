unit DeepStar.SDL2_Encapsulation.Mixer;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.Utils,
  libSDL2_mixer;

type
  TMixerBase = class(TInterfacedObject)
  protected
    _IsAudioOpened: Boolean; static;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(fileName: string); virtual; abstract;
  end;

  TMusic = class(TMixerBase)
  private
    _Music: PMix_Music;

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(fileName: string); override;
    procedure Play;
  end;

  TChunk = class(TMixerBase)
  private
    _Chunk: PMix_Chunk;

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(fileName: string); override;
    procedure Play;
  end;

implementation

{ TMixerBase }

constructor TMixerBase.Create;
begin
  if not _IsAudioOpened then
  begin
    if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
      raise Exception.Create('SDL_mixer could not initialize! SDL_mixer Error');
  end;

  _IsAudioOpened := true;
end;

destructor TMixerBase.Destroy;
begin
  if _IsAudioOpened then
  begin
    _IsAudioOpened := false;
    Mix_CloseAudio;
  end;

  inherited Destroy;
end;

{ TMusic }

constructor TMusic.Create;
begin
  inherited Create;

  _Music := PMix_Music(nil);
end;

destructor TMusic.Destroy;
begin
  if _Music <> nil then
  begin
    Mix_FreeMusic(_Music);
    _Music := nil;
  end;

  inherited Destroy;
end;

procedure TMusic.LoadFromFile(fileName: string);
var
  errStr: String;
begin
  _Music := Mix_LoadMUS(CrossFixFileName(fileName).ToPAnsiChar);
  if _Music = nil then
  begin
    errStr := string('Failed to load ' + fileName);
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

procedure TMusic.Play;
begin
  Mix_PlayMusic(_Music, -1);
end;

{ TChunk }

constructor TChunk.Create;
begin
  inherited Create;
end;

destructor TChunk.Destroy;
begin
  inherited Destroy;
end;

procedure TChunk.LoadFromFile(fileName: string);
begin
  _Chunk := Mix_LoadWAV(CrossFixFileName(fileName).ToPAnsiChar);
  if _Music = nil then
  begin
    errStr := string('Failed to load ' + fileName);
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

procedure TChunk.Play;
begin

end;

end.

