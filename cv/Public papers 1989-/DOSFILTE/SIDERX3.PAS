Program Siderx3;       {Laver een side tekst om til tre spalter p† samme side}
Uses DosFilter;                            {Brug nyttige variabler og rutiner}
Const SpalterAntal=3;
var
  Sider: array[1..SpalterAntal,1..100] of String[200];
  n: Integer;
{$V-}
begin
{{{{  Assign(input,'x'); reset(input); {{{}
  Stop(ParamCount,3,3,                                   {3 parametrer kr‘ves}
        'Syntax: SiderX3 68 4 80 <fil1 >fil2'#13#10+
        '   -- 68=antal linjer, 4=antal blanke, 80=total linjel‘ngden'#13#10+
        '   -- 68+4=72 =antal linjer total p† siden'#13#10+
        '   -- Antal blanke<0  => skriv FF istedetfor blanke linjer'+
        '   -- Antal blanke=-2 => skriv | som skilletegn');
  Stop(ParamNo(1),  1,100,  'Antal linjer skal v‘re mellem 1 og 100');
  Stop(ParamNo(2), -2, 99,  'Forkert antal blanke linjer angivet');
  Stop(ParamNo(3), 10,200,  'Forkert linjel‘ngde');
  DF3:=0; write(ErrorOutput,'Behandler side:xxx');               {Side t‘ller}
  while not eof do begin
    inc(DF3); write(ErrorOutput,^H^H^H,DF3:3); Flush(ErrorOutput);
    for DF1:=1 to SpalterAntal do             {Indl‘s nn gange linje antallet}
    for DF2:=1 to ParamNo(1) do begin
      readln(Sider[DF1,DF2]);
      RemTab(Sider[DF1,DF2],8);                               {Fjern tab tegn}
      AdjustLine(Sider[DF1,DF2],(ParamNo(3) div SpalterAntal)-1);{Juster l‘ngde}
    end;
    for DF1:=1 to ParamNo(1) do begin                      {Kombiner linjerne}
      Line:=Sider[1,DF1];
      for n:=2 to SpalterAntal do
      if ParamNo(2)=-2 then
        Line:=Line+'|'+Sider[n,DF1]                {S‘t de to halvdele sammen}
      else
        Line:=Line+' '+Sider[n,DF1];
      RemSpace(Line);                     {Undlad at udskriv ekstra blanktegn}
{{    MakeTab(Line,8); {{}
      writeln(Line);                                            {Skriv linjen}
    end;
    if ParamNo(2)<0 then
      if true then
        write(#$1B#$19#$52)                     {Skip page on a Microline 39x}
      else
        write(^L);                                    {Skriv FormFeed istedet}
    for DF1:=1 to ParamNo(2) do writeln;                 {Skriv blanke linjer}
  end;
  writeln(ErrorOutput);
end.
