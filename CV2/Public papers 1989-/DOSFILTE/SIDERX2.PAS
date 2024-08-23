Program SiderX2;        {Laver een side tekst om til to spalter p† samme side}
Uses DosFilter;                            {Brug nyttige variabler og rutiner}
var  Sider: array[1..2,1..120] of String;
begin
{{{{  Assign(input,'x'); reset(input); {{{}
  Stop(ParamCount,3,3,                                   {3 parametrer kr‘ves}
        'Syntax: SiderX2 68 4 80 <fil1 >fil2'#13#10+
        '   -- 68=antal linjer, 4=antal blanke, 80=total linjel‘ngden'#13#10+
        '   -- 68+4=72 =antal linjer total p† siden'#13#10+
        '   -- Antal blanke<0  => skriv FF istedetfor blanke linjer'+
        '   -- Antal blanke=-2 => skriv | som skilletegn');
  Stop(ParamNo(1),  1,120,  'Antal linjer skal v‘re mellem 1 og 120');
  Stop(ParamNo(2), -3, 99,  'Forkert antal blanke linjer angivet');
  Stop(ParamNo(3), 10,200,  'Forkert linjel‘ngde');
  DF3:=0; write(ErrorOutput,'Behandler side:xxx');               {Side t‘ller}
  if ParamNo(2)=-3 then begin                                      {Canon LBP}
    write  (#27';'#27'<'#27'[0p'#27'[&z');
    write  (#27'[?32h'#27'[11h'#27')''!6'#27'[0%r'#27'[3y'#27'[?1667 K'#27'[81 C');
    writeln(#27'[0m'#27'[72;34 G');
    writeln(#27'[0;0f'#27'[;1x'#27'[36a'#27'[0;2t'#27'[;1x');
    write  (#27'[1&s'#27'[;1x'#27'[1;6{'#27'[;4x'#27'[}');
    writeln(#27'[99;2772f'#27'[;1;2x'#27'[1;2{'#27'[;4;2x'#27'[}'#27'[&s'#27'[1&w');
  end;
  while not eof do begin
    inc(DF3); write(ErrorOutput,^H^H^H,DF3:3); Flush(ErrorOutput);
    for DF1:=1 to 2 do                         {Indl‘s 2 gange linje antallet}
    for DF2:=1 to ParamNo(1) do begin
      readln(Sider[DF1,DF2]);
      RemTab(Sider[DF1,DF2],8);                               {Fjern tab tegn}
      AdjustLine(Sider[DF1,DF2],(ParamNo(3) div 2)-1);         {Juster l‘ngde}
    end;
    for DF1:=1 to ParamNo(1) do begin                      {Kombiner linjerne}
      case ParamNo(2) of
      -2: Line:=Sider[1,DF1]+'|'+Sider[2,DF1]      {S‘t de to halvdele sammen}
      else
        Line:=Sider[1,DF1]+' '+Sider[2,DF1];
      end;
      RemSpace(Line);                     {Undlad at udskriv ekstra blanktegn}
{{      MakeTab(Line,8); {{}
      writeln(Line);                                            {Skriv linjen}
    end;
    case ParamNo(2) of
    -1,-2: if true then
             write(#$1B#$19#$52);               {Skip page on a Microline 39x}
    -3:      writeln(^L);                                          {Canon LBP}
    else
             write(^L);                               {Skriv FormFeed istedet}
             for DF1:=1 to ParamNo(2) do writeln;        {Skriv blanke linjer}
    end;
  end;
  writeln(ErrorOutput);
end.
