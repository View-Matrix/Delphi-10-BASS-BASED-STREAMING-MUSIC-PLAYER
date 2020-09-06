unit FMX.Devgear.Extensions;

interface

uses
  System.Classes, System.Types, FMX.Graphics;

type
  TBitmapHelper = class helper for TBitmap
  private
    function LoadStreamFromUrl(AUrl: string): TMemoryStream;
  public
    procedure LoadFromUrl(AUrl: string; var outSize: Int64); overload;
    procedure LoadFromUrl(AUrl: string); overload;

    procedure LoadThumbnailFromUrl(AUrl: string; const AFitWidth, AFitHeight: Integer);
  end;

implementation

uses
  IdHttp, IdTCPClient;

function TBitmapHelper.LoadStreamFromUrl(AUrl: string): TMemoryStream;
var
  Http: TIdHttp;
begin
  Result := TMemoryStream.Create;
  Http := TIdHttp.Create(nil);
  try
    try
      Http.Get(AUrl, Result);
    except
    end;
  finally
    Http.Free;
  end;
end;

procedure TBitmapHelper.LoadFromUrl(AUrl: string; var outSize: Int64);
var
  Stream: TMemoryStream;
begin
  Stream := LoadStreamFromUrl(AUrl);
  outSize := Stream.Size;
  try
    if Stream.Size > 0 then
    begin
      LoadFromStream(Stream);
    end
  finally
    Stream.Free;
  end;
end;

procedure TBitmapHelper.LoadFromUrl(AUrl: string);
var
  tmp: Int64;
begin
  LoadFromUrl(AUrl, tmp);
end;

procedure TBitmapHelper.LoadThumbnailFromUrl(AUrl: string; const AFitWidth,
  AFitHeight: Integer);
var
  Bitmap: TBitmap;
  scale: Single;
begin
  LoadFromUrl(AUrl);
  scale := RectF(0, 0, Width, Height).Fit(RectF(0, 0, AFitWidth, AFitHeight));
  Bitmap := CreateThumbnail(Round(Width / scale), Round(Height / scale));
  try
    Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;
end.
