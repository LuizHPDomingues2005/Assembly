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

    CALL INIT_SCREEN ; LIMPAMOS A TELA
    MOV SI, 1998     ; ALOCAMOS O PONTEIRO DO CURSOR NO CENTRO DA TELA


    ; INICIALIZAR O REGISTRADOR ES COM O ENDERECO DO VIDEO B800h
    MOV AX, 0B800h ; -> endereco de memoria de video
    MOV ES, AX

    XOR DI, DI ; -> ZERAMOS O PONTEIRO DAS 
               ;    POSICOES DA MEMORIA DE VIDEO

    XOR DX, DX ; ZERAMOS DX PARA VERIFICAR INICIO DO JOGO
    INT 10h

    MOV AX, 02DBh

    MOV DI, SI
    MOV [ES]:DI, AX

GAME_LOOP:

    CMP DL, 00h     ; SE DL FOR 00, OU SEJA, O JOGADOR NAO COMECOU A JOGAR
        JE CONTINUE ; NAO VAI PRINTAR NADA

    ; LEMBRANDO NA MEMORIA DE VIDEO
    ; AH -> ATRIBUTO DO CARACTER
    ; AL -> CARACTER.
    MOV AX, 02DBh

    MOV DI, SI
    MOV [ES]:DI, AX

CONTINUE:

    ; CHAMAMOS O PROCEDIMENTO DE DELAY VARIAS VEZES
    ; POR NOSSOS PROCESSADORES SEREM POTENTES E O JOGO
    ; FICAR RAPIDO DEMAIS SEM ELES

    CALL DELAY
    CALL DELAY
    CALL DELAY



    CALL READ_BUFFER ; SEMPRE CHAMAREMOS O PROCEDIMENTO PARA LER DO TECLADO
    JMP CHECK_PRESSED_KEYS ; IREMOS DIRETAMENTE PARA A VERIFICACAO DE TECLAS CASO O USUARIO NAO TENHA APERTADO NADA
    


CHECK_PRESSED_KEYS:

    ; =======================================================
    ; NOTA: 

    ; IREMOS COMPARAR A TECLA DIGITADA COM AS
    ; TECLAS MAIS USADAS EM JOGOS (WASD)
    ; COMO DIRECIONAIS

    ; PARA ESQUERDA E DIREITA USAREMOS APENAS INTRUCOES SIMPLES
    ; DE OPERADORES UNARIOS DE INCREMENTAR E DECREMENTAR O VALOR DO
    ; PONTEIRO DO CURSOR

    ; PARA CIMA E PARA BAIXO, DEMOS LEVAR EM CONSIDERACAO QUE UMA
    ; LINHA POSSUI 80 CARACTERES, POR ISSO USAMOS OPERADORES
    ; BINARIOS PARA SOMAR OU SUBTRAIR 80 DO PONTEIRO NESSES CASOS.

    ; =======================================================

    CMP DL, 'w'
        JE UP
    CMP DL, 'a'
        JE LEFT
    CMP DL, 's'
        JE DOWN
    CMP DL, 'd'
        JE RIGHT        


    CMP DL, 1Bh  ; COMPARA SE DIGITOU ESC PARA SAIR
        JE  END_GAME   ; SE DIGITOU ESC SAI DO JOGO

    

    JMP GAME_LOOP ; REPETE O JOGO

UP:
    ; PARA IR PARA A LINHA DE CIMA, SUBTRAIMOS 80 DO PONTEIRO
    SUB SI, 80 
    JMP GAME_LOOP

DOWN:
    ; PARA IR PARA A LINHA DE BAIXO, SOMAMOS 80 DO PONTEIRO
    ADD SI, 80
    JMP GAME_LOOP

RIGHT:
    ; PARA IR PARA A DIREITA, SOMAMOS 2 NO VALOR NO PONTEIRO
    ADD SI, 2
    JMP GAME_LOOP

LEFT:
    ; PARA IR PARA A ESQUERDA, SUBTRAIMOS 2 NO VALOR NO PONTEIRO
    SUB SI, 2

    JMP GAME_LOOP



END_GAME: ; fim do programa
    MOV AX, 4C00h
    INT 21h


;============================ PROCEDIMENTOS =======================================================




DELAY PROC ; PROCEDIMENTO DE DELAY PARA O JOGO
    MOV CX, 65535 ; 65535 E O VALOR MAXIMO QUE CX PODE CHEGAR

    DELAYLOOP:
        ; ENTRA EM LOOPING ATE CX VALER 0
        CMP AX, 0
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
    XOR AX, AX

    ; LER DADOS DO TECLADO SEM SER AUTO BLOCANTE.
    MOV AH, 1      ; DEFINIR FUNÇÃO 1H DA INTERRUPÇÃO 16H (VERIFICAÇÃO DE TECLADO)
    INT 16H        ; CHAMAR A INTERRUPÇÃO 16H

        JZ NO_KEY_PRESS ; VERIFICAR SE NENHUMA TECLA FOI PRESSIONADA

    MOV AH, 0      ; DEFINIR FUNÇÃO 0H DA INTERRUPÇÃO 16H (LEITURA DO TECLADO)
    INT 16H        ; CHAMAR A INTERRUPÇÃO 16H

    JMP KEY_PRESSED

    ; O CARACTERE ASCII DA TECLA PRESSIONADA ESTARA EM AL

    ; SE ALGUMA TECLA FOI PRESSIONADA
    KEY_PRESSED:

        ; AQUI IREMOS COMPARAR SE A TECLA PRESSIONADA E VALIDA
        ; PARA MOVER AL PARA DL CORRETAMENTE E
        ; NAO QUEBRAR O PROGRAMA OU TRAVAR O JOGO
        CMP_VALID_KEYS:
            CMP AL, 'w'
                JE KEY_IS_VALID
            CMP AL, 'a'
                JE KEY_IS_VALID
            CMP AL, 's'
                JE KEY_IS_VALID
            CMP AL, 'd'
                JE KEY_IS_VALID 

            CMP AL, 1Bh  ; COMPARA SE DIGITOU ESC PARA SAIR
                JE KEY_IS_VALID   ; SE DIGITOU ESC SAI DO JOGO


            ; SE NENHUMA DAS TECLAS COMPARADAS ACIMA TIVEREM SIDO DIGITADAS
            ; PULA PARA O LABEL ONDE NENHUMA TECLA FOI DIGITADA
            JMP KEY_IS_NOT_VALID

        KEY_IS_VALID:
            MOV DL, AL ; MOVEMOS AL PARA DL PARA MAIOR SEGURANCA EM SALVAR A ULTIMA TECLA SALVA
            XOR AH, AH

        KEY_IS_NOT_VALID:
            ; NAO FAZ NADA, IGNORANDO A TECLA INVALIDA


    NO_KEY_PRESS:
        ; NAO FAZ NADA, DEIXANDO O JOGO RODAR SEM ALTERAR DL
        ; E CONSEQUENTEMENTE SEM ALTERAR
        ; A DIRECAO DA COBRA OU SAIR DO JOGO

    RET
ENDP


END START