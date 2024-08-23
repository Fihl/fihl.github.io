Program JMP2Test;
{$M 2000,0,0}

Uses LJMP;

var T: Target;

Function Fakultet(N: Integer): Real;
var BigBUFF: array[1..50] of byte;
begin
  if SPtr<1200 then LongJmp(T,SPtr);
  if N=1 then
    Fakultet:=1
  else
    Fakultet:=N*Fakultet(N-1);
end;

var
  n: Integer;
begin
  n:=SetJMP(T);
  if n<>0 then begin
    writeln('Fakultets fejl. Stakfejl, SPtr=',n);
    HALT;
  end;
  for n:=1 to 20 do
    writeln(Fakultet(n):15:0,' =',n:2,'!');
end.
