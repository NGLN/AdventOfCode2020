program AOC2020_16;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

type
  TIndex = 0..31;
  TIndices = set of TIndex;

  TField = class(TObject)
  private
    FIndices: TIndices;
  public
    Departure: Boolean;
    Lo1: Integer;
    Hi1: Integer;
    Lo2: Integer;
    Hi2: Integer;
    Index: Integer;
    constructor Create(const ALo1, AHi1, ALo2, AHi2: String);
    procedure ExcludeIndex(AIndex: TIndex);
    procedure IncludeIndices(AIndices: TIndices);
    function IndexCount: Integer;
    function ValueInRange(AValue: Integer): Boolean;
  end;

constructor TField.Create(const ALo1, AHi1, ALo2, AHi2: String);
begin
  Lo1 := ALo1.ToInteger;
  Hi1 := AHi1.ToInteger;
  Lo2 := ALo2.ToInteger;
  Hi2 := AHi2.ToInteger;
  Index := -1;
end;

procedure TField.ExcludeIndex(AIndex: TIndex);
var
  I: TIndex;
begin
  Exclude(FIndices, AIndex);
  if IndexCount = 1 then
    for I in FIndices do
      Index := I;
end;

procedure TField.IncludeIndices(AIndices: TIndices);
begin
  FIndices := AIndices
end;

function TField.IndexCount: Integer;
var
  I: TIndex;
begin
  Result := 0;
  for I in FIndices do
    Inc(Result);
end;

function TField.ValueInRange(AValue: Integer): Boolean;
begin
  Result := ((AValue >= Lo1) and (AValue <= Hi1)) or
    ((AValue >= Lo2) and (AValue <= Hi2));
end;

function StrArrToIntArr(AStrings: TArray<String>): TArray<Integer>;
var
  I: Integer;
begin
  SetLength(Result, Length(AStrings));
  for I := 0 to Length(AStrings) - 1 do
    Result[I] := AStrings[I].ToInteger;
end;

function CompareFields(const Left, Right: TField): Integer;
begin
  Result := Left.IndexCount - Right.IndexCount;
end;

var
  Input: TStringList;
  Fields: TObjectList<TField>;
  MyTicket: TArray<Integer>;
  Tickets: TList<TArray<Integer>>;

procedure ParseInput;
var
  I: Integer;
  S: String;
  Strings: TArray<String>;
begin
  Input.LoadFromFile('input.txt');
  I := 0;
  while Input[I] <> '' do
  begin
    S := Copy(Input[I], Pos(':', Input[I]) + 2, MaxInt);
    Strings := StringReplace(S, ' or ', '-', []).Split(['-']);
    Fields.Add(TField.Create(Strings[0], Strings[1], Strings[2], Strings[3]));
    Fields.Last.Departure := LeftStr(Input[I], 9) = 'departure';
    Inc(I);
  end;
  Inc(I, 2);
  MyTicket := StrArrToIntArr(Input[I].Split([',']));
  for I := I + 3 to Input.Count - 1 do
    Tickets.Add(StrArrToIntArr(Input[I].Split([','])));
end;

var
  I: Integer;
  J: Integer;
  K: Integer;
  Value: Integer;
  ValidTicket: Boolean;
  ValidField: Boolean;
  ErrorRate: Integer = 0;
  Answer2: Int64 = 1;

begin
  Input := TStringList.Create;
  Fields := TObjectList<TField>.Create(
    TComparer<TField>.Construct(CompareFields));
  Tickets := TList<TArray<Integer>>.Create;
  try
  { Part I }
    ParseInput;
    for I := Tickets.Count - 1 downto 0 do
    begin
      ValidTicket := True;
      for J := 0 to Length(Tickets[I]) - 1 do
      begin
        Value := Tickets[I][J];
        ValidField := False;
        for K := 0 to Fields.Count - 1 do
          if Fields[K].ValueInRange(Value) then
          begin
            ValidField := True;
            Break;
          end;
        if not ValidField then
        begin
          Inc(ErrorRate, Value);
          ValidTicket := False;
        end;
      end;
      if not ValidTicket then
        Tickets.Delete(I);
    end;
    WriteLn('Part I: ', ErrorRate);
  { Part II }
    Tickets.Add(MyTicket);
    for I := 0 to Fields.Count - 1 do
    begin
      Fields[I].IncludeIndices([0..Fields.Count - 1]);
      for J := 0 to Tickets.Count - 1 do
        for K := 0 to Fields.Count - 1 do
          if not Fields[I].ValueInRange(Tickets[J][K]) then
            Fields[I].ExcludeIndex(K);
    end;
    Fields.Sort;
    for I := 0 to Fields.Count - 1 do
      for J := 0 to Fields.Count - 1 do
        Fields[J].ExcludeIndex(Fields[I].Index);
    for I := 0 to Fields.Count - 1 do
      if Fields[I].Departure then
        Answer2 := Answer2 * MyTicket[Fields[I].Index];
    WriteLn('Part II: ', Answer2);
  finally
    Tickets.Free;
    Fields.Free;
    Input.Free;
  end;
  ReadLn;
end.
