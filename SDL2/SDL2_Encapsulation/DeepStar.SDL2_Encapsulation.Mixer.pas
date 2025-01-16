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

  public
    class var _IsAudioOpened: Boolean;

    procedure LoadFromFile(fileName: string); virtual abstract;
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

  public
    constructor Create;
    destructor Destroy; override;

  end;

implementation

{ TMusic }

constructor TMusic.Create;
begin
  _Music := PMix_Music(nil);

  if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
    raise Exception.Create('SDL_mixer could not initialize! SDL_mixer Error');
end;

destructor TMusic.Destroy;
begin
  if _IsAudioOpened then
    Mix_CloseAudio;

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
  _IsAudioOpened := true;
end;

{ TChunk }

constructor TChunk.Create;
begin

end;

destructor TChunk.Destroy;
begin
  inherited Destroy;
end;

end.

