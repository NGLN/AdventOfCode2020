program AOC2020_20;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections,
  System.Types;

const
  TileSize = 10;
  GridSize = 12;
  MapSize = GridSize * (TileSize - 2);

type
  // -1, TopCW, RightCW, BottomCW, LeftCW, TopCCW, RightCCW, BottomCCW, LeftCCW
  TBorderId = -1..7;
  TTileData = array[1..TileSize] of String;

  TTile = class(TObject)
    TileData: TTileData;
    Id: Integer;
    procedure AlignAgainstLeftTile(const ItsRightBorder: String);
    procedure AlignAgainstTopTile(const ItsBottomBorder: String);
    function Border(Index: TBorderId): String;
    function BorderIndex(const ABorder: String): TBorderId;
    function EdgeCount: Integer;
    procedure Flip;
    function Neighbor(Index: TBorderId): TTile;
    procedure RotateLeft;
  end;

  TMapData = array[1..MapSize] of String;

  TTiles = class(TObjectList<TTile>)
    Grid: array[0..GridSize - 1, 0..GridSize - 1] of TTile;
    MapData: TMapData;
    SeaMonster: array of TPoint;
    SeaMonsterWidth: Integer;
    SeaMonsterHeight: Integer;
    procedure CreateMapData;
    procedure Flip;
    function MultiplyCornerTileIds: Int64;
    procedure ReadSeaMonsterFromFile;
    procedure ReadTilesFromFile;
    procedure RotateLeft;
    function HabitatRoughness: Integer;
    function SeaMonsterCount: Integer;
    procedure SetupGridOfTiles;
    function TileWithBorder(const ABorder: String; Excl: TTile): TTile;
    function TopLeftCornerTile: TTile;
  end;

var
  Tiles: TTiles;

{ TTile }

procedure TTile.AlignAgainstLeftTile(const ItsRightBorder: String);
var
  Index: TBorderId;
  I: Integer;
begin
  Index := BorderIndex(ItsRightBorder);
  if Index < 4 then
    Flip;
  Index := BorderIndex(ReverseString(ItsRightBorder));
  for I := 0 to Index do
    RotateLeft;
end;

procedure TTile.AlignAgainstTopTile(const ItsBottomBorder: String);
var
  Index: TBorderId;
  I: Integer;
begin
  Index := BorderIndex(ItsBottomBorder);
  if Index < 4 then
    Flip;
  Index := BorderIndex(ReverseString(ItsBottomBorder));
  for I := 1 to Index do
    RotateLeft;
end;

function TTile.Border(Index: TBorderId): String;
var
  Y: Integer;
begin
  SetLength(Result, TileSize);
  case Index of
    0, 4:
      Result := TileData[1];
    1, 5:
      for Y := 1 to TileSize do
        Result[Y] := TileData[Y][TileSize];
    2, 6:
      Result := ReverseString(TileData[TileSize]);
    3, 7:
      for Y := 1 to TileSize do
        Result[Y] := TileData[TileSize + 1 - Y][1];
  end;
  if Index > 3 then
    Result := ReverseString(Result);
end;

function TTile.BorderIndex(const ABorder: String): TBorderId;
begin
  for Result := 0 to 7 do
    if Border(Result) = ABorder then
      Exit;
  Result := -1;
end;

function TTile.EdgeCount: Integer;
var
  Index: TBorderId;
begin
  Result := 0;
  for Index := 0 to 7 do
    if Neighbor(Index) = nil then
      Inc(Result);
end;

procedure TTile.Flip;
var
  Original: TTileData;
  X: Integer;
  Y: Integer;
begin
  Original := TileData;
  for X := 1 to TileSize do
    for Y := 1 to TileSize do
      TileData[X, Y] := Original[Y, X];
end;

function TTile.Neighbor(Index: TBorderId): TTile;
begin
  Result := Tiles.TileWithBorder(Border(Index), Self);
end;

procedure TTile.RotateLeft;
var
  Original: TTileData;
  X: Integer;
  Y: Integer;
begin
  Original := TileData;
  for X := 1 to TileSize do
    for Y := 1 to TileSize do
      TileData[X, Y] := Original[Y, TileSize + 1 - X];
end;

{ TTiles }

procedure TTiles.CreateMapData;
var
  GridY: Integer;
  TileY: Integer;
  MapY: Integer;
  GridX: Integer;
  TileX: Integer;
  MapX: Integer;
begin
  for GridY := 0 to GridSize -1 do
    for TileY := 2 to TileSize - 1 do
    begin
      MapY := GridY * (TileSize - 2) + TileY - 1;
      SetLength(MapData[MapY], MapSize);
      for GridX := 0 to GridSize -1 do
        for TileX := 2 to TileSize - 1 do
        begin
          MapX := GridX * (TileSize - 2) + TileX - 1;
          MapData[MapY][MapX] := Grid[GridX, GridY].TileData[TileY][TileX];
        end;
    end;
end;

