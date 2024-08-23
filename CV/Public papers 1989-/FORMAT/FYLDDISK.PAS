program FyldDisk;
{ Af Christen Fihl
  "Ufarligt" program
  Sletter den ubrugte del af disken.
  Skriver til en fil indtil disken er fuld.
  Derefter slettes filen
}
Uses Dos;

const Monster: string[64]=
'- slettet af Christen Fihl      - slettet af Christen Fihl    '#13#10; {32+30+2}
type  KByte= array[1..16,1..64] of char;
var   B: KByte;
      F: File of KByte;
      M,N: Integer;
begin
  for N:=1 to 16 do Move(Monster[1],B[N],SizeOf(B[N]));      { Fyld m›nster }
  Assign(F,'Slettet.$$$'); Rewrite(F);
  N:=DiskFree(0) div 1024;
  for M:=1 to N do begin
    write(^H^H^H^H^H,N-M:5);
    write(F,B);                             { Fyld disken med dette m›nster }
  end;
  writeln(#13'Ok   '^G);                                   { Dyt n†r F‘rdig }
  Close(F);
  Erase(F);                                               { Slet filen igen }
end.
