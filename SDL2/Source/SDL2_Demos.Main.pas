unit SDL2_Demos.Main;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  {%H-}libSDL2,
  {%H-}libSDL2_image,
  {%H-}DeepStar.Utils,
  {%H-}DeepStar.SDL2_Encapsulation.Utils;

procedure Run;

implementation

uses SDL2_Demos.Circle;

procedure Test;
begin
  //i := SDL_MapRGB
  Exit;
end;

procedure Run;
begin
  Test;
  Main;
end;

end.
