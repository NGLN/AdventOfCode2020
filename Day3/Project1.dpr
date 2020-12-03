program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.Classes;

const
  X = 0;
  Y = 1;

var
  List: TStringList;
  Col: Integer;
  Row: Integer;
  ColCount: Integer;
  RowCount: Integer;
  Answer1: Integer;
  Answer2: Int64;
  Slopes: array[0..4] of array[X..Y] of Integer =
    ((1, 1), (3, 1), (5, 1), (7, 1), (1, 2));
  I: Integer;
  J: Integer;

begin
  List := TStringList.Create;
  try
    List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
    ColCount := Length(List[0]);
    RowCount := List.Count;
    { Part I }
    Answer1 := 0;
    for Row := 0 to RowCount - 1 do
    begin
      Col := 1 + ((Row * 3) mod ColCount);
      if List[Row][Col] = '#' then
        Inc(Answer1);
    end;
    WriteLn(Answer1);
    { Part II }
    Answer2 := 1;
    for I := Low(Slopes) to High(Slopes) do
    begin
      Answer1 := 0;
      for J := 0 to (RowCount - 1) div Slopes[I, Y] do
      begin
        Row := J * Slopes[I, Y];
        Col := 1 + ((J * Slopes[I, X]) mod ColCount);
        if List[Row][Col] = '#' then
          Inc(Answer1);
      end;
      WriteLn(Answer1);
      Answer2 := Answer2 * Answer1;
    end;
    WriteLn(Answer2);
  finally
    List.Free;
  end;
  ReadLn;
end.
