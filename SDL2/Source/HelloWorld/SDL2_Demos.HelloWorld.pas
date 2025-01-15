unit SDL2_Demos.HelloWorld;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  libSDL2,
  DeepStar.SDL2_Encapsulation.Windows,
  DeepStar.SDL2_Encapsulation.Texture,
  DeepStar.SDL2_Encapsulation.Utils;

procedure Main;

implementation

procedure Main;
const
  SCREEN_WIDTH = 800;
  SCREEN_HEIGHT = 600;
var
  win_managed: IInterface;
  win: TWindow;
  title: String;
begin
  title := '';
  title := 'SDL2 Window - ' + lowerCase({$I %FPCTargetCPU%}) + '-'
    + lowerCase({$I %FPCTargetOS%});

  win_managed := IInterface(TWindow.Create);
  win := win_managed as TWindow;
  //win.Init(

end;

end.

