;FILENAME:861-1.ASM
;要求利用PC系列机上的8254的0号定时计数器引发的日时钟中断，设计程序：每间隔1s在PC终端屏幕上显示一行字符串'HELLO!'，显示10行后结束

.586
DATA SEGMENT USE16
    MESG   DB 'HELLO!',0DH,0AH,'$'
    OLD1C  DD ?
    ICOUNT DB 18                      ;终端计数初值
    COUNT  DB 10                      ;显示行数控制
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
            CLI                           ;关中断
            CALL   READ1C
            CALL   WRITE1C
            STI                           ;开中断
    SCAN:   
            CMP    COUNT,0
            JNZ    SCAN
            CLI
            CALL   RESET
            STI
            MOV    AH,4CH
            INT    21H
    ;-----------------------------------------------
SERVICE PROC
            PUSHA
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            DEC    ICOUNT
            JNZ    EXIT
            MOV    ICOUNT,18
            DEC    COUNT
            MOV    AH,9
            LEA    DX,MESG
            INT    21H
    EXIT:   
            POP    DS
            POPA
            IRET                          ;返回系统08H型终端服务子程序
SERVICE ENDP
    ;-----------------------------------------------
READ1C PROC
            MOV    AX,351CH
            INT    21H
            MOV    WORD PTR OLD1C,BX
            MOV    WORD PTR OLD1C+2,ES
            RET
READ1C ENDP
    ;-----------------------------------------------
WRITE1C PROC
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET SERVICE
            MOV    AX,251CH
            INT    21H
            POP    DS
            RET
WRITE1C ENDP
    ;-----------------------------------------------
RESET PROC
            MOV    DX,WORD PTR OLD1C
            MOV    DS,WORD PTR OLD1C+2
            MOV    AX,251CH
            INT    21H
            RET
RESET ENDP
    ;-----------------------------------------------
CODE ENDS
END BEG