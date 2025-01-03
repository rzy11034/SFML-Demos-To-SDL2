﻿unit SDL2_Demos.Circle;

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
  surface: PSDL_Surface;
  zoomX, zoomY: Real;
  c: TSDL_Color;
  r: PSDL_Renderer;
  tx: TTexture;
begin
  title := '';
  title := 'SDL2 Circle - ' + lowerCase({$I %FPCTargetCPU%}) + '-'
    + lowerCase({$I %FPCTargetOS%});

  win_managed := IInterface(TWindow.Create);
  win := win_managed as TWindow;
  win.InitWithOpenGL(Title, SCREEN_WIDTH, SCREEN_HEIGHT);




  win.SetRenderDrawColorAndClear;
  c := SDL_Color(TAlphaColors.Red);

  libSDL2_gfx.aaCircleRGBA(win.Renderer, 100, 100, 50, c.R, c.G, c.B, c.A);
  libSDL2_gfx.filledCircleRGBA(win.Renderer, 100, 100, 50, c.R, c.G, c.B, c.A);

  tx_managed := IInterface(TTexture.Create);
  tx := tx_managed as TTexture;
  tx.CreateFormFromWindoesSurface(win.ToPSDL_Window);

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

      if event.window.event = SDL_WINDOWEVENT_SIZE_CHANGED then
      begin
        //tx := surface;
        ////tx := SDL_GetWindowSurface(win.ToPtr);
        //
        //zoomX := win.Width / SCREEN_WIDTH;
        //zoomY := win.Height / SCREEN_HEIGHT;
        //
        //
        //tx := libSDL2_gfx.rotozoomSurfaceXY(surface, 0, zoomX, zoomY, 32);
        //
        //SDL_UpperBlit(tx, nil, surface, nil);
      end;


    end;

    win.SetRenderDrawColorAndClear;

    libSDL2_gfx.aaCircleRGBA(win.Renderer, 100, 100, 50, c.R, c.G, c.B, c.A);
    libSDL2_gfx.filledCircleRGBA(win.Renderer, 100, 100, 50, c.R, c.G, c.B, c.A);

    //win.Draw(tx);
    win.Display;
  end;
end;

end.

