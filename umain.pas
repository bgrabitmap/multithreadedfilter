unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, BGRAVirtualScreen,
  BCFilters, BGRABitmap, BGRABitmapTypes, BCTypes, umultithreadfilter;

type

  { TForm1 }

  TForm1 = class(TForm)
    BGRAVirtualScreen1: TBGRAVirtualScreen;
    procedure BGRAVirtualScreen1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BGRAVirtualScreen1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
begin
  Bitmap.GradientFill(0, 0, Bitmap.Width, Bitmap.Height, BGRA(0,255,0), BGRA(0,0,255), gtLinear, PointF(0,0), PointF(Bitmap.Height, 0), dmSet);
  FilterGrayscale(Bitmap, TThread.ProcessorCount);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Caption := IntToStr(TThread.ProcessorCount) + ' Threads';
end;

end.

