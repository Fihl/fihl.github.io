Program SetKey;
{$I-,R-,S-}

{ Bruges sammen med DEFKEY.COM                                             }
{ Kan l‘se/skrive en definition til/fra en indl‘st DEFKEY.COM              }
{ SETKEY fil             henter en definition                              }
{ SETKEY -w fil          gemmer en definition                              }
{ SETKEY -s fil          gemmer en definition                              }

Uses Dos;

Type  DefKeyRec=record
                  Name: packed array[1..6] of char;
                  Base,Size: word;
                end;

Var   MemPtr,
      INT9:  ^DefKeyRec;
Var   N:     Integer;
Var   S:     String;
Var   F:     File;
Const Name:  String='defkey';
Const Save:  Boolean=false;

procedure CheckIOResult;
begin
  if IOResult<>0 then begin
    if Save then writeln('USEKEY: kan ikke gemme filen: ',Name)
    else         writeln('USEKEY: kan ikke †bne filen: ',Name);
    HALT(99)
  end;
end;

{ Dette program kan IKKE debugges, da interupt 9 IKKE peger korrekt!!!}
begin
  GetIntVec(9,Pointer(INT9)); Dec(Longint(INT9),SizeOf(DefKeyRec));
  if INT9^.Name<>'DEFKEY' then begin
    writeln('DEFKEY ikke installeret. Start denne f›rst');
    HALT(1);
  end;
  MemPtr:=Ptr(Seg(INT9^),INT9^.Base);
  for n:=1 to ParamCount do begin
    S:=ParamStr(n);
    if S[1] in ['-','/'] then
      Save:=S[2] in ['w','W','s','S']  {W for Write, S for Skriv eller Save}
    else
      Name:=S;
  end;
  if pos('.',Name)=0 then Insert('.def',Name,999);   {Default extension=.DEF}
  assign(F,Name); if Save then Rewrite(F,1) else Reset(F,1);
  CheckIOResult;
  if Save then BlockWrite(F,MemPtr^,INT9^.Size)
  else         BlockRead (F,MemPtr^,INT9^.Size);
  CheckIOResult;
  Close(F);
  CheckIOResult;
  write(Name); if Save then writeln(' skrevet') else writeln(' l‘st');
end.
