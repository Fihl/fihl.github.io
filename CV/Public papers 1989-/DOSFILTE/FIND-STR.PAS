Program FindString;                                         {S›g efter streng}
Uses DosFilter;                            {Brug nyttige variabler og rutiner}
begin
  Stop(ParamCount,1,1,
    'Syntax: Find-Str tekst <fil1 >fil2');
  while not EOF do begin
    readln(Line);
    if pos(ParamStr(1),Line)>0 then
      writeln(Line);
  end;
end.
