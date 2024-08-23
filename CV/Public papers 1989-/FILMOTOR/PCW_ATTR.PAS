Program PCW_ATTR;
{ Af Christen Fihl 1990 for PC World

  PCW_ATTR /S -A sti\filer1 filer2 filer3 ...
  Der kan kun v‘re sti p† den f›rste fil angivelse.
  /S angiver at der skal s›ges gennem alle underbiblioteker.
  -A angiver at A flaget (backup) skal fjernes.
  +A angiver at A flaget (backup) skal s‘ttes.

  Eksempel: PCW_ATTR \*.bak -a /s
}

Uses Dos,FilMotor;
{$M 10000,0,0}


procedure SetMode(FilNavn: PathStr; attr: Word);       {’ndre fil-attributten}
var
  n: byte;
  Regs: Registers;
begin
  write(FilNavn);
  n:=ord(Length(FilNavn)); move(FilNavn[1],FilNavn[0],n); FilNavn[n]:=#0;
  Regs.dx:=ofs(FilNavn); Regs.ds:=seg(FilNavn);      {ASCIIZ streng= C streng}
  Regs.ax:=$4301; Regs.cx:=Attr;
  MsDos(Regs);                                {’ndre attribut flaget p† filen}
  if Odd(Regs.Flags) then write(^G'  FEJL'); {Odd er true hvis Carry flag sat}
  writeln;
end;

{$F+}      {SKAL v‘re F+ for at kunne bruges, ellers overs‘ttelsesfejl senere}
procedure PlusBehandlEnFil(var SR: SearchRec; var Sti: PathStr);
begin
 if (SR.Attr and Archive)=0 then SetMode(Sti+SR.Name,SR.Attr or Archive)
end;

procedure MinusBehandlEnFil(var SR: SearchRec; var Sti: PathStr);
begin
 if (SR.Attr and Archive)<>0 then SetMode(Sti+SR.Name,SR.Attr and not Archive)
end;

begin
  LaesKommandoLinjen(KunFiler);                   {Kun interesseret i filerne}
  if Option('-A') then FilBehandl:=MinusBehandlEnFil else
  if Option('+A') then FilBehandl:= PlusBehandlEnFil else begin
    writeln('Du skal enten angive -A eller +A');
    halt(1);
  end;
  FindFiler(HovedSti);
end.
