program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Classes, System.SysUtils;

var
  List: TStringList;
  I: Integer;
  J: Integer;
  Answer1: Integer;
  Answer2: Integer;

begin
  List := TStringList.Create;
  try
    List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
    List.Sort;
    { Part I }
    for I := 0 to List.Count - 1 do
      if List.IndexOf(IntToStr(2020 - StrToInt(List[I]))) > 0 then
      begin
        Answer1 := StrToInt(List[I]);
        WriteLn(Answer1);
        WriteLn(2020 - Answer1);
        WriteLn(Answer1 * (2020 - Answer1));
      end;
    { Part II }
    for I := 0 to List.Count - 1 do
    begin
      Answer1 := StrToInt(List[I]);
      for J := 0 to List.Count - 1 do
      begin
        Answer2 := StrToInt(List[J]);
        if List.IndexOf(IntToStr(2020 - Answer2 - Answer1)) > 0 then
        begin
          WriteLn(Answer1);
          WriteLn(Answer2);
          WriteLn(2020 - Answer2 - Answer1);
          WriteLn(Answer1 * Answer2 * (2020 - Answer2 - Answer1));
        end;
      end;
    end;
  finally
    List.Free;
  end;
  ReadLn;
end.
