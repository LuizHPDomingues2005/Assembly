; programa

.MODEL SMALL
.STACK 100H
.DATA
    Text DB "Este e um texto", 13, 10, '$'
    Text1 DB "Este e outro texto", 13, 10, '$'

.CODE
START:
    MOV AX,@DATA
    MOV DS, AX


    MOV DH, 1 ; coluna
    MOV DL, 2 ; linha
    MOV AH, 02h ; move o cursor
    XOR BH, BH ; pagina de video 0
    INT 10h

    MOV DX, OFFSET Text
    MOV AH, 9
    INT 21h


    MOV DH, 1 ; coluna
    MOV DL, 1 ; linha
    MOV AH, 02h ; move o cursor
    XOR BH, BH ; pagina de video 0
    INT 10h

    MOV DX, OFFSET Text1
    MOV AH, 9
    INT 21h


    MOV AX, 4C00h ; termina o programa
    INT 21h


END START