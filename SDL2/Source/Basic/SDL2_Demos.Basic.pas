unit SDL2_Demos.Basic;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  libSDL2,
  DeepStar.SDL2_Lib.Windows,
  DeepStar.SDL2_Lib.Texture,
  DeepStar.SDL2_Lib.Utils;

var
  title: string;
  window: TWindow;
  txText: TTexture;
  event: TSDL_Event;
  quit: boolean;

procedure Main;

implementation

procedure Main;
begin
  title := 'SDL2 Basic Window - ' + lowerCase({$I %FPCTargetCPU%}) + '-' + lowerCase({$I %FPCTargetOS%});
  window := TWindow.Create;
  window.InitWithOpenGL(Title, 800, 600);

  txText := TTexture.Create;
  txText.LoadFormString(window.Renderer, '../Resources/admirationpains.ttf',
    50, 'Basic Window', TColors.White);
  txText.SetPosition(200, 250);

  event:= Default(TSDL_Event);
  quit := boolean(false);
  while quit = false do
  begin
    while SDL_PollEvent(@event) <> 0 do
    begin
      if event.type_ = SDL_QUIT_EVENT then
      begin
        quit := true;
      end
      else if event.type_ = SDL_KEYDOWN then
      begin
        case event.key.keysym.sym of
          SDLK_ESCAPE: quit := true;
        end;
      end;
    end;

    window.SetRenderDrawColorAndClear(TColors.Blue);
    window.Draw(txText);

    window.Display;
  end;

  Window.Free;
end;

end.
