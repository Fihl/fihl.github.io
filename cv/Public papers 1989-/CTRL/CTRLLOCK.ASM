;       CtrlLock (C) Christen Fihl 1990. Tlf: 42 17 52 73
;       Ombyt CapsLock og Ctrl tasternes virkning
; Virker KUN p† 80286/80386 maskiner, der har INT15 underst›ttelse af INT9!

; Lav CtrlLock.COM s†ledes (med Turbo assembleren):
; TASM CtrlLock
; TLINK /t /x CtrlLock
; DEL CtrlLock.obj

; ERRORLEVEL s‘ttes til: 0=Passiv, 1=Aktiv, 2=installeret og aktiv, 99=fejl

Code    SEGMENT

MagiskTast EQU  0DDh                   ; Magisk v‘rdi. En ubrugt "skankode"
MagiskSub  EQU  0                      ; Sub magisk v‘rdi
                                       ; 0..15 reserveret Christen Fihl

Org0    LABEL   BYTE                   ; Label i adresse 0000

        ORG     005CH                  ; F›rste ledige adresse, normalt 100h!
OldVec  DD      ?                      ; Adressen p† den gamle rutine
Aktiv   DB      ?                      ; -1 = Ctrl-CapsLock omskifteren aktiv
E0Flag  DB      ?                      ; Sat til -1 n†r E0 koden er m›dt
NewINT15H:                             ; Flyt koden fra INT15H hertil

        ORG     0100H                  ; HER startes programmet af DOS
        ASSUME  CS:Code,DS:Code

Start:  JMP     short Init
        DB      13,'CtrlLock (C) Christen Fihl 1990. Tlf: 42 17 52 73',13,10
        DB      'Ombytter CapsLock og Ctrl tasternes virkning',13,10,10,26
Init:   ;;JMP	Start2          ; =EB 10 Glem testen p† visse mystiske maskiner
        MOV     AH,0C0h                ; Hent system oplysninger fra AT & PS/2
        INT     15h
        MOV     DX,OFFSET IkkePC       ; Fejl tekst "Ikke fra en PC'er"
        MOV     AL,99                  ; ERRORLEVEL 99 = Alvorlig fejl
        JC      PrintE                 ; Ingen systemoplysning!
        TEST    ES:byte ptr 5[BX],10h  ; Bruges INT15 fra INT9?
        JZ      PrintE                 ; Nej, kan DERFOR IKKE bruges!!!!!
Start2: MOV     AX,4F00h+MagiskTast    ; Er min INT15 allerede installeret?
        MOV     BX,MagiskSub
        STC
        INT     15h                    ; Kald min eller gammel INT15H
        JC      InstallProg            ; Min version ikke installeret, g›r det
; Var installeret, udskriv status og afslut med ERRORLEVEL sat til 0 eller 1
        AND     AL,1                   ; ERRORLEVEL: 1=Aktiv, 0=Passiv
        MOV     DX,OFFSET ErPassi      ; Status: "Er passiv"
        JZ      PrintE
        MOV     DX,OFFSET ErAktiv      ; Status: "Er aktiv"
PrintE: PUSH    AX                     ; Skriv tekst i DX og HALT(fejl=AL)
        CALL    Print
        POP     AX
        MOV     AH,4Ch                 ; HALT med ERRORLEVEL=0, 1 eller 99
        INT     21h                    ; STOP. Her afsluttes installeringen
Print:  MOV     AH,09h
        INT     21h
        RET

; * Installer INT15H driveren ********************************************
InstallProg:
        MOV     DX,Offset Instal       ; Status: "Installerer.."
        CALL    Print
        MOV     Aktiv,-1               ; Initialisere variabler
        MOV     E0Flag,0               ; ? bet›d "ved ikke"
CodeSize=OFFSET INT15end-OFFSET INT15H ; m† ikke v‘re ALT for stor
        MOV     CX,CodeSize            ; Flyt s† meget kode
        MOV     SI,OFFSET INT15H       ; herfra
        MOV     DI,OFFSET NewINT15H    ; hertil
        PUSH    CS
        POP     ES
        CLD
        REP     MOVSB                  ; Flyt det
