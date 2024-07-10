unit SDL2_Demos.Basic;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  DeepStar.SDL2_ADV.Windows,
  DeepStar.SDL2_ADV.Texture,
  DeepStar.SDL2_ADV.Utils;

var
  Title: string;
  window: TWindow;

procedure Main;

implementation

procedure Main;
begin
  Title := 'SDL2 Basic Window - ' + lowerCase({$I %FPCTargetCPU%}) + '-' + lowerCase({$I %FPCTargetOS%});

  window := TWindow.Create;
  window.InitWithOpenGL(Title, 800, 600);



  Window.Free;
end;

end.
