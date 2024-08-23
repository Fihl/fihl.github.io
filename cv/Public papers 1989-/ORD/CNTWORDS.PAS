program CntWords;
{ Tël ord i en SPRINT fil
  Af Christen Fihl, 42175273 for PC-World
  Syntaks:  CntWords <fil> ... <fil>
  <fil> kan vëre med "*" og "?" som fx "*.def"

  Filer af typen ".DEF" indeholder linjer af formen
  -GJORDT    Ord der ER interessante/forkerte/forbudte. Udskrives
  MED        Alle andre ord der ikke er interessante. Overspringes
}

Uses Dos;
{$V-,S-,R-,I+}
{$M 64000,20000,655000}

Const
  vers=       '1.0';
  BindeTegn:  Set of Char=[#$1D,#$1E,'-'];
  PreStr:     String[30]='NGUDKRXBEIMPSWZACFHJLOQTVYíùè';   {"Binërt" ordnet}
  FirstLetter:Set of Char=['0'..'9','a'..'z','A'..'Z','ë','õ','Ü','í','ù','è'];
  Letter:     Set of Char=['0'..'9','a'..'z','A'..'Z',
                           'ë','õ','Ü','í','ù','è',#$90,#$82,#$9A,#$81
{***                       ,^B,^E,^N   {Bold, Italic, etc ***}
                          ];

Type
  RefType    = (Normale,Skjulte,Forbudte);
  ixwordptr  = ^ixword;
  ixword     = String[19];
  ixentryptr = ^ixentry;
  ixentry    = record
                 Antal,Last_Optimering: Integer;
                 What: RefType;
                 UsedInFile: Set of Byte;
                 Left,Right: ixentryptr;
                 Word: ixwordptr;
               end;

Const MaxNames = 50;                      {Antal filer der kan lëses per gang}
Type  FilesUsedType=0..MaxNames;

Var
  InpFile: Text;
  MemBefore: Longint;
  SR: SearchRec;
  Path: PathStr; FName,FExt: NameStr;
  FilesUsed: Array[FilesUsedType] of String[12];
  ParamIndex: Integer;

Const  {Initialiserede variabler}
  FileNameIndex: FilesUsedType=0;
  ixroot:   ixentryptr= NIL;
  nfiles:   Integer=0;

Procedure UpCaseStr(var Str: String); {Generel procedure. Lav store bogstaver}
var n: Integer;
    Ch: Char;
begin
  for n:=1 to length(Str) do begin
    Ch:=Str[n];
    case Ch of
      'a'..'z': Ch:=UpCase(Ch);
      'ë': Ch:='í'; 'õ': Ch:='ù'; 'Ü': Ch:='è';
      #$82: Ch:=#$90;
      #$81: Ch:=#$9A;
    end;
    Str[n]:=Ch;
  end;
end;

Procedure EnterWord(newword: ixword; W: RefType); {Indsët. Laver fõrst UpCase}
Procedure Enter(var root: ixentryptr);               {Indsët, lokal procedure}
begin
  if root=nil then begin                                   {Opret nyt element}
    new(root); FillChar(root^,SizeOf(root^),#0);
    with root^ do begin
      GetMem(Word,succ(ord(newword[0]))); Word^:=newword;   {Plads til streng}
      What:=W;
      if W=Normale then begin
        inc(Antal); UsedInFile:=[FileNameIndex];
      end;
    end;
  end else begin                {Bemërk sorterings rëkkefõlgen er ABC..XYZèíù}
    if newword<root^.Word^ then Enter(root^.Left) else          {Til venstre?}
    if newword>root^.Word^ then Enter(root^.Right) else         {Til hõjre?  }
    with root^ do begin                        {Lige i õjet, opdater tëllerne}
      if W=Normale then begin
        Inc(Antal);
        if Last_Optimering<>FileNameIndex then begin
          UsedInFile:=UsedInFile+[FileNameIndex];{Tager forholdsvis meget tid}
          Last_Optimering:=FileNameIndex;            {Derfor denne optimering}
        end;
      end else begin
        if (What<>Normale) and (What<>W) then  {Fejl i definitions filen}
          writeln('"',Word^,'" allerede erklëret anderledes i .DEF filen');
        What:=W
      end;
    end;
  end;
end;

begin   {EnterWord proceduren. Lav fõrst UpCaseStr. Kald derefter den interne}
  UpCaseStr(newword);
  Enter(ixroot);
end;

{ Indlës en "rigtig" tekstfil}
Procedure ReadTextFile;
var
  Line : String[50];
  Ch: Char;
begin
  while not eof(InpFile) do begin
    repeat read(InpFile,Ch) until (Ch in FirstLetter) or eof(InpFile);
    if not eof(InpFile) then begin
      Line:='';
      repeat
        if Ch in BindeTegn then read(InpFile,Ch);       {Deletegn som '-' etc}
        while not eof(InpFile) and (Ch in Letter) do begin
          if Ch>' ' then insert(Ch,Line,255);             {Opsaml et helt ord}
          read(InpFile,Ch);
        end;
      until not (Ch in BindeTegn);
    end;
    if Length(Line)>=3 then                                   {Glem "smÜ" ord}
      if Line[1]>='@' then EnterWord(Line,Normale);  {Skal starte pÜ 'A'..'z'}
  end;
end;

{ Indlës .DEF filer}
Procedure ReadDEF;
var Line: String;
begin
  while not eof(InpFile) do begin
    readln(InpFile,Line);
    delete(Line,Pos(' ',Line+' '),255);
    if Length(Line)>=2 then begin
      case Line[1] of
      '#': ;                                                {Kommentar linjer}
      '-': EnterWord(Copy(Line,2,255),Forbudte);            {MINUS ord. Vises}
      Else EnterWord(Line,Skjulte);                {Skjulte ord. Vises aldrig}
      end;
    end;
  end;
end;

{ Udskriv hele Strukturen.
  1: behandl venstre trë, 2: behandl elementet selv, 3: behandl hõjre trë
}
Procedure WriteTree(W: RefType);
var hdrchr: Char;
Procedure WriteSubTree(root: ixentryptr);
var n: Integer;
    Wrd: ixword;
begin
  if root=nil then EXIT;                                  {Slut pÜ denne gren}
  WriteSubTree(root^.Left);                          {Lõb gennem venstre gren}
  with root^ do                                                {Dette element}
  if (Antal>0) and (Antal<99) and (length(Word^)>=3) {Lav visse begrënsninger}
      and (W=What) then begin
    Wrd:=Word^;
    if Wrd[1]<>hdrchr then begin          {Begynder pÜ ord med nyt forbogstav}
      hdrchr:=Wrd[1]; writeln(#10,hdrchr,'..');
    end;
    write(Wrd,' ':20-Length(Wrd),Antal:3);              {Skriv det fundne ord}
    for n:=1 to FileNameIndex do
      if n in UsedInFile then write(' ',FilesUsed[n]); {Skriv alle filnavnene}
    writeln;
  end;
  WriteSubTree(root^.Right);                           {Lõb gennem hõjre gren}
end;

begin {WriteTree proceduren}
  hdrchr:=' '; WriteSubTree(ixroot); writeln;
end;

{ Hoved programmet }
begin
  writeln('CntWords Version ',vers);
  writeln('Tëller og sammenligner ordene i en (Sprint) tekstfil');
  writeln('Af Christen Fihl 1990, for PC-World Danmark');
  writeln;
  if ParamCount<1 then begin                            {Ingen filer angivet!}
    writeln('Syntaks: CntWords <fil> ... <fil>'+
            '         <fil> kan vëre med "*" og "?"');
    halt(1);
  end;
  for ParamIndex:=1 to Length(PreStr) do                  {Lav balanceret trë}
    EnterWord(PreStr[ParamIndex],Skjulte);
  MemBefore:=MemAvail;            {Udskriv senere hvor meget lager der bruges}
  for ParamIndex:=0 to ParamCount do begin               {0 => "CNTWORDS.DEF"}
    Path:=ParamStr(ParamIndex);
    FSplit(Path,Path,FName,FExt);
    if ParamIndex=0 then begin
      FExt:='.DEF'; if FName='' then FName:='CntWords';{DOS>=3.3 giver navnet}
    end;
{Se PC World nummer 3, 1990 under FilMotor, hvordan FindFirst bruges}
    FindFirst(Path+FName+FExt,(AnyFile and (not(Directory or VolumeID))), SR);
    if (DosError<>0) then
      writeln('Kan ikke finde......: ',Path+FName+FExt);
    while DosError=0 do begin
      if FileNameIndex=MaxNames then HALT {FEJL!!!} else inc(FileNameIndex);
      FilesUsed[FileNameIndex]:=SR.Name;
      while pos('.',FilesUsed[FileNameIndex])>0 do            {Slet EXTension}
        delete(FilesUsed[FileNameIndex],length(FilesUsed[FileNameIndex]),1);
      assign(InpFile,Path+SR.Name); {$I-} reset(InpFile) {$I+};
      if IOResult=0 then begin
        if pos('.DEF',SR.Name)=0 then begin
          writeln('Behandler filen.....: ',SR.Name);
          ReadTextFile;                                {"Almindelig" tekstfil}
        end else begin
          writeln('Initialiserer fra...: ',SR.Name);
          ReadDEF;                                           {Definitions fil}
        end;
        close(InpFile);
        Inc(nfiles);
      end;
      FindNext(SR);
    end;
  end;
  writeln(   'Heap brugt..........: ',  MemBefore-MemAvail:6,' bytes');
  writeln(   'Heap tilbage........: ',  MemAvail:6,' bytes');
  writeln(#10'Forbudte ord........: '); WriteTree(Forbudte);
  writeln(#10'Andre ord...........: '); WriteTree(Normale);
end.
