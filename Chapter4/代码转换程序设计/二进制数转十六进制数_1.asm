;设从NUM单元开始，有1个8位的二进制数，要求将其转换成16进制数，并送屏幕显示

.586

DATA SEGMENT USE16
    BNUM  DB 11111111B                   ;FFH
    BUF   DB 2 DUP(?),'H',0DH,0AH,'$'
    COUNT DB 2
DATA ENDS

CODE SEGMENT USE16
             ASSUME CS:CODE,DS:DATA
    BEG:     
             MOV    AX,DATA
             MOV    DS,AX
             MOV    BX,OFFSET BNUM
    AGA:     
             MOV    DL,[BX]
             SAL    DX,8
             CALL   N2_16ASC

             MOV    AH,9               ;显示转换后的16进数
             MOV    DX,OFFSET BUF
             INT    21H
             
             MOV    AH,4CH
             INT    21H

    ;-------------------------------------------
N2_16ASC PROC
             MOV    SI,OFFSET BUF      ;输出缓冲区地址→SI
    LAST:    
             ROL    DX,4
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