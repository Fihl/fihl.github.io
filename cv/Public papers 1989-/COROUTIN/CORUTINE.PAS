Unit CoRutine;
{$F+,R-,S-,D-}   {Fjern eventuelt D-, hvis du vil se hvordan rutinerne virker}

interface

{ Idle kaldes s† ofte som muligt. Idle deler CPU'en for brug af alle task}
procedure Idle;

{ Installer en Task (en procedure i $F+ tilstand)}
{ Hver task skal have egen stak plads. StackTop er toppen af omr†det givet}
procedure InstallTask(Adresse: Pointer; StackTop: Word);

{ Utility rutine}
{ returner true hver gang der er g†et "Ticks" ticks (1/18 sekund)}
{ if HasUsedTicks(Ticks,4*18) then DoIt;  Kalder derfor Doit hvert 4 sekund}
function  HasUsedTicks(var LocalVar: longint; Ticks: integer): boolean;

Const TaskMax=10;
Const TaskCount: Integer=0;
Const TaskIndex: Integer=0;
Const Tasks:     array[0..TaskMax] of Word=(0,0,0,0,0,0,0,0,0,0,0); {SP tabel}

implementation

Var Temp: Word;                  {SKAL v‘re global. Bruges i INLINE udtrykket}

procedure Idle;
{INGEN LOKALE VARIABLER HER!!}
begin
  if TaskIndex<>-1 then                        {Speciel for terminerings brug}
    Tasks[TaskIndex]:=SPtr;           {Altid bortset fra ved kald fra LastOne}
  repeat                      {Find n‘ste aktive Task i stak pointer tabellen}
    if TaskIndex=TaskMax then TaskIndex:=0 else inc(TaskIndex);   {0..TaskMax}
    Temp:=Tasks[TaskIndex];
  until Temp<>0;
  inline ($8B/$2E/Temp); { MOV  BP,Temp }
  inline ($8B/$26/Temp); { MOV  SP,Temp }
end;                     { (MOV SP,BP,) POP BP, RETF}

procedure LastOne;  {Hertil hoppes n†r en bruger-rutine returnerer (End/Exit)}
begin
  Tasks[TaskIndex]:=0;                       {Fjern tabel indholdet for "mig"}
  TaskIndex:=-1; dec(TaskCount);                    {"-1" er et flag til Idle}
  Idle;                   {Idle returnerer aldrig, da tabellen for "mig" er 0}
end;

procedure InstallTask(Adresse: Pointer; StackTop: Word);
Type InitSP= record
               BP: word;
               IPCS, Final: Pointer
             end;
Var   Pptr:  ^InitSP;
      N:     Integer;
begin
  if StackTop>(SPtr-1000) then begin
    writeln('Ikke mere stak plads!');  HALT(99);
  end;
  inc(TaskCount); dec(StackTop,SizeOf(InitSP)); {Plads til vores initial data}
  Pptr:=Ptr(SSeg,StackTop);
  Pptr^.BP:=0;                           {Lav en passende struktur p† stakken}
  Pptr^.IPCS:=Adresse;                              {Adressen p† vores rutine}
  Pptr^.Final:=@LastOne;  {En rutine der kaldes EFTER vores procedure er slut}
  n:=0; repeat inc(n) until Tasks[n]=0;            {Find ledig hul i tabellen}
  Tasks[n]:=StackTop;                                        {Inds‘t i hullet}
end;

function  HasUsedTicks(var LocalVar: longint; Ticks: integer): boolean;
Var   TimerLow: word absolute $0040:$006C;        { BIOS'ens timer variabel }
      L: LongInt;
begin
  L:=LongInt(TimerLow)+LongInt(Ticks);
  if LocalVar>L then LocalVar:=TimerLow;
  if LocalVar>=timerLow then HasUsedTicks:=false else begin
    LocalVar:=L;
    HasUsedTicks:=true;
  end;
end;

end.
