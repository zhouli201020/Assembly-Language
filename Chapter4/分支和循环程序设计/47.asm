;计算1-100的累加和

.586

DATA SEGMENT USE16
    SUM  DW ?
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA
    BEG: MOV    AX,DATA
         MOV    DS,AX
         MOV    CX,100
         MOV    AX,0
    AGA: ADD    AX,CX
         LOOP   AGA
         MOV    SUM,AX
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG