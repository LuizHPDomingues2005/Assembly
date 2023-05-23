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

LIMPAR_TELA:
  
    MOV CX, 0000
    MOV DX, 184Fh
    INT 10h

    MOV AH, 02
    MOV BH, 00
    INT 10h


    



    ; INICIALIZAR O REGISTRADOR ES COM O ENDERECO DO VIDEO B800h
    MOV AX, 0B800h ; -> endereco de memoria de video
    MOV ES, AX

    XOR DI, DI ; -> ZERAMOS O PONTEIRO DAS 
               ;    POSICOES DA MEMORIA DE VIDEO

    ; LEMBRANDO NA MEMORIA DE VIDEO
    ; AH -> ATRIBUTO DO CARACTER
    ; AL -> CARACTER.

    MOV AX, 07DFh ; -> COR E CARACTER QUE FARAO A COBRA
    INT 10h

GAME_LOOP:
    ; SE UMA LINHA TEM 80 CARACTERES POR EXEMPLO PARA A LINHA 1
    ; DEVEMOS COLOCAR DI EM QUE VALOR?
    ; DI = DI + 80 * 2
    MOV DI, SI
    MOV [ES]:DI, AX

    ; LER DADOS DO TECLADO SEM SER AUTO BLOCANTE.
    MOV AH, 06H
    MOV DL, 0FFH 
    INT 21H

    ; SE ZF SET NENHUM CARACTER FOI DIGITADO
    ; SE ZF CLEAR (0) CARACTER DIGITADO E VALOR EM AL
    JZ  INICIO_1
    CMP AL, 'w'
        JE UP
    CMP AL, 'a'
        JE LEFT
    CMP AL, 's'
        JE DOWN
    CMP AL, 'd'
        JE RIGHT        

    
    CMP AL, 01BH  ; COMPARA SE DIGITOU ESC PARA SAIR
        JE  FIM   ; SE DIGITOU ESC SAI DO JOGO

    JMP GAME_LOOP ; REPETE O JOGO

UP:
    SUB SI, 80
    JMP GAME_LOOP

DOWN:
    ADD SI, 80
    JMP GAME_LOOP

RIGHT:
    INC SI
    JMP GAME_LOOP

LEFT:
    DEC SI
    JMP GAME_LOOP


INICIO_1:
    ;MOV AL, 0DBh
    MOV AX, 07DBh
    JMP GAME_LOOP






FIM: ; fim do programa
    MOV AX, 4C00h
    INT 21h


INIT_SCREEN PROC
    MOV AH, 0
    MOV AL, 12h
    INT 10h
    RET
ENDP

END START