;;
; LEITURA DO TECLADO NÃO BLOCANTE USANDO
; A INT 21H FUNCAO AH 06H E DL=0FFH
;
;;
.MODEL SMALL
.STACK 100H
.DATA

.CODE

START:
    ; INICIALIZAR O REGISTRADOR ES COM O ENDEREÇO DO VÍDEO B800H
    MOV AX, 0B800H
    MOV ES, AX
    ; USAREMOS O REGISTRADOR DI COMO PONTEIRO PARA AS POSIÇÕES
    ; DA MEMÓRIA DE VÍDEO.
    XOR DI,DI
    ; LEMBRANDO NA MEMORIA DE VIDEO
    ; AH -> ATRIBUTO DO CARACTER
    ; AL -> CARACTER.
    MOV SI, 240 ; NA TERCEIRA LINHA
    MOV AX, 042AH
 INICIO:
    MOV AH, 04H
    ; DI COM VALOR 0 COORDENADA 0,0 
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
    CMP AL,'A'
    JE  INC_DI
    CMP AL,'S'
    JE  DEC_DI

    CMP AL, 01BH  ; COMPARA SE DIGITOU ESC PARA SAIR
    JE  FIM
    JMP INICIO
INICIO_1:
    MOV AL, 25H
    JMP INICIO
INC_DI:
    ADD SI,80
    JMP INICIO

DEC_DI:
    SUB SI,40
    JMP INICIO

FIM:
    MOV AX, 4C00H
    INT 21H

END START
