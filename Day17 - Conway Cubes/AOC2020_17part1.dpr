program AOC2020_17part1;

{$APPTYPE CONSOLE}

uses
  System.Classes;

var
  Grid: array of array of array of array[Boolean] of Boolean;

function ReadCube(X, Y, Z: Integer; GenId: Integer): Boolean;
begin
  Result := Grid[X, Y, Z, Odd(GenId)];
end;

procedure WriteCube(X, Y, Z: Integer; Active: Boolean; GenId: Integer);
begin
  Grid[X, Y, Z, Odd(GenId)] := Active;
end;

function NeighborCount(AX, AY, AZ: Integer; GenId: Integer): Integer;
var
  X: Integer;
  Y: Integer;
  Z: Integer;
begin
  Result := 0;
  for X := AX - 1 to AX + 1 do
    for Y := AY - 1 to AY + 1 do
      for Z := AZ - 1 to AZ + 1 do
        if not ((X = AX) and (Y = AY) and (Z = AZ)) then
          if ReadCube(X, Y, Z, GenId) then
            Inc(Result);
end;

procedure Generate(GenId: Integer);
var
  X: Integer;
  Y: Integer;
  Z: Integer;
  Active: Boolean;
  NC: Integer;
begin
  for X := 1 to Length(Grid) - 2 do
    for Y := 1 to Length(Grid[X]) - 2 do
      for Z := 1 to Length(Grid[X, Y]) - 2 do
      begin
        Active := ReadCube(X, Y, Z, GenId - 1);
        NC := NeighborCount(X, Y, Z, GenId - 1);
        if Active and not ((NC = 2) or (NC = 3)) then
          WriteCube(X, Y, Z, False, GenId)
        else if not Active and (NC = 3) then
          WriteCube(X, Y, Z, True, GenId)
        else
          WriteCube(X, Y, Z, Active, GenId);
      end;
end;

function ActiveCount(GenId: Integer): Integer;
var
  X: Integer;
  Y: Integer;
  Z: Integer;
begin
  Result := 0;
  for X := 0 to Length(Grid) - 1 do
    for Y := 0 to Length(Grid[X]) - 1 do
      for Z := 0 to Length(Grid[X, Y]) - 1 do
        if ReadCube(X, Y, Z, GenId) then
          Inc(Result);
end;

var
  Input: TStringList;
  I: Integer;
  J: Integer;

begin
  Input := TStringList.Create;
  try
  { Part I }
    Input.LoadFromFile('input.txt');
    SetLength(Grid, Input.Count + 14, Length(Input[0]) + 14, 15);
    for I := 0 to Input.Count - 1 do
      for J := 1 to Length(Input[I]) do
        if Input[I][J] = '#' then
          WriteCube(J + 6, I + 7, 7, True, 0);
    for I := 1 to 6 do
      Generate(I);
    WriteLn('Part I: ', ActiveCount(6));
  finally
    Input.Free;
  end;
  ReadLn;
end.
