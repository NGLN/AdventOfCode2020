program AOC2020_11;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils;

var
  Input: TStringList;
  RowCount: Integer;
  ColCount: Integer;
  Grid: array of array of Char;

function AdjacentOccupiedCount(AX, AY: Integer): Integer;

  function Occup(DeltaX, DeltaY: Integer): Boolean;
  begin
    Result := Grid[AX + DeltaX, AY + DeltaY] = '#';
  end;

begin
  Result := 0;
  if (AX > 0) and (AY > 0) and Occup(- 1, - 1) then
    Inc(Result);
  if (AX > 0) and Occup(- 1, 0) then
    Inc(Result);
  if (AX > 0) and (AY < RowCount - 1) and Occup(- 1, 1) then
    Inc(Result);
  if (AX < ColCount - 1) and (AY > 0) and Occup(1, - 1) then
    Inc(Result);
  if (AX < ColCount - 1) and Occup(1, 0) then
    Inc(Result);
  if (AX < ColCount - 1) and (AY < RowCount - 1) and Occup(1, 1) then
    Inc(Result);
  if (AY > 0) and Occup(0, - 1) then
    Inc(Result);
  if (AY < RowCount - 1) and Occup(0, 1) then
    Inc(Result);
end;

function ShuffleCount: Integer;
var
  X: Integer;
  Y: Integer;
begin
  Result := 0;
  for Y := 0 to RowCount - 1 do
    for X := 0 to ColCount - 1 do
      Grid[X, Y] := Input[Y][X + 1];
  for Y := 0 to RowCount - 1 do
    for X := 0 to ColCount - 1 do
    begin
      if (Grid[X, Y] = 'L') and (AdjacentOccupiedCount(X, Y) = 0) then
      begin
        Input[Y] := StuffString(Input[Y], X + 1, 1, '#');
        Inc(Result);
      end
      else if (Grid[X, Y] = '#') and (AdjacentOccupiedCount(X, Y) >= 4) then
      begin
        Input[Y] := StuffString(Input[Y], X + 1, 1, 'L');
        Inc(Result);
      end
    end;
end;

function OccupiedCount: Integer;
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

const
  DX = 0;
  DY = 1;

var
  Dirs: array[0..7] of array[DX..DY] of Integer = ((-1, -1), (0, -1), (1, -1),
    (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1));

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
      Inc(X, Dirs[I, DX]);
      Inc(Y, Dirs[I, DY]);
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

function ReshuffleCount: Integer;
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
      if (Grid[X, Y] = 'L') and (VisibleOccupiedCount(X, Y) = 0) then
      begin
        Input[Y] := StuffString(Input[Y], X + 1, 1, '#');
        Inc(Result);
      end
      else if (Grid[X, Y] = '#') and (VisibleOccupiedCount(X, Y) >= 5) then
      begin
        Input[Y] := StuffString(Input[Y], X + 1, 1, 'L');
        Inc(Result);
      end
    end;
end;

begin
  Input := TStringList.Create;
  try
  { Part I }
    Input.LoadFromFile('input.txt');
    RowCount := Input.Count;
    ColCount := Length(Input[0]);
    SetLength(Grid, ColCount, RowCount);
    while ShuffleCount > 0 do;
    WriteLn('Part I: ', OccupiedCount);
  { Part II }
    Input.LoadFromFile('input.txt');
    AddGridBoundary;
    RowCount := Input.Count;
    ColCount := Length(Input[0]);
    SetLength(Grid, ColCount, RowCount);
    while ReshuffleCount > 0 do;
    WriteLn('Part II: ', OccupiedCount);
  finally
    Input.Free;
  end;
  ReadLn;
end.
