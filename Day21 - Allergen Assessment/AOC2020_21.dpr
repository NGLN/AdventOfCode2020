program AOC2020_21;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TByteSet = set of Byte;

  TFood = class(TObject)
    Allergens: TStringList;
    Ingredients: TStringList;
    IngredientSet: TByteSet;
    constructor Create;
    destructor Destroy; override;
  end;

  TFoods = class(TObjectList<TFood>)
    Allergens: TStringList;
    Ingredients: TStringList;
    function CanonicalDangerousIngredientList: String;
    constructor Create;
    destructor Destroy; override;
    procedure IdentifyAllergens;
    function SafeIngredientMentionCount: Integer;
  end;

{ TFood }

constructor TFood.Create;
begin
  inherited Create;
  Allergens := TStringList.Create;
  Ingredients := TStringList.Create;
end;

destructor TFood.Destroy;
begin
  Ingredients.Free;
  Allergens.Free;
  inherited Destroy;
end;

{ TFoods }

function TFoods.CanonicalDangerousIngredientList: String;
var
  I: Integer;
  IngredientIndex: Integer;
begin
  Result := '';
  for I := 0 to Allergens.Count - 1 do
  begin
    IngredientIndex := Integer(Allergens.Objects[I]);
    if I > 0 then
      Result := Result + ',';
    Result := Result + Ingredients[IngredientIndex];
  end;
end;

constructor TFoods.Create;
begin
  inherited Create;
  Allergens := TStringList.Create;
  Allergens.Sorted := True;
  Allergens.Duplicates := dupIgnore;
  Ingredients := TStringList.Create;
  Ingredients.Sorted := True;
  Ingredients.Duplicates := dupIgnore;
end;

function NumberOfElements(ASet: TByteSet): Integer;
var
  I: Byte;
begin
  Result := 0;
  for I in ASet do
    Inc(Result);
end;

procedure TFoods.IdentifyAllergens;
var
  Food: TFood;
  Ingredient: String;
  LoopNo: Integer;
  Allergen: String;
  I: Byte;
  IngredientSet: TByteSet;
  J: Integer;
begin
  for Food in Self do
    for Ingredient in Food.Ingredients do
      Include(Food.IngredientSet, Ingredients.IndexOf(Ingredient));
  for LoopNo := 0 to Allergens.Count - 1 do
    for Allergen in Allergens do
    begin
      for I := 0 to Ingredients.Count - 1 do
        Include(IngredientSet, I);
      for Food in Self do
        if Food.Allergens.IndexOf(Allergen) > -1 then
          IngredientSet := IngredientSet * Food.IngredientSet;
      if NumberOfElements(IngredientSet) = 1 then
      begin
        J := Allergens.IndexOf(Allergen);
        if Allergens.Objects[J] = nil then
          for I in IngredientSet do
          begin
            Ingredients.Objects[I] := TObject(J);
            Allergens.Objects[J] := TObject(I);
            for Food in Self do
              Exclude(Food.IngredientSet, I);
          end;
      end;
    end;
end;

function TFoods.SafeIngredientMentionCount: Integer;
var
  Food: TFood;
  Ingredient: String;
  I: Integer;
begin
  Result := 0;
  IdentifyAllergens;
  for Food in Self do
    for Ingredient in Food.Ingredients do
    begin
      I := Ingredients.IndexOf(Ingredient);
      if Integer(Ingredients.Objects[I]) = -1 then
        Inc(Result);
    end;
end;

destructor TFoods.Destroy;
begin
  Ingredients.Free;
  Allergens.Free;
  inherited Destroy;
end;

var
  Input: TStringList;
  Foods: TFoods;

procedure ParseInput;
var
  I: Integer;
  P: Integer;
  Text: String;
  Strings: TArray<String>;
  Food: TFood;
  J: Integer;
begin
  Input.LoadFromFile('input.txt');
  for I := 0 to Input.Count - 1 do
  begin
    Food := TFood.Create;
    P := Pos(' (contains ', Input[I]);
    Text := Copy(Input[I], 1, P - 1);
    Strings := Text.Split([' ']);
    for J := 0 to Length(Strings) - 1 do
    begin
      Food.Ingredients.Add(Strings[J]);
      Foods.Ingredients.AddObject(Strings[J], TObject(-1));
    end;
    Text := Copy(Input[I], P + 11, Length(Input[I]) - P - 11);
    Strings := Text.Split([', ']);
    for J := 0 to Length(Strings) - 1 do
    begin
      Food.Allergens.Add(Strings[J]);
      Foods.Allergens.Add(Strings[J]);
    end;
    Foods.Add(Food);
  end;
end;

begin
  Input := TStringList.Create;
  Foods := TFoods.Create;
  try
    ParseInput;
  { Part I }
    WriteLn('Part I: ', Foods.SafeIngredientMentionCount);
  { Part II }
    WriteLn('Part II: ', Foods.CanonicalDangerousIngredientList);
  finally
    Foods.Free;
    Input.Free;
  end;
  ReadLn;
end.
