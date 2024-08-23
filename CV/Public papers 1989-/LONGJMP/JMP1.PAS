Program JMP1Test;
{ Eksempel p† brug af SetJMP/LongJMP
  Det er s† simpelt, at man lige s† godt kunne have brugt en almindelige GOTO
  Der udskrives f›lgende:
    Installering af Afslut
    Afslut er installeret
       1   2   3   4   5   6   7   8   9  10  11  12
    LongJMP(Afslut)
    Afslut: returneret
}
Uses LJMP;

var Afslut: Target;
    n: Integer;

begin
  writeln; writeln('Installering af Afslut');
  if SetJMP(Afslut)<>0 then
    writeln('Afslut: returneret')
  else begin
    writeln('Afslut er installeret');
    for n:=1 to 20 do
      if n=13 then begin                                    { F‘rdig, afslut }
        writeln; writeln('LongJMP(Afslut)');
        LongJMP(Afslut,1);            { Hop tilbage til efter SetJMP(Afslut) }
      end else write(n:4);
  end;
end.
