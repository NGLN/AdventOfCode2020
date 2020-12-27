program AOC2020_24;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections,
  System.Types,
  System.Math;

const
  Delta: array[0..5] of record             //         \/    \/    \/    \/
    S: String;                             //          | -,+ | 0,+ | +,+ |
    DX: Integer;                           //         /\    /\    /\    /
    DY: Integer;                           //        /  \  /  \  /  \  /
  end = ((S: 'e';  DX:  1; DY:  0),        //       /    \/    \/    \/
         (S: 'se'; DX:  1; DY: -1),        //       | -,0 | 0,0 | +,0 |
         (S: 'sw'; DX:  0; DY: -1),        //      /\    /\    /\    /
         (S: 'w';  DX: -1; DY:  0),        //     /  \  /  \  /  \  /
         (S: 'nw'; DX: -1; DY:  1),        //    /    \/    \/    \/
         (S: 'ne'; DX:  0; DY:  1));       //    | -,- | 0,- | +,- |
  DaysOfGrowth = 100;                      //   /\    /\    /\    /\

var
  BlackTiles: TList<TPoint>;
  Input: TStringList;
  MaxStepCount: Integer = 0;
  Lobby: array of array of array[Boolean] of Boolean;

function ReadTile(X, Y: Integer; GenId: Integer): Boolean;
begin
  Result := Lobby[X, Y, Odd(GenId)];
end;

procedure WriteTile(X, Y: Integer; Black: Boolean; GenId: Integer);
begin
  Lobby[X, Y, Odd(GenId)] := Black;
end;

procedure ParseLine(const Steps: String);
var
  P: TPoint;
  I: Integer;
  Step: String;
  J: Integer;
begin
  P := Point(0, 0);
  I := 1;
  while I <= Length(Steps) do
  begin
    Step := Steps[I];
    if (Step <> 'e') and (Step <> 'w') then
      Step := Step + Steps[I + 1];
    for J := 0 to 5 do
      if Delta[J].S = Step then
        P.Offset(Delta[J].DX, Delta[J].DY);
    Inc(I, Length(Step));
  end;
  if BlackTiles.Contains(P) then
    BlackTiles.Remove(P)
  else
    BlackTiles.Add(P);
  MaxStepCount := Max(MaxStepCount, Length(Steps));
end;

function NeighborBlackCount(AX, AY: Integer; GenId: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to 5 do
    if ReadTile(AX + Delta[I].DX, AY + Delta[I].DY, GenId) then
      Inc(Result);
end;

procedure Generate(GenId: Integer);
var
  X: Integer;
  Y: Integer;
  Black: Boolean;
  NBC: Integer;
begin
  for X := 1 to Length(Lobby) - 2 do
    for Y := 1 to Length(Lobby[X]) - 2 do
    begin
      Black := ReadTile(X, Y, GenId - 1);
      NBC := NeighborBlackCount(X, Y, GenId - 1);
      if Black and ((NBC = 0) or (NBC > 2)) then
        WriteTile(X, Y, False, GenId)
      else if not Black and (NBC = 2) then
        WriteTile(X, Y, True, GenId)
      else
        WriteTile(X, Y, Black, GenId);
    end;
end;

function BlackCount(GenId: Integer): Integer;
var
  X: Integer;
  Y: Integer;
begin
  Result := 0;
  for X := 0 to Length(Lobby) - 1 do
    for Y := 0 to Length(Lobby[X]) - 1 do
      if ReadTile(X, Y, GenId) then
        Inc(Result);
end;

var
  I: Integer;
  Center: TPoint;
  DayNo: Integer;

begin
  Input := TStringList.Create;
  BlackTiles := TList<TPoint>.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    for I := 0 to Input.Count - 1 do
      ParseLine(Input[I]);
    WriteLn('Part I: ', BlackTiles.Count);
  { Part II }
    Center := Point(DaysOfGrowth + MaxStepCount, DaysOfGrowth + MaxStepCount);
    SetLength(Lobby, 2 * Center.X, 2 * Center.Y);
    for I := 0 to BlackTiles.Count - 1 do
      WriteTile(Center.X + BlackTiles[I].X, Center.Y + BlackTiles[I].Y, True,
        0);
    for DayNo := 1 to DaysOfGrowth do
      Generate(DayNo);
    WriteLn('Part II: ', BlackCount(DaysOfGrowth));
  finally
    BlackTiles.Free;
    Input.Free;
  end;
  ReadLn;
end.
