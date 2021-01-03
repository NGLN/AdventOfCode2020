program AOC2020_23;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections;

const
  MaxLabel = 1000000;
  Input = '253149867';
//  Input = '389125467'; {AoC test input}
//  3 8 9 1 2 5 4 6 7       Current = 3
//  3       2 5 4 6 7       Destination = 2
//  3 2       5 4 6 7
//  3 2 8 9 1 5 4 6 7
//    2 8 9 1 5 4 6 7 3     Current = 2
//    2       5 4 6 7 3     Destination = 1 > 9 > 8 > 7
//    2 5 4 6 7       3
//    2 5 4 6 7 8 9 1 3
//      5 4 6 7 8 9 1 3 2   Current = 5

type
  TLabel = Integer;

  TCups1 = class(TList<TLabel>)
    CurrentIndex: Integer;
    function LabelsAfter1: String;
    procedure Move;
    procedure ReadFromInput;
  end;

  TCups2 = class(TObject)
    Current: TLabel;
    Nexts: array[1..MaxLabel] of TLabel;
    procedure Move;
    function MultiplyTwoCupsAfterOne: Int64;
    procedure ReadFromInput;
  end;

function TCups1.LabelsAfter1: String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to 8 do
    Result := Result + IntToStr(Items[I]);
  I := Pos('1', Result);
  Result := Copy(Result, I + 1, 9) + Copy(Result, 1, I - 1);
end;

procedure TCups1.Move;
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

procedure TCups1.ReadFromInput;
var
  I: Integer;
begin
  for I := 1 to Length(Input) do
    Add(StrToInt(Input[I]));
end;

procedure TCups2.Move;
var
  Cup1: TLabel;
  Cup2: TLabel;
  Cup3: TLabel;
  DestCup: TLabel;

  function Destination: TLabel;
  begin
    Result := Current - 1;
    while (Result = Cup1) or (Result = Cup2) or (Result = Cup3) or
      (Result = 0) do
    begin
      Dec(Result);
      if Result <= 0 then
        Result := MaxLabel;
    end;
  end;

begin
  Cup1 := Nexts[Current];
  Cup2 := Nexts[Cup1];
  Cup3 := Nexts[Cup2];
  DestCup := Destination;
  Nexts[Current] := Nexts[Cup3];
  Nexts[Cup3] := Nexts[DestCup];
  Nexts[DestCup] := Cup1;
  Current := Nexts[Current];
end;

function TCups2.MultiplyTwoCupsAfterOne: Int64;
begin
  Result := Nexts[1];
  Result := Result * Nexts[Result];
end;

procedure TCups2.ReadFromInput;
var
  L: Integer;
  I: Integer;
  Cup: TLabel;
  NextCup: TLabel;
begin
  L := Length(Input);
  for I := 1 to MaxLabel do
  begin
    if I < L then
    begin
      Cup := StrToInt(Input[I]);
      NextCup := StrToInt(Input[I + 1]);
    end
    else if I = L then
    begin
      Cup := StrToInt(Input[I]);
      NextCup := L + 1;
    end
    else if I < MaxLabel then
    begin
      Cup := I;
      NextCup := I + 1;
    end
    else // I = MaxLabel
    begin
      Cup := I;
      NextCup := StrToInt(Input[1]);
    end;
    Nexts[Cup] := NextCup;
  end;
  Current := StrToInt(Input[1]);
end;

var
  Cups1: TCups1;
  I: Integer;
  Cups2: TCups2;

begin
{ Part I }
  Cups1 := TCups1.Create;
  try
    Cups1.ReadFromInput;
    for I := 1 to 100 do
      Cups1.Move;
    WriteLn('Part I: ', Cups1.LabelsAfter1);
  finally
    Cups1.Free;
  end;
{ Part II }
  Cups2 := TCups2.Create;
  try
    Cups2.ReadFromInput;
    for I := 1 to 10000000 do
      Cups2.Move;
    WriteLn('Part II: ', Cups2.MultiplyTwoCupsAfterOne);
  finally
    Cups2.Free;
  end;
  ReadLn;
end.
