unit DeepStar.SDL2_Encapsulation.Utils;

{$mode ObjFPC}{$H+}
{$ModeSwitch unicodestrings}{$J-}
{$ModeSwitch advancedrecords}{$J-}
{$modeswitch typehelpers}

interface

uses
  Classes,
  SysUtils,
  Types,
  libSDL2,
  System.UITypes,
  DeepStar.Utils,
  DeepStar.DSA.Linear.ArrayList,
  DeepStar.SDL2_Encapsulation.Texture;

const
  SDL_COLOR_BLACK: TSDL_Color = (r: 0; g: 0; b: 0; a: $FF);
  SDL_COLOR_WHITE: TSDL_Color = (r: $FF; g: $FF; b: $FF; a: $FF);

type
  float = single;

  TColor = System.UITypes.TColor;
  TColors = System.UITypes.TColors;
  TAlphaColor = System.UITypes.TAlphaColor;
  TAlphaColors = System.UITypes.TAlphaColors;

  TList_TTexture = specialize TArrayList<TTexture>;
  TList_TPoint = specialize TArrayList<TPoint>;
  TList_TRect = specialize TArrayList<TRect>;

  TArr_TTexture = array of TTexture;
  TArr_TPoint = array of TPoint;
  TArr_TRect = array of TRect;

  TArrayUtils_TTexture = specialize TArrayUtils<TTexture>;

type
  TRectHelper = type Helper for TRect
  public
    function ToSDL_Rect: TSDL_Rect;
  end;

  TSDL_RectHelper = type helper for TSDL_Rect
  public
    function ToPtr: PSDL_Rect;
  end;

operator := (AColor: TColor): TSDL_Color;
operator := (AColor: TAlphaColor): TSDL_Color;
operator := (AColor: TColor): TColors;
operator := (AColor: TAlphaColor): TAlphaColors;

function SDL_Point(aX, aY: integer): TSDL_Point;
function SDL_Point(p: TPoint): TSDL_Point;

function SDL_Rect(aX, aY, aW, aH: integer): TSDL_Rect;
function SDL_Rect(rc: TRect): TSDL_Rect;

function RGBA_Color(color: TColor): UInt32;
function RGBA_Color(color: TAlphaColor): UInt32;

var
  SDL_BlitSurface: TTSDL_UpperBlit;

procedure Init;

implementation

operator := (AColor: TColor): TSDL_Color;
var
  temp: TColors;
begin
  temp := TColors(AColor);

  Result.r := temp.R;
  Result.g := temp.G;
  Result.b := temp.B;
  Result.a := $FF;
end;

operator := (AColor: TAlphaColor): TSDL_Color;
var
  temp: TAlphaColors;
begin
  temp := TAlphaColors(AColor);

  Result.r := temp.R;
  Result.g := temp.G;
  Result.b := temp.B;
  Result.a := temp.A;
end;

operator := (AColor: TColor): TColors;
begin
  Result := AColor;
end;

operator := (AColor: TAlphaColor): TAlphaColors;
begin
  Result := TAlphaColors.Create(AColor);
end;

function SDL_Point(aX, aY: integer): TSDL_Point;
var
  res: TSDL_Point;
begin
  res := Default(TSDL_Point);

  with res do
  begin
    x := aX;
    y := aY;
  end;

  Result := res;
end;

function SDL_Point(p: TPoint): TSDL_Point;
begin
  Result := SDL_Point(p.X, p.Y);
end;

function SDL_Rect(aX, aY, aW, aH: integer): TSDL_Rect;
var
  res: TSDL_Rect;
begin
  res := Default(TSDL_Rect);

  with res do
  begin
    x := aX; y := aY; w := aW; h := aH;
  end;

  Result := res;
end;

function SDL_Rect(rc: TRect): TSDL_Rect;
begin
  Result := SDL_Rect(rc.Left, rc.Top, rc.Width, rc.Height);
end;

function RGBA_Color(color: TColor): UInt32;
begin
  //Result := SDL_MapRGB();
end;

function RGBA_Color(color: TAlphaColor): UInt32;
begin

end;

{ TRectHelper }

function TRectHelper.ToSDL_Rect: TSDL_Rect;
var
  res: TSDL_Rect;
begin
  res := Default(TSDL_Rect);

  with res do
  begin
    x := Self.Left;
    y := Self.Top;
    w := Self.Width;
    h := Self.Height;
  end;

  Result := res;
end;

{ TSDL_RectHelper }

function TSDL_RectHelper.ToPtr: PSDL_Rect;
begin
  Result := @Self;
end;

procedure Init;
begin
  SDL_BlitSurface := SDL_UpperBlit;
end;

end.
