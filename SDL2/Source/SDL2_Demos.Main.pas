unit SDL2_Demos.Main;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  {%H-}libSDL2,
  {%H-}libSDL2_image,
  {%H-}DeepStar.Utils,
  {%H-}DeepStar.SDL2_Encapsulation.Utils;

procedure Run;

implementation

//uses SDL2_Demos.Basic;

procedure Test;
const
  path = '..\Resources\background.jpg';

var
  win: PSDL_Window;
  screen, image: PSDL_Surface;
  gameIsRunning: Boolean;
  event: TSDL_Event;
begin
  SDL_Init(SDL_INIT_VIDEO);

  win := PSDL_Window(nil);
  win := SDL_CreateWindow
    (
      '所',
      SDL_WINDOWPOS_CENTERED,
      SDL_WINDOWPOS_CENTERED,
      640,
      480,
      SDL_WINDOW_SHOWN
    );

  screen := PSDL_Surface(nil);
  screen := SDL_GetWindowSurface(win);

  image := PSDL_Surface(nil);
  image := IMG_Load(CrossFixFileName(path).ToPAnsiChar);

  //SDL_SetWindowSize(win, image^.w, image^.h);
  SDL_BlitSurface(image,  nil, screen, nil);
  SDL_FreeSurface(image);



  gameIsRunning := true;
  event := Default(TSDL_Event);

  while gameIsRunning do
  begin
    while SDL_PollEvent(@event) <> 0 do
    begin
      if event.type_ = SDL_QUIT_EVENT then
      begin
        gameIsRunning := false;
      end
      else if event.button.button = SDL_BUTTON_LEFT then
      begin
        if event.button.state = SDL_PRESSED then
        begin
          SDL_LockSurface(screen);
            sdl_mems
            WriteLn('SDL_BUTTON_LEFT');
          SDL_UnlockSurface(screen);
        end;
      end;
    end;

    SDL_UpdateWindowSurface(win);
  end;



  SDL_DestroyWindow(win);
  SDL_Quit;

  Exit;
end;

procedure Run;
begin
  Test;
  //Main;
end;

end.
