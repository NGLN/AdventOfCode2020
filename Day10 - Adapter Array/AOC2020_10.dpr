program AOC2020_10;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

var
  Input: TStringList;
  I: Integer;
  DiffCounts: array[1..3] of Integer;
  Answer1: Integer;
  BranchCounts: array of Int64;
  Answer2: Int64;

function CompareStrAsInt(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := List[Index1].ToInteger - List[Index2].ToInteger;
end;

function DoubleBranch(Index: Integer): Boolean;
begin
  if Index >= Input.Count - 2 then
    Result := False
  else
    Result := Input[Index + 2].ToInteger <= Input[Index].ToInteger + 3;
end;

function TrippleBranch(Index: Integer): Boolean;
begin
  if Index >= Input.Count - 3 then
    Result := False
  else
    Result := Input[Index + 3].ToInteger = Input[Index].ToInteger + 3;
end;

begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
    Input.Add('0');
    Input.CustomSort(CompareStrAsInt);
  { Part I }
    for I := 1 to Input.Count - 1 do
      Inc(DiffCounts[Input[I].ToInteger - Input[I - 1].ToInteger]);
    Inc(DiffCounts[3]);
    Answer1 := DiffCounts[1] * DiffCounts[3];
    WriteLn('Part I: ', Answer1);
  { Part II }
    SetLength(BranchCounts, Input.Count);
    BranchCounts[Input.Count - 1] := 1;
    for I := Input.Count - 2 downto 0 do
    begin
      if TrippleBranch(I) then
        BranchCounts[I] := BranchCounts[I + 1] + BranchCounts[I + 2] +
          BranchCounts[I + 3]
      else if DoubleBranch(I) then
        BranchCounts[I] := BranchCounts[I + 1] + BranchCounts[I + 2]
      else
        BranchCounts[I] := BranchCounts[I + 1];
    end;
    Answer2 := BranchCounts[0];
    WriteLn('Part II: ', Answer2);
  finally
    Input.Free;
  end;
  ReadLn;
end.
