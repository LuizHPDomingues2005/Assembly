; programa

.MODEL SMALL
.STACK 100H
.DATA
    Text DB "Este e um texto",13,10,"$"

    Vooce DB "Voce",13,10,"$"
    ehh DB "eh",13,10,"$"
    gaay DB "gay",13,10,"$"

.CODE
START:
    MOV AX,@DATA
    MOV ES, AX

    ;MOV BP, OFFSET Text
    ;MOV AH, 13h
    ;MOV AL, 01h
    ;XOR BH, BH
    ;MOV BL, 5
    ;MOV CX, 17
    ;MOV DH, 5
    ;MOV DL, 5
    ;INT 10h

    MOV BP, OFFSET Vooce
    MOV AH, 13h
    MOV AL, 01h
    XOR BH, BH
    MOV BL, 9
    MOV CX, 6
    MOV DH, 2 ; linha
    MOV DL, 1 ; coluna
    INT 10h

    MOV BP, OFFSET ehh
    MOV AH, 13h
    MOV AL, 01h
    XOR BH, BH
    MOV BL, 5
    MOV CX, 2
    MOV DH, 2 ; linha
    MOV DL, 6 ; coluna
    INT 10h

    MOV BP, OFFSET gaay
    MOV AH, 13h
    MOV AL, 01h
    XOR BH, BH
    MOV BL, 2
    MOV CX, 3
    MOV DH, 2 ; linha
    MOV DL, 9 ; coluna
    INT 10h

    MOV AX, 4C00h ; termina o programa
    INT 21h


END START