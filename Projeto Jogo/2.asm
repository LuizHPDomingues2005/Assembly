; Snake Game em Assembly 8086
; INI 51 - Professor Sergio Luiz Moral Marques
;
; Made  by
;
; Gustavo Mendes Oliveira             - RA: 20136
; Luiz Henrique Parolim Domingues     - RA: 21248
; Matheus Henrique de Oliveira Freire - RA: 21251

.MODEL SMALL
.STACK 100h
.DATA

.CODE
START:

    MOV SI, 0
LIMPAR_TELA:
  
    
    CALL INIT_SCREEN


    ; INICIALIZAR O REGISTRADOR ES COM O ENDERECO DO VIDEO B800h
    MOV AX, 0B800h ; -> endereco de memoria de video
    MOV ES, AX

    XOR DI, DI ; -> ZERAMOS O PONTEIRO DAS 
               ;    POSICOES DA MEMORIA DE VIDEO

    ; LEMBRANDO NA MEMORIA DE VIDEO
    ; AH -> ATRIBUTO DO CARACTER
    ; AL -> CARACTER.

    MOV AX, 07DBh ; -> COR E CARACTER QUE FARAO A COBRA
    INT 10h

GAME_LOOP:

;READ_BUFFER:
    ; LER DADOS DO TECLADO SEM SER AUTO BLOCANTE.
 ;   MOV AH, 06h ; Função 00h da interrupção 16h lê um caractere
  ;  MOV DL, 0FFH 
   ; INT 21h     ; Interrupção 16h para ler o caractere digitado

    CALL READ_BUFFER ; FARA A PRIMEIRA LEITURA

DRAW_SNAKE:

    ; SE UMA LINHA TEM 80 CARACTERES POR EXEMPLO PARA A LINHA 1
    ; DEVEMOS COLOCAR DI EM QUE VALOR?
    ; DI = DI + 80 * 2
    MOV DI, SI
    MOV [ES]:DI, AX

    ; SE ZF SET NENHUM CARACTER FOI DIGITADO
    ; SE ZF CLEAR (0) CARACTER DIGITADO E VALOR EM AL
    JZ  INICIO_1

    CALL DELAY

    CMP AL, 00h
        JNE MOV_ALtoDL
    CALL READ_BUFFER
    JMP CHECK_PRESSED_KEYS
    
MOV_ALtoDL:
    MOV DL, AL
    XOR AH, AH

CHECK_PRESSED_KEYS:
    CMP DL, 'w'
        JE UP
    CMP DL, 'a'
        JE LEFT
    CMP DL, 's'
        JE DOWN
    CMP DL, 'd'
        JE RIGHT        



    
    CMP DL, 01BH  ; COMPARA SE DIGITOU ESC PARA SAIR
        JE  FIM   ; SE DIGITOU ESC SAI DO JOGO

    JMP DRAW_SNAKE

    JMP GAME_LOOP ; REPETE O JOGO

UP:
    SUB SI, 80
    JMP DRAW_SNAKE

DOWN:
    ADD SI, 80
    JMP DRAW_SNAKE

RIGHT:
    INC SI
    JMP DRAW_SNAKE

LEFT:
    DEC SI
    JMP DRAW_SNAKE



INICIO_1:
    ;MOV AL, 0DBh
    MOV AX, 07DBh
    JMP GAME_LOOP






FIM: ; fim do programa
    MOV AX, 4C00h
    INT 21h


;============================ PROCEDIMENTOS =======================================================




DELAY PROC ; PROCEDIMENTO DE DELAY PARA O JOGO
    XOR DX, DX
    MOV CX, 65535

    DELAYLOOP:

        CMP DX, CX
            LOOP DELAYLOOP
        
        RET
	
ENDP

INIT_SCREEN PROC

    MOV CX, 0000
    MOV DX, 184Fh
    INT 10h

    MOV AH, 02
    MOV BH, 00
    INT 10h
    
    RET

ENDP

READ_BUFFER PROC
    ; LER DADOS DO TECLADO SEM SER AUTO BLOCANTE.
    MOV AH, 06h ; Função 00h da interrupção 16h lê um caractere
    MOV DL, 0FFH 
    INT 21h     ; Interrupção 16h para ler o caractere digitado

    RET
ENDP


END START