Code    segment
        assume  CS:Code,DS:Nothing
Org0:
        org     100H
Start:  jmp     Initialize
        org     100H
OldInt8 dd      ?
; Kontrol struktur for Pascal brug
Pascal  db      0                       ;0=Ok, 1=Set0, 2=Set1
TimerV  dw      -1
Signatu db      9,'LydDriver'

TimerS  dw      -1
TimerD  dw      -1

Delay:  call    d2
d2:     call    d
d:      ret

TimerI  proc    far
        push    ax
        xor     ax,ax
        xchg    ah,Pascal               ;Case action of
        cmp     ah,al
        je      SetTime
        in      al,61H
        and     ax,2FDH                 ;AH nu 0 eller 2. AL=uden lyd bit
        or      al,ah
        call    Delay
        out     61H,al
SetTime:cmp     TimerV,0
        je      Ok
        mov     al,36H                  ;’ndre timer deleren
        out     43H,al
        xor     ax,ax
        xchg    ax,TimerV
        call    Delay
        out     40H,al
        mov     TimerS,ax               ;Husk p† timer deleren
        xchg    al,ah
        call    Delay
        out     40H,al
Ok:     mov     ax,TimerS               ;Ikke flere aktioner
        add     TimerD,ax
        jnc     Quick
        push    ds                      ;Stadig forrest i Timer k‘den??
        xor     ax,ax
        mov     ds,ax
        mov     ax,cs
        cmp     ax,ds:[8*4+2]
        je      IsFirst
        mov     TimerS,-1
IsFirst:pop     ds
        pop     ax
        jmp     OldInt8                 ;Brug den gamle timer rutine af og til
Quick:  mov     al,20H                  ;Ellers lav selv EOI
        out     20H,al
        pop     ax
        iret
TimerI  endp

;=============================================================================
Initialize:
        assume  CS:Code,DS:Code
        mov     ax,3508H                ;Hent den gamle Timer interrupt
        int     21H
        mov     WORD PTR OldInt8+0,bx
        mov     WORD PTR OldInt8+2,es
        mov     ax,2508H                ;Set ny Timer interrupt
        mov     dx,OFFSET TimerI
        int     21H
        mov     ax,2564H                ;Brug interrupt 64H som interface
        mov     dx,OFFSET Pascal        ;til Pascal rutinerne
        int     21H
        mov     es,ds:[2CH]             ;Fjern Environment
        mov     ah,49H
        int     21H
        mov     ax,3100H                ;Stay Resident, afslut installation
        mov     dx,((OFFSET Initialize-OFFSET Org0)+15)/16
        int     21H
Code    ends
        end     Start
