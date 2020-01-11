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

  procedure FilterGrayscale(const Bitmap: TBGRABitmap; const numberOfThreads: integer = 2);

implementation

procedure FilterGrayscale(const Bitmap: TBGRABitmap; const numberOfThreads: integer = 2);
var
  i, j: integer;
  arr: array of TThreadFilter;
begin
  SetLength(arr, numberOfThreads);
  j := Bitmap.Height div Length(arr);
  for i:=0 to Length(arr)-1 do
  begin
    arr[i] := TThreadFilter.Create(True);
    arr[i].FreeOnTerminate := True;
    if i <> Length(arr)-1 then
      arr[i].Pixels := Rect(0, j * i, Bitmap.Width, j * (i + 1))
    else
      arr[i].Pixels := Rect(0, j * i, Bitmap.Width, Bitmap.Height);
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

