;FILENAME:871-1.ASM
;一外扩8254 0#计数器输出的是周期为100ms的方波，将该8254的OUT0接至系统总线插槽B4端子，利用该8254的OUT0输出
;作为定时时钟源，编程实现每隔1s在屏幕上显示字符串'HELLO!'，主机有按键时显示结束

.586
DATA SEGMENT USE16
    MESG   DB 'HELLO!',0DH,0AH,'$'
    OLD0A  DD ?
    ICOUNT DB 10                      ;中断计数初值
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
            CLI
            CALL   READ0A
            CALL   WRITE0A
            CALL   I8259A
            STI
    SCAN:   
            MOV    AH,1
            INT    16H
            JZ     SCAN
            CLI
            CALL   RESET
            STI
            MOV    AH,4CH
            INT    21H

SERVICE PROC
            PUSHA                         ;保护现场
            PUSH   DS                     ;DS=40H
            MOV    AX,DATA
            MOV    DS,AX                  ;重新给DS赋值
            DEC    ICOUNT
            JNZ    EXIT
            MOV    ICOUNT,10
            MOV    AH,9
            LEA    DX,MESG
            INT    21H
    EXIT:   
            MOV    AL,20H
            OUT    20H,AL                 ;给主8259A写结束字
            POP    DS                     ;恢复现场
            POPA
            IRET                          ;返回系统71型中断服务子程序
SERVICE ENDP

READ0A PROC                               ;转移系统0AH型中断向量
            MOV    AX,350AH
            INT    21H
            MOV    WORD PTR OLD0A,BX
            MOV    WORD PTR OLD0A+2,ES
            RET
READ0A ENDP

WRITE0A PROC                              ;写入用户0AH型中断向量
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET SERVICE
            MOV    AX,250AH
            INT    21H
            POP    DS
            RET
WRITE0A ENDP

I8259A PROC
            IN     AL,0A1H
            AND    AL,11111101B
            OUT    0A1H,AL                ;从8259A IMR1置零
            IN     AL,21H
            AND    AL,11111011B
            OUT    21H,AL                 ;主8259A IMR2置零
            RET
I8259A ENDP

RESET PROC                                ;恢复系统0AH型中断向量
            MOV    DX,WORD PTR OLD0A
            MOV    DS,WORD PTR OLD0A+2
            MOV    AX,250AH
            INT    21H
            RET
RESET ENDP

CODE ENDS
END BEG