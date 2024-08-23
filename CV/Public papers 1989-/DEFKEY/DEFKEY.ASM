	TITLE	Tastatur omdefinering og type-ahead udvidelse fra 15 til 40

;	Copyright (C) 1991, Christen Fihl og PC-World

;       Kan assembleres med TASM, assembleren fra Borland
;;      tasm DEFKEY
;;      tlink /x /t DEFKEY;             ;Resultatet er DEFKEY.COM
;;      del DEFKEY.obj

DEFBUFZ	EQU	420                     ;Buffer plads til ca 200 tegn

; Data omrÜde ABSOLUTE $0040:$0000
BIOSAREA EQU	40H
SHFTS    EQU    ES:BYTE PTR 017H        ;=8 med ALT tasten nedtrykket
SYSOUTP  EQU    ES:WORD PTR 01AH        ;UdPil for BIOS kald
SYSINP	 EQU    ES:WORD PTR 01CH        ;IndPil for interrupt rutinen
SYSBUF   EQU    ES:WORD PTR 000H        ;Type definition
SYSFRST	 EQU    ES:WORD PTR 080H        ;^Fõrste word i bufferen
SYSLAST	 EQU    ES:WORD PTR 082H        ;^Sidste word i bufferen+2
BIGBUFA  EQU    ES:WORD PTR 0AEH        ;00AEH..0100H er ubrugt indtil videre
BIGBUFL  EQU    ES:WORD PTR 100H        ;..

CODE	SEGMENT WORD

	ASSUME	CS:CODE,DS:CODE

Org0    LABEL   BYTE

	ORG	5CH+1                   ;FCB omrÜde, initialiseret af DOS
Flag1   DW      ?

	ORG	0A0H                    ;Plads til nogle variabler
INT9	DD	?       		;Kopi af INT9 vektoren
SAVECX  DW      ?
SAVEBX  DW      ?
SAVEDI  DW      ?

	ORG	100H                    ;Fõrste byte i programmet

        LOCALS                          ;Tillader brugen af @@ lokale symboler

START:	JMP	INIT                    ;Fõrste linje i programmet
        DB      'DEFKEY'                ;Kende mërker for SETKEY opdatering
        DW	DEFBUF,DEFBUFE-DEFBUF	;

; INT9	KEYBOARD INTERRUPT ROUTINE *******************************************

XINT9	PROC	FAR
	PUSH	AX
	PUSH	BX
	PUSH	CX                      ;DX ikke gemt!
	PUSH	SI
	PUSH	DI
	PUSH	DS
	PUSH	ES
	PUSH	CS
	POP	DS
	MOV	AX,BIOSAREA
	MOV	ES,AX                   ;Global value in ES
        MOV     SI,SYSINP               ;Gem vërdi fõr INT9 kaldet
	PUSHF                           ;Simuler et INT 9H kald
	CALL	INT9                    ;til den gamle INT9 rutine (i ROM)
	IN	AL,60H                  ;Hent skan-koden for tasten. ESC=1
	MOV	AH,SHFTS
	AND	AH,0FH
	CMP	AX,0801H                ;Definitions knappen ALT-ESC trykket
;;	CMP	AX,044CH                ;Definitions knappen Ctrl-Num5 trykket
        JZ      @@Res
        CMP     SI,SYSINP               ;Samme som fõr INT9 kaldet?
        JZ      Return
        MOV     AX,SYSBUF[SI]           ;Nej, hent tasten fra bufferen
@@Res:  CLD
        JMP     SHORT Resume
Return: POP	ES
	POP	DS
	POP	DI
	POP	SI
	POP	CX
	POP	BX
	POP	AX
	IRET
XINT9	ENDP

PDEFKEY DW      DEFKEY                  ;Tilstands variabel for WaitKey
MAXBUFS DW      15+1                    ;Max 15 characters in buffer

; Interrupt hjëlpe rutine ****************************************************
; "Vent" pÜ nëste taste tryk
; Kun BX,CX,DI bliver gemt
; Der mÜ IKKE vëre noget extra pÜ stakken ved indgang, ellers total havari
; Returner Zero flaget hvis ALT-ESC er trykket
; Simulerer en funktion der returnerer den nëste tast der trykkes,
; men reelt returneres der fra interrupt rutinen indtil nëste interrupt kommer
WaitKey:POP	PDEFKEY                 ;Gem "gammel" adresse
        MOV     SAVEDI,DI               ;Husk: Intet pÜ stakken!!!!
	MOV	SAVECX,CX
        MOV	SAVEBX,BX
        JMP	SHORT Return	        ;"Returner" indtil nëste taste tryk
