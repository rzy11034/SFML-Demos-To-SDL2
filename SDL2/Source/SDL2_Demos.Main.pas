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
  {%H-}libSDL2_gfx,
  {%H-}DeepStar.Utils,
  {%H-}DeepStar.SDL2_Encapsulation.Utils;

procedure Run;

implementation

uses DeepStar.SDL2_Encapsulation.Mixer;

procedure Test;
var
  t1_managed, t2_managed: IInterface;
  t1, t2: TMusic;
  _is: Boolean;
begin
  t1_managed := IInterface(TMusic.Create);
  t1 := t1_managed as TMusic;

  _is := t1._IsAudioOpened;
  t1._IsAudioOpened := not t1._IsAudioOpened;

  t2_managed := IInterface(TMusic.Create);
  t2 := t2_managed as TMusic;

  _is := t1._IsAudioOpened;


  Exit;
end;

procedure Run;
begin
  Test;
  //Main;
end;

end.
