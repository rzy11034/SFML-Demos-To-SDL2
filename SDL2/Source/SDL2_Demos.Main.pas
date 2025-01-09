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
var
  win: PSDL_Window;
  screen, image: PSDL_Surface;
begin
  SDL_Init(SDL_INIT_VIDEO);

  win := PSDL_Window(nil);
  win := SDL_CreateWindow('', 0, 0, 400, 400, SDL_WINDOW_SHOWN);

  screen := PSDL_Surface(nil);
  screen := SDL_GetWindowSurface(win);

  image := PSDL_Surface(nil);
  image := SDL_LoadBMP('hello_world.bmp'.ToPAnsiChar);
  SDL_BlitSurface(image, nil, screen, nil);
  SDL_FreeSurface(image);


  SDL_UpdateWindowSurface(win);


  SDL_Delay(2000);
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
