program AOC2020_22;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TPlayer = class(TQueue<Integer>)
    procedure AddCardsFrom(APlayer: TPlayer; ACount: Integer);
    procedure EnqueueCards(First, Second: Integer);
    function Hand: String;
    function Score: Integer;
  end;

procedure TPlayer.AddCardsFrom(APlayer: TPlayer; ACount: Integer);
var
  I: Integer;
begin
  for I in APlayer do
    if Count < ACount then
      Enqueue(I);
end;

procedure TPlayer.EnqueueCards(First, Second: Integer);
begin
  Enqueue(First);
  Enqueue(Second);
end;

function TPlayer.Hand: String;
var
  I: Integer;
begin
  Result := '';
  for I in Self do
    Result := Result + ',' + I.ToString;
end;

function TPlayer.Score: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Count downto 1 do
    Inc(Result, I * Dequeue);
end;

function PlayGame(Player1, Player2: TPlayer; PartII: Boolean): TPlayer;
var
  Card1: Integer;
  Card2: Integer;
  NewPlayer1: TPlayer;
  NewPlayer2: TPlayer;
  Hands1: TStringList;
  Hands2: TStringList;
  Hand1: String;
  Hand2: String;
begin
  Hands1 := TStringList.Create;
  Hands2 := TStringList.Create;
  try
    while (Player1.Count > 0) and (Player2.Count > 0) do
    begin
      Hand1 := Player1.Hand;
      Hand2 := Player2.Hand;
      if (Hands1.IndexOf(Hand1) > -1) or (Hands2.IndexOf(Hand2) > -1) then
        Exit(Player1);
      Hands1.Add(Hand1);
      Hands2.Add(Hand2);
      Card1 := Player1.Dequeue;
      Card2 := Player2.Dequeue;
      if PartII and (Player1.Count >= Card1) and (Player2.Count >= Card2) then
      begin
        NewPlayer1 := TPlayer.Create;
        NewPlayer2 := TPlayer.Create;
        try
          NewPlayer1.AddCardsFrom(Player1, Card1);
          NewPlayer2.AddCardsFrom(Player2, Card2);
          if PlayGame(NewPlayer1, NewPlayer2, True) = NewPlayer1 then
            Player1.EnqueueCards(Card1, Card2)
          else
            Player2.EnqueueCards(Card2, Card1);
        finally
          NewPlayer2.Free;
          NewPlayer1.Free;
        end;
      end
      else
      begin
        if Card1 > Card2 then
          Player1.EnqueueCards(Card1, Card2)
        else
          Player2.EnqueueCards(Card2, Card1);
      end;
    end;
    if Player1.Count = 0 then
      Result := Player2
    else
      Result := Player1;
  finally
    Hands2.Free;
    Hands1.Free;
  end;
end;

var
  Input: TStringList;
  Player1: TPlayer;
  Player2: TPlayer;
  Winner: TPlayer;

procedure Reset;
var
  I: Integer;
begin  
  Player1.Clear;
  Player2.Clear;
  Input.LoadFromFile('input.txt');
  for I := 1 to 25 do
    Player1.Enqueue(Input[I].ToInteger);
  for I := 28 to 52 do
    Player2.Enqueue(Input[I].ToInteger);
end;

begin
  Input := TStringList.Create;
  Player1 := TPlayer.Create;
  Player2 := TPlayer.Create;
  try
  { Part I }
    Reset;
    Winner := PlayGame(Player1, Player2, False);
    WriteLn('Part I: ', Winner.Score);
  { Part II }
    Reset;
    Winner := PlayGame(Player1, Player2, True);
    WriteLn('Part II: ', Winner.Score);
  finally
    Player2.Free;
    Player1.Free;
    Input.Free;
  end;
  ReadLn;
end.
