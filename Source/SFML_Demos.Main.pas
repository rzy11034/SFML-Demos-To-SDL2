unit SFML_Demos.Main;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils, ctGL;

procedure Run;

implementation

uses
  SFML_Demos.Colorful;

procedure Test;
var
  bool: Boolean;
begin
  bool := false;
  bool := OpenGLLib_InitOK;
  OpenGL_InitializeAdvance;
  Exit;
end;

procedure Run;
begin
  Test;
  Main;
end;

end.
