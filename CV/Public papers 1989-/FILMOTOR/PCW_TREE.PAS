Program PCW_TREE;
{ Af Christen Fihl 1990 for PC World

  PCW_TREE sti
  Udskriver tr‘ strukturen af biblioteket startende i STI.

  Eksempel:  PCW_TREE C:\
}

Uses Dos,FilMotor;
{$M 10000,0,0}

Const
  Taller:    Integer=0;
  SidsteSti: String='';

{$F+}                                                           {SKAL v‘re F+}
procedure BehandlEnSti(var SR: SearchRec; var Sti: PathStr);
var
  S: String;
  N: Integer;
  Stop: Boolean;
begin
  S:=Sti+SR.Name; N:=1; Stop:=False;
  While not Stop and (pos('\',Copy(S,N+1,255))>0) and
        (N<=Length(S)) and (N<=Length(SidsteSti)) do begin
    if S[N]=SidsteSti[N] then begin
      if S[N]='\' then write('\') else write('-');
      inc(N);
    end else Stop:=True;
  end;
  SidsteSti:=S; writeln(copy(S,N,255));
  Inc(Taller);                                             {Antal biblioteker}
end;

begin
  LaesKommandoLinjen(KunStier); StiBehandl:=BehandlEnSti;
  Opt_S:=True;                                {Behandl ALTID underbiblioteker}
  FindFiler(HovedSti);
  if Taller>0 then Write('Der var ialt ',Taller) else write('Der var ingen');
  writeln(' biblioteker');
end.
