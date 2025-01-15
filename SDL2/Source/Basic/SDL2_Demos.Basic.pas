unit SDL2_Demos.Basic;

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
  title: string;
  win: TWindow;
  texture: TTexture;
  event: TSDL_Event;
  window_managed, texture_managed:IInterface;
  quit: Boolean;
begin
  title := 'SDL2 Basic win - ' + lowerCase({$I %FPCTargetCPU%}) + '-'
    + lowerCase({$I %FPCTargetOS%});

  window_managed := IInterface(TWindow.Create);
  win := window_managed as TWindow;
  win.Init(Title, SCREEN_WIDTH, SCREEN_HEIGHT);

  texture_managed := IInterface(TTexture.Create(win.Renderer));
  texture := texture_managed as TTexture;
  texture.LoadFormString('../Resources/admirationpains.ttf', 80, 'Basic win',
    TColors.White);
  texture.SetPosition(180, 250);

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
        texture.SetScale(win.Width / SCREEN_WIDTH, win.Height / SCREEN_HEIGHT);
    end;

    texture.SetDrawColor(TSDL_Color(TAlphaColors.Blue));
    texture.Clear;
    texture.Render(texture.Position);
    texture.Display;
  end;
end;

end.