; Hent gammel interrupt 15h og gem
        MOV     AX,3515h
        INT     21h
        MOV     word ptr [OldVec+2],ES
        MOV     word ptr [OldVec],BX
; Installer ny interrupt 15h
        MOV     DX,OFFSET NewINT15H
        MOV     AX,2515h
        INT     21h
; Fjern enviroment omr†det, alts† det med PATH=, PROMPT= etc
; Dette omr†de kan s† genbruges af n‘ste program der startes
        MOV     ES,DS:[002Ch]
        MOV     AH,49H
        INT     21h
CodeBase=(OFFSET NewINT15H-OFFSET Org0) ;Lidt besv‘rlig!
        MOV     DX,(CodeBase+CodeSize+15)/16 ; Behold kun s† meget
        MOV     AX,3102h               ; Stay Resident, ErrorLevel=2 =1.gang
        INT     21h                    ; S† er programmet afsluttet!
                                       ; Den residente del ligger der stadig

; * Resident del *********************************************************
; Bliver flyttet nedad i lageret ved installering

        ASSUME  CS:Code,DS:Nothing     ; KUN AX registeret m† bruges!!!!
INT15H  PROC    FAR                    ; FAR medf›rer: RET => RETF
        CMP     AH,04Fh                ; Keyboard intercept= INT15(AH=4F)
        JNZ     UseOld
        CMP     AL,MagiskTast          ; Styring af Aktiv/Passiv?
        JNE     NotEna
        CMP     BL,MagiskSub           ; Giv plads til mange flere af denne
        JNE     NotEna                 ; type programmer
        NOT     Aktiv                  ; Skift mellem Aktiv/Passiv
        MOV     AL,Aktiv               ; Returner Aktiv flaget
        CLC                            ; Slet CARRY= vis at ordren er opfattet
        RET     2                      ; RETF instruktion da INT15H er proc FAR
NotEna: CMP     Aktiv,0                ; Aktiveret?
        JE      UseOld                 ; Nej
        MOV     AH,1+1
        CMP     AL,0E0h                ; Glem sekvenser med "E0 NN"
        JE      SkipE0
        MOV     AH,2+1
        CMP     AL,0E1h                ; Glem sekvenser med "E1 NN NN"
        JE      SkipE0                 ; Pause knappen blev brugt, gav E1
        CMP     E0Flag,0               ; Var forrige E0/E1, s† glem denne
        JNE     DecE0                  ; 2 => 1, 1 => 0
        CMP     AL,01Dh                ; Ombyt 1D med 3A
        MOV     AH,03Ah
        JZ      Found
        CMP     AL,03Ah                ; Ombyt 3A med 1D
        MOV     AH,01Dh
        JZ      Found
        CMP     AL,09Dh                ; Ombyt 9D med BA
        MOV     AH,0BAh
        JZ      Found
        CMP     AL,0BAh                ; Ombyt BA med 9D
        MOV     AH,09Dh
        JNZ     NotFnd
Found:  MOV     AL,AH                  ; Returner den nye tastv‘rdi
        MOV     AH,0+1                 ; Efter normale taster
SkipE0: MOV     E0Flag,AH              ; slettes "E0 har v‘ret der" flaget
DecE0:  DEC     E0Flag
NotFnd: MOV     AH,04Fh                ; Genskab AH=04Fh
UseOld: STC
Ret2:   JMP     OldVec
INT15end:
INT15H  ENDP

; * Tekster **************************************************************
IkkePC  DB      'CtrlLock kan ikke bruges p† denne maskine',13,10,'$'
Instal: DB      'Ctrl-CapsLock ombytter (C) Christen Fihl 1990.',13,10;.......
ErAktiv DB      'CtrlLock er aktiv',13,10,'$'
ErPassi DB      'CtrlLock er passiv',13,10,'$'

Code    ENDS
        END     Start
