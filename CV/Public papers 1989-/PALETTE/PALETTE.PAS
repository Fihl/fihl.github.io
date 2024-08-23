program PaletteDemo;
{ Demonstration af palette skift i TurboPascal.
  Skrevet af Christen Fihl for PC-World.
  Et ubrugeligt men interressant program.
}

Uses Crt,Graph;

Const
  Drivers = 'C:\turbo';    {Hvor er grafik driverne? Angiv dine egen sti her}
  Reklame='Salgs gas her';
  maxCol=14;                          {Antal farver bortset fra sort og hvid}

Var
  m,n,o,p,ReklameW,ReklameH,ReklameX,ReklameY,
  CentrumX,CentrumY,
  ReklameTimeOut, GrDriver, GrModus: Integer;
  rad: real;
  Pal: PaletteType;
  Image: Pointer;

begin
  GrDriver := VGA; grModus:= VGAHi;
  InitGraph(GrDriver,grModus,Drivers);
  if GraphResult <> grOk then begin
    GrDriver := EGA; grModus:= EGAHi;      {Pr›v i EGA, hvis VGA ikke lykkes}
    InitGraph(GrDriver,grModus,Drivers);
    n:=GraphResult;
    if n <> grOk Then begin
      writeln('InitGraph fejl: ',n); halt(n);
    end;
  end;
  CentrumX:=GetMaxX div 2; CentrumY:=GetMaxY div 2;       {Find sk‘rm midten}
  ReklameTimeOut:=0;
  for n:=0 to 360 do begin
    rad:=(2*pi/360*n);
    moveto(CentrumX,CentrumY);
    o:=1+(n mod maxCol);
    for p:=1 to 6 do begin
      m:=8+15*p;
      setColor(o);
      lineRel(round(m*sin(rad)),round(m*cos(rad)));
      o:=1+MaxCol-o;
    end;
  end;
  delay(500);                                          {Alt grafik er tegnet}
  SetColor(15); SetTextStyle(TriplexFont,0,6);
  OutTextXY( 35,25,'Christen Fihl');
  OutTextXY(CentrumX+100,CentrumY-5,'PC World');
  delay(500);                                                 {Alt er tegnet}
  {Tag en kopi af pladsen hvor reklamen vil dukke op og forsvinde}
  ReklameW:=textwidth(Reklame); ReklameH:=TextHeight(Reklame);
  GetMem(Image,imageSize(0,0,ReklameW,ReklameH));
  ReklameX:=CentrumX-ReklameW div 2; ReklameY:=CentrumY+CentrumY div 2;
  GetImage(ReklameX,ReklameY,ReklameX+ReklameW,ReklameY+ReklameH,Image^);
  GetPalette(Pal);
  with Pal do repeat
    m:=Colors[1];
    for n:=1 to maxCol-1 do                                  {Roter farverne}
      Colors[n]:=Colors[n+1];
    Colors[MaxCol]:=m; setAllPalette(Pal);
    case random(20) of                             {Lav ogs† bl›de ‘ndringer}
    1:  setRGBPalette( 1+random( 5),128+random(128),random( 20),random( 20));
    2:  setRGBPalette( 6+random( 5),random( 20),128+random(128),random( 20));
    3:  setRGBPalette(11+random( 4),random( 20),random( 20),128+random(128));
    4:  setRGBPalette( 1+random(15),255,1,1);
    else                                  {Ingen ‘ndring 16/20 dele af tiden}
    end;
    if (ReklameTimeOut=0) and (random(50)=0) then begin
      SetColor(15); OutTextXY(ReklameX,ReklameY,Reklame);   {Skriv med hvidt}
      ReklameTimeOut:=30;
    end;
    if ReklameTimeOut>0 then begin
      dec(ReklameTimeOut);
      if ReklameTimeOut=0 then                       {Sluk for reklamen igen}
        putimage(ReklameX,ReklameY,Image^,NormalPut);
    end;
  until keypressed;
  closegraph;
end.
