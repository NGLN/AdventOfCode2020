program AOC2020_18;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils;

type
  TValueCalculator = function(const Txt: String): Int64;

function CalcValue1(const Txt: String): Int64;
var
  Items: TArray<String>;
  I: Integer;
begin
  Items := Txt.Split([' ']);
  Result := Items[0].ToInteger;
  I := 1;
  repeat
    if Items[I] = '+' then
      Result := Result + Items[I + 1].ToInt64
    else {if Items[I] = '*' then}
      Result := Result * Items[I + 1].ToInt64;
    Inc(I, 2);
  until I = Length(Items);
end;

function CalcValue2(const Txt: String): Int64;
var
  Items: TArray<String>;
  I: Integer;
  Sum: Int64;
begin
  Items := Txt.Split([' ']);
  I := 1;
  repeat
    if Items[I] = '+' then
    begin
      Sum := Items[I - 1].ToInt64 + Items[I + 1].ToInt64;
      Items[I + 1] := Sum.ToString;
      Items[I - 1] := '1';
      Items[I] := '*';
    end;
    Inc(I, 2);
  until I = Length(Items);
  Result := Items[0].ToInteger;
  I := 1;
  repeat
    Result := Result * Items[I + 1].ToInt64;
    Inc(I, 2);
  until I = Length(Items);
end;

function ParseBrackets(var Txt: String; Calculator: TValueCalculator): Boolean;
var
  From: Integer;
  UpTo: Integer;
  Sub: String;
begin
  UpTo := Pos(')', Txt);
  Result := UpTo > 0;
  if Result then
  begin
    From := UpTo;
    repeat
      Dec(From);
    until Txt[From] = '(';
    Sub := Copy(Txt, From + 1, UpTo - From - 1);
    Txt := StuffString(Txt, From, UpTo - From + 1, Calculator(Sub).ToString);
  end;
end;

var
  Input: TStringList;
  I: Integer;
  Line: String;
  Answer1: Int64 = 0;
  Answer2: Int64 = 0;

begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    for I := 0 to Input.Count - 1 do
    begin
      Line := Input[I];
      while ParseBrackets(Line, CalcValue1) do ;
      Inc(Answer1, CalcValue1(Line));
    end;
    WriteLn('Part I: ', Answer1);
  { Part II }
    for I := 0 to Input.Count - 1 do
    begin
      Line := Input[I];
      while ParseBrackets(Line, CalcValue2) do ;
      Inc(Answer2, CalcValue2(Line));
    end;
    WriteLn('Part II: ', Answer2);
  finally
    Input.Free;
  end;
  ReadLn;
end.
