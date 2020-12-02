program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Classes, System.SysUtils;

var
  List: TStringList;
  I: Integer;
  Entry: String;
  J: Integer;
  Min: Integer;
  K: Integer;
  Max: Integer;
  Ch: Char;
  Pw: String;
  Count: Integer;
  Answer1: Integer = 0;
  Answer2: Integer = 0;

function CountCharsInStr(AChar: Char; AStr: String): Integer;
var
  C: Char;
begin
  Result := 0;
  for C in AStr do
    if C = AChar then
      Inc(Result);
end;

begin
  List := TStringList.Create;
  try
    List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
    for I := 0 to List.Count - 1 do
    begin
      Entry := List[I];
      J := Pos('-', Entry);
      Min := StrToInt(Copy(Entry, 1, J - 1));
      K := Pos(' ', Entry);
      Max := StrToInt(Copy(Entry, J + 1, K - J - 1));
      Ch := Entry[K + 1];
      Pw := Copy(Entry, K + 4, Length(Entry));
      Count := CountCharsInStr(Ch, Pw);
      { Part I }
      if (Count >= Min) and (Count <= Max) then
        Inc(Answer1);
      { Part II }
      if (Pw[Min] = Ch) xor (Pw[Max] = Ch) then
        Inc(Answer2);
    end;
    WriteLn(Answer1);
    WriteLn(Answer2);
  finally
    List.Free;
  end;
  ReadLn;
end.
