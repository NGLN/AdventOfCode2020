program AOC2020_23;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections;

type
  TLabel = Integer;

  TCups = class(TList<TLabel>)
    CurrentIndex: Integer;
    function AsText: String;
    function LabelsAfter1: String;
    procedure Move1;
    procedure Move2;
    procedure PrepareForPartII;
    procedure ReadFromInput;
  end;

{ TCups }

function TCups.AsText: String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to 8 do
    Result := Result + Items[I].ToString;
end;

procedure TCups.PrepareForPartII;
var
  I: TLabel;
begin
  Capacity := 10000000 + 1000000;
  for I := 10 to 1000000 do
    Add(I);
end;

function TCups.LabelsAfter1: String;
var
  I: Integer;
begin
  Result := AsText;
  I := Pos('1', Result);
  Result := Copy(Result, I + 1, 9) + Copy(Result, 1, I - 1);
end;

procedure TCups.Move1;
var
  Current: TLabel;
  Draws: array[0..2] of TLabel;
  I: Integer;
  Dest: TLabel;
  DestIndex: Integer;
begin
  CurrentIndex := 0;
  Current := Items[CurrentIndex];
  for I := 0 to 2 do
    Draws[I] := ExtractAt(1);
  Dest := Current;
  repeat
    Dec(Dest);
    if Dest = 0 then
      Dest := 9;
    DestIndex := IndexOf(Dest);
  until DestIndex > -1;
  InsertRange(DestIndex + 1, Draws, 3);
  Add(ExtractAt(CurrentIndex));
end;

const
  Input = '253149867'; {aoc input}
//  Input = '123456789'; {aoc test input}
//  Input = '428619375';  {my test input}
{
4 2 8 6 1 9 3 7 5         Current = 4
4       1 9 3 7 5         Dest = 3
4 1 9 3       7 5
4 1 9 3 2 8 6 7 5
  1 9 3 2 8 6 7 5 4       Current = 1
  1       8 6 7 5 4       Dest = 8
  1 8       6 7 5 4
  1 8 9 3 2 6 7 5 4
    8 9 3 2 6 7 5 4 1     Current = 8
}

procedure TCups.Move2;
var
  Current: TLabel;
  Draws: array[0..2] of TLabel;
  I: Integer;
  Dest: TLabel;

  function CalcDestination: TLabel;
  var
    J: Integer;
    K: Integer;
  begin
    Result := Current - 1;
    for J := 0 to 2 do
    begin
      for K := 0 to 2 do
        if Result = Draws[K] then
          Dec(Result);
      if Result = 0 then
        Result := 1000000;
    end;
  end;

begin
  Current := Items[CurrentIndex];
  for I := 0 to 2 do
    Draws[I] := Items[CurrentIndex + 1 + I];
  Dest := CalcDestination;
  I := CurrentIndex;
  repeat
    Inc(I);
    Items[I] := Items[I + 3];
  until Items[I + 3] = Dest;
  Items[I + 1] := Draws[0];
  Items[I + 2] := Draws[1];
  Items[I + 3] := Draws[2];
  Add(Current);
  Inc(CurrentIndex);
end;

procedure TCups.ReadFromInput;
var
  I: Integer;
begin
  for I := 1 to Length(Input) do
    Add(StrToInt(Input[I]));
end;

var
  Cups: TCups;
  I: Integer;

begin
  Cups := TCups.Create;
  try
    Cups.ReadFromInput;
  { Part I }
    for I := 1 to 100 do
      Cups.Move1;
    WriteLn('Part I: ', Cups.LabelsAfter1);
  { Part II }
    Cups.Clear;
    Cups.ReadFromInput;
    Cups.PrepareForPartII;
    for I := 1 to 10000000 do
      Cups.Move2;
    WriteLn('Part II: ', 'This takes way too long!!!');
  finally
    Cups.Free;
  end;
  ReadLn;
end.
