unit SFML_Demos.Basic;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}

interface

uses
  Classes,
  SysUtils;

procedure Main;

implementation

uses
  {$ifdef LINUX}
  Math,
  {$endif}
  DeepStar.Utils,
  CSFMLConfig,
  CSFMLGraphics,
  CSFMLSystem,
  CSFMLWindow;

procedure Main;
var
  Mode: sfVideoMode;
  Window: PsfRenderWindow;
  Title: string;
  Text: PsfText;
  Font: PsfFont;
  TextPos: sfVector2f;
  Event: sfEvent;
begin
  {$ifdef LINUX}
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  {$endif}

  Mode.Width := 800;
  Mode.Height := 600;
  Mode.BitsPerPixel := 32;

  Title := 'SFML Basic Window - ' + lowerCase({$I %FPCTARGETCPU%}) + '-' + lowerCase({$I %FPCTARGETOS%});
  Window := sfRenderWindow_Create(Mode, Title.ToPAnsiChar, sfUint32(sfResize) or sfUint32(sfClose), nil);
  if not Assigned(Window) then
    raise Exception.Create('Window error');

  // Create a graphical text to display
  Font := sfFont_createFromFile('../resources/admirationpains.ttf');
  if not Assigned(Font) then
    raise Exception.Create('Font error');

  Text := sfText_Create();
  sfText_setString(Text, 'Basic Window');
  sfText_setFont(Text, Font);
  sfText_setCharacterSize(Text, 50);
  sfText_setColor(Text, sfWhite);
  TextPos.X := 250;
  TextPos.Y := 250;
  sfText_setPosition(Text, TextPos);

  // Start the game loop
  while (sfRenderWindow_IsOpen(Window) = sfTrue) do
  begin
    // Process events
    while (sfRenderWindow_PollEvent(Window, @Event) = sfTrue) do
    begin
      // Close window : exit
      if (Event.type_ = sfEvtClosed) then
        sfRenderWindow_Close(Window);
    end;

    // Clear the screen
    sfRenderWindow_clear(Window, sfBlue);

    // Draw the text
    sfRenderWindow_drawText(Window, Text, nil);

    // Update the window
    sfRenderWindow_display(Window);
  end;

  // Cleanup resources
  sfRenderWindow_Destroy(Window);
end;

end.
