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
  for Rule in Values do
    for LoopNo := 1 to 3 do // A rule appears at most 3 times in a single rule
      if Rule.ContainsRule(ARule) then
        Rule.SubstituteRule(ARule);
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
    Rule.Index := StrToInt(Copy(Input[0], 1, I - 1));
    Rule.Pattern := ' ' + Copy(Input[0], I + 2, MaxInt) + ' ';
    if Rule.Pattern[2] = '"' then
      Rule.Pattern := Rule.Pattern[3];
    Rules.Add(Rule.Index, Rule);
    Input.Delete(0);
  end;
  Input.Delete(0);
end;

type
  TMessageValidator = function(const AMessage: String): Boolean;

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
  Pattern: String;
  M: Integer;
begin
  M := 1;
  repeat
//  Pattern := '(Pattern31){M}$'
    Pattern := '(' + Rules[31].Pattern + '){' + IntToStr(M) + '}$';
    Result := TRegEx.IsMatch(AMessage, Pattern, [roExplicitCapture]);
    if Result then
    begin
//    Pattern := '^(Pattern42){M+1,}(Pattern31){M}$'
      Pattern := '^(' + Rules[42].Pattern + '){' + IntToStr(M + 1) + ',}' +
        Pattern;
      if TRegEx.IsMatch(AMessage, Pattern, [roExplicitCapture]) then
        Exit(True);
    end;
    Inc(M);
  until not Result;
end;

function ValidMessageCount(Validator: TMessageValidator): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Input.Count - 1 do
    if Validator(Input[I]) then
      Inc(Result);
end;

begin
  Input := TStringList.Create;
  Rules := TRules.Create;
  try
    Input.LoadFromFile('input.txt');
    ParseInput;
    Rules.Resolve;
    WriteLn('Part I: ', ValidMessageCount(ValidMessage1));
    WriteLn('Part II: ', ValidMessageCount(ValidMessage2));
  finally
    Rules.Free;
    Input.Free;
  end;
  ReadLn;
end.