Resume:	MOV	BX,SAVEBX               ;Input: Zero hvis ALT-ESC trykket
	MOV	CX,SAVECX
        MOV	DI,SAVEDI
	CMP	AX,0801H                ;Sët Zero flag hvis definitions tast
;;	CMP	AX,044CH                ;Definitions knappen Ctrl-Num5 trykket
        JMP     PDEFKEY		        ;Fortsët hvor WaitKey slap

; IN:   ES      0040H
;       SI      SYSINP
DEFKEY:	JE	@@1                     ;Definitions tast?
        CALL    ExpKey                  ;Nej, expander den hvis fundet
@@0:    CALL    WaitKey			;Fõrste tast
        JMP	DEFKEY
@@1:	CALL	WaitKey			;Anden tast
        JNE	@@2
	MOV	DEFBUF,0	        ;Slet definitions buffer
        JMP	@@0
@@2:	CALL	FindKey			;Ind: AX=Key, OUT: BX=^KEY
	CALL	DelKey			;Ind: BX
	CALL	FindKey			;Ind: AX=Key, OUT: BX=^KEY
        MOV	CX,MAXBUFS              ;Max taster i bufferen+1. (16/41)
        MOV	DI,BX			;Gem start pointeren. Viser tast antallet
        JMP     SHORT @@First           ;Vis aldrig den definerede tast selv
@@Loop: CALL	WaitKey			;efterfõlgende taste tryk
        JE	@@0                     ;Slut pÜ definitionen
	INC     WORD PTR [DI]           ;1 tast mere i bufferen
        INC	BX
        INC	BX
        CMP     Flag1,'H-'              ;Skal de andre taster vises?
        JNE     @@4
@@First:MOV     SYSINP,SI               ;Nej, glem den
@@4:    MOV	[BX+2],AX               ;Gem tasten i vores buffer
	MOV	WORD PTR [BX+4],0       ;Sët nyt slutmërke
        CMP	BX,OFFSET DEFBUFE-10	;Enden er nër?
        JGE     @@Beep
        LOOP    @@Loop
@@Beep: CALL    BEEP                    ;Ikke mere plads!
        JMP     @@0

; Hjëlpe rutiner *************************************************************

ExpKey: CALL    FindKey
        JC      @@9
        CLD
	MOV	DI,SI                   ;Fyld tegn i bufferen herfra. (SYSINP)
        CALL    @@Clr                   ;Fjern det brugte tegn (hvis fejl)
	LEA	SI,4[BX]
	MOV	CX,[BX]			;DEF found, RET NC, altid >= 1 !
@@Loop:	MOVSW                           ;Flyt alle tegn fra definitionen
	CMP	DI,SYSLAST              ;Sidste position i buffer
	JNE	@@2                     ;Ja, reset pointer til fõrste pos
	MOV	DI,SYSFRST              ;PÜ samme mÜde som BIOS'en opfõrer sig
@@2:	CMP	DI,SYSOUTP
	JE	BEEP                    ;bufferen er fyldt, glem alt foregÜende
	LOOP    @@Loop
@@Clr:  MOV     SYSINP,DI               ;Gem den nye pointer hvis alt gik godt
@@9:    RET

; Find definition
; IN    AX      ùnsket tast
; OUT   Flag NC hvis ikke fundet
;       BX      ^Definition hvis fundet, ellers ^nëste frie plads
; USES  DI
FindKey:MOV	BX,OFFSET DEFBUF
@@1:	CMP	WORD PTR [BX],0
	STC
	JE	@@9			;Definitionen ikke fundet
	CMP	AX,[BX+2]
	JE	@@9			;Definitionen fundet
	MOV     DI,[BX]
        ADD     DI,DI
        LEA     BX,4[BX+DI]             ;Nëste definition
	JMP	@@1
@@9:	RET

; Slet en definiton udpeget af BX
; IN    BX      ^Definition der skal slettes
; USES  BX
DelKey:	PUSH    SI
        PUSH	AX
        MOV     SI,[BX]
        ADD     SI,SI
        JZ      @@9                     ;Tom eller sidste definition
	LEA     SI,4[BX+SI]
	JMP     @@Strt                  ;Nëste definition, eller slut mërket
