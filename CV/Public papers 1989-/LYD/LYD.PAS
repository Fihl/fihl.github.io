program SimpelLyd;
{ Af Christen Fihl 42 17 52 73 }

Uses Crt,Dos;

Type DriverT= Record
                Action:(Done,Set0,Set1,SetTimer);
                Timer: word;
                ID:    String[10];
              end;
Var  Driver: ^DriverT ABSOLUTE $0000:4*$0064;

procedure FlipHT(On: Boolean);
var P: byte;
begin
  inline($FA);
    P:=port[$61];
    if on then
      port[$61]:=P or 2
    else
      port[$61]:=P and not 2;
{  inline($FB); {}
end;

procedure Lyd(Freq, Antal, Pause: integer);
var P: Integer;
begin
  Sound(Freq); {}
  inline($FA); {}
  for Antal:=1 to Antal do begin
    FlipHT(odd(Antal));
    for P:=1 to Pause do;
  end;
  inline($FB);    Nosound;
end;

const P1000= 140;
      Pause: Integer=P1000;
var   n,p:   Integer;

begin
  with Driver^ do begin
    if ID<>'LydDriver' then HALT;
    Timer:=1193182 div 1000;
    Action:=SetTimer;
  end;
end.

  Lyd(1000, 1000, P1000);
  Lyd(697, 697, P1000*1000 div 697);
  Lyd(1209, 1209, P1000*1000 div 1209);
  inline($FB);    Nosound;
end.
  Sound(1000); {{ Delay(500);   {}
  inline($FA); {}
  for n:=1 to 1000 do begin
    FlipHT(odd(n));
    for P:=1 to Pause do;
  end;
  inline($FB);    Nosound;
end.
s1200	=	1193182/1200		;1200Hz
