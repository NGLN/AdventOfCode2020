program AOC2020_08;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes;

var
  Input: TStringList;
  Accumulator: Integer;
  I: Integer = 0;

function NormalRun(SwapIndex: Integer = -1): Boolean;
var
  I: Integer;
  Operation: String;
  Argument: Integer;
begin
  Input.LoadFromFile('input.txt');
  Input.Add('');
  I := 0;
  Accumulator := 0;
  repeat
    Input.Objects[I] := TObject(1);
    Operation := Copy(Input[I], 1, 3);
    Argument := StrToInt(Copy(Input[I], 5, MaxInt));
    if I = SwapIndex then
      if Operation = 'nop' then
        Operation := 'jmp'
      else if Operation = 'jmp' then
        Operation := 'nop';
    if Operation = 'acc' then
      Inc(Accumulator, Argument);
    if Operation = 'jmp' then
      Inc(I, Argument)
    else
      Inc(I);
    Result := Input.Objects[I] = nil;
  until (not Result) or (I = Input.Count - 1);;
end;

begin
  Input := TStringList.Create;
  try
  { Part I }
    NormalRun;
    WriteLn('Part I: ', Accumulator);
  { Part II }
    while not NormalRun(I) do
      Inc(I);
    WriteLn('Part II: ', Accumulator);
  finally
    Input.Free;
  end;
  ReadLn;
end.