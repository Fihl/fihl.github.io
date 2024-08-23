Unit LJMP;
{ Af Christen Fihl, for PC-World
  Definition af SetJMP, LongJMP rutinerne og af Target typen
  Bruges s†ledes:
  if SetJMP(T)<>0 then writeln('T: returneret')
  else writeln('T er installeret');
  .....
  LongJMP(T,1);
}


interface

Type
  Target= Record
    SP,BP,IP,CS: Word;
  end;

function  SetJMP(T: Target): Integer;
procedure LongJMP(T: Target; Val: Integer);

implementation

{$L LJMP.OBJ}

function  SetJMP(T: Target): Integer;        EXTERNAL;
procedure LongJMP(T: Target; Val: Integer);  EXTERNAL;

end.
