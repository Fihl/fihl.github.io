Program RemTabInFile;            {Fjern tab tegn. Bruger mere plads til filen}
Uses DosFilter;                            {Brug nyttige variabler og rutiner}
begin
  DF1:=8;                         {Default 8 tegn/tab hvis ikke andet angives}
  if ParamCount>0 then begin
    DF1:=ParamNo(1);
    Stop(DF1,2,32,'Syntax: rem-tab 8 <fil1 >fil2'#13#10+  {Tab mellem 2 og 32}
                     'eller   rem-tab   <fil1 >fil2');
  end;
  while not EOF do begin
    readln(Line);
    RemTab(Line,DF1);                                    {Fjern gamle tabtegn}
    writeln(Line);
  end;
end.
