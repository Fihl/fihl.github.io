; Switch.COM

        LOCALS

Code    SEGMENT
        ASSUME  CS:Code
        ORG     100H
Start:  JMP     SHORT @@Initialize
        NOP
@@0103  DD      0
@@0107  DB      'CCRS'
@@010B: JMP     SHORT @@0127
        NOP
Count   DW      0
Busy    DW      0
CRight  DB      'revolution',1AH,'Key',1AH,'Switch'

@@0127: PUSHF
        CMP     AH,04Fh                         ;'O'
        JZ      @@0133
@@012D: POPF
        JMP     @@0103
@@0133: INC     Word Ptr CS:[Count]
        CMP     AL,0E0h
        JNZ     @@0146
        MOV     Word Ptr CS:[Busy],0001
        JMP     @@0177
        NOP
@@0146: TEST    Word Ptr CS:[Busy],-1
        JNZ     @@0170
        CMP     AL,01Dh
        JNZ     @@0158
        MOV     AL,03Ah                         ;':'
        JMP     @@0170
        NOP
@@0158: CMP     AL,09Dh
        JNZ     @@0161
        MOV     AL,0BAh
        JMP     @@0170
        NOP
@@0161: CMP     AL,0BAh
        JNZ     @@016A
        MOV     AL,09Dh
        JMP     @@0170
        NOP
@@016A: CMP     AL,03Ah                         ;':'
        JNZ     @@012D
        MOV     AL,01Dh
@@0170: MOV     Word Ptr CS:[Busy],0000
@@0177: POPF
        STC
        RETF    0002
@@017C: DB     0

        assume  CS:Code,DS:Code
@@Initialize:
        CLD
        CALL    @@02B4
        CALL    @@02F3
        JZ      @@0189
        JMP     @@01AF
        NOP
@@0189: CALL    @@0270
        TEST    Byte Ptr [@@017C],-1
        JNZ     @@0196
        JMP     @@01AD
        NOP
@@0196: CALL    @@022D                 ; Removing...
        CALL    @@0205                 ; Set vector to ES:oldVect
        PUSH    ES
        MOV     AX,4900h               ; Free block
        INT     21h
        POP     ES
;        CALL    @@0312
;        JB      @@01AD
;        MOV     AX,4900h               ; Free block
;        INT     21h
@@01AD: INT     20h
@@01AF: TEST    Byte Ptr [@@017C],-1
        JNZ     @@01AD
        MOV     Byte Ptr [CRight],'R'
        MOV     AX,3515h               ; Get vector address
        INT     21h
        MOV     word ptr [@@0103+2],ES
        MOV     word ptr [@@0103],BX
        LEA     DX,[@@010B]
        MOV     AX,CS                  ; Already done????
        MOV     DS,AX
        MOV     AX,2515h               ; Set vector address
        INT     21h
        MOV     Word Ptr [Count],0
        INT     09h                    ; Look which count changes
@@01DD: MOV     AX,0100h
        INT     16h
        JZ      @@01EB
        MOV     AX,0
        INT     16h
        JMP     @@01DD
@@01EB: MOV     AX,[Count]
        OR      AX,AX
        JNZ     @@01FC
        CALL    @@02AC
        PUSH    CS
        POP     ES
        CALL    @@0205
        INT     20h
@@01FC: CALL    @@024F
	MOV	ES,DS:[2Ch]
	MOV	AH,49H             ; Deallocate the program's enviroment block
	INT     21h
        LEA     DX,cs:[@@Initialize]
        INT     27h
@@0205: MOV     DX,ES:word ptr [@@0103]
        MOV     DS,ES:word ptr [@@0103+2]
        MOV     AX,2515h
        INT     21h
        RET
@@0215: DB      'Removing Key Switcher',13,10,'$'
@@022D: MOV     DX,OFFSET @@0215
        MOV     AH,09h
        INT     21h
        RET
@@0235: DB      'Installing Key Switcher',13,10,'$'
@@024F: MOV     DX,OFFSET @@0235
        MOV     AH,09h
        INT     21h
        RET
@@0257  DB      'Key Switcher is active',13,10,'$'
@@0270: MOV     DX,OFFSET @@0257
        MOV     AH,09h
        INT     21h
        RET
@@0278  DB      'Key Switcher is not compatible with this machine',7,13,10,'$'
@@02AC: MOV     DX,OFFSET @@0278
        MOV     AH,09h
        INT     21h
        RET

@@02B4: MOV     CL,DS:[0080h]
        OR      CL,CL
        JNZ     @@02BF
        JMP     @@02DD
        NOP
@@02BF: XOR     CH,CH
        MOV     BX,0081h
@@02C4: MOV     AL,[BX]
        CMP     AL,'/'
        JNZ     @@02DA
        MOV     AL,[BX+01]
        AND     AL,0DFh
        CMP     AL,'X'
        JNZ     @@02DA
        MOV     Byte Ptr [@@017C],01
        JMP     @@02DA
@@02DA: INC     BX
        LOOP    @@02C4
@@02DD: RET

@@02DE  DB      'Revolution',1AH,'Key',1AH,'Switch'
SwLen   EQU     $-@@02DE
@@02F3: MOV     AX,CS
        SUB     AX,1
        MOV     ES,AX
@@02FA: MOV     AX,ES
        DEC     AX
        CMP     AX,0060h
        JL      @@0311
        MOV     ES,AX
        MOV     SI,OFFSET @@02DE
        MOV     DI,OFFSET CRight
        MOV     CX,SwLen
        REPZ
        CMPSB
        JNZ     @@02FA
@@0311: RET
Code    ENDS
        END     Start


@@0312: PUSH    AX
        PUSH    BX
        MOV     BX,ES
        MOV     AX,ES
        DEC     AX
        DEC     AX
        MOV     ES,AX
@@031C: CMP     Byte Ptr ES:[0000],'M'
        JZ      @@032D
@@0324: MOV     AX,ES
        DEC     AX
        MOV     ES,AX
        JNZ     @@031C
        STC
        RET
@@032D: CMP     BX,ES:[0001]
        JNZ     @@0324
        INC     AX
        MOV     ES,AX
        POP     BX
        POP     AX
        CLC
        RET

