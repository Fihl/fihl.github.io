; LJMP.ASM filen. Giver efter assemblering filen LJMP.OBJ

; Assembleres s†ledes:
; TASM LJMP    med Turbo assembleren eller
; MASM LJMP;   med Microsoft assembleren

        PUBLIC  SetJMP,LongJMP         ; Giv rutinerne til TurboPascal

Target  struc                          ; Strukturen Target fra LJMP.PAS
SaveSP  DW    ?                        ; Target= Record
SaveBP  DW    ?                        ;   SP,BP,IP,CS: Word;
SaveIP  DW    ?                        ; end;
SaveCS  DW    ?
Target  ends

CODE    segment                         ; Der er kun kode i dette modul

; function  SetJMP(T: Target): Integer;       EXTERNAL;
SetJMP: pop     bx                      ; Pop returadressen af stakken
        pop     cx                      ; --
        pop     di                      ; Hent adressen p† T
        pop     es                      ; --
        mov     ES:SaveSP[di],SP        ; Gem SP i T
        mov     ES:SaveBP[di],BP        ; Gem BP i T
	mov     ES:SaveIP[di],bx        ; Gem offset af returadressen i T
	mov     ES:SaveCS[di],cx        ; Gem segment af returadressen i T
        xor     ax,ax                   ; Returner 0 efter installering
        jmp     ES:dword ptr SaveIP[di]

; procedure LongJMP(T: Target; Val: Integer); EXTERNAL;
LongJMP:pop     ax                     ; Retur adressen bruges ikke
        pop     ax                     ; --
        pop     ax                     ; Val
        pop     di                     ; Offset af T
        pop     es                     ; Segment af T
        mov     SP,ES:SaveSP[di]       ; Reetabler SP
        mov     BP,ES:SaveBP[di]       ; og BP
        sub     ax,1                   ; Returner Val. AX = 0 er ulovlig!
        adc     ax,1                   ; 0 => 1, ellers u‘ndret
        jmp     ES:dword ptr SaveIP[di]; Returner Val efter hop gennem SetJMP

CODE    ends
        end
