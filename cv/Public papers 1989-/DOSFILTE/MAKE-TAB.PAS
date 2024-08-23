Program MakeTabInFile;                     {Inds‘t tab tegn. Vil spare plads!}
Uses DosFilter;                            {Brug nyttige variabler og rutiner}
begin
  DF1:=8;                         {Default 8 tegn/tab hvis ikke andet angives}
  if ParamCount>0 then begin
    DF1:=ParamNo(1);
    Stop(DF1,2,32,'Syntax: make-tab 8 <fil1 >fil2'#13#10+ {Tab mellem 2 og 32}
                     'eller   make-tab   <fil1 >fil2');
  end;
  while not EOF do begin
    readln(Line);
    MakeTab(Line,DF1);                                     {Geninds‘t tabtegn}
    writeln(Line);
  end;
end.
