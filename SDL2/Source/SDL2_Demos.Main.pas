unit SDL2_Demos.Main;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  GraphMath,
  DeepStar.Utils,
  DeepStar.SDL2_Encapsulation.Utils;

procedure Run;

implementation

uses SDL2_Demos.Circle;

procedure Test;
begin
  Exit;
end;

procedure Run;
begin
  Test;
  Main;
end;

end.
