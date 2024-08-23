Program MiniCalc;
{$I-,N-,M 5000,0,0
  Regnemaskine af Christen Fihl for PC-World 1990
  Pascalfilen bõr kaldes !.PAS pÜ disken, hvorved TurboPascal genererer !.EXE
  Bruges som fx.    ! P=3.1415927
                    ! 22/7 / P ; 2+3
  Kan ogsÜ bruges interaktiv, ved blot at skrive ! pÜ DOS linjen
}
{ Type Real=Double;       {Erklër dette, hvis IEEE format/nõjagtighed õnskes}
Const NextIsError=#1; NextIsValue=#2; NextIsName=#3; NextIsEOF=#4;
Type  TStr   =     String[80];
      TSaved =     Array['A'..'Z'] of Real;
Var   FSaved:      File of TSaved;                {Diskfilen for de samme 26}
      Saved:       TSaved;                         {De 26 hukommelses celler}
      InputLine:   TStr; {Bruges ved debug Kik pÜ denne sammen med InputShow}
      InputShow:   TStr; {Bruges ved debug Kik pÜ denne sammen med InputLine}
      Position,n:  Integer;                           {Position pÜ InputLine}
      ErrPos:      Integer;                   {Peger pÜ fejlstedet hvis fejl}
      LastPos:     Integer;{Bruges for at kunne gÜ tilbage/gentage pÜ linjen}
      CmdLine:     TStr;            {Brugerens linje. Adskilles med tegnet ;}
      NextName:    TStr;            {ID returneret af Next nÜr Ch=NextIsName}
      NextVal,R:   Real;          {Vërdi returneret af Next nÜr Ch=NextIsVal}
      Ch,LastCh:   Char; {Ch=specialtegn som +, eller de 4 forannëvnte Const}

{Find nëste token (element) fra linjen. Afleverer Ch=Sidste tegn/tal/navn}
procedure Next;
var p,e: integer;
procedure NextCh;
begin
  if Position<=Length(InputLine) then inc(Position);
  if Position>Length(InputLine) then Ch:=NextIsEOF
  else Ch:=UpCase(InputLine[Position]);
  InputShow[Position]:='^';
end;
procedure PrevCh;                                      {Spol et tegn tilbage}
begin
  InputShow[Position]:=' '; dec(Position)
end;

begin {procedure Next}
  LastCh:=Ch; LastPos:=Position;                          {Gem forrige token}
  repeat NextCh until Ch<>' ';                    {Glem alle disse blanktegn}
  FillChar(InputShow,SizeOf(InputShow),' ');      {Lav pën debugger variabel}
  InputShow[0]:=InputLine[0]; InputShow[Position]:='^';
  ErrPos:=Position;                          {Vis dette hvis der kommer fejl}
  case Ch of
  '0'..'9','.':            {Indlës et tal. Heltal, decimalt, eller eksponent}
    begin
      p:=Position;
      repeat NextCh until not (Ch in ['0'..'9','.']);
      if UpCase(Ch)='E' then begin  {Sõg efter eksponent som fx E+13}
        NextCh;
        if Ch in ['+','-'] then NextCh;
        while Ch in ['0'..'9'] do NextCh;
      end;
      Val(Copy(InputLine,p,Position-p),NextVal,e);
      if e<>0 then begin Position:=p+e-1; Ch:=NextIsError end;
      PrevCh; Ch:=NextIsValue;
    end;
  'A'..'Z':                                   {Indlës et navn (til NextName)}
    begin
      NextName:='';
      while (Ch in ['A'..'Z']) do begin NextName:=NextName+Ch; NextCh end;
      PrevCh; Ch:=NextIsName;
    end;
  end;
end;

function AddExpr: Real; FORWARD;

function Factor: Real;             {Den inderste rutine i udtryks beregneren}
function FindAndSkip(What: TStr): Boolean;
begin
  if NextName=What then begin
    Next;  FindAndSkip:=True;
  end else FindAndSkip:=False;
end;

begin
  case Ch of
  NextIsValue:
    begin
      Factor:=NextVal;
      Next;
    end;
  NextIsName:      {Kan skrives som SIN(10) eller som SIN 10 (uden parentes)}
    begin
    {TILFùJ dine egne rutiner her pÜ samme mÜde!!!!!!!!!!!!!!!}
      if FindAndSkip('PI')   then Factor:=PI             else   {3.1415927..}
      if FindAndSkip('SQR')  then Factor:=sqr(Factor)    else       {Kvadrat}
      if FindAndSkip('SQRT') then Factor:=sqrt(Factor)   else    {Kvatratrod}
      if FindAndSkip('ABS')  then Factor:=abs(Factor)    else {Absolut vërdi}
      if FindAndSkip('SIN')  then Factor:=sin(Factor)    else         {Sinus}
      if FindAndSkip('COS')  then Factor:=cos(Factor)    else       {Cosinus}
      if FindAndSkip('ARCTAN') then Factor:=arctan(Factor) else  {ArcTangens}
      if FindAndSkip('LOG')  then Factor:=ln(Factor)/ln(10) else  {Logaritme}
      if FindAndSkip('LN')   then Factor:=ln(Factor)     else  {Naturlig log}
      if FindAndSkip('EXP')  then Factor:=exp(Factor)    else   {Exponential}
      if FindAndSkip('MIN')  then begin  {Eksempel pÜ brugerdefineret rutine}
        if Saved['X']<Saved['Y'] then Factor:=Saved['X']  {Returner min(x,y)}
        else                          Factor:=Saved['Y']
      end else
      if Length(NextName)=1 then begin
        Factor:=Saved[NextName[1]];
        Next;
      end else Ch:=NextIsError
    end;
  '(':                                              {Bruges til fx X=3+(4*5)}
    begin
      Next;
      Factor:=AddExpr;     {Kald den nederste Expr rutine rekursiv}
      if Ch<>')' then Ch:=NextIsError              {SKAL ende i )}
      else Next;
    end;
  else {Fejl}
    Ch:=NextIsError; Factor:=0;
  end;
