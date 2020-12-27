program AOC2020_25;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils;

const
//  PublicKey1 = 5764801;
//  PublicKey2 = 17807724;
  PublicKey1 = 8458505;
  PublicKey2 = 16050997;

function Transform(Value, SubjectNo: UInt64): UInt64;
begin
  Result := Value * SubjectNo;
  Result := Result mod 20201227;
end;

function EncryptionKey(APublicKey, ALoopSize: UInt64): UInt64;
var
  I: UInt64;
begin
  Result := 1;
  for I := 1 to ALoopSize do
    Result := TransForm(Result, APublicKey);
end;

function LoopSize(AKey, SubjectNo: UInt64): UInt64;
var
  Key: UInt64;
begin
  Result := 0;
  Key := 1;
  while Key <> AKey do
  begin
    Inc(Result);
    Key := Transform(Key, SubjectNo);
  end;
end;

var
  LoopSize1: UInt64;
  LoopSize2: UInt64;
  EncryptionKey1: UInt64;
  EncryptionKey2: UInt64;

begin
{ Part I }
//  LoopSize1 := LoopSize(PublicKey1, 7);
  LoopSize2 := LoopSize(PublicKey2, 7);
  EncryptionKey1 := EncryptionKey(PublicKey1, LoopSize2);
//  EncryptionKey2 := EncryptionKey(PublicKey2, LoopSize1);
  WriteLn('Part I: ', EncryptionKey1);
{ Part II }


  WriteLn('Part II: ', '');
  ReadLn;
end.
