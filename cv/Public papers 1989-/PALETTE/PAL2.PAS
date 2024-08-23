Program Animate;
{ Flyt rundt p† alle mine brikker ved hj‘lp af palette skift
  Af Christen Fihl
}
uses Crt,Graph;
Const
  Pal1: palettetype=(Size:16;Colors:(0,63,2,3, 0,63, 2, 3,0,63,2,3,0,63,2,3));
  Pal2: palettetype=(Size:16;Colors:(0, 0,0,0,63,63,63,63,2, 2,2,2,3, 3,3,3));
  PalA: palettetype=(Size:16;Colors:(0,63,2,3,63,63,63,63,2,63,2,3,0,63,2,3));
  GrDriver: Integer=EGA; GrModus: Integer=EGAHI; MegetFlimmer=false;
var n: Integer;
begin
  InitGraph(GrDriver,grModus,'c:\turbo');
  SetWriteMode(XORPut);
  SetColor(2); Rectangle(220,10,250,40);                     {Kontrol kasser}
  SetColor(8); Rectangle(220+50,10,250+50,40);
  repeat
    n:=1-1; SetColor(8); Rectangle(n+1,n+1,n+181,n+181);
    for n:=1 to 20 do begin
      SetColor(2); Rectangle(n,n,n+180,n+180);
      if not MegetFlimmer then SetAllPalette(PalA);      {Vis begge samtidig}
      SetAllPalette(Pal1); Delay(10);
      SetColor(8); Rectangle(n,n,n+180,n+180);
      SetColor(8); Rectangle(n+1,n+1,n+181,n+181);
      if not MegetFlimmer then SetAllPalette(PalA);     {Giver ikke "huller"}
      SetAllPalette(Pal2); Delay(10);
      SetColor(2); Rectangle(n,n,n+180,n+180);
    end;
    n:=20+1; SetColor(8); Rectangle(n,n,n+180,n+180);
  until keypressed;
  closegraph;
end.
