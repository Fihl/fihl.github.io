; Circle routine
; IN:	CircR	Radius of circle
;	CircX	X
;	CircY	and y coordinates of center

Circle:	CALL	SetModify
	MOV	AX,CircR
	SUB	AX,1
	ADC	AX,1			;Rad>=1!
	JS	CIRC5
	MOV	CX,AX			;Initial dependent axis=radius
	MUL	AX
	MOV	CIRR2H,DX
	MOV	CIRR2L,AX
	XOR	BX,BX			;Independent axis
CIRC0:	CALL	CIRC8		;DRAW 8 PARTS
	INC	BX
	MOV	AX,BX		;New CircDP:=(Rad**2-CircIDP**2)/Old CircDP
	MUL	AX		;NEWTON ITERATION!
	NOT	AX
	NOT	DX
	STC
	ADC	AX,CIRR2L
	ADC	DX,CIRR2H
	DIV	CX			;Divide by Old dependent
	SHL	DX,1
	CMP	CX,DX
	ADC	AX,CX			;Round (one up if DX*2 > CX)
	SHR	AX,1
	MOV	CX,AX			;New dependent
	CMP	CX,BX
	JGE	CIRC0			;Do while dependent <= independent
CIRC5:	RET
CIRC8:	CMP	BX,CX
	JE	CIRC4
	XCHG	BX,CX
	CALL	CIRC4
	XCHG	BX,CX
CIRC4:	NEG	BX
	JZ	CIRC2
	CALL	CIRC2
	NEG	BX
CIRC2:	NEG	CX
	JZ	CIRC1
	CALL	CIRC1
	NEG	CX
CIRC1:	PUSH	BX
	PUSH	CX
	MOV	DX,CX
	ADD	BX,CircX
	ADD	DX,CircY
	CALL	PLTXY
	POP	CX
	POP	BX
	RET

; Arc routine
; IN:	ArcR	Radius of circle
;	ArcX	X
;	ArcY	and Y coordinates of center
;	ArcA1	Start
;	ArcA2	and end-angle for arc

Arc:	CALL	SetModify
	MOV	AX,ArcR
	ADD	ArcX,AX			;Start point=Arcx+ArcR,ArcY
	MUL	AX
	MOV	ArcR2H,DX
	MOV	ArcR2L,AX
	MOV	ArcDir,00000001B	;Rotate left one for each 45 deg.
	MOV	ArcXT,-1
	MOV	ArcYT,-1
; Draw max 8 arcs of max 45 deg (one octant)
ARC2:	CMP	ArcA1,45
	JG	ARC3
	CALL	ARCD			;Draw arc if part or full inside octant
ARC3:	TEST	ArcDir,01010101B	;Skip each second time
	JZ	ARC6
	MOV	AX,ArcR			;Give next startpoint in ArcX,ArcY
 IF PPAS
	TEST	ArcDir,00001111B	;Sign of X movement
 ENDIF
 IF Turbo
	TEST	ArcDir,00111100B	;Sign of X movement
 ENDIF
	JZ	ARC4
	NEG	AX
ARC4:	ADD	ArcX,AX
	MOV	AX,ArcR
 IF PPAS
	TEST	ArcDir,11000011B	;Sign of Y movement
 ENDIF
 IF Turbo
	TEST	ArcDir,11110000B	;Sign of Y movement
 ENDIF
	JZ	ARC5
	NEG	AX
ARC5:	ADD	ArcY,AX
ARC6:	ROL	ArcDir,1		;Next octant
	SUB	ArcA1,45
	JNC	ARC7
	MOV	ArcA1,0
ARC7:	SUB	ArcA2,45
	JNC	ARC2
	RET				;;;CALL PLTXYC???;;;

ARCD:	MOV	BX,ArcA1		;Draw one arc
	MOV	AX,ArcA2
	CMP	AX,45
	JL	ARCD2
	MOV	AX,45
ARCD2:	CMP	AX,BX
	JE	ARCD13
	TEST	ArcDir,10101010B
	JZ	ARCD3
	XCHG	AX,BX			;45..90 -> 45..0
	SUB	AX,45
	SUB	BX,45
	NEG	AX
	NEG	BX
ARCD3:	PUSH	BX
	CALL	FSIN
	MUL	WORD PTR ArcR
	SHL	AX,1			;Round up
	ADC	DX,0
	MOV	ArcFigs,DX		;Total points
	POP	AX
	CALL	FSIN
	MUL	WORD PTR ArcR
	TEST	ARCDIR,10101010B
	JZ	ARCD4
	SUB	DX,1
	ADC	DX,1			;Minimum 1 if odd octant
ARCD4:	MOV	DI,DX			;Points to skip
	SUB	ArcFigs,DI		;Points to plot
	MOV	AX,ArcR
	MOV	ArcDep,AX
	MOV	ArcInd,0
	MOV	BX,ArcX
	MOV	DX,ArcY
ARCD10:	DEC	DI			;Skip points
	JS	ARCD11
	CALL	ArcNP
	JMP	ARCD10
ARCD11:	CALL	PLTXY
	DEC	ArcFigs
	JS	ArcD12
	CALL	ARCNP
	CMP	ArcXT,BX		;Point equals last point in 45 deg
	JNE	ARCD11
	CMP	ArcYT,DX
	JNE	ARCD11
	RET
ARCD12:	MOV	ArcXT,BX		;Save last point plotted
	MOV	ArcYT,DX
ARCD13:	RET

; Calculate next point (0..44 deg)

ARCNP:	INC	ArcInd
	MOV	AX,ArcInd
	MOV	CX,ArcDep
	PUSH	DX
	MUL	AX
	NOT	AX
	NOT	DX
	STC
	ADC	AX,ArcR2L
	ADC	DX,ArcR2H
	JS	ARCNP6
	DIV	CX
	SHL	DX,1
	CMP	CX,DX			;Round=inc AX if DX>CX/2
	POP	DX
	ADC	AX,CX
	SHR	AX,1
	ADC	AX,0
	XCHG	AX,ArcDep
	SUB	AX,ArcDep
	MOV	CX,1
 IF PPAS
	TEST	ArcDir,00101101B
	JZ	ARCNP3
	NEG	CX			;Independent axis
ARCNP3:	TEST	ArcDir,11100001B
	JZ	ARCNP4
	NEG	AX			;Dependent axis
ARCNP4:	TEST	ArcDir,01100110B
	JZ	ARCNP5
	XCHG	AX,CX			;Y-axis are dependent!
ARCNP5:	ADD	BX,AX
	ADD	DX,CX
	RET
 ENDIF
 IF TURBO
	TEST	ArcDir,00101101B
	JZ	ARCNP3
	NEG	CX			;Independent axis
ARCNP3:	TEST	ArcDir,11100001B
	JZ	ARCNP4
	NEG	AX			;Dependent axis
ARCNP4:	TEST	ArcDir,01100110B
	JZ	ARCNP5
	XCHG	AX,CX			;Y-axis are dependent!
ARCNP5:	ADD	BX,AX
	ADD	DX,CX
	RET
 ENDIF
ARCNP6:	POP	DX			;Error exit
	RET

