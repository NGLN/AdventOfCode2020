program AOC2020_19;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections,
  System.RegularExpressions;

type
  TRule = class(TObject)
    Pattern: String;
    Index: Integer;
    Substituted: Boolean;
    function ContainsRule: Boolean; overload;
    function ContainsRule(ARule: TRule): Boolean; overload;
    procedure SubstituteRule(ARule: TRule);
  end;

  TRules = class(TObjectDictionary<Integer, TRule>)
    procedure Resolve;
    procedure SubstituteRule(ARule: TRule);
  end;

{ TRule }

function TRule.ContainsRule: Boolean;
var
  C: Char;
begin
  Result := False;
  for C in Pattern do
    if CharInSet(C, ['0'..'9']) then
      Exit(True);
end;

function TRule.ContainsRule(ARule: TRule): Boolean;
begin
  Result := Pos(' ' + IntToStr(ARule.Index) + ' ', Pattern) > 0;
end;

procedure TRule.SubstituteRule(ARule: TRule);
var
  S: String;
  I: Integer;
  L: Integer;
begin
  S := ' ' + IntToStr(ARule.Index) + ' ';
  I := Pos(S, Pattern) + 1;
  L := Length(S) - 2;
  if Length(ARule.Pattern) > 2 then
    Pattern := StuffString(Pattern, I, L, '(' + ARule.Pattern + ')')
  else
    Pattern := StuffString(Pattern, I, L, ARule.Pattern);
end;

{ TRules }

procedure TRules.Resolve;
var
  Done: Boolean;
  Rule: TRule;
begin
  Done := False;
  while not Done do
  begin
    Done := True;
    for Rule in Values do
      if not Rule.Substituted and not Rule.ContainsRule then
      begin
        Rule.Pattern := StringReplace(Rule.Pattern, ' ', '', [rfReplaceAll]);
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
    for Rule in Values do
      if Rule.ContainsRule(ARule) then
        Rule.SubstituteRule(ARule);
end;

var
  Messages: TStringList;
  Rules: TRules;

procedure ParseInput;
var
  I: Integer;
  Rule: TRule;
begin
  while Messages[0] <> '' do
  begin
    I := Pos(':', Messages[0]);
    Rule := TRule.Create;
    Rule.Index := StrToInt(Copy(Messages[0], 1, I - 1));
    Rule.Pattern := ' ' + Copy(Messages[0], I + 2, MaxInt) + ' ';
    if Rule.Pattern[2] = '"' then
      Rule.Pattern := Rule.Pattern[3];
    Rules.Add(Rule.Index, Rule);
    Messages.Delete(0);
  end;
  Messages.Delete(0);
end;

function ValidMessage1(const AMessage: String): Boolean;
var
  Pattern: String;
  RegEx: TRegEx;
begin
  Pattern := '^' + Rules[0].Pattern + '$';
  RegEx := TRegEx.Create(Pattern, [roExplicitCapture]);
  Result := RegEx.IsMatch(AMessage);
end;

function ValidMessage2(const AMessage: String): Boolean;
// Rule 8: 42 | 42 8
// Rule 8: n*42              ; n>0
// Rule 11: 42 31 | 42 11 31
// Rule 11: m*42 m*31        ; m>0
// Rule 0: 8 11
// Rule 0: n*42 m*42 m*31    ; n>0, m>0
// Rule 0: n*42 m*31         ; n>m, m>0
var
  Input: String;
  Pattern: String;
  RegEx: TRegEx;
  M: Integer;
begin
  Input := AMessage;
  M := 1;
  repeat
    // Pattern := '^(Pattern42){M+1,}(Pattern31){M}$'
    Pattern := '(' + Rules[31].Pattern + '){' + IntToStr(M) + '}$';
    RegEx := TRegEx.Create(Pattern, [roExplicitCapture]);
    Result := RegEx.IsMatch(Input);
    if Result then
    begin
      Pattern := '^(' + Rules[42].Pattern + '){' + IntToStr(M + 1) + ',}' +
        Pattern;
      RegEx := TRegEx.Create(Pattern, [roExplicitCapture]);
      if RegEx.IsMatch(Input) then
        Exit(True);
      Inc(M);
    end;
  until not Result;
end;

var
  I: Integer;
  Answer1: Integer = 0;
  Answer2: Integer = 0;

begin
  Messages := TStringList.Create;
  Rules := TRules.Create;
  try
    Messages.LoadFromFile('input.txt');
    ParseInput;
    Rules.Resolve;
  { Part I }
    for I := 0 to Messages.Count - 1 do
      if ValidMessage1(Messages[I]) then
        Inc(Answer1);
    WriteLn('Part I: ', Answer1);
  { Part II }
    for I := 0 to Messages.Count - 1 do
      if ValidMessage2(Messages[I]) then
        Inc(Answer2);
    WriteLn('Part II: ', Answer2);
  finally
    Rules.Free;
    Messages.Free;
  end;
  ReadLn;
end.
