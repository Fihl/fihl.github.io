Program EGAdemo;

Procedure SetCursor(Linie1, Linie2: Byte); ASSEMBLER;
ASM     MOV     CH,Linie1               {Start linje                        }
        MOV     CL,Linie2               {Slut linje                         }
        MOV     AH,1                    {Set cursor udseende                }
        INT     10H                     {Kald video rutinen                 }
END;

Procedure CursorOff;                    ASSEMBLER;
ASM     MOV     DX,99 * 256 + 99        {Goto(99,99), altsÜ langt vëk       }
        MOV     BH,0                    {Video side=0                       }
        MOV     AH,2                    {Set cursor position                }
        INT     10H                     {Kald video rutinen                 }
END;

Type
  t8x8Array = array[Char,0..7] of Byte;         {?????????????????}
  t8x14Array = array[Char,0..13] of Byte;
Var
  Font8x8:  ^t8x8Array;
  Font8x14: ^t8x14Array;
  Font9x14: ^t8x14Array;

Procedure LoadFont(var Buf; No: Char);  ASSEMBLER;
ASM     MOV     DL,No                   {Fõrste tegn                        }
        MOV     DH,0
        MOV     CX,1                    {Antal                              }
	MOV     BX,1000H                {Det õnskede tegn                   }
	MOV     AX,1110H                {Set bitmõnster                     }
        PUSH    BP                      {BP Bruges. Dette er noget giftigt! }
        LES     BP,Buf                  {ES:DX := ^Bufferen                 }
        INT     10H                     {Kald video rutinen                 }
        POP     BP
END;

VAR Ch: Char;

Type  FontType= array[0..13] of Byte;
Const Font1: FontType=(1,2,4,8,16,32,64,128,$FF,$FF,0,0,0,$FF);
Const Font2: FontType=($FF,$FF,0,0,$FF,0,1,2,4,8,16,32,64,128);
Const FontSO: FontType=($00,$00,$00,$00,$00,$7C,$C6,$C6,$C6,$C6,$C6,$7C,$00,$00);
Const FontLO: FontType=($00,$00,$7C,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$7C,$00,$00);

begin
  writeln('ABEëõÜíùè `o`o`o~O~O~O0 DFGJSDGLíSDKJGSDíLKG');
  LoadFont(FontSO,'`');{õõõùùùùùù0}
  LoadFont(FontLO,'~');
end.


  gotoxy(3,3);
  CursorOff; DELAY(1000); gotoxy(3,3); writeln('davs');
  SetCursor(32,5); DELAY(1000); write('davs'); SetCursor(14,14); writeln('DAVS');
  delay(1000);
  delay(1000); SetCursor(14,14); write(' 14 ');
  delay(1000); SetCursor(8,8);   write(' 8 ');
  delay(1000); SetCursor(1,1);   write(' 1 ');
  delay(1000);
end.

Procedure SetFontBases;  ASSEMBLER;
ASM     PUSH    BP                      {BP Bruges. Dette er noget giftigt! }
        MOV     AX,1130H                {Hent bitmõnster                    }
        MOV     BH,2
        INT     10H                     {Kald video rutinen                 }
        MOV     word ptr Font8x14+0,ES
        MOV     word ptr Font8x14+2,BP
        MOV     AX,1130H                {Hent bitmõnster                    }
        MOV     BH,3
        INT     10H                     {Kald video rutinen                 }
        MOV     word ptr Font8x8+0,ES
        MOV     word ptr Font8x8+2,BP
        MOV     AX,1130H                {Hent bitmõnster                    }
        MOV     BH,5
        INT     10H                     {Kald video rutinen                 }
        MOV     word ptr Font9x14+0,ES
        MOV     word ptr Font9x14+2,BP
        POP     BP
END;

