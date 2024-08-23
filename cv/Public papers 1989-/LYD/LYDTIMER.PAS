program LydTimer;
{ Af Christen Fihl 42 17 52 73 }
{$R-,S-}
Uses Crt;

Type DriverT= Record
                Action:(Done,Set0,Set1);
                Timer: word;
                ID:    String[10];
              end;
Var  Driver: ^DriverT ABSOLUTE $0000:4*$0064;

procedure FlipHT(On: Byte);
begin
  with Driver^do begin
    repeat until Action=Done;
    if Odd(On) then Action:=Set1
    else            Action:=Set0;
  end;
end;

procedure SetTimer(Freq: word);
begin
  Driver^.Timer:=1193182 div Freq;
end;

var f,n,S: Integer;
begin
  s:=4000;
  if Driver^.ID<>'LydDriver' then HALT;
  SetTimer(S);
{  Driver^.Timer:=1193182 div S; {}
{  Sound(1000); {}
  for F:=1 to 10 do begin
    SetTimer(S+f*10); {}
    for N:=1 to 100 do FlipHT(N);
  end;
  NoSound;
end.

  Lyd(1000, 1000, P1000);
  Lyd(697, 697, P1000*1000 div 697);
  Lyd(1209, 1209, P1000*1000 div 1209);
  inline($FB);    Nosound;
end.
