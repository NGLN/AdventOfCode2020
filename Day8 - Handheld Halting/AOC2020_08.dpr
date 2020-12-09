program AOC2020_08;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

var
  Input: TStringList;
  Accumulator: Integer;
  I: Integer;
  Operation: String;
  Argument: Integer;
  J: Integer = 0;

function NormalRun(SwapIndex: Integer = -1): Boolean;
begin
  Input.LoadFromFile('input.txt');
  Input.Add('');
  I := 0;
  Accumulator := 0;
  repeat
    Input.Objects[I] := TObject(1);
    Operation := Copy(Input[I], 1, 3);
    Argument := StrToInt(Copy(Input[I], 5, Length(Input[I])));
    if I = SwapIndex then
      if Operation = 'nop' then
        Operation := 'jmp'
      else if Operation = 'jmp' then
        Operation := 'nop';
    if Operation = 'acc' then
    begin
      Inc(Accumulator, Argument);
      Inc(I);
    end
    else if Operation = 'jmp' then
      Inc(I, Argument)
    else if Operation = 'nop' then
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
    while not NormalRun(J) do
      Inc(J);
    WriteLn('Part II: ', Accumulator);
  finally
    Input.Free;
  end;
  ReadLn;
end.
