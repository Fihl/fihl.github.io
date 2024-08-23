Unit DosFilter;

{ Af Christen Fihl 1989 }

{ Filerne Input, Output kan pipes som fx PROGRAM <fil1 >fil2  }
{ Filen ErrorOutput kan IKKE pipes, hvorfor fejlmeldinger kan }
{ gives selvom Output filer er pipet til en fil som >fil2     }
{$R-}

interface

var
  ErrorOutput: Text;            {ErrorOutput, kan IKKE redirektes til en fil!}
  DF1,DF2,DF3: Integer;    {Hj‘lpe variabler. Grimt, men sparer et par linjer}
  Line:  String;

const NoParamNo=$8000; {Magisk v‘rdi}

procedure Stop(Hvad,Lav,Hoej: integer; Tekst: String);     {Test "Hvad" er ok}
function  ParamNo(Nummer: integer): Integer;
procedure AdjustLine(var Line: string; Len: integer);    {Juster linje l‘ngde}
procedure RemTab(var Line: string; TabPos: integer);           {Fjern tabtegn}
procedure MakeTab(var Line: string; TabPos: integer);            {Lav tabtegn}
procedure RemSpace(var Line: string);                              {Fjern ' '}

implementation

Uses Dos;

Const StandardInput=0; StandardOutPut=1;                {Standard DOS filerne}
      StandardError=2; StandardAux=3; StandardPrinter=4;

{ Returner v‘rdien af en kommandolinje parameter. ELLER NoParamNo hvis fejl}
function  ParamNo(Nummer: integer): Integer;
var n,Fejl: integer;
begin
  val(ParamStr(Nummer),n,Fejl);
  if (Fejl<>0) or (ParamStr(Nummer)='') then word(n):=NoParamNo;
  ParamNo:=n
end;

{Juster linje l‘ngde. DVS tilf›j blanke, eller afkort efter behov}
{Resultatet er en linje p† samme l‘ngde hver gang                }
procedure AdjustLine(var Line: string; Len: integer);
begin
  while Line[0]<char(Len) do insert('     ',Line,255);           {Fyld ' ' p†}
  Line[0]:=char(Len);                                     {Fjern overskydende}
end;

{Fjern tabtegn fra linjen. Tab position faktoren skal angives}
procedure RemTab(var Line: string; TabPos: integer);
var m,n: integer;
begin
  repeat
    n:=pos(^I,Line);
    if n>0 then begin
      delete(Line,n,1);
      repeat insert(' ',Line,n); inc(n) until (n mod TabPos)=1;
    end;
  until n=0;
end;

{Lav nye tabtegn p† linjen. Tab position faktoren skal angives}
procedure MakeTab(var Line: string; TabPos: integer);
var m,n: integer;
begin
  RemTab(Line,TabPos);
  n:=TabPos; m:=Length(Line);
  while (n<m) do begin      {Gem alle blanke, der kun best†r af et enkelt ' '}
    if (Line[n]=' ') then if Line[n-1]=' ' then Line[n]:=^I else Line[n]:=#0;
    inc(n,TabPos);
  end;
  repeat n:=Pos(' '^I,Line);
    if n>0 then Delete(Line,n,1)   {Alle blanke f›r et tabtegn er overfl›dige}
  until n=0;
  while Pos(#0,Line)>0 do Line[Pos(#0,Line)]:=' ';                {Genetabler}
end;

{Fjern afsluttende blanktegn p† linjen}
procedure RemSpace(var Line: string);
begin
  while Line[ord(Line[0])]=' ' do dec(Line[0]);        {Er ret dyr i CPU tid!}
end;

{ Stop programmet hvis "Hvad" IKKE ligger i intervallet "Lav" til "H›j"      }
procedure Stop(Hvad,Lav,Hoej: integer; Tekst: String);
begin
  if (Hvad<Lav) OR (Hvad>Hoej) then begin
    writeln(ErrorOutput,Tekst);  {Skriv fejlen p† sk‘rmen}
    HALT(1);
  end;
end;

var    {Erkl‘r nogle bedre(=st›rre) buffere}
  BufferInput,BufferOutput: Array[1..1*1024] of char;
  BufferErrorOutput: char;      {Lille og langsom, men giver automatisk flush}

{Initializerings kode               }
{  Gen†ben Input & Output           }
{  Opret ny fil: ErrorOutput        }
{  G›r Input og Output hurtigere    }
begin
  Assign(Input,''); reset(Input);           {Gen†ben Input, hvis Crt er brugt}
  Assign(Output,''); rewrite(Output);      {Gen†ben Output, hvis Crt er brugt}
  Assign(ErrorOutput,''); rewrite(ErrorOutput); {Koster IKKE nogen ny handle!}
  TextRec(ErrorOutput).Handle:=StandardError;          {IKKE handle 1, MEN #2}
  SetTextBuf(Input,BufferInput);                         {Brug de nye buffere}
  SetTextBuf(Output,BufferOutput);
  SetTextBuf(ErrorOutput,BufferErrorOutput);
end.