procedure TTiles.Flip;
var
  Original: TMapData;
  X: Integer;
  Y: Integer;
begin
  Original := MapData;
  for X := 1 to MapSize do
    for Y := 1 to MapSize do
      MapData[X, Y] := Original[Y, X];
end;

function TTiles.HabitatRoughness: Integer;
var
  X: Integer;
  Y: Integer;
begin
  Result := 0;
  for X := 1 to MapSize do
    for Y := 1 to MapSize do
      if MapData[Y][X] = '#' then
        Inc(Result);
  Dec(Result, SeaMonsterCount * Length(SeaMonster));
end;

function TTiles.MultiplyCornerTileIds: Int64;
var
  Tile: TTile;
begin
  Result := 1;
  for Tile in Self do
    if Tile.EdgeCount = 4 then
      Result := Result * Tile.Id;
end;

procedure TTiles.ReadSeaMonsterFromFile;
var
  Input: TStringList;
  Y: Integer;
  X: Integer;
begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('seamonster.txt');
    for Y := 0 to Input.Count - 1 do
      for X := 1 to Length(Input[Y]) do
        if Input[Y][X] = '#' then
        begin
          SetLength(SeaMonster, Length(SeaMonster) + 1);
          SeaMonster[Length(SeaMonster) - 1] := Point(X - 1, Y);
        end;
    SeaMonsterWidth := Length(Input[0]);
    SeaMonsterHeight := Input.Count;
  finally
    Input.Free;
  end;
end;

procedure TTiles.ReadTilesFromFile;
var
  Input: TStringList;
  I: Integer;
  Tile: TTile;
  Y: Integer;
begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
    I := 0;
    repeat
      Tile := TTile.Create;
      Tile.Id := StrToInt(Copy(Input[I], 6, 4));
      for Y := 1 to TileSize do
        Tile.TileData[Y] := Input[I + Y];
      Add(Tile);
      Inc(I, 12);
    until (I >= Input.Count - 1);
  finally
    Input.Free;
  end;
end;

procedure TTiles.RotateLeft;
var
  Original: TMapData;
  X: Integer;
  Y: Integer;
begin
  Original := MapData;
  for X := 1 to MapSize do
    for Y := 1 to MapSize do
      MapData[X, Y] := Original[Y, MapSize + 1 - X];
end;

function TTiles.SeaMonsterCount: Integer;
var
  FlipCount: Integer;
  RotateCount: Integer;
  X: Integer;
  Y: Integer;
  I: Integer;
begin
  Result := 0;
  for FlipCount := 0 to 1 do
  begin
    for RotateCount := 0 to 3 do
    begin
      for Y := 1 to MapSize - SeaMonsterHeight + 1 do
        for X := 1 to MapSize - SeaMonsterWidth + 1 do
          for I := 0 to Length(SeaMonster) - 1 do
            if MapData[Y + SeaMonster[I].Y][X + SeaMonster[I].X] <> '#' then
              Break
            else if I = Length(SeaMonster) - 1 then
              Inc(Result);
      if Result = 0 then
        RotateLeft
      else
        Break;
    end;
    if Result = 0 then
      Flip
    else
      Break;
  end;
end;

procedure TTiles.SetupGridOfTiles;
var
  X: Integer;
  Y: Integer;
  Border: String;
begin
  Grid[0, 0] := TopLeftCornerTile;
  for X := 1 to GridSize - 1 do
  begin
    Border := Grid[X - 1, 0].Border(1);
    Grid[X, 0] := TileWithBorder(Border, Grid[X - 1, 0]);
    Grid[X, 0].AlignAgainstLeftTile(Border);
  end;
  for Y := 1 to 11 do
    for X := 0 to 11 do
    begin
      Border := Grid[X, Y - 1].Border(2);
      Grid[X, Y] := TileWithBorder(Border, Grid[X, Y - 1]);
      Grid[X, Y].AlignAgainstTopTile(Border);
    end;
end;

function TTiles.TileWithBorder(const ABorder: String; Excl: TTile): TTile;
begin
  for Result in Self do
    if Result <> Excl then
      if Result.BorderIndex(ABorder) > -1 then
        Exit;
  Result := nil;
end;

function TTiles.TopLeftCornerTile: TTile;
begin
  Result := nil;
  for Result in Self do
    if Result.EdgeCount = 4 then
      Break;
  while not ((Result.Neighbor(0) = nil) and (Result.Neighbor(3) = nil)) do
    Result.RotateLeft;
end;

begin
  Tiles := TTiles.Create;
  try
    Tiles.ReadTilesFromFile;
  { Part I }
    WriteLn('Part I: ', Tiles.MultiplyCornerTileIds);
  { Part II }
    Tiles.SetupGridOfTiles;
    Tiles.CreateMapData;
    Tiles.ReadSeaMonsterFromFile;
    WriteLn('Part II: ', Tiles.HabitatRoughness);
  finally
    Tiles.Free;
  end;
  ReadLn;
end.
