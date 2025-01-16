unit SDL2_Demos.Main;

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
  {%H-}libSDL2,
  {%H-}libSDL2_image,
  {%H-}libSDL2_gfx,
  {%H-}DeepStar.Utils,
  {%H-}DeepStar.SDL2_Encapsulation.Utils;

procedure Run;

implementation

uses DeepStar.SDL2_Encapsulation.Mixer;

procedure Test;
var
  t1: TMusic;
  t2: TChunk;
begin
  t1 := TMusic.Create;
  t2 := TChunk.Create;

  t1.Free;
  t2.Free;

  Exit;
end;

procedure Run;
begin
  Test;
  //Main;
end;

end.
