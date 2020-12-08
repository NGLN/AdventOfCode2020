program AOC2020_07;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TBag = class;

  TBagItem = record
    Count: Integer;
    Bag: TBag;
  end;

  TBag = class(TObject)
    Color: String;
    Items: array of TBagItem;
    Rule: String;
    constructor Create(ARule: String);
    function Contains(AColor: String): Integer;
    function Content: Integer;
  end;

  TBags = class(TObjectList<TBag>)
    function GetBagWithColor(AColor: String): TBag;
    procedure ResolveAllRules;
  end;

{ TBag }

{ Rules:
dull blue bags contain 2 dotted green bags, 1 dull brown bag, 3 striped tomato bags, 5 muted blue bags.
posh green bags contain no other bags. }

function TBag.Contains(AColor: String): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Length(Items) - 1 do
  begin
    if Items[I].Bag.Color = AColor then
      Inc(Result, Items[I].Count)
    else
      Inc(Result, Items[I].Bag.Contains(AColor));
  end;
end;

constructor TBag.Create(ARule: String);
begin
  Rule := ARule;
  Color := Copy(ARule, 1, Pos(' bags', ARule) - 1);
end;

function TBag.Content: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Length(Items) - 1 do
    Inc(Result, Items[I].Count * (1 + Items[I].Bag.Content));
end;

{ TBags }

function TBags.GetBagWithColor(AColor: String): TBag;
begin
  Result := nil;
  for Result in Self do
    if Result.Color = AColor then
      Break;
end;

procedure TBags.ResolveAllRules;
var
  Bag: TBag;
  S: String;
  I: Integer;
  A: TArray<String>;
  J: Integer;
  K: Integer;
begin
  for Bag in Self do
  begin
    S := Bag.Rule;
    System.Delete(S, 1, Pos('contain', S) + 7);
    if S <> 'no other bags.' then
    begin
      A := S.Split([', ']);
      SetLength(Bag.Items, Length(A));
      for I := 0 to Length(A) - 1 do
      begin
        J := Pos(' ', A[I]);
        Bag.Items[I].Count := StrToInt(Copy(A[I], 1, J - 1));
        K := Pos(' bag', A[I]);
        Bag.Items[I].Bag := GetBagWithColor(Copy(A[I], J + 1, K - J - 1));
      end;
    end;
  end;
end;

var
  Input: TStringList;
  Answer1: Integer = 0;
  Answer2: Integer;
  I: Integer;
  Bags: TBags;

begin
  Input := TStringList.Create;
  Bags := TBags.Create;
  try
    Input.LoadFromFile('input.txt');
    { Part I }
    for I := 0 to Input.Count - 1 do
      Bags.Add(TBag.Create(Input[I]));
    Bags.ResolveAllRules;
    for I := 0 to Bags.Count - 1 do
      if Bags[I].Contains('shiny gold') > 0 then
        Inc(Answer1);
    WriteLn('Part I: ', Answer1);
    { Part II }
    Answer2 := Bags.GetBagWithColor('shiny gold').Content;
    WriteLn('Part II: ', Answer2);
  finally
    Bags.Free;
    Input.Free;
  end;
  ReadLn;
end.
