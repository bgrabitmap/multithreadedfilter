unit umultithreadfilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmap, BGRABitmapTypes;

type

  { TThreadFilter }

  TThreadFilter = class(TThread)
  private
    FBitmap: TBGRABitmap;
    FPixels: TRect;
  public
    property Pixels: TRect read FPixels write FPixels;
    property Bitmap: TBGRABitmap read FBitmap write FBitmap;
    procedure Execute; override;
  end;

  procedure FilterGrayscale(const Bitmap: TBGRABitmap);

implementation

procedure FilterGrayscale(const Bitmap: TBGRABitmap);
var
  i: integer;
  arr: array[0..1] of TThreadFilter;
begin
  for i:=0 to 1 do
  begin
    arr[i] := TThreadFilter.Create(True);
    arr[i].FreeOnTerminate := True;
    arr[i].Pixels := Rect(0, (Bitmap.Height div 2) * i, Bitmap.Width, (Bitmap.Height div 2) * (i + 1));
    arr[i].Bitmap := Bitmap;
    arr[i].Execute;
  end;
end;

{ TThreadFilter }

procedure TThreadFilter.Execute;
var
  x, y: integer;
  p: PBGRAPixel;
  c: byte;
begin
  for y := Pixels.Top to Pixels.Bottom - 1 do
  begin
    p := Bitmap.Scanline[y];
    for x := 0 to Pixels.Right - 1 do
    begin
      c := (p^.red + p^.green + p^.blue) div 3;
      p^.red := c;
      p^.green := c;
      p^.blue := c;
      Inc(p);
    end;
  end;
end;

end.

