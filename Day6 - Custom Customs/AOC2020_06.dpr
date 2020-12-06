program AOC2020_06;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

var
  Input: TStringList;
  Answer1: Integer = 0;
  Answer2: Integer = 0;
  I: Integer;
  J: Integer;
  GroupQuestions: TSysCharSet;
  AllQuestions: TSysCharSet = ['a'..'z'];
  PersonQuestions: TSysCharSet;

function QuestionCount: Integer;
var
  Question: AnsiChar;
begin
  Result := 0;
  for Question in GroupQuestions do
    Inc(Result);
end;

begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
    Input.Add('');
    { Part I }
    for I := 0 to Input.Count - 1 do
    begin
      if Input[I] = '' then
      begin
        Inc(Answer1, QuestionCount);
        GroupQuestions := [];
      end
      else
        for J := 1 to Length(Input[I]) do
          Include(GroupQuestions, AnsiChar(Input[I][J]));
    end;
    WriteLn('Part I: ', Answer1);
    { Part II }
    GroupQuestions := AllQuestions;
    for I := 0 to Input.Count - 1 do
    begin
      if Input[I] = '' then
      begin
        Inc(Answer2, QuestionCount);
        GroupQuestions := AllQuestions;
      end
      else
      begin
        PersonQuestions := [];
        for J := 1 to Length(Input[I]) do
          Include(PersonQuestions, AnsiChar(Input[I][J]));
        GroupQuestions := GroupQuestions * PersonQuestions;
      end;
    end;
    WriteLn('Part II: ', Answer2);
  finally
    Input.Free;
  end;
  ReadLn;
end.
