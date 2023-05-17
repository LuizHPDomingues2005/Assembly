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
    ; acessando memoria de video do DOS
    MOV AX, 0B800h ; -> endereco de memoria de video
    MOV ES, AX

    




FIM: ; fim do programa
    MOV AX, 4C00h
    INT 21h

END START