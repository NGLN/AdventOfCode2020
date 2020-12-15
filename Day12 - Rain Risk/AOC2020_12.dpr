program AOC2020_12;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Types;

type
  TPointHelper = record helper for TPoint
    function ManhattenDistance: Integer;
    procedure Move(WindDirection: Char; Value: Integer);
    procedure Rotate(Angle: Integer);
    procedure MoveBy(const APoint: TPoint; Multiplier: Integer);
  end;

function TPointHelper.ManhattenDistance: Integer;
begin
  Result := Abs(X) + Abs(Y);
end;

procedure TPointHelper.Move(WindDirection: Char; Value: Integer);
begin
  case WindDirection of
    'N': Inc(Y, Value);
    'S': Dec(Y, Value);
    'E': Inc(X, Value);
    'W': Dec(X, Value);
  end;
end;

procedure TPointHelper.MoveBy(const APoint: TPoint; Multiplier: Integer);
begin
  Inc(X, APoint.X * Multiplier);
  Inc(Y, APoint.Y * Multiplier);
end;

procedure TPointHelper.Rotate(Angle: Integer);
begin
  case Angle mod 360 of
    90, -270:
      SetLocation(Y, -X);
    180, -180:
      SetLocation(-X, -Y);
    270, -90:
      SetLocation(-Y, X);
  end;
end;

var
  Input: TStringList;
  I: Integer;
  Action: Char;
  Value: Integer;
  Heading: Integer;
  Ferry: TPoint = (X: 0; Y: 0);
  WayPoint: TPoint = (X: 10; Y: 1);

function HeadingToAction: Char;
begin
  case Heading mod 360 of
    0:
      Result := 'E';
    90, -270:
      Result := 'S';
    180, -180:
      Result := 'W';
    else
      Result := 'N';
  end;
end;

begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    for I := 0 to Input.Count - 1 do
    begin
      Action := Input[I][1];
      Value := StrToInt(Copy(Input[I], 2, MaxInt));
      case Action of
        'N', 'S', 'E', 'W':
          Ferry.Move(Action, Value);
        'L':
          Dec(Heading, Value);
        'R':
          Inc(Heading, Value);
        'F':
          Ferry.Move(HeadingToAction, Value);
      end;
    end;
    WriteLn('Part I: ', Ferry.ManhattenDistance);
  { Part II }
    Ferry.SetLocation(0, 0);
    for I := 0 to Input.Count - 1 do
    begin
      Action := Input[I][1];
      Value := StrToInt(Copy(Input[I], 2, MaxInt));
      case Action of
        'N', 'S', 'E', 'W':
          WayPoint.Move(Action, Value);
        'L':
          WayPoint.Rotate(-Value);
        'R':
          WayPoint.Rotate(Value);
        'F':
          Ferry.MoveBy(WayPoint, Value);
      end;
    end;
    WriteLn('Part II: ', Ferry.ManhattenDistance);
  finally
    Input.Free;
  end;
  ReadLn;
end.
