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
    gameMsg DB "     SNAKE GAME", 0AH, 0AH, 0AH, "    PRESSIONE UM CARACTER PARA JOGAR",13,10,"$"
.CODE
START:

    
    CALL INIT_SCREEN ; LIMPAMOS A TELA PARA INICIAR O JOGO





    ; TESTE MSG INICIO DE GAME ==================
    ;MOV AH, 09h
    ;MOV DX, OFFSET gameMsg
    ;INT 21h

    ;JMP FIM
    ; ======================================





    ; INICIALIZAR O REGISTRADOR ES COM O ENDERECO DO VIDEO B800h
    MOV AX, 0B800h ; -> endereco de memoria de video
    MOV ES, AX


    XOR DI, DI ; -> ZERAMOS O PONTEIRO DAS 
               ;    POSICOES DA MEMORIA DE VIDEO

    ; LEMBRANDO NA MEMORIA DE VIDEO
    ; AH -> ATRIBUTO DO CARACTER
    ; AL -> CARACTER.




GAME_LOOP:
    ;XOR DI,DI
    CALL DELAY ; DELAY IMPEDIRA QUE O JOGO FIQUE RAPIDO DEMAIS PARA SER JOGADO

    ; SE UMA LINHA TEM 80 CARACTERES POR EXEMPLO PARA A LINHA 1
    ; DEVEMOS COLOCAR DI EM QUE VALOR?
    ; DI = DI + 80 * 2

    MOV DI, SI
    MOV [ES]:DI, AX

    ;CALL READ_BUFFER
MOV AH, 06H
    INT 21H

    ; SE ZF SET NENHUM CARACTER FOI DIGITADO
    ; SE ZF CLEAR (0) CARACTER DIGITADO E VALOR EM AL
    JZ  DRAW_SNAKE

    ; VERIFICAMOS QUAIS LETRAS PARA DIRECAO
    ; QUE USAREMOS PARA MOVIMENTAR A COBRA
    CMP AL, 'w' ; 
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


DRAW_SNAKE:
    ;MOV AL, 0DBh
    MOV AX, 07DBh
    JMP GAME_LOOP
    







FIM: ; fim do programa
    MOV AX, 4C00h
    INT 21h

; =============================================== PROCEDIMENTOS ===========================================================

INIT_SCREEN PROC ; PROCEDIMENTO PARA LIMPAR A TELA
    MOV CX, 0000
    MOV DX, 184Fh
    INT 10h

    MOV AH, 02
    MOV BH, 00
    INT 10h

    RET
ENDP





DELAY PROC ; PROCEDIMENTO DE DELAY PARA O JOGO
    XOR DX, DX
    MOV CX, 65535

    DELAYLOOP:

        CMP DX, CX
            LOOP DELAYLOOP
        
        RET
	
ENDP





READ_BUFFER PROC ; LER O TECALDO SEM SER AUTO BLOCANTE

    ;XOR AH, AH
    ;MOV AH, 01H
    ;INT 16H

    MOV AH, 06H
    INT 21H


    RET

ENDP



END START