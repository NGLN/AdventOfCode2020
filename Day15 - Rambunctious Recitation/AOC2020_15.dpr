program AOC2020_15;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

var
  Input: TStringList;
  Numbers1: TList<Integer>;
  I: Integer;
  PrevIndex: Integer;
  Numbers2: TDictionary<Integer, Integer>;
  NewIndex: Integer;
  LastNumber: Integer;

function IndexOfListExclLast(AValue: Integer): Integer;
begin
  for Result := Numbers1.Count - 2 downto 0 do
    if Numbers1[Result] = AValue then
      Exit;
  Result := -1;
end;

begin
  Input := TStringList.Create;
  Numbers1 := TList<Integer>.Create;
  Numbers2 := TDictionary<Integer, Integer>.Create;
  try
  { Part I }
    Numbers1.Capacity := 2020;
    Input.CommaText := '1,20,11,6,12,0';
    for I := 0 to Input.Count - 1 do
      Numbers1.Add(Input[I].ToInteger);
    repeat
      PrevIndex := IndexOfListExclLast(Numbers1.Last);
      if PrevIndex = -1 then
        Numbers1.Add(0)
      else
        Numbers1.Add(Numbers1.Count - 1 - PrevIndex);
    until Numbers1.Count = 2020;
    WriteLn('Part I: ', Numbers1.Last);
  { Part II }
    for I := 0 to Input.Count - 2 do
    begin
      LastNumber := Input[I].ToInteger;
      Numbers2.Add(LastNumber, I);
    end;
    NewIndex := Input.Count - 1;
    LastNumber := Input[NewIndex].ToInteger;
    repeat
      if Numbers2.TryGetValue(LastNumber, PrevIndex) then
      begin
        Numbers2.AddOrSetValue(LastNumber, NewIndex);
        LastNumber := NewIndex - PrevIndex;
      end
      else
      begin
        Numbers2.Add(LastNumber, NewIndex);
        LastNumber := 0;
      end;
      Inc(NewIndex);
    until NewIndex = 30000000 - 1;
    WriteLn('Part II: ', LastNumber);
  finally
    Numbers2.Free;
    Numbers1.Free;
    Input.Free;
  end;
  ReadLn;
end.
