program HentSnavs;
{ Af Christen Fihl, 42 17 52 73
  "Ufarligt" program
  Opret en fil uden indhold.
  Denne fil indeholder derfor hvad der
  oprindelig var p† disken p† samme plads
}

Uses Dos;

type  KByte= array[1..128,1..8] of char;
var   F: File of KByte;
      Free,P: Integer;

begin
  Free:=DiskFree(0) div 1024;
  writeLn('Henter gamle blokke fra disken');
  writeln('Der er ',Free,' KBytes frit p† disken');
  writeLn;
  repeat
    write('Hvor mange KByte skal der findes: '); readln(P);
  until (P>=0) and (P<=Free);
  if P=0 then HALT;                                             { Stop p† 0 }
  Assign(F,'Snavs'); Rewrite(F);
  Seek(F,P);                                      { S† stor skal filen v‘re }
  Truncate(F);                { Truncate er det samme som BlockWrite(F,B,0) }
  Close(F);
end.
