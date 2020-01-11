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
    FFinished: boolean;
    FPixels: TRect;
  public
    property Pixels: TRect read FPixels write FPixels;
    property Bitmap: TBGRABitmap read FBitmap write FBitmap;
    property AFinished: boolean read FFinished write FFinished;
    procedure Execute; override;
  end;

procedure FilterGrayscale(const Bitmap: TBGRABitmap;
  const numberOfThreads: integer = 2);

implementation

procedure FilterGrayscale(const Bitmap: TBGRABitmap; const numberOfThreads: integer = 2);
var
  i, j: integer;
  arr: array of TThreadFilter;
  AllFinished: boolean;
begin
  SetLength(arr, numberOfThreads);
  j := Bitmap.Height div Length(arr);
  for i := Low(arr) to High(arr) do
  begin
    arr[i] := TThreadFilter.Create(True);
    if i <> High(arr) then
      arr[i].Pixels := Rect(0, j * i, Bitmap.Width, j * (i + 1))
    else
      arr[i].Pixels := Rect(0, j * i, Bitmap.Width, Bitmap.Height);
    arr[i].Bitmap := Bitmap;
    arr[i].Start;
  end;

  for j:=Low(arr) to High(arr) do
    arr[i].WaitFor;

  //Bitmap.InvalidateBitmap;

  for i := Low(arr) to High(arr) do
    arr[i].Free;
end;

{ TThreadFilter }

procedure TThreadFilter.Execute;
var
  x, y: integer;
  p: PBGRAPixel;
  c: byte;
begin
  FFinished := False;
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
  FFinished := True;
end;

end.
