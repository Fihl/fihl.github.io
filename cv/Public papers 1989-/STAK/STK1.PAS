Program StakTest;
{$S+,R-,M 2000,0,0}

{ Af Christen Fihl }

Type
  BytePtr= ^byte; {BytePtr(Ptr(SSeg,0))^ Peger p† bunden af stakken}
  Str20=String[20]; {Den datatype vi bruger overalt}
Var
  S: Str20;

{ Fyld stakken med et m›nster (5A)      }
{ Brug KUN op til SPtr minus "en smule" }
{ Returner pegerpind til nuv‘rende stak }
function StakMaerke1: word;
begin
  FillChar(BytePtr(Ptr(SSeg,0))^,SPtr-20,#$5A);
  StakMaerke1:=SPtr;
end;

{ Returner addressen p† f›rste byte p†
  stakken, der er blevet brugt          }
function StakMaerke2: word;
var n: word;
begin
  n:=0; repeat inc(n) until BytePtr(Ptr(SSeg,n))^<>$5A;
  StakMaerke2:=n;
end;

function  Funktion1: Str20;
begin
  Funktion1[0]:=#1 {Brug variablen}
end;

procedure Test2;
begin
  s:='PC World'; { Konstant, beregnet under kompilering}
  s:='PC'+' '+'World'; { Konstant, beregnet under kompilering}
end;

procedure Test3;
Const World: Str20='World';
begin
  s:='PC '+World; { IKKE konstant, skal beregnes. Bruger 256 bytes}
end;

procedure Test4;
begin
  s:=Funktion1; { Bruger 256 bytes}
end;

procedure Test5;
begin
  s:=Funktion1+Funktion1; { Bruger 512 bytes}
end;

function  FunkProc(St: Str20): Str20;
begin
  St[0]:=#1; FunkProc[0]:=#1; {Brug variablerne}
end;

procedure Test6;
begin
  s:=FunkProc(s); { Bruger 256+20 bytes}
end;

procedure Test7;
begin { Bruger 4*256 bytes}
  s:=FunkProc(FunkProc(FunkProc(FunkProc(s))));
end;

procedure Test8(St: Str20);
begin
  St[0]:=#1 {Brug variablen. Bruger 20 bytes}
end;

procedure Test9(var St: Str20);
begin
  St[0]:=#1 {Brug variablen. Bruger 0 byte}
end;

{ Fakultets rutine. Fakultet(4)=4*3*2*1, beregnet rekursiv
  Der bruges 200 bytes for StorTestVariabel+ 14 til andet.
  Bruger det samme antal bytes hver gang det kaldes.
  Fakultet(6) i fors›g 15 vil derfor bruge 6*200 bytes.}
function Fakultet(F: LongInt): LongInt;
var { Test variabel. Pr›v med 1000 istedet for 100}
  StorTestVariabel: array[1..100] of integer; {Bruges ikke. Kun et eksempel}
begin
  StorTestVariabel[1]:=0; {Brug lageret}
  if F<=1 then Fakultet:=1 else Fakultet:=F*Fakultet(F-1);
end;

{ Test programmet}
Var
  StakPosition1,StakBrugt,n: word;
  L: LongInt;

begin
  Writeln('Test af stakforbrug i TurboPascal');
  for n:=1 to 15 do begin
    StakPosition1:=StakMaerke1;
    case n of
     1: ; {Ingenting}
     2: Test2;
     3: Test3;
     4: Test4;
     5: Test5;
     6: Test6;
     7: Test7;
     8: Test8(s);
     9: Test9(s);
    10..15: L:=Fakultet(n-9);
    end;
    StakBrugt:=StakPosition1-StakMaerke2;
    writeln('Stak forbrugt i fors›g',n:3,': ',StakBrugt);
  end;
  write('Tryk p† retur..'); readln;
end.
