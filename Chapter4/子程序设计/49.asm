;FILENAME:49.ASM

.586

DATA SEGMENT USE16
    ARRAY  DW 1111H,2222H,3333H,4444H,5555H
    RESULT DW ?
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    MOV    AX,DATA
            MOV    DS,AX

            MOV    CX,5
            MOV    BX,OFFSET ARRAY
            CALL   COMPUTE
    XYZ:    
            MOV    RESULT,AX
    EXIT:   
            MOV    AH,4CH
            INT    21H
;------------------------------------------
COMPUTE PROC
            MOV    AX,0
    AGA:    
            ADD    AX,[BX]
            ADD    BX,2
            LOOP   AGA
            RET
COMPUTE ENDP
;-------------------------------------------
CODE ENDS
END BEG