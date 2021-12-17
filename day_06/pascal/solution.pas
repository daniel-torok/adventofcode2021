program Solution;

{$APPTYPE CONSOLE}
{$mode objFPC}

uses
  Sysutils;

  function ReadLine(name: String): AnsiString;
  var
    fileIn : TextFile;
  begin
    AssignFile(fileIn, name);
    Reset(fileIn);
    Readln(fileIn, Result);
    CloseFile(fileIn);
  end;

  function Iterate(counter: array of Int64; iterations: Integer): Int64;
  var
    tmp   : Int64;
    IT, I : Integer;
  begin
    for IT := 1 to iterations do
    begin
      counter[7] := counter[7] + counter[0];
      tmp := counter[0];
      for I := 0 to Length(counter) - 2 do
        counter[I] := counter[I + 1];
      counter[Length(Counter) - 1] := tmp;
    end;

    Result := 0;
    for I := 0 to Length(counter) - 1 do
      Result := Result + counter[I];
  end;

const
  C_FNAME = 'input.data';

var
  line    : AnsiString;
  counter : array of Int64 = (0, 0, 0, 0, 0, 0, 0, 0, 0);
  I       : Integer;
begin
  line := ReadLine(C_FNAME);
  for I := 1 to Length(line) do
  begin
    if line[I] = ',' then continue;
    counter[StrToInt(line[I])] := counter[StrToInt(line[I])] + 1;
  end;

  Writeln('First: ' + IntToStr(Iterate(Copy(counter, 0, 9), 80)));
  Writeln('First: ' + IntToStr(Iterate(Copy(counter, 0, 9), 256)));
end.
