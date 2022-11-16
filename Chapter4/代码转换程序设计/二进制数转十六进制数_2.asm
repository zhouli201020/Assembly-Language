;设从BNUM单元开始，有4个16位的二进制数，要求把它们转换成16进制数，并送屏幕显示

.586

DATA SEGMENT USE16
    BNUM  DW 0001001000110100B    ;1234H
          DW 0101011001111000B    ;5678H
          DW 0001101000101011B    ;1A2BH
          DW 0011110001001101B    ;3C4DH
    BUF   DB 4 DUP(?),'H $'       ;输出缓冲区
    COUNT DB 4
DATA ENDS

CODE SEGMENT USE16
             ASSUME CS:CODE,DS:DATA
    BEG:     
             MOV    AX,DATA
             MOV    DS,AX
             MOV    CX,4
             MOV    BX,OFFSET BNUM
    AGA:     
             MOV    DX,[BX]
             SAL    EDX,16
             CALL   N2_16ASC
             MOV    AH,9
             MOV    DX,OFFSET BUF
             INT    21H
             ADD    BX,2
             LOOP   AGA
             MOV    AH,4CH
             INT    21H

    ;----------------------------------------
N2_16ASC PROC
             MOV    SI,OFFSET BUF
             MOV    COUNT,4
    LAST:    
             ROL    EDX,4
             AND    DL,0FH
             CMP    DL,10
             JC     NEXT
             ADD    DL,7
    NEXT:    
             ADD    DL,30H
             MOV    [SI],DL
             INC    SI
             DEC    COUNT
             JNZ    LAST
             RET
N2_16ASC ENDP

CODE ENDS
END BEG