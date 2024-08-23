Program PrintScreenFilter;

{ Af Christen Fihl 1991 for PC World                                        }

{ Programmet tester sk‘rmbilledet for m‘rkelige styretegn                   }
{ f›rend den gamle PrintScreen rutine kaldes                                }

{ Skal overs‘ttes med Turbo Pascal version 6, da der bruges                 }
{ inline assembler. Dette 'kan' dog godt ‘ndres                             }

{$M 1024,0,0}
Uses Dos;

Const
  CharCount    = 25*80;                 { Antal tegn p† sk‘rmen             }
  Logo         : String[40] = 'PC World dukker op alle vegne...   ';
  LogoPosX     = 1;                     { Hvor skal logo'en placeres        }
  LogoPosY     = 24;                    { Her er valgt 1,24 (Sidste linje)  }
  LogoIndexM1  = LogoPosY*80+LogoPosX-1;{ Skal helst blive indenfor sk‘rmen }

Type
  TScreen = array[1..CharCount] of
              record
                Tegn: Char;
                Attr: Byte
              end;
  PScreen = ^TScreen;

Var
  Vektorer:   Array[0..255] of Pointer absolute $0000:$0000;
  OldInt5Vec: Pointer;                  { Adressen p† maskinens gamle PrScr }
  ScreenCopy: TScreen;                  { Kopi af sk‘rmen                   }
Const
  Screen:     PScreen=NIL;              { En peger til sk‘rmen              }

Procedure NewPrtScreen; Interrupt;
{Det er bedst IKKE at have variabler her. Ellers bruges for meget stakplads }
var                                     { Men et par enkelte skader da ikke }
  Index:      Integer;                  { Den eneste t‘ller i programmet    }
  ErKlar:     Boolean;                  { Udelukkelsesflag         (Privat) }
  CrtMode:    Byte absolute $0040:$0049;{ 3=Farve sk‘rm, 7=S/H sk‘rm        }
begin
  ErKlar:=Screen=NIL;                   { Allerede i brug?                  }
  if ErKlar then begin
    case CrtMode of
    2,3: Screen:=Ptr($B800,0);          { B›r v‘re en lokal kopi da der kan }
    7:   Screen:=Ptr($B000,0);          { tastes PrScr flere gange imens    }
    else ErKlar:=False;                 { Gik ikke! Viser m†ske grafik nu.  }
    end;

    if ErKlar then begin
      ScreenCopy:=Screen^;              { Tag en kopi af alt p† sk‘rmen     }
      for Index:=1 to CharCount do      { Gennems›g 25 linier af 80 tegn    }
	case Screen^[Index].Tegn of
(*----	'‘': Screen^[Index].Tegn:='{';  { ‘›†’ => {|}[\]. Ikke gjort her!*)
        #$00..#$1F,                     { Fjern alle styretegn 0..31        }
	#$7F,                           { DEL tegnet. Er altid et problem!  }
{-----  #$80..#$FF:                     { Fjern m†ske alle 8 bits tegn      }
        #$FF: Screen^[Index].Tegn:=' '; { Fjern kontrol tegn midlertidig    }
        end;

      for Index:=1 to Length(Logo) do   { Skriv en f‘lles overskrift        }
        Screen^[Index+LogoIndexM1].Tegn:=Logo[Index];

{Lav eventuelt altid en sideskift. Fjern da kommentaren f›rst p† n‘ste linje}
{-- Screen^[CharCount].Tegn:=#12;       { Er udkommenteret!!!               }

    end; {ErKlar }
  end; {ErKlar}

  asm                                   { Brug inline assembleren           }
        STI                             { Tillad nye interrupts             }
        PUSHF                           { Simuler et interrupt kald         }
        CALL    OldInt5Vec              { derfor pushf f›r kaldet           }
  end;

  if ErKlar then begin                  { Reetabler sk‘rmbilledet           }
    Screen^:=ScreenCopy;
    Screen:=NIL;                        { Kan nu genbruges                  }
  end; {ErKlar }
end;

begin
  OldInt5Vec:=Vektorer[5];              { Gem adressen p† den gamle rutine  }
  Vektorer[5]:=@NewPrtScreen;           { S‘t adressen p† den nye (vores)   }
{ Fjern environment omr†det, dvs det med PATH=, PROMPT= etc                 }
{ Dette omr†de kan da genbruges af n‘ste program der startes                }
  asm                                   { Brug inline assembleren           }
        MOV     ES,PrefixSeg            { Adressen (segment) p† vores PSP   }
        MOV     ES,ES:[$002C]           { Adressen (segment) p† environment }
        MOV     AH,49H
        INT     21H                     { Frigiv environment                }
  end;
  Keep(0);                              { L‘g programmet fast i hukommelsen }
end.
