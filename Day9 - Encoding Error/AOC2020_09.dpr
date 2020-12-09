program AOC2020_09;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Math;

type
  TData = class(TList<Integer>)
    function TwoItemsSumUpTo(ASum: Integer): Boolean;
  end;

{ TData }

function TData.TwoItemsSumUpTo(ASum: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I in Self do
  begin
    Result := Contains(ASum - I);
    if Result then
      Break;
  end;
end;

var
  Input: TStringList;
  Data: TData;
  I: Integer;
  Answer1: Integer = -1;
  FromIndex: Integer = 0;
  MaxValue: Integer;
  MinValue: Integer;
  Sum: Integer;
  Answer2: Integer = 0;

begin
  Input := TStringList.Create;
  Data := TData.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    for I := 0 to 24 do
      Data.Add(Input[I].ToInteger);
    for I := 25 to Input.Count - 1 do
    begin
      Answer1 := Input[I].ToInteger;
      if not Data.TwoItemsSumUpTo(Answer1) then
        Break;
      Data.Delete(0);
      Data.Add(Answer1);
    end;
    WriteLn('Part I: ', Answer1);
  { Part II }
    while FromIndex < Input.Count - 1 do
    begin
      I := FromIndex;
      MaxValue := 0;
      MinValue := MaxInt;
      Sum := 0;
      while Sum < Answer1 do
      begin
        Inc(Sum, Input[I].ToInteger);
        MaxValue := Max(MaxValue, Input[I].ToInteger);
        MinValue := Min(MinValue, Input[I].ToInteger);
        Inc(I);
      end;
      if Sum = Answer1 then
      begin
        Answer2 := MinValue + MaxValue;
        Break;
      end;
      Inc(FromIndex);
    end;
    WriteLn('Part II: ', Answer2);
  finally
    Data.Free;
    Input.Free;
  end;
  ReadLn;
end.
