unit SDL2_Demos.Circle;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  GL,
  libSDL2,
  libSDL2_image,
  libSDL2_gfx,
  DeepStar.SDL2_Encapsulation.Utils,
  DeepStar.SDL2_Encapsulation.Windows,
  DeepStar.SDL2_Encapsulation.Texture;

procedure Main;

implementation

procedure Main;
const
  RADIUS = 200;
  SCREEN_WIDTH = RADIUS * 2;
  SCREEN_HEIGHT = RADIUS * 2;
var
  win_managed, tx_managed: IInterface;
  win: TWindow;
  title: String;
  event: TSDL_Event;
  quit: Boolean;
  c: TSDL_Color;
  tx: TTexture;
  OriginPoint: TPoint;

  procedure __Render__;
  begin


    OriginPoint := Point(0, 0);
  end;

begin
  title := '';
  title := 'SDL2 Circle - ' + lowerCase({$I %FPCTargetCPU%}) + '-'
    + lowerCase({$I %FPCTargetOS%});

  win_managed := IInterface(TWindow.Create);
  win := win_managed as TWindow;
  win.InitWithOpenGL(Title, SCREEN_WIDTH, SCREEN_HEIGHT);

  tx_managed := IInterface(TTexture.Create(win.Renderer));
  tx := tx_managed as TTexture;
  tx.CreateBlank(SCREEN_WIDTH, SCREEN_HEIGHT);

  event := Default(TSDL_Event);
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
    end;

    tx.SetTarget;

    tx.UnsetTarget;

    tx.Display;
  end;
end;

end.

