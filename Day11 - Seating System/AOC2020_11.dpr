program AOC2020_11;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils;

const
  DX = 0;
  DY = 1;

var
  Input: TStringList;
  RowCount: Integer;
  ColCount: Integer;
  Grid: array of array of Char;
  Delta: array[0..7] of array[DX..DY] of Integer = ((-1, -1), (0, -1), (1, -1),
    (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1));

type
  TOccupiedCounter = function(AX, AY: Integer): Integer;

function AdjacentOccupiedCount(AX, AY: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to 7 do
    if Grid[AX + Delta[I, DX], AY + Delta[I, DY]] = '#' then
      Inc(Result);
end;

function VisibleOccupiedCount(AX, AY: Integer): Integer;
var
  I: Integer;
  X: Integer;
  Y: Integer;
begin
  Result := 0;
  for I := 0 to 7 do
  begin
    X := AX;
    Y := AY;
    repeat
      Inc(X, Delta[I, DX]);
      Inc(Y, Delta[I, DY]);
      if Grid[X, Y] = '#' then
      begin
        Inc(Result);
        Break;
      end
      else if Grid[X, Y] = 'L' then
        Break;
    until (X = 0) or (Y = 0) or (X = ColCount - 1) or (Y = RowCount - 1);
  end;
end;

function ShuffleCount(OccupiedCount: TOccupiedCounter;
  LeaveThreshold: Integer): Integer;
var
  X: Integer;
  Y: Integer;
begin
  Result := 0;
  for Y := 0 to RowCount - 1 do
    for X := 0 to ColCount - 1 do
      Grid[X, Y] := Input[Y][X + 1];
  for Y := 1 to RowCount - 2 do
    for X := 1 to ColCount - 2 do
    begin
      if (Grid[X, Y] = 'L') and (OccupiedCount(X, Y) = 0) then
      begin
        Input[Y] := StuffString(Input[Y], X + 1, 1, '#');
        Inc(Result);
      end
      else if (Grid[X, Y] = '#') and
        (OccupiedCount(X, Y) >= LeaveThreshold) then
      begin
        Input[Y] := StuffString(Input[Y], X + 1, 1, 'L');
        Inc(Result);
      end
    end;
end;

function TotalOccupiedCount: Integer;
var
  X: Integer;
  Y: Integer;
begin
  Result := 0;
  for Y := 0 to RowCount - 1 do
    for X := 0 to ColCount - 1 do
      if Grid[X, Y] = '#' then
        Inc(Result);
end;

procedure AddGridBoundary;
var
  I: Integer;
begin
  Input.Insert(0, StringOfChar('.', Length(Input[0])));
  Input.Append(StringOfChar('.', Length(Input[0])));
  for I := 0 to Input.Count - 1 do
    Input[I] := '.' + Input[I] + '.';
end;

begin
  Input := TStringList.Create;
  try
  { Part I }
    Input.LoadFromFile('input.txt');
    AddGridBoundary;
    RowCount := Input.Count;
    ColCount := Length(Input[0]);
    SetLength(Grid, ColCount, RowCount);
    while ShuffleCount(AdjacentOccupiedCount, 4) > 0 do;
    WriteLn('Part I: ', TotalOccupiedCount);
  { Part II }
    Input.LoadFromFile('input.txt');
    AddGridBoundary;
    while ShuffleCount(VisibleOccupiedCount, 5) > 0 do;
    WriteLn('Part II: ', TotalOccupiedCount);
  finally
    Input.Free;
  end;
  ReadLn;
end.
