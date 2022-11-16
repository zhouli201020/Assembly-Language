;FILENAME:418.ASM
;将BUF单元中的二进制数转换为十六进制数并送屏幕显示

.586

DATA SEGMENT USE16
    BUF  DW 987AH
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA
    BEG: 
         MOV    AX,DATA
         MOV    DS,AX
    INIT:
         MOV    DX,BUF
         MOV    CX,4
         SAL    EDX,16
    AGA: 
         ROL    EDX,4
         AND    DL,0FH
         CMP    DL,10
         JC     NEXT
         ADD    DL,7
    NEXT:
         ADD    DL,30H
         MOV    AH,2
         INT    21H
         LOOP   AGA
    EXIT:
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG