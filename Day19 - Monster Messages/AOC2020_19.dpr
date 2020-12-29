program AOC2020_19;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.RegularExpressions;

type
  TRule = class(TObject)
    Definition: String;
    Index: Integer;
    Substituted: Boolean;
    function ContainsRule: Boolean; overload;
    function ContainsRule(ARule: TRule): Boolean; overload;
    procedure SubstituteRule(ARule: TRule);
  end;

  TRules = class(TObjectList<TRule>)
    function RegExPattern: String;
    procedure Resolve;
    procedure SubstituteRule(ARule: TRule);
  end;

{ TRule }

function TRule.ContainsRule: Boolean;
var
  C: Char;
begin
  Result := False;
  for C in Definition do
    if CharInSet(C, ['0'..'9']) then
      Exit(True);
end;

function TRule.ContainsRule(ARule: TRule): Boolean;
begin
  Result := Pos(' ' + IntToStr(ARule.Index) + ' ', Definition) > 0;
end;

procedure TRule.SubstituteRule(ARule: TRule);
var
  S: String;
  I: Integer;
  L: Integer;
begin
  S := ' ' + IntToStr(ARule.Index) + ' ';
  I := Pos(S, Definition) + 1;
  L := Length(S) - 2;
  if Length(ARule.Definition) > 1 then
    Definition := StuffString(Definition, I, L, '(' + ARule.Definition + ')')
  else
    Definition := StuffString(Definition, I, L, ARule.Definition);
end;

{ TRules }

function TRules.RegExPattern: String;
begin
  Result := Items[0].Definition;
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := '^' + Result + '$';
end;

procedure TRules.Resolve;
var
  Done: Boolean;
  Rule: TRule;
begin
  Done := False;
  while not Done do
  begin
    Done := True;
    for Rule in Self do
      if not Rule.Substituted and not Rule.ContainsRule then
      begin
        SubstituteRule(Rule);
        Rule.Substituted := True;
        Done := False;
      end;
  end;
end;

procedure TRules.SubstituteRule(ARule: TRule);
var
  LoopNo: Integer;
  Rule: TRule;
begin
  for LoopNo := 1 to 3 do // A rule appears at most 3 times in a single rule
    for Rule in Self do
      if Rule.ContainsRule(ARule) then
        Rule.SubstituteRule(ARule);
end;

function CompareRules(const Left, Right: TRule): Integer;
begin
  Result := Left.Index - Right.Index;
end;

var
  Input: TStringList;
  Rules: TRules;

procedure ParseInput;
var
  I: Integer;
  Rule: TRule;
begin
  while Input[0] <> '' do
  begin
    I := Pos(':', Input[0]);
    Rule := TRule.Create;
    Rule.Index := Copy(Input[0], 1, I - 1).ToInteger;
    Rule.Definition := ' ' + Copy(Input[0], I + 2, MaxInt) + ' ';
    if Rule.Definition[2] = '"' then
      Rule.Definition := Rule.Definition[3];
    Rules.Add(Rule);
    Input.Delete(0);
  end;
  Input.Delete(0);
end;

var
  RegEx: TRegEx;
  I: Integer;
  Answer1: Integer = 0;

begin
  Input := TStringList.Create;
  Rules := TRules.Create(TComparer<TRule>.Construct(CompareRules));
  try
    Input.LoadFromFile('input.txt');
    ParseInput;
  { Part I }
    Rules.Sort;
    Rules.Resolve;
    RegEx := TRegEx.Create(Rules.RegExPattern, [roExplicitCapture]);
    for I := 0 to Input.Count - 1 do
      if RegEx.IsMatch(Input[I], 1) then
        Inc(Answer1);
    WriteLn('Part I: ', Answer1);
  { Part II }

    WriteLn('Part II: ', '');
  finally
    Rules.Free;
    Input.Free;
  end;
  ReadLn;
end.
