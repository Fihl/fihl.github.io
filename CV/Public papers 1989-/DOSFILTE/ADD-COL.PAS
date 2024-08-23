Program SammenTaelSojle;  {Adder tallene i en s›jle. Kald det for ADD-COL.EXE}
Uses DosFilter;                            {Brug nyttige variabler og rutiner}
var Total,W: longint;
const Fjern: string[10]=' ,.';
begin
  Stop(ParamCount,2,2,'Syntax: Add-Col S›jle1 S›jle2 <fil1 >fil2');
  DF1:=ParamNo(1); DF2:=ParamNo(2);
  Stop(DF1,  1,255,  'Starts›jle forkert angivet');
  Stop(DF2,DF1,255,  'Sluts›jle skal v‘re st›rre end starts›jle');
  Total:=0;
  while not EOF do begin
    readln(Line); Delete(Line,DF2+1,255); Delete(Line,1,DF1-1);
    for DF3:=1 to Length(Fjern) do         {Slet alle forekomster fra "Fjern"}
      while pos(Fjern[DF3],Line)>0 do
        delete(Line,pos(Fjern[DF3],Line),1);  
    val(Line,W,DF3);
    Inc(Total,W);
  end;
  writeln(Total);                                            {Udskriv totalen}
end.
