unit SDL2_Demos.Caleidos;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils,
  libSDL2,
  DeepStar.Utils,
  DeepStar.SDL2_Encapsulation.Windows,
  DeepStar.SDL2_Encapsulation.Utils;

var
  FragmentShader, title: string;
  window: TWindow;
  event: TSDL_Event;
  quit: Boolean;

procedure Main;
function Read_GLSL(fileName: string): string;

implementation

procedure Main;
begin
  FragmentShader := Read_GLSL('..\Source\Caleidos\Caleidos.fs');

  title := 'SDL2 Shader - ';
  title += lowerCase({$I %FPCTargetCPU%}) + '-' + lowerCase({$I %FPCTargetOS%});

  window := TWindow.Create;
  window.InitWithOpenGL(Title, 800, 600);

  event := Default(TSDL_Event);
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

    window.SetRenderDrawColorAndClear(TColors.Black);
    //window.Draw(txText);

    window.Display;
  end;

  window.Free;
end;

function Read_GLSL(fileName: string): string;
var
  strList: TStringList;
begin
  strList := TStringList.Create();
  try
    strList.LoadFromFile(fileName.ToAnsiString);
    Result := string(strList.Text);
  finally
    strList.Free;
  end;
end;

end.
