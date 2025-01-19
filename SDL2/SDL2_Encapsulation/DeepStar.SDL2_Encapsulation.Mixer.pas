unit DeepStar.SDL2_Encapsulation.Mixer;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}
{$ModeSwitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  DeepStar.SDL2_Encapsulation.ClassBase,
  DeepStar.Utils,
  libSDL2_mixer;

type
  TMusic = class(TMixerBase)
  private
    _Music: PMix_Music;

  public
    constructor Create; override;
    destructor Destroy; override;

    procedure LoadFromFile(fileName: string); override;
    procedure Play; override;
  end;

  TChunk = class(TMixerBase)
  private
    _Chunk: PMix_Chunk;

  public
    constructor Create; override;
    destructor Destroy; override;

    procedure LoadFromFile(fileName: string); override;
    procedure Play; override;
  end;

implementation

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
  _Chunk := PMix_Chunk(nil);
end;

destructor TChunk.Destroy;
begin
  if _Chunk <> nil then
  begin
    Mix_FreeChunk(_Chunk);
    _Chunk := nil;
  end;

  inherited Destroy;
end;

procedure TChunk.LoadFromFile(fileName: string);
var
  errStr: String;
begin
  _Chunk := Mix_LoadWAV(CrossFixFileName(fileName).ToPAnsiChar);
  if _Chunk = nil then
  begin
    errStr := string('Failed to load ' + fileName);
    raise Exception.Create(errStr.ToAnsiString);
  end;
end;

procedure TChunk.Play;
begin
  Mix_PlayChannel(-1, _Chunk, 0);
end;

end.