@@Loop:	INC	BX
	INC	BX
@@Strt:	LODSW                           ;Lës
	MOV	[BX],AX                 ;Flyt resten af definitionerne nedad
	OR	AX,AX
	JNZ	@@Loop
@@9:    POP	AX
        POP     SI
        RET

BEEP:	MOV	CX,100*2                ;Skal vëre et lige antal!
@@Loop: IN	AL,61H
	XOR	AL,2
        JMP     $+2                     ;Lidt pause for 386 PC'er
	OUT	61H,AL
	MOV	AH,100                  ;Tone frekvensen
@@L2:	DEC	AH
	JNZ	@@L2
	LOOP	@@Loop
	RET

        ALIGN                           ;En smule optimering
DEFBUF	DW      0                       ;Tom ved opstart
DEFBUFE	EQU	DEFBUF+DEFBUFZ          ;Buffer slut adresse (lëngere fremme)

; Opstart ********************************************************************

; Ret i INT9 vektoren, hardware interruptet for tastaturet
; Slet resten herfra

INIT:   MOV     AX,3509h                ;Hent gammel vektor
        INT     21h
	MOV	WORD PTR INT9,BX        ;Gem original vektor
	MOV	WORD PTR INT9+2,ES
; Find en evt tidligere version af DEFKEY
	MOV	SI,OFFSET XINT9         ;DS:SI = ^Vores residente kode
	MOV	DI,SI                   ;ES:DI = ^Gammel kode, mÜske vores egen
	MOV	CX,30                   ;Sammenlign de fõrste NN bytes
	REP	CMPSB                   ;Er den allerede installeret??
	JNE	@@Ok
@@Kopi: MOV     AX,Flag1                ;Flyt "-h" flaget til kopien
        MOV     ES:Flag1,AX
        CMP     AX,'  '
        JNE     @@NoMsg
        MOV     DX,OFFSET Allerede      ;Allerede installeret
        MOV     AH,09h
        INT     21h
@@NoMsg:MOV     AX,4C01h                ;HALT med ERRORLEVEL=1
        INT     21h                     ;STOP
@@Ok:   MOV     DX,OFFSET OkTekst       ;Ok, kan startes
        MOV     AH,09h
        INT     21h
; Installer ny interrupt 9
        MOV     DX,OFFSET XINT9
        MOV     AX,2509h
        INT     21h
; Fjern enviroment omrÜdet, altsÜ det med PATH=, PROMPT=, COMSPEC= etc
; Dette omrÜde kan sÜ genbruges af nëste program der startes
        MOV     ES,DS:[002Ch]
        MOV     AH,49H
        INT     21h
; Installer en stor buffer for interrupt rutinen
; ùger type-ahead bufferen fra 15 til 40 tegn
;;....  JMP     SHORT @@Skip            ;Skip 14 linjer hvis du fÜr problemer
	MOV	AX,BIOSAREA             ;Find 82 frie bytes i 40:AE .. 40:FE
	MOV	ES,AX
        MOV     BX,OFFSET BIGBUFA
        SUB     AX,AX
        CMP     ES:[BX],AX              ;OmrÜdet allerede brugt?
        JNZ     @@Skip                  ;Da glem alt om en stõrre buffer
        CMP     ES:18[BX],AX            ;Lav en enkelt test mere
        JNZ     @@Skip
        MOV     MAXBUFS,(OFFSET BIGBUFL-OFFSET BIGBUFA)/2
                                        ;Plads til 40 tegn (fõr 15)
        MOV     ES:SYSINP,BX
        MOV     ES:SYSOUTP,BX
        MOV     ES:SYSFRST,BX
        MOV     ES:SYSLAST,OFFSET BIGBUFL
@@Skip: MOV     DX,(OFFSET DEFBUFE-OFFSET Org0+15)/16 ;Antal segmenter fra CS:0
        MOV     AX,3100h               ;Keep(). Fjern alt efter bufferen
        INT     21h                    ;SÜ er programmet afsluttet!
                                       ;Den residente del ligger der stadig

; * Tekster ******************************************************************
Allerede        DB      'DEFKEY er allerede installeret',13,10,'$'
OkTekst         DB      'DEFKEY installeret',13,10,'$'

CODE	ENDS
	END	START                   ;Programmet starter in START

