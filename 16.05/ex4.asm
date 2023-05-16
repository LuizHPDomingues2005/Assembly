; manipulando memoria de video
; 0B800h -> Endereco de memoria de video
; WORD   -> parte baixa caracter a ser escrito
;        -> parte alta atributo do caracter(cor exemplo)

.MODEL SMALL
.STACK 100h
.DATA

.CODE
START:
    ; acessando memoria de video do DOS
    MOV AX, 0B800h ; -> endereco de memoria de video
    MOV ES, AX
    ; usarmos o registrador DI como ponteiro para as posicoes
    ; da memeoria de video
    XOR DI, DI ; zera o ponteiro da memoria de video ES:DI
    ; lembrando na memoria de video
    ; AH -> atributo do caracter
    ; AL -> caracter
    MOV SI, 240 ; na terceira linha
    MOV AX, 042Ah

INICIO:
    MOV AH, 04h    
    ; DI com valor 0 coordenada 0,0
    ; se uma linha tem 80 caracteres por exemplo para a linha 1
    ; devemos colocar DI em que valor?
    ; DI = DI + 80 * 2
    MOV DI, SI
    MOV [ES]:DI, AX
    
    ; ler dados do teclado sem ser auto blocante (programa para r
    ; e esperar o digito)
    MOV AH, 06h
    MOV DL, 0FFh
    INT 21h
    ; se ZF set nenhum caracter foi caracter foi digitado]
    ; se ZF clear (0) caracter digitado e valor em AL
        JZ INICIO
    CMP AL, 'a'
        JE INC_DI
    CMP AL, 's'
        JE DEC_DI
    CMP AL, 01Bh ; compara se a tecla apertada é ESC para sair
        JE FIM
    JMP INICIO

INC_DI:
    ADD SI, 80
    JMP INICIO
DEC_DI:
    SUB SI, 40
    JMP INICIO

FIM:
    MOV AX, 4C00h
    INT 21h

END START