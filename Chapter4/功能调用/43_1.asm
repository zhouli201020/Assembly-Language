;FILENAME:43_1.ASM
;在屏幕左上角显示黑底灰白字符串'HELLO'，并在屏幕中央显示红底白字字符串'WELCOME'

.586

DATA SEGMENT USE16
        MESG1 DB  'HELLO$'
        MESG2 DB  'WELCOME'
        LL    EQU $-MESG2
DATA ENDS

CODE SEGMENT USE16
             ASSUME CS:CODE,DS:DATA,ES:DATA

        BEG: MOV    AX,DATA
             MOV    DS,AX
             MOV    ES,AX

             MOV    AX,0003H                       ;80列25行彩色文本显示方式
             INT    10H

             MOV    AH,9                           ;显示黑白字符串HELLO
             MOV    DX,OFFSET MESG1
             INT    21H

             MOV    AX,1301H                       ;显示彩色字符串WELCOME
             MOV    BH,0
             MOV    BL,01001111B
             MOV    CX,LL
             MOV    DH,12
             MOV    DL,(80-LL)/2
             MOV    BP,OFFSET MESG2
             INT    10H

             MOV    AH,4CH
             INT    21H

CODE ENDS
        END BEG