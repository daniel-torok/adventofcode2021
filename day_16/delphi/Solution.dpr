program Solution;

{$APPTYPE CONSOLE}

uses
  System.Math,
  System.SysUtils;

type TLiteralValueResult = record
  LiteralValue : String;
  Length       : Integer;
end;

type TParsePacketResult = record
  SumOfVersions : Integer;
  Length        : Integer;
  Value         : Int64;
end;

function HexToBin(const HexValue: String): String;
const
  BinaryValues: array [0..15] of String = (
    '0000', '0001', '0010', '0011',
    '0100', '0101', '0110', '0111',
    '1000', '1001', '1010', '1011',
    '1100', '1101', '1110', '1111'
  );
var
  HexDigitValue : Integer;
  Ptr           : PChar;
begin
  SetLength(Result, Length(HexValue) * 4);
  Ptr := Pointer(Result);
  for var HexDigit in HexValue do
  begin
    case HexDigit of
    '0'..'9':
      HexDigitValue := Ord(HexDigit) - Ord('0');
    'A'..'F':
      HexDigitValue := 10 + Ord(HexDigit) - Ord('A');
    else
      raise EConvertError.CreateFmt('Invalid hex digit ''%s'' found in ''%s''', [HexDigit, HexValue]);
    end;
    Move(Pointer(BinaryValues[HexDigitValue])^, Ptr^, 4 * SizeOf(Char));
    Inc(Ptr, 4);
  end;
end;

function Pow(const Base: Integer; const Exponent: Integer): Int64;
var
  TMP : Int64;
begin
  TMP := 1;
  for var I := 1 to Exponent do TMP := TMP * Base;
  Result := TMP;
end;

function BinToDec(const BinValue: String): Int64;
var
  Exponent : Integer;
begin
  Result := 0;
  for var I := 1 to Length(BinValue) do
  begin
    if '1' = BinValue[I] then
    begin
      Exponent := Length(BinValue) - I;
      Result := Result + Pow(2, Exponent);
    end;
  end;

end;

function ExtractLiteralValue(const BinData: String; const PacketIndex: Integer): TLiteralValueResult;
var
  Fragment, Buff   : String;
  I                : Integer;
begin
  I := 0;
  repeat
    Fragment := BinData.Substring(PacketIndex + I, 5);
    Inc(I, 5);
    Buff := Buff + Fragment.Substring(1, 4);
  until '0' = Fragment[1];
  Result.LiteralValue := Buff;
  Result.Length := I;
end;

function ParsePacket(const BinData: String; const _PacketIndex: Integer): TParsePacketResult;
var
  PacketVersion, PacketID  : Integer;
  PacketIndex              : Integer;
  LiteralValueResult       : TLiteralValueResult;
  FollowingPacketLength, FollowingPacketLength_BitLength : Integer;
  FollowingPacketCounter, ParsePacketResultCounter       : Integer;
  TMPParsePacketResult     : TParsePacketResult;
  ListOfParsePacketResults : array [0 .. 100] of TParsePacketResult;
  IncreaseAmount           : Integer;
  IsMeasuredInBits         : Boolean;
  TMPCalculation           : Int64;
begin
  PacketIndex := _PacketIndex;
  PacketVersion := BinToDec(BinData.Substring(PacketIndex, 3));
  Inc(PacketIndex, 3);
  Result.SumOfVersions := PacketVersion;

  PacketID := BinToDec(BinData.Substring(PacketIndex, 3));
  Inc(PacketIndex, 3);

  if 4 = PacketID then // Represents a literal value
  begin
    LiteralValueResult := ExtractLiteralValue(BinData, PacketIndex);
    Inc(PacketIndex, LiteralValueResult.Length);
    Result.Value := BinToDec(LiteralValueResult.LiteralValue);
  end
  else // Represents an operator
  begin
    IsMeasuredInBits := '0' = BinData[PacketIndex + 1];
    Inc(PacketIndex);

    if IsMeasuredInBits then FollowingPacketLength_BitLength := 15 else FollowingPacketLength_BitLength := 11;

    FollowingPacketLength := BinToDec(BinData.Substring(PacketIndex, FollowingPacketLength_BitLength));
    Inc(PacketIndex, FollowingPacketLength_BitLength);

    ParsePacketResultCounter := 0;
    FollowingPacketCounter := 0;
    repeat
      TMPParsePacketResult := ParsePacket(BinData, PacketIndex);
      Inc(PacketIndex, TMPParsePacketResult.Length);

      ListOfParsePacketResults[ParsePacketResultCounter] := TMPParsePacketResult;
      Inc(ParsePacketResultCounter);

      if IsMeasuredInBits then IncreaseAmount := TMPParsePacketResult.Length else IncreaseAmount := 1;
      Inc(FollowingPacketCounter, IncreaseAmount);

      Result.SumOfVersions := Result.SumOfVersions + TMPParsePacketResult.SumOfVersions;
    until FollowingPacketCounter = FollowingPacketLength;

    if 0 = PacketID then // +
    begin
      TMPCalculation := 0;
      for var I := 0 to ParsePacketResultCounter - 1 do
      begin
        TMPCalculation := TMPCalculation + ListOfParsePacketResults[I].Value;
      end;
    end
    else if 1 = PacketID then // *
    begin
      TMPCalculation := 1;
      for var I := 0 to ParsePacketResultCounter - 1 do TMPCalculation := TMPCalculation * ListOfParsePacketResults[I].Value;
    end
    else if 2 = PacketID then // min
    begin
      TMPCalculation := ListOfParsePacketResults[0].Value;
      for var I := 1 to ParsePacketResultCounter - 1 do TMPCalculation := min(TMPCalculation, ListOfParsePacketResults[I].Value);
    end
    else if 3 = PacketID then // max
    begin
      TMPCalculation := ListOfParsePacketResults[0].Value;
      for var I := 1 to ParsePacketResultCounter - 1 do TMPCalculation := max(TMPCalculation, ListOfParsePacketResults[I].Value);
    end
    else if 5 = PacketID then // >
    begin
      if ListOfParsePacketResults[0].Value > ListOfParsePacketResults[1].Value then
        TMPCalculation := 1
      else
        TMPCalculation := 0;
    end
    else if 6 = PacketID then // <
    begin
      if ListOfParsePacketResults[0].Value < ListOfParsePacketResults[1].Value then
        TMPCalculation := 1
      else
        TMPCalculation := 0;
    end
    else if 7 = PacketID then // =
    begin
      if ListOfParsePacketResults[0].Value = ListOfParsePacketResults[1].Value then
        TMPCalculation := 1
      else
        TMPCalculation := 0;
    end;


    Result.Value := TMPCalculation
  end; // end operator if

  Result.Length := PacketIndex - _PacketIndex;
end;

var HexData, BinData        : String;
var ParsePacketResult       : TParsePacketResult;

begin
  //HexData := '9C0141080250320F1802104A08';
  HexData := '4054460802532B12FEE8B180213B19FA5AA77601C010E4EC2571A9EDFE356C7008E7B141898C1F4E50DA7438C011D005E4F6E727B738FC40180CB3ED802323A8C3FED8C4E8844297D88C578C26008E004373BCA6B1C1C99945423798025800D0CFF7DC199C9094E35980253FB50A00D4C401B87104A0C8002171CE31C412010' +
'62C01393AE2F5BCF7B6E969F3C553F2F0A10091F2D719C00CD0401A8FB1C6340803308A0947B30056803361006615C468E4200E47E8411D26697FC3F91740094E164DFA0453F46899015002A6E39F3B9802B800D04A24CC763EDBB4AFF923A96ED4BDC01F87329FA491E08180253A4DE0084C5B7F5B978CC410012F9CFA84C9' +
'3900A5135BD739835F00540010F8BF1D22A0803706E0A47B3009A587E7D5E4D3A59B4C00E9567300AE791E0DCA3C4A32CDBDC4830056639D57C00D4C401C8791162380021108E26C6D991D10082549218CDC671479A97233D43993D70056663FAC630CB44D2E380592FB93C4F40CA7D1A60FE64348039CE0069E5F565697D59' +
'424B92AF246AC065DB01812805AD901552004FDB801E200738016403CC000DD2E0053801E600700091A801ED20065E60071801A800AEB00151316450014388010B86105E13980350423F447200436164688A4001E0488AC90FCDF31074929452E7612B151803A200EC398670E8401B82D04E31880390463446520040A44AA71' +
'C25653B6F2FE80124C9FF18EDFCA109275A140289CDF7B3AEEB0C954F4B5FC7CD2623E859726FB6E57DA499EA77B6B68E0401D996D9C4292A881803926FB26232A133598A118023400FA4ADADD5A97CEEC0D37696FC0E6009D002A937B459BDA3CC7FFD65200F2E531581AD80230326E11F52DFAEAAA11DCC01091D8BE0039B' +
'296AB9CE5B576130053001529BE38CDF1D22C100509298B9950020B309B3098C002F419100226DC';
  BinData := HexToBin(HexData);

  ParsePacketResult := ParsePacket(BinData, 0);
  Writeln('Part one: ' + IntToStr(ParsePacketResult.SumOfVersions));
  Writeln('Part two: ' + IntToStr(ParsePacketResult.Value));

  Sleep(50000); // To keep to window open ...
end.

