Program CO_test;
{$M 64000,0,0} {$F+,R-}

{ CO-rutiner i Turbo Pascal }
{ Af Christen Fihl 1990     }

{ Kik p† SPtr og Tasks medens du debugger. Brug F7 hertil }
{ Kik m†ske ogs† p† TaskCount og TaskIndex }

Uses Crt,CoRutine;

Const Stop: Boolean=False;             {Stopper Task3 n†r den s‘ttes til true}

procedure Idle;      {En procedure, der g›r det nemmere at debugge programmet}
begin                                    {Spilder lidt tid, men hvad g›r det!}
  CoRutine.Idle
end;

procedure Task1;                      {1 sekund task. Kan fx bruges som et ur}
Var   m,n: Integer;
      Ticks: Longint;
begin
  for n:=1 to 10 do begin                                  {K›r i 10 sekunder}
    repeat Idle until HasUsedTicks(Ticks,18);
    gotoxy(1,TaskIndex+2); write(' 1/sec: ',n:6);
  end;
  write(' Ok');
end;

procedure Task2;                                    {18 gange per sekund task}
Var   m,n: Integer;
      Ticks: LongInt;
begin
  for n:=1 to 100 do begin  {K›r i 100 ticks = 100/18 sekunder = 5.5 sekunder}
    repeat Idle until HasUsedTicks(Ticks,1);
    gotoxy(1,TaskIndex+2); write('18/sec: ',n:6);
  end;
  write(' Ok');
end;

procedure Task3;         {K›r hurtigst muligt, men giv de andre tid alligevel}
Var   n: LongInt;                            {Stopper ogs† p† "Stop" signalet}
Var   LastTimer: Word;
Var   TimerLow: Word absolute $0040:$006C;           {BIOS'ens timer variabel}
begin
  for n:=1 to MaxLongInt do begin
    if (LastTimer<>TimerLow) or (n=999999) then begin
      Idle; LastTimer:=TimerLow;
      gotoxy(1,TaskIndex+2); write('hurtig: ',n:6);
    end;
    if Stop or (N=999999) then begin
      if Stop then write(' Stoppet') else write(' Ok');
      EXIT;
    end;
  end;
end;

procedure Task4;                  {L‘s fra tastaturet indtil der tastes retur}
Var   x:  Integer;
      Ch: Char;
Const Y=  15;
begin
  gotoxy(1,y); write('Tast en linje her: ');
  repeat
    x:=WhereX;
    while not KeyPressed do begin Idle; gotoxy(x,y) end; Ch:=ReadKey;
    if Ch=#13 then x:=999 else write(Ch);
  until x>=70;
  Stop:=True;                                                {Stop ogs† Task3}
  write(' ... Tak');
  repeat Idle; gotoxy(1,y+2) until TaskCount=1; {Hold cursoren p† samme plads}
end;

begin
  ClrScr;
  InstallTask(@Task1,1*4000);
  InstallTask(@Task2,2*4000);
  InstallTask(@Task3,3*4000);
  InstallTask(@Task4,4*4000);
  Idle; Idle; Idle; Idle; Idle; Idle;
  InstallTask(@Task2,5*4000);
  Idle; Idle; Idle; Idle; Idle; Idle;
  InstallTask(@Task2,6*4000);
  repeat
    Idle;
  until (TaskCount=0);
end.
