Unit DateCalc;

{ Af Christen Fihl "1956-05-09 onsdag" }

{ B›r kun bruges mellem 1900-03-01 of 2100-2-28 }

interface

Type JulType= Longint;                       {Dato i Juliansk kalender system}

function JulDate(Year, Month, Day: integer): JulType;      {Lav Juliansk dato}
procedure CalenderDate(JDate: JulType;                {Konverter tilbage igen}
                       var Year, Month, Day: integer);
function JulToday: JulType;                       {DagsDato i Juliansk format}
function Date(JDate: JulType): string;          {Returner dato i tekst format}
function WeekDay(JDate: JulType): integer;             {Ugedag. 0..6=s›n..l›r}
function WeekDayStr(JDate: JulType): string;                {Ugedag som tekst}
function WeekNo(JDate: JulType): integer;               {Ugenummeret for dato}
function JulDate1stWeek(JD: JulType): JulType;  {Juster dato til mandag uge 1}

implementation

Uses Dos;

Const DateOffset=1720982;

function Floor(R: real): real;
begin
  If R<0 then R:=R-1.0; Floor:=int(R)
end;

{ Lav Juliansk dato fra r, M†ned, Dag }
{ Returneret dato er gemt i Longint    }
function  JulDate(Year, Month, Day: integer): JulType;
begin
  If Month<=2 then begin
    Inc(Month,12);
    Dec(Year);
  end;
  JulDate:=round(floor(365.25*Year)+floor(30.6001*(Month+1))+Day+DateOffset)
end;

{ Udpak Juliansk format }
procedure CalenderDate(JDate: JulType; var Year, Month, Day: integer);
var
  DayNo,Y,Y365,M,D: Real;
begin
  DayNo:=JDate-DateOffset;
  Y:=floor((Dayno-122.1)/365.25);
  Y365:=floor(Y*365.25);
  M:=floor((DayNo-Y365)/30.6001);
  D:=DayNo-Y365-floor(M*30.6001);
  Year:=round(Y); Month:=round(M)-1; Day:=round(D);
  If Month>=13 then Dec(Month,12);
  If Month<=2 then Inc(Year);
end;

{ DagsDato i Juliansk format }
function  JulToday: JulType;
var
  Year, Month, Day, DayOfWeek: word;
begin
  GetDate(Year,Month,Day,DayOfWeek);
  JulToday:=JulDate(Year,Month,Day);
end;

{ Returner dato i tekst format "1989-12-31" }
function  Date(JDate: JulType): string;          {Returner dato i tekst format}
Const
  D: string[11]='0000-00-00';
Var
  Year, Month, Day: integer;
procedure Flyt2Cifrer(n,pos: integer);
var ns: string[2];
begin
  str(n,ns); if n<10 then insert('0',ns,1);                   {Altid 2 cifrer}
  move(ns[1],D[pos],2);
end;
begin
  CalenderDate(JDate, Year, Month, Day);
  Date:='';
  if Year>=0 then begin
    Flyt2Cifrer(Year div 100,1);    {19xx-xx-xx}
    Flyt2Cifrer(Year mod 100,3);    {xx90-xx-xx}
    Flyt2Cifrer(Month,6);           {xxxx-01-xx}
    Flyt2Cifrer(Day,9);             {xxxx-xx-03}
    Date:=D;
  end;
end;

{ Returner dagens nummer i ugen (0..6), 0=s›ndag }
function  WeekDay(JDate: JulType): integer;
begin
  WeekDay:=(JDate+1) mod 7;
end;

{ Returner dagens nummer i ugen som tekst. Hver fylder 7 tegn }
function  WeekDayStr(JDate: JulType): string;
Const
  WDayStr: array[0..6] of string[7]=                    {Alle er 7 tegn lange}
    ('s›ndag ','mandag ','tirsdag','onsdag ','torsdag','fredag ','l›rdag ');
begin
  if JDate>7 then JDate:=WeekDay(JDate);            {Enten 0..7 eller JulType}
  WeekDayStr:=WDayStr[JDate]
end;

{ Returner datoen p† den f›rste dag i ugen i JD †ret }
{ Uge 1 indeholder ALTID den f›rste torsdag i †ret   }
function  JulDate1stWeek(JD: JulType): JulType;
Var
  N, Year, Month, Day: integer;
  JDate: JulType;
begin
  CalenderDate(JD, Year, Month, Day);
  JDate:=JulDate(Year,1,1);
  if WeekDay(JDate) in [5,6,0] then N:=1 else N:=-1;       {fredag til s›ndag}
  while WeekDay(JDate)<>1 do JDate:=JDate+N;                  {mandag i uge 1}
  JulDate1stWeek:=JDate
end;

{ Returner ugenummeret for dato (1..53)            }
{ Uge 1 indeholder ALTID den f›rste torsdag i †ret }
function  WeekNo(JDate: JulType): integer;              {Ugenummeret for dato}
var
  W: JulType;
begin
  W:=JulDate1stWeek(JDate+31);
  if JDate<W then W:=JulDate1stWeek(JDate);
  WeekNo:=(7+JDate-W) div 7
end;

end.


Gammel version med fejl.....
{ Returner datoen p† den f›rste dag i ugen i JD †ret }
{ Uge 1 indeholder ALTID den f›rste torsdag i †ret   }
function  JulDate1stWeek(JD: JulType): JulType;
Var
  N, Year, Month, Day: integer;
  JDate: JulType;
begin
  CalenderDate(JD, Year, Month, Day);
  JDate:=JulDate(Year,1,1);
  if WeekDay(JDate) in [5,6,0] then N:=1 else N:=-1;       {fredag til s›ndag}
  while WeekDay(JDate)<>1 do JDate:=JDate+N;                  {mandag i uge 1}
  if JD>=JDate then
    JulDate1stWeek:=JDate
  else
    JulDate1stWeek:=JulDate1stWeek(JD-7);
end;
