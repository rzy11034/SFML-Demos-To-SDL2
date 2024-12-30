unit SDL2_Demos.Basic;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  GL,
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
  title: string;
  window: TWindow;
  txText: TTexture;
  event: TSDL_Event;
  window_managed, txText_managed:IInterface;
  quit: Boolean;
begin
  title := 'SDL2 Basic Window - ' + lowerCase({$I %FPCTargetCPU%}) + '-' + lowerCase({$I %FPCTargetOS%});

  window_managed := IInterface(TWindow.Create);
  window := window_managed as TWindow;
  window.InitWithOpenGL(Title, SCREEN_WIDTH, SCREEN_HEIGHT);

  txText_managed := IInterface(TTexture.Create);
  txText := txText_managed as TTexture;
  txText.LoadFormString(window.Renderer, '../Resources/admirationpains.ttf',
    50, 'Basic Window', TColors.White);
  txText.SetPosition(200, 250);

  event:= Default(TSDL_Event);
  quit := false;
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

      if event.window.event = SDL_WINDOWEVENT_SIZE_CHANGED then
        txText.SetScale(window.Width / SCREEN_WIDTH, window.Height / SCREEN_HEIGHT);
    end;

    window.SetRenderDrawColorAndClear(TColors.Blue);
    window.Draw(txText);

    window.Display;
  end;
end;

end.