end;

function SignedFactor: Real; {SignedFactor ::= (+|-| ) SignedFactor}
begin
  case Ch of
  '-': begin Next; SignedFactor:=-SignedFactor; end;
  '+': begin Next; SignedFactor:=+SignedFactor; end;
  else
    SignedFactor:=Factor;
  end;
end;

function Term: Real;         {Term ::= (^| ) SignedFactor}
var   R: Real;
begin
  R:=SignedFactor;
  while Ch='^' do begin
    Next; R:=exp(ln(R)*SignedFactor);
  end;
  Term:=R;
end;

function MulExpr: Real;      {MulExpr ::= Term (*|/| ) Term}
var   R: Real;
begin
  R:=Term;
  while Ch in ['*','/'] do begin
    Next;
    case LastCh of
    '*': R:=R*Term;
    '/': R:=R/Term;
    end;
  end;
  MulExpr:=R;
end;

function AddExpr: Real;      {AddExpr ::= MulExpr (+|-| ) MulExpr}
var   R: Real;
begin
  R:=MulExpr;
  while Ch in ['+','-'] do begin
    Next;
    case LastCh of
    '+': R:=R+MulExpr;
    '-': R:=R-MulExpr;
    end;
  end;
  AddExpr:=R;
end;

function AssignStmt: Boolean;  {AssignStmt ::= ID=AddExpr}
var ID: Char; Pos2: Integer;
begin
  AssignStmt:=False;
  if Ch=NextIsName then begin
    Pos2:=LastPos; ID:=NextName[1];                          {Gem tilstanden}
    Next; if Ch='=' then begin                         {Skip ID, sõg efter =}
      Next; Saved[ID]:=AddExpr;                          {Gem udtryk i Saved}
      AssignStmt:=True;
    end else begin
      Position:=Pos2; Next;                   {Genetabler scanner tilstanden}
    end;
  end;
end;

Label Exit;
begin {Main program}
  InputLine:=ParamStr(0);         {Programnavn hvis DOS 3.3 og senere bruges}
  if InputLine='' then InputLine:='C:\!.EXE';     {='' hvis ëldre DOS bruges}
  InputLine[Length(InputLine)]:='D'; { 'C:\!.EXE' =>  'C:\!.EXD' = datafil}
  assign(FSaved,InputLine); reset(FSaved); FillChar(Saved,SizeOf(Saved),0);
  if IOResult=0 then Read(FSaved,Saved) else rewrite(FSaved);{Lës hukommelse}
  if ParamCount=0 then writeln('MiniCalc fra PC-World');
  repeat
    if ParamCount=0 then begin                           {Interaktiv version}
      write('* '); readln(CmdLine); if CmdLine='' then goto Exit;
    end else begin                                    {Kommandolinje version}
      CmdLine:=''; for n:=1 to ParamCount do CmdLine:=CmdLine+ParamStr(n)+' '
    end;
    repeat
      Position:=Pos(';',CmdLine+';');      {Hent udtryk en for en fra linjen}
      InputLine:=Copy(CmdLine,1,Position-1); Delete(CmdLine,1,Position);
      Position:=0; Next;
      if (Ch<>NextIsEOF) then begin
        if not AssignStmt then begin         {X=2+3. Tildeling uden udskrift}
          R:=AddExpr;                           {2+3. Beregning med udskrift}
          if Ch=NextIsEOF then begin
            write('= ');
{           if abs(R)>1 then writeln(R:10:2) else {evt andre udskriftsformer}
            if R=0 then writeln(0) else
            writeln(R);
          end;
        end;
        if Ch<>NextIsEOF then writeln(InputLine,#13#10'^ fejl':ErrPos+8);
      end;
    until (CmdLine='');
  until (ParamCount>0);      {Kun 1 gang rundt, hvis kommandolinje versionen}
Exit:
  seek(FSaved,0); Write(FSaved,Saved);       {Gem hukommelsen vëk til senere}
end.
