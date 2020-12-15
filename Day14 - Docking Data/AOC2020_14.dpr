program AOC2020_14;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.Generics.Collections,
  System.StrUtils;

function IntToBin(AValue: UInt64): String;
const
  Bits: array[Boolean] of Char = ('0', '1');
var
  I: Integer;
  BitMask: UInt64;
begin
  SetLength(Result, 36);
  BitMask := UInt64(1) shl 35;
  for I := 1 to 36 do
  begin
    Result[I] := Bits[(AValue and BitMask) <> 0];
    BitMask := BitMask shr 1;
  end;
end;

function BinToInt(AValue: String): UInt64;
var
  I: Integer;
begin
  Result := UInt64(0);
  for I := 1 to 36 do
    if AValue[I] = '1' then
      Inc(Result, UInt64(1) shl (36 - I));
end;

var
  Memory: TDictionary<UInt64, UInt64>;

procedure MaskWrite(const AMask: String; AAddress, AValue: UInt64);
var
  I: Integer;
  BitMask: UInt64;
  NewValue: UInt64;
begin
  NewValue := 0;
  BitMask := UInt64(1) shl 35;
  for I := 1 to 36 do
  begin
    case AMask[I] of
      '0': ;
      '1': Inc(NewValue, BitMask);
      'X': Inc(NewValue, AValue and BitMask);
    end;
    BitMask := BitMask shr 1;
  end;
  Memory.AddOrSetValue(AAddress, NewValue);
end;

procedure MultiWrite(Index: Integer; const AAddress: String; AValue: UInt64);
begin
  if Index = 37 then
    Memory.AddOrSetValue(BinToInt(AAddress), AValue)
  else if AAddress[Index] = 'X' then
  begin
    MultiWrite(Index + 1, StuffString(AAddress, Index, 1, '0'), AValue);
    MultiWrite(Index + 1, StuffString(AAddress, Index, 1, '1'), AValue);
  end
  else
    MultiWrite(Index + 1, AAddress, AValue);
end;

procedure FloatWrite(const AMask: String; AAddress, AValue: UInt64);
var
  I: Integer;
  NewAddress: String;
begin
  NewAddress := IntToBin(AAddress);
  for I := 1 to 36 do
    case AMask[I] of
      '0': ;
      '1': NewAddress[I] := '1';
      'X': NewAddress[I] := 'X';
    end;
  MultiWrite(1, NewAddress, AValue);
end;

var
  Input: TStringList;
  I: UInt64;
  Mask: String;
  Address: UInt64;
  Value: UInt64;
  SumOfValues: UInt64 = 0;

begin
  Input := TStringList.Create;
  Memory := TDictionary<UInt64, UInt64>.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    for I := 0 to Input.Count - 1 do
      if Input[I][2] = 'a' then
        Mask := Copy(Input[I], 8, 36)
      else
      begin
        Address := StrToInt(Copy(Input[I], 5, Pos(']', Input[I]) - 5));
        Value := StrToInt(Copy(Input[I], Pos('=', Input[I]) + 2, MaxInt));
        MaskWrite(Mask, Address, Value);
      end;
    for I in Memory.Keys do
      Inc(SumOfValues, Memory[I]);
    WriteLn('Part I: ', SumOfValues);
  { Part II }
    SumOfValues := 0;
    Memory.Clear;
    for I := 0 to Input.Count - 1 do
      if Input[I][2] = 'a' then
        Mask := Copy(Input[I], 8, 36)
      else
      begin
        Address := StrToInt(Copy(Input[I], 5, Pos(']', Input[I]) - 5));
        Value := StrToInt(Copy(Input[I], Pos('=', Input[I]) + 2, MaxInt));
        FloatWrite(Mask, Address, Value);
      end;
    for I in Memory.Keys do
      Inc(SumOfValues, Memory[I]);
    WriteLn('Part II: ', SumOfValues);
  finally
    Memory.Free;
    Input.Free;
  end;
  ReadLn;
end.
