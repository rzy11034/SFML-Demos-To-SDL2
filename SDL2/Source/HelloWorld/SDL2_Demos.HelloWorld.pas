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
  win_managed, texture_managed, font_managed: IInterface;
  win: TWindow;
  title: String;
  texture, font: TTexture;
  scaleX, scaleY: float;
  quit: Boolean;
  event: TSDL_Event;
begin
  title := '';
  title := 'SDL2 Window - ' + lowerCase({$I %FPCTargetCPU%}) + '-'
    + lowerCase({$I %FPCTargetOS%});

  win_managed := IInterface(TWindow.Create);
  win := win_managed as TWindow;
  win.Init(title, SCREEN_WIDTH, SCREEN_HEIGHT);

  texture_managed := IInterface(TTexture.Create(win.Renderer));
  texture := texture_managed as TTexture;
  texture.LoadFromFile('../resources/oncapintada.jpg');

  font_managed := IInterface(TTexture.Create(win.Renderer));
  font := font_managed as TTexture;
  font.LoadFormString('../resources/admirationpains.ttf', 50, 'Hello World',
    TSDL_Color(TColors.Black));
  font.SetPosition(300, 5);

  quit := false;
  event := Default(TSDL_Event);
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
      begin
        scaleX := win.Width / SCREEN_WIDTH;
        scaleY := win.Height / SCREEN_HEIGHT;

        texture.SetScale(scaleX, scaleY);
        font.SetScale(scaleX, scaleY);
      end;
    end;

    texture.Render;
    font.Render(font.Position);
    texture.Display;
  end;
end;

end.

