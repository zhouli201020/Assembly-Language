;比较法将二进制数转化为十进制数显示在屏幕上
;采用子程序方式实现
.586
CODE SEGMENT USE16
                ASSUME CS:CODE
        BEN     DB     174
        BEG:    
                MOV    BL,100
                CALL   CMPDISP
                MOV    BL,10
                CALL   CMPDISP
                MOV    BL,1
                CALL   CMPDISP
                MOV    AH,4CH
                INT    21H

CMPDISP PROC
                MOV    DL,0
        LAST:   
                CMP    BEN,BL
                JC     NEXT
                INC    DL
                SUB    BEN,BL
                JMP    LAST
        NEXT:   
                ADD    DL,30H
                MOV    AH,2
                INT    21H
                RET
CMPDISP ENDP
CODE ENDS
END BEG