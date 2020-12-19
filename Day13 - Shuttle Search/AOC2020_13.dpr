program AOC2020_13;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TBus = record
    Id: UInt64;
    Delay: UInt64;
    constructor Create(AId, ADelay: UInt64);
  end;

constructor TBus.Create(AId, ADelay: UInt64);
begin
  Id := AId;
  Delay := ADelay;
end;

var
  Input: TStringList;
  Estimate: Integer;
  I: Integer;
  BusId: Integer = -1;
  MyBusId: Integer = -1;
  WaitTime: Integer = MaxInt;
  TimeStamp: UInt64;
  Busses: TList<TBus>;
  StepSize: UInt64;

begin
  Input := TStringList.Create;
  Busses := TList<TBus>.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    Estimate := Input[0].ToInteger;
    Input.CommaText := Input[1];
    for I := 0 to Input.Count - 1 do
    begin
      if Input[I] <> 'x' then
        BusId := Input[I].ToInteger;
        if (BusId - Estimate mod BusId) < WaitTime then
        begin
          MyBusId := BusId;
          WaitTime := BusId - Estimate mod BusId;
        end;
    end;
    WriteLn('Part I: ', MyBusId * WaitTime);
  { Part II }
    // Solution gotten by writing out a bus Id list of 5,8,3,11,7 in Excel
    // for TimeStamps up to 420. By then the solution presents itself.
    for I := 0 to Input.Count - 1 do
      if Input[I] <> 'x' then
        Busses.Add(TBus.Create(Input[I].ToInteger, I));
    StepSize := Busses[0].Id;
    TimeStamp := 0;
    for I := 1 to Busses.Count - 1 do
    begin
      while (TimeStamp + Busses[I].Delay) mod Busses[I].Id <> 0 do
        Inc(TimeStamp, StepSize);
      StepSize := StepSize * Busses[I].Id;
      WriteLn(TimeStamp);
    end;
    WriteLn('Part II: ', TimeStamp);
  finally
    Busses.Free;
    Input.Free;
  end;
  ReadLn;
end.
