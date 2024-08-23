Unit FilMotor;

{ Modul til rekursiv gennems›gning af en disk efter filer }
{ Af Christen Fihl 1990 for PC World.    Tlf: 42 17 52 73 }

interface

Uses Dos;

type StiEllerFil=(KunFiler,KunStier);       {Parameter til LaesKommandoLinjen}

procedure LaesKommandoLinjen(StiFil: StiEllerFil);         {Indl‘s kommandoer}
procedure FindFiler(Sti: PathStr);                    {S›g efter alle filerne}
Function  Option(S: ExtStr): boolean;        {Sp›rg efter om parameter er sat}

Type
  Behandl= Procedure(var M: SearchRec; var P: PathStr);

var
  FilMotorRC:  Integer;                                  {Returneret fejlkode}
  FilBehandl:  Behandl;                 {Denne kaldes for hver fil der findes}
  StiBehandl:  Behandl;            {Denne kaldes for hver sti der gennems›ges}
Const                    {Er reelt variabler, blot initialiserede fra starten}
  HovedSti:    PathStr='';                {Sti delen fra f›rste fil-parameter}
  FilStop:     Boolean=False;     {S‘t til true hvis ›jeblikkelig stop ›nskes}
  Opt_S:       Boolean=False;     {Sat/s‘ttes hvis rekursiv behandling ›nskes}
  StiDybde:    Integer=0;                               {Nuv‘rende sti niveau}
  MaxStiDybde: Integer=99;     {H›jeste sti niveau, dog h›jst mulighed for 32}

implementation
{$V-}

const
  MaxOption=   10;
  MaxFil=      30;
  OptAntal:    Integer=0;          {Antal option af formen /xx, -xx eller +xx}
  FilAntal:    Integer=0;             {Antal filmasker. Alt andet end options}

Var
  Opt:       array[1..MaxOption] of String[4];
  Filer:     array[1..MaxFil] of String[12];

procedure FindFiler(Sti: PathStr);             {Denne procedure kaldes af dig}
var
  n:  Integer;
  S:  SearchRec;                                             {Fylder 43 bytes}
Label Exit;       {Brug ikke EXIT, da StiDybde da ellers ikke t‘lles ned igen}
begin
  Inc(StiDybde);
  if SPtr<300 then goto EXIT;                           {Ikke mere stakplads!}
  for n:=1 to FilAntal do begin                      {S›g gennem alle filerne}
    FindFirst(Sti+Filer[n], (AnyFile and (not (Directory or VolumeID))), S);
    if DosError=3 then goto EXIT;                            {Sti ikke fundet}
    while DosError=0 do begin
      FilBehandl(S,Sti);                         {Kald bruger rutinen for FIL}
      if FilStop then goto EXIT;         {FilBehandl kan s‘tte denne til true}
      FindNext(S);
    end;
  end;
  if Opt_S and (StiDybde<=MaxStiDybde) then begin    {S›g stier EFTER filerne}
    FindFirst(Sti+'*.*', Directory, S);
    while DosError=0 do begin
      if (S.Attr and Directory<>0) and (S.Name<>'.') and (S.Name<>'..') then
      begin
        StiBehandl(S,Sti);                       {Kald bruger rutinen for FIL}
        if FilStop then goto EXIT;       {FilBehandl kan s‘tte denne til true}
        FindFiler(Sti+S.Name+'\');
      end;
      FindNext(S);
    end;
  end;
Exit:
  FilMotorRC:=DosError; if DosError=18 then FilMotorRC:=0;     {18=ikke flere}
  Dec(StiDybde);               {F‘rdig med dette niveau, returner til forrige}
end;

procedure UpCaseStr(var S: String);                      {Dejlig lille rutine}
var n: Integer;
begin
  for n:=1 to Length(S) do S[n]:=UpCase(S[N]);
end;

Function Option(S: ExtStr): boolean;      {Returner TRUE hvis option S er sat}
var n: integer;
begin
  Option:=True;
  UpCaseStr(S);
  for n:=1 to OptAntal do if Opt[n]=S then EXIT;
  Option:=False;
end;

procedure LaesKommandoLinjen(StiFil: StiEllerFil);{Genneml‘s parameter linjen}
var
  n:   Integer;
  S:   PathStr;
  Fil: String[8];
  Ext: String[4];
begin
  For n:=1 to ParamCount do begin
    S:=ParamStr(n); UpcaseStr(S);
    if S[1] in ['+','-','/'] then begin       {V‘lg enten options eller filer}
      if OptAntal<MaxOption then inc(OptAntal);                    {ELSE FEJL}
      Opt[OptAntal]:=S;
      if Copy(S,2,99)='S' then Opt_S:=True;       {Rekursiv behandling ›nsket}
    end else begin
      if FilAntal<MaxFil then inc(FilAntal);                       {ELSE FEJL}
      if (StiFil=KunStier) or ((S[1]='.') and (pos('\',S)=0)) then
        if (S[Length(S)]<>':') and (S[Length(S)]<>'\') then S:=S+'\';
      FSplit(S,S,Fil,Ext);                        {'A:B.C' => 'A:', 'B', '.C'}
      if HovedSti='' then                           {Kun een hovedsti tilladt}
        HovedSti:=S
      else
        if S<>'' then writeln('Sti forkert angivet!!!');
      Filer[FilAntal]:=Fil+Ext;                    {Gem alt bortset fra stien}
      if (StiFil=KunStier) or (Filer[FilAntal]='') then Dec(FilAntal);
    end;
  end;
  if (StiFil=KunFiler) and (FilAntal=0) then begin  {Intet angivet, da anvend}
    inc(FilAntal); Filer[1]:='*.*';                 {  *.*                   }
  end;
end;

{$F+}
{Udskrivnings rutine, der dog ikke laver andet end at g›re Pascal'en glad}
procedure DummyBehandl(var M: SearchRec; var P: PathStr);
begin
end;

begin                                        {Initialiser procedure pointerne}
  FilBehandl:=DummyBehandl; StiBehandl:=DummyBehandl; {Setup dummy procedurer}
end.
