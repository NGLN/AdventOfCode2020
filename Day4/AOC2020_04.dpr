program AOC2020_04;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils;

var
  Answer1: Integer;
  Answer2: Integer;
  Input: TStringList;
  PassText: String;
  Passport: TStringList;
  I: Integer;
  J: Integer;
  Keys: array[0..6] of String =
    ('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid');
  EyeColors: array[0..6] of String =
    ('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth');
  Valid: Boolean;
  S: String;
  V: Integer;

begin
  Input := TStringList.Create;
  Passport := TStringList.Create;
  try
    Input.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
    Input.Add('');
    { Part I }
    Answer1 := 0;
    for I := 0 to Input.Count - 1 do
    begin
      if Input[I] = '' then
      begin
        Valid := True;
        for J := Low(Keys) to High(Keys) do
          if Pos(Keys[J], PassText) = 0 then
          begin
            Valid := False;
            Break;
          end;
        if Valid then
          Inc(Answer1);
        PassText := '';
      end
      else
        PassText := PassText + ' ' + Input[I];
    end;
    WriteLn('Part I: ', Answer1);
    { Part II }
    Answer2 := 0;
    Passport.NameValueSeparator := ':';
    for I := 0 to Input.Count - 1 do
    begin
      if Input[I] <> '' then
      begin
        PassText := PassText + ' ' + Input[I];
        Continue;
      end;
      Passport.DelimitedText := PassText;
      PassText := '';
      { Birth year }
      S := Passport.Values['byr'];
      if (not TryStrToInt(S, V)) or (V < 1920) or (V > 2002) then
        Continue;
      { Issue year }
      S := Passport.Values['iyr'];
      if (not TryStrToInt(S, V)) or (V < 2010) or (V > 2020) then
        Continue;
      { Expiration year }
      S := Passport.Values['eyr'];
      if (not TryStrToInt(S, V)) or (V < 2020) or (V > 2030) then
        Continue;
      { Height }
      S := Passport.Values['hgt'];
      if RightStr(S, 2) = 'cm' then
      begin
        if (not TryStrToInt(LeftStr(S, 3), V)) or (V < 150) or (V > 193) then
          Continue;
      end
      else if RightStr(S, 2) = 'in' then
      begin
        if (not TryStrToInt(LeftStr(S, 2), V)) or (V < 59) or (V > 76) then
          Continue;
      end
      else
        Continue;
      { Hair color }
      S := Passport.Values['hcl'];
      if (Length(S) <> 7) or (S[1] <> '#') or
          (not TryStrToInt('$' + RightStr(S, 6), V)) then
        Continue;
      { Eye color }
      S := Passport.Values['ecl'];
      Valid := False;
      for J := Low(EyeColors) to High(EyeColors) do
        if S = EyeColors[J] then
          Valid := True;
      if not Valid then
        Continue;
      { Passport ID }
      S := Passport.Values['pid'];
      if (Length(S) <> 9) or (not TryStrToInt(S, V)) then
        Continue;
      Inc(Answer2);
    end;
    WriteLn('Part II: ', Answer2);
  finally
    Passport.Free;
    Input.Free;
  end;
  ReadLn;
end.
