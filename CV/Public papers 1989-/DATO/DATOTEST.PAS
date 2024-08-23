Program DatoTest;

Uses DateCalc;

var
  Aar: integer;
  Paaske,Idag,EnDag: JulType;

begin
  IDag:=JulToDay;
  EnDag:=JulDate(1989,12,9);
  Paaske:=JulDate(1990, 4,15);                  {P†ske er den 15 april i 1990}
  WriteLn;
  WriteLn('Idag er Juliansk: ',Idag);
  WriteLn('Dato er: ',Date(Idag));
  WriteLn('Ugedag(',WeekDay(Idag),') er: ',WeekDayStr(WeekDay(Idag)));
  WriteLn;
  WriteLn('P†ske er: ',WeekDayStr(WeekDay(Paaske)),' ',Date(Paaske));
  WriteLn('Der er ',Paaske-JulToDay,' dage til p†ske');
  WriteLn('P†ske 1991 er en ',WeekDayStr(JulDate(1991, 3,31)));
  WriteLn('P†ske 1999 er en ',WeekDayStr(JulDate(1999, 4, 4)));
  WriteLn('P†ske 2000 er en ',WeekDayStr(JulDate(2000, 4,23)));
  WriteLn('P†ske 2007 er en ',WeekDayStr(WeekDay(JulDate(2007, 4, 8))));

{  for Aar:=1940 to 2040 do begin {}
  for Aar:=1985 to 1995 do begin
    EnDag:=JulDate1stWeek(JulDate(Aar,1,1));
    write('Uge 1 i ',Aar,' starter ',Date(EnDag));
    while weekday(EnDag)<4 do inc(EnDag);
    write(' ',WeekDayStr(EnDag),'=',Date(EnDag));
    writeln('.   1. januar er en ',WeekDayStr(JulDate(Aar,1,1))); {{{}
  end;
end.
