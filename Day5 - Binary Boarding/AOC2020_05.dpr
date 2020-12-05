program AOC2020_05;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Math;

var
  Input: TStringList;
  Answer1: Integer = 0;
  Answer2: Integer = 0;
  I: Integer;
  J: Integer;
  Row: Integer;
  Col: Integer;
  Seat: Integer;

begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
    { Part I }
    for I := 0 to Input.Count - 1 do
    begin
      Row := 0;
      for J := 0 to 6 do
        if Input[I][J + 1] = 'B' then
          Inc(Row, 1 shl (6 - J));
      Col := 0;
      for J := 0 to 2 do
        if Input[I][J + 7 + 1] = 'R' then
          Inc(Col, 1 shl (2 - J));
      Seat := 8 * Row + Col;
      Answer1 := Max(Answer1, Seat);
      Input[I] := Format('%.3d', [Seat]);
    end;
    WriteLn('Part I: ', Answer1);
    { Part II }
    Input.Sort;
    for I := 1 to Input.Count - 1 do
      if (StrToInt(Input[I]) - StrToInt(Input[I - 1])) = 2 then
        Answer2 := StrToInt(Input[I]) - 1;
    WriteLn('Part II: ', Answer2);
  finally
    Input.Free;
  end;
  ReadLn;
end.
