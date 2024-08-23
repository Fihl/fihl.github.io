Program PCW_DIR;
{ Af Christen Fihl 1990 for PC World

  PCW_DIR /S /n sti\filer1 filer2 filer3 ...
  Der kan kun v‘re sti p† den f›rste fil angivelse.
  /S angiver at der skal s›ges gennem alle underbiblioteker.
  /n, n=1,2,4 eller 8 angiver filblokst›rrelsen p† disken

  Eksempel: PCW_DIR C:\src\*.pas /s
}

Uses Dos,FilMotor;
{$M 10000,0,0}

Const
  Modulus: Integer=1;
  Taller:  Integer=0;
  Total:   Longint=0;
  TotalM:  Longint=0;

{$F+}                                                           {SKAL v‘re F+}
procedure BehandlEnFil(var SR: SearchRec; var Sti: PathStr);
begin
  writeln(Sti,SR.Name);
  Inc(Taller);                                                   {Antal filer}
  Inc(Total,SR.Size);                                 {N›jagtig fil st›rrelse}
  Inc(TotalM,Modulus*((SR.Size+Modulus-1) div Modulus));  {Oprundet st›rrelse}
end;

begin
  LaesKommandoLinjen(KunFiler);
  if Option('/1') then Modulus:=1024 else  {Floppydisk med 1024 bytes/cluster}
  if Option('/2') then Modulus:=2048 else    {Harddisk med 2048 bytes/cluster}
  if Option('/4') then Modulus:=4096 else    {Harddisk med 4096 bytes/cluster}
  if Option('/8') then Modulus:=8192;        {Harddisk med 8192 bytes/cluster}
  FilBehandl:=BehandlEnFil; FindFiler(HovedSti);
  if Taller>0 then begin
    if Taller=1 then
      Writeln('Denne fil fylder ',Total,' bytes')
    else
      Writeln('Disse',Taller:5,' filer fylder ',Total,' bytes');
    if Modulus<>1 then
      writeln('Oprundet giver dette:   ',TotalM,' bytes');
  end;
end.
