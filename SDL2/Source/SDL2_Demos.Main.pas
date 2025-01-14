unit SDL2_Demos.Main;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}
{$ModeSwitch advancedrecords}
{$ModeSwitch implicitfunctionspecialization}
{$ModeSwitch anonymousfunctions}
{$ModeSwitch functionreferences}
{$ModeSwitch duplicatelocals}

interface

uses
  Classes,
  SysUtils,
  {%H-}libSDL2,
  {%H-}libSDL2_image,
  libSDL2_gfx,
  {%H-}DeepStar.Utils,
  {%H-}DeepStar.SDL2_Encapsulation.Utils;

procedure Run;

implementation

uses SDL2_Demos.Circle;

procedure Test;

const
  path = '..\Resources\background.jpg';
var
  win: PSDL_Window;
  image, surface: PSDL_Surface;
  event: TSDL_Event;
  tx1, tx2, tx3, tx4, tx5: PSDL_Texture;
  rc1, rc2: TRect;
  x, y, access: Integer;
  format_: UInt32;
  s, gameIsRunning: Boolean;
  str: PAnsiChar;
  renderer: PSDL_Renderer;
  i: integer;
  c: TSDL_Color;
  sc1: TSDL_Rect;
  p: PSDL_Rect;
begin
  SDL_Init(SDL_INIT_VIDEO);

  win := PSDL_Window(nil);
  win := SDL_CreateWindow
    (
      'SDL测试'.ToPAnsiChar,
      SDL_WINDOWPOS_CENTERED,
      SDL_WINDOWPOS_CENTERED,
      640,
      480,
      SDL_WINDOW_RESIZABLE
    );

  renderer := PSDL_Renderer(nil);
  renderer := SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED);

  image := PSDL_Surface(nil);
  image := IMG_Load(CrossFixFileName(path).ToPAnsiChar);

  tx1 := PSDL_Texture(nil);
  tx2 := PSDL_Texture(nil);
  tx3 := PSDL_Texture(nil);
  tx4 := PSDL_Texture(nil);
  tx1 := SDL_CreateTextureFromSurface(renderer, image);
  tx2 := SDL_CreateTextureFromSurface(renderer, image);
  tx3 := SDL_CreateTextureFromSurface(renderer, image);
  tx4 := SDL_CreateTextureFromSurface(renderer, image);

  surface := PSDL_Surface(nil);
  surface := SDL_GetWindowSurface(win);

  tx5 := PSDL_Texture(nil);
  tx5 := SDL_CreateTexture(renderer, surface^.format^.format, SDL_TEXTUREACCESS_TARGET,
    surface^.w, surface^.h);



  x := 0;
  y := 0;
  format_ := uint32(0);
  access := Integer(0);
  str := PAnsiChar(nil);

  s := true;
  SDL_QueryTexture(tx1, @format_, @access, @x, @y);
  str := SDL_GetPixelFormatName(format_);

  event := Default(TSDL_Event);
  gameIsRunning := true;

  while gameIsRunning do
  begin
    while SDL_PollEvent(@event) <> 0 do
    begin
      if event.type_ = SDL_QUIT_EVENT then
      begin
        gameIsRunning := false;
      end
      else if event.key.type_ = SDL_KEYDOWN then
      begin
        WriteLn('aaaaa');

        case event.key.keysym.sym of
          SDLK_a: SDL_SetTextureBlendMode(tx5, SDL_BLENDMODE_ADD);
          SDLK_s: SDL_SetTextureBlendMode(tx5, SDL_BLENDMODE_BLEND);
          SDLK_d: SDL_SetTextureBlendMode(tx5, SDL_BLENDMODE_MOD);
          SDLK_ESCAPE: SDL_SetTextureBlendMode(tx5, SDL_BLENDMODE_NONE);
        end;
      end;
    end;



    SDL_SetRenderTarget(renderer, tx5);
      SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
      SDL_RenderClear(renderer);

      rc1 := TRect.Create(30, 10, 300, 200);
      sc1 := SDL_Rect(30, 10, 300, 200);
      p := rc1.ToPSDL_Rect;

      SDL_RenderCopy(renderer, tx1, nil, nil);
      //SDL_SetRenderDrawColor(renderer, 0, 0, 255, 255);
      //SDL_RenderFillRect(renderer, sc1.ToPtr);

      aacircleRGBA(renderer, 100, 100, 50, 0, 0, 255, 255);

      //rc1.Offset(100, 100);
      //SDL_RenderFillRect(renderer, rc1.ToPSDL_Rect);

    SDL_SetRenderTarget(renderer, nil);


    SDL_RenderCopy(renderer, tx5, nil, nil);

    SDL_RenderPresent(renderer);
  end;

  SDL_DestroyTexture(tx1);
  SDL_DestroyTexture(tx2);
  SDL_DestroyTexture(tx3);
  SDL_DestroyTexture(tx4);
  SDL_DestroyTexture(tx5);

  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(win);
  SDL_Quit;

  Exit;
end;

procedure Run;
begin
  //Test;
  Main;
end;

end.
