; Leitura do teclado nao blocante usando
; a int 21h funcao AH 06h e DL=0FFh
;
;

.MODEL SMALL
.STACK 100h
.DATA

.CODE
START:
    ; inicializar o registrador ES com o endereco do video 8B00h
    MOV AX, 0B800h ; 
    MOV ES, AX


    XOR DI, DI 

    MOV AH, 4 
    MOV AL, "C" ; coloca o valor a ser mostrado (caracter a ser exibido)
    MOV [ES]:DI, AX ; move para a posicao de memoria ES:DI
    ADD DI, 2
    MOV AH, 1 ; muda atributo do caracter (blue)
    MOV AL, "1" ; coloca o valor a ser mostrado (caracter a ser exibido)
    MOV [ES]:DI, AX ; move para a posicao de memoria ES:DI
    
    ;; utilizando instrucoes mais complexas
    ADD DI,2
    MOV AH, 2
    MOV AL, "*"
    CLD
    STOSW
    STOSW
    MOV AH, 5
    MOV AL, "*"
    MOV CX, 20 ; coloca o valor de 20 no registrador CX usado como contador
    REP STOSW

    MOV AH, 3
    MOV AL, "E"
    MOV DI, 120
    MOV CX, 20
    REP STOSW

    MOV AH, 4
    MOV AL, "U"
    MOV DI, 600
    MOV CX, 20
    REP STOSW

    MOV AH, 2
    MOV AL, "I"
    MOV DI, 100
    MOV CX, 20
    REP STOSW

    MOV AX, 4C00h
    INT 21h

END START