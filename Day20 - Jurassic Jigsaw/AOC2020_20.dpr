program AOC2020_20;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections;

type
  TWind = (N, E, S, W);
  TWise = (CW, CCW);

  TTile = record
    Grid: array[1..10, 1..10] of Char;
    Id: Integer;
    Border: array[TWind, TWise] of String;
    procedure BordersNeeded;
  end;

var
  Borders: TStringList;

procedure TTile.BordersNeeded;
var
  I: Integer;
  Wind: TWind;
  Wise: TWise;
begin
  Border[N, CW] := '';
  Border[E, CW] := '';
  Border[S, CCW] := '';
  Border[W, CCW] := '';
  for I := 1 to 10 do
  begin
    Border[N, CW] := Border[N, CW] + Grid[I, 1];
    Border[E, CW] := Border[E, CW] + Grid[10, I];
    Border[S, CCW] := Border[S, CCW] + Grid[I, 10];
    Border[W, CCW] := Border[W, CCW] + Grid[1, I];
  end;
  Border[N, CCW] := ReverseString(Border[N, CW]);
  Border[E, CCW] := ReverseString(Border[E, CW]);
  Border[S, CW] := ReverseString(Border[S, CCW]);
  Border[W, CW] := ReverseString(Border[W, CCW]);
  for Wind := Low(TWind) to High(TWind) do
    for Wise := Low(TWise) to High(TWise) do
      Borders.AddObject(Border[Wind, Wise], TObject(Id));
end;

var
  Input: TStringList;
  Tiles: TList<TTile>;

procedure ParseInput;
var
  I: Integer;
  Tile: TTile;
  X: Integer;
  Y: Integer;
begin
  I := 0;
  repeat
    Tile.Id := StrToInt(Copy(Input[I], 6, 4));
    for X := 1 to 10 do
      for Y := 1 to 10 do
        Tile.Grid[X, Y] := Input[I + Y][X];
    Tile.BordersNeeded;
    Tiles.Add(Tile);
    Inc(I, 12);
  until (I >= Input.Count - 1);
end;

var
  I: Integer;
  Edges: TStringList;
  Answer1: Int64 = 1;

begin
  Input := TStringList.Create;
  Tiles := TList<TTile>.Create;
  Borders := TStringList.Create;
  Edges := TStringList.Create;
  try
  { Part I }
    Input.LoadFromFile('input.txt');
    ParseInput;
    Borders.Sort;
    I := 1;
    repeat
      if Borders[I] <> Borders[I - 1] then
      begin
        Edges.Add(IntToStr(Integer(Borders.Objects[I - 1])));
        Inc(I);
      end
      else
        Inc(I, 2);
    until I >= Borders.Count;
    Edges.Sort;
    for I := 3 to Edges.Count - 1 do
      if (Edges[I - 3] = Edges[I - 2]) and (Edges[I - 2] = Edges[I - 1]) and
        (Edges[I - 1] = Edges[I]) then
      begin
        WriteLn(Edges[I].ToInt64);
        Answer1 := Answer1 * Edges[I].ToInt64;
      end;
    WriteLn('Part I: ', Answer1);
  finally
    Edges.Free;
    Borders.Free;
    Tiles.Free;
    Input.Free;
  end;
  ReadLn;
end.
