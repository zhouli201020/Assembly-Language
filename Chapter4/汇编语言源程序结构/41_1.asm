;FILENAME41_1.ASM
;加法程序实现46H+52H，并将运算结果存放在数据段变量SUM中

.586

DATA SEGMENT USE16
    SUM  DB ?
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA
    BEG: MOV    AX,DATA
         MOV    DS,AX
         MOV    AL,46H
         ADD    AL,52H
         MOV    SUM,AL
         MOV    AH,4CH
         INT    21H
CODE ENDS
        END BEG