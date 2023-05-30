; Snake Game em Assembly 8086
; INI 51 - Professor Sergio Luiz Moral Marques
;
; Made  by
;
; Gustavo Mendes Oliveira             - RA: 20136
; Luiz Henrique Parolim Domingues     - RA: 21248
; Matheus Henrique de Oliveira Freire - RA: 21251
; Controles: i - cima | j - esquerda | k - baixo | l - direita
; O código está dividido em segmentos de dados (DATASEG) e código (CODESEG) 
; para separar as declarações de variáveis e as instruções do programa.

IDEAL
MODEL SMALL
STACK 100H
DATASEG
	; CONSTANTES PARA AS CORES
	Preto EQU 0H
	Vermelho EQU 0CH
	Verde EQU 0AH

	TILEL EQU 20D ; TAMANHO DO BLOCO
	KeyboardBufferHead EQU 001CH ; Endereço da cabeça do buffer do teclado
	KeyboardBufferTail EQU 001AH ; Endereço da cauda do buffer do teclado

	; VARIÁVEIS
    TextTitulo DB "     SNAKE GAME", 0AH, 0AH, 0AH, "    PRESSIONE UM CARACTER PARA JOGAR$"
	numeroPontuacao DW 0FF99H ; PONTUAÇÃO ATUAL DO JOGADOR
	textoPontuacao DB '000$' ; TEXTO QUE EXIBE A PONTUAÇÃO
	Rand DW ?
	fruta_posicao DW 0508H	; O BYTE ALTO É A POSIÇÃO Y, O BYTE BAIXO É A POSIÇÃO X
	cabeca_posicao DW 0508H
	cauda_posicao DW 0508H
	cauda_posicao_anterior DW ?
	cabeca_direcao DW 0H  ; Direção atual da cabeça da cobra (0 - cima, 1 - esquerda, 2 - baixo, 3 - direita)
	cauda_direcao DW 0H    ; Direção atual da cauda da cobra (0 - cima, 1 - esquerda, 2 - baixo, 3 - direita)
	Switcher DW 0FF00H, 0FFH, 0100H, 01H	; REPRESENTA CADA VALOR DE DIREÇÃO: CIMA, ESQUERDA, BAIXO, DIREITA
	Borda DB 160 DUP(5D)	; REPRESENTA O ESTADO DE CADA PARTE DA COBRA NA TELA: 0 - MUDANÇA DE DIREÇÃO PARA CIMA | 1 - MUDANÇA DE DIREÇÃO PARA ESQUERDA | 2 - MUDANÇA DE DIREÇÃO PARA BAIXO | 3 - MUDANÇA DE DIREÇÃO PARA DIREITA | 4 - PARTE NORMAL DA COBRA | 5 - ESPAÇO VAZIO
	
CODESEG
; CONVERTE UMA POSIÇÃO NORMAL DO BLOCO PARA O ÍNDICE DO ARRAY Borda
; ENTRADA: CX - POSIÇÃO DO BLOCO | SAÍDA: AX - ÍNDICE DO ARRAY Borda
PROC Converte_posicao
	; Converte as posições do bloco em posições Reais
	XOR AH, AH
	MOV AL, CH
	SHL AL, 4
	ADC AL, CL
	MOV DI, AX
	RET

ENDP Converte_posicao



; ENTRADA: DX - CONTAGEM DO TEMPO DE ATRASO
PROC DELAY

	XOR AH, AH
	INT 1AH
	MOV BX, DX
	
DELAYLOOP:
	XOR AH, AH
	INT 1AH
	SUB DX, BX
	CMP DX, SI
	JL DELAYLOOP
	
	RET
	
ENDP DELAY


; DESENHA UM BLOCO COLORIDO EM UMA POSIÇÃO DE BLOCO ESPECÍFICA
; ENTRADA: DX - POSIÇÃO DO BLOCO (ALTO - POSIÇÃO Y, BAIXO - POSIÇÃO X)
PROC Desenha_bloco
	; CONVERTE AS POSIÇÕES DO BLOCO EM POSIÇÕES REAIS
	PUSH DX
	PUSH CX
	PUSH DI
	XOR AH, AH
	MOV BH, TILEL

	MOV AL, CH
	MUL BH
	MOV DX, AX

	MOV AL, CL
	MUL BH
	MOV DI, AX

	MOV AL, BL
	MOV AH, 0CH
	XOR BH, BH

	MOV CX, TILEL
ROW:
	PUSH CX
	MOV CX, TILEL
Linha:
	PUSH CX
	MOV CX, DI
	INT 10H

	POP CX
	INC DI
	LOOP Linha

	POP CX
	INC DX
	SUB DI, TILEL
	LOOP ROW

	POP DI
	POP CX
	POP DX
	RET

ENDP Desenha_bloco


; Move A COBRA E REALIZA OUTRAS OPERAÇÕES NECESSÁRIAS
PROC Move

	PUSH BX
	PUSH DX
	
	MOV CX, [WORD PTR cabeca_posicao]
	MOV AX, [WORD PTR Rand]
	ADD AL, CL
	MOV [WORD PTR Rand], AX

	CMP [WORD PTR cabeca_direcao], 0H
	JZ Apaga_Cauda
	CMP DL, DH
	JZ Apaga_Cauda

Add_bloco:
	POP DX
	INC DL
	PUSH DX
	JMP SKIP

Apaga_Cauda:
	MOV CX, [WORD PTR cauda_posicao]
	MOV [WORD PTR cauda_posicao_anterior], CX
	CALL Converte_posicao
	MOV AL, [BYTE PTR DS:BP+DI]

	CMP AL, 3D
	JA Sem_Troca_Direcao
	SHL AX, 1
	MOV SI, AX
	MOV DX, [WORD PTR BX+SI]
	MOV [WORD PTR cauda_direcao], DX
Sem_Troca_Direcao:
	MOV [BYTE PTR DS:BP+DI], 5D

	MOV BX, Preto
	CALL Desenha_bloco

	MOV AX, [WORD PTR cauda_direcao]
	ADD CL, AL
	ADD CH, AH
	MOV [WORD PTR cauda_posicao], CX

SKIP:
	MOV CX, [WORD PTR cabeca_posicao]
	MOV AX, [cabeca_direcao]
	ADD CL, AL	
	ADD CH, AH

	CALL Converte_posicao

	
	MOV [WORD PTR cabeca_posicao], CX
	MOV BX, Verde
	CALL Desenha_bloco


	CMP CL, 0FH
	JA Perdeu
	CMP CH, 09H
	JA Perdeu
	CMP [BYTE PTR DS:BP+DI], 5D
	MOV [BYTE PTR DS:BP+DI], 4D
	JL Perdeu
	CMP CX, [WORD PTR fruta_posicao]
	JZ Nova_fruta
	JMP Continua

Perdeu:
	MOV [numeroPontuacao], 0FF99H
	MOV [fruta_posicao], 0508H
	MOV [cabeca_posicao], 0508H
	MOV [cauda_posicao], 0508H
	MOV [cabeca_direcao], 0
	MOV [cauda_direcao], 0

	LEA BX, [Borda]
	XOR SI, SI
	MOV CX, 160D
RESET_Borda:
	MOV [BYTE PTR BX+SI], 5D
	INC SI
	LOOP RESET_Borda

	ADD SP, 6D	
	JMP Setup

Nova_fruta:
	MOV CX, 3D
Nova_fruta_LOOP:
	XOR DI, DI
	MOV BX, [WORD PTR Rand]
	MOV AX, BX
	AND AX, 127D
	ADD DI, AX
	ADD BL, BH
	
	MOV AX, BX
	AND AX, 31D
	ADD DI, AX
	ADD BL, BH
	
	MOV AX, BX
	AND AX, 1D
	ADD DI, AX


	CMP [BYTE PTR DS:BP+DI], 4D
	JA USE_RandOM
	ROL [WORD PTR Rand], 1
	LOOP Nova_fruta_LOOP
	
	MOV CX, [cauda_posicao_anterior]	
	JMP Finally

USE_RandOM:
	MOV AX, DI
	MOV CX, DI
	SHR AX, 4D
	MOV CH, AL
	SHL AL, 4D
	SUB CL, AL

Finally:
	MOV [WORD PTR fruta_posicao], CX
	MOV BX, Vermelho
	CALL Desenha_bloco

	POP DX
	INC DH
	PUSH DX

	
	MOV AX, [WORD PTR numeroPontuacao]
	CLC		
	INC AX
	DAA		
	ADC AH, 0H	
	MOV [WORD PTR numeroPontuacao], AX
	

	LEA BX, [textoPontuacao]
	MOV DH, AH
	MOV AH, AL
	AND AH, 0FH	
	SHR AL, 04H
	OR AX, 3030H
	MOV [WORD PTR BX+1], AX

	MOV AH, DH
	AND AH, 0FH	
	OR AH, 30H
	MOV [BYTE PTR BX], AH

Continua:
	XOR BH, BH
	MOV DX, 013H
	MOV AH, 02H
	INT 10H

	MOV AH, 09H
	LEA DX, [textoPontuacao]
	INT 21H

	
	PUSH 0040H
	POP ES
   	MOV AX, [ES:KeyboardBufferTail]
   	MOV [ES:KeyboardBufferHead], AX

	
	MOV SI, 04H
	CALL DELAY

	POP DX
	POP BX
	RET

ENDP Move


Start:
	MOV AX, @DATA
	MOV DS, AX

	MOV AX, 13H
	INT 10H

	XOR BH, BH
	MOV DX, 060AH
	MOV AH, 02H
	INT 10H

	MOV AH, 09H
	LEA DX, [TextTitulo]
	INT 21H
	
	XOR AH, AH
	INT 16H

Setup:
	;LIMPA A TELA
	MOV AX, 13H
	INT 10H


	XOR AH, AH
	INT 1AH
	MOV [WORD PTR Rand], DX

	;SETA AS VARIÁVEIS
	LEA BP, [Borda]
	LEA BX, [Switcher]
	MOV DX, 0201H	;BYTE BAIXO É O TAMANHO ATUAL DA SNAKE, BYTE ALTO É O TAMANHO MÁXIMO DA SNAKE

espera_digito:
	CALL Move

Pula_movimento:
	MOV AH, 1H
	INT 16H		
	JZ espera_digito

Checka_digito:
	XOR AH, AH	
	
	SUB AX, 69H		
	CMP AX, 3H
	JA espera_digito

	
	SHL AX, 1
	MOV SI, AX
	MOV AX, [WORD PTR BX+SI]
	TEST AX, [WORD PTR cabeca_direcao]	
	JNZ espera_digito
	MOV [WORD PTR cabeca_direcao], AX

	
	MOV CX, [WORD PTR cabeca_posicao]
	CALL Converte_posicao
	MOV AX, SI
	SHR AX, 1
	MOV [BYTE PTR DS:BP+DI], AL
	JMP espera_digito

EXIT:
	MOV AX, 4C00H
	INT 21H
END Start
