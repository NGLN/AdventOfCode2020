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
    ContentRule: String;
    Items: array of TBagItem;
    function Contains(const AColor: String): Integer;
    function Content: Integer;
    constructor Create(const ABagRule: String);
  end;

  TBags = class(TObjectList<TBag>)
    function GetBagWithColor(const AColor: String): TBag;
    procedure ResolveAllRules;
  end;

{ TBag }

function TBag.Contains(const AColor: String): Integer;
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

constructor TBag.Create(const ABagRule: String);
const
  S: String = ' bags contain ';
begin
  Color := Copy(ABagRule, 1, Pos(S, ABagRule) - 1);
  ContentRule := Copy(ABagRule, Length(Color + S) + 1, Length(ABagRule));
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

function TBags.GetBagWithColor(const AColor: String): TBag;
begin
  Result := nil;
  for Result in Self do
    if Result.Color = AColor then
      Break;
end;

procedure TBags.ResolveAllRules;
var
  Bag: TBag;
  Rules: TArray<String>;
  I: Integer;
  J: Integer;
  K: Integer;
begin
  for Bag in Self do
    if Bag.ContentRule <> 'no other bags.' then
    begin
      Rules := Bag.ContentRule.Split([', ']);
      SetLength(Bag.Items, Length(Rules));
      for I := 0 to Length(Rules) - 1 do
      begin
        J := Pos(' ', Rules[I]);
        Bag.Items[I].Count := StrToInt(Copy(Rules[I], 1, J - 1));
        K := Pos(' bag', Rules[I]);
        Bag.Items[I].Bag := GetBagWithColor(Copy(Rules[I], J + 1, K - J - 1));
      end;
    end;
end;

var
  Input: TStringList;
  Bags: TBags;
  I: Integer;
  Answer1: Integer = 0;
  Answer2: Integer;

begin
  Input := TStringList.Create;
  Bags := TBags.Create;
  try
    Input.LoadFromFile('input.txt');
    for I := 0 to Input.Count - 1 do
      Bags.Add(TBag.Create(Input[I]));
    Bags.ResolveAllRules;
  { Part I }
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
