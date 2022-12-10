;设微机系统外扩一片8255A，相应的实验电路如下图所示。
;要求利用微机日时钟1CH中断，实现发光二级管LED点亮1秒钟后，再熄灭1秒，循环往复。
;当主机键盘按下任意键时，程序结束。（要求给出完整的源程序）
.586
DATA SEGMENT USE16
    OLD1C  DD ?
    ICOUNT DB 18
    TAB    DB 11111110B
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
            CLI
            CALL   I8255A
            CALL   READIC
            CALL   WRITE1C
            STI
    SCAN:   
            MOV    AH,1
            INT    16H
            JZ     SCAN
            CALL   RESET
            MOV    AH,4CH
            INT    21H

SERVICE PROC
            PUSH   AX
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            DEC    ICOUNT
            JNZ    EXIT
            MOV    ICOUNT,18
            MOV    AL,TAB
            MOV    DX,230H
            OUT    DX,AL
            NOT    TAB
    EXIT:   
            POP    DS
            POP    AX
            IRET
SERVICE ENDP

I8255A PROC
            MOV    DX,233H
            MOV    AL,80H
            OUT    DX,AL
            RET
I8255A ENDP

READIC PROC
            MOV    AX,351CH
            INT    21H
            MOV    WORD PTR OLD1C,BX
            MOV    WORD PTR OLD1C+2,ES
            RET
READIC ENDP

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

RESET PROC
            MOV    DX,WORD PTR OLD1C
            MOV    DS,WORD PTR OLD1C+2
            MOV    AX,251CH
            INT    21H
            RET
RESET ENDP

CODE ENDS
END BEG