;FILENAME:861-1.ASM
;要求利用PC系列机上的8254的0号定时计数器引发的日时钟中断，设计程序：每间隔1s在PC终端屏幕上显示一行字符串'HELLO!'，显示10行后结束
;方法一：置换系统1CH型中断向量，将其指向自定义的中断服务子程序
.586
DATA SEGMENT USE16
    MESG   DB 'HELLO!',0DH,0AH,'$'
    OLD1C  DD ?                       ;保存旧1CH型中断向量
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
            JNZ    SCAN                   ;是否显示了10行'HELLO!'，否则继续扫描
            CLI                           ;显示10行完成后，关中断
            CALL   RESET
            STI
            MOV    AH,4CH                 ;返回DOS
            INT    21H
    ;-----------------------------------------------
SERVICE PROC                              ;中断服务子程序
            PUSHA                         ;将所有通用寄存器的内容压入堆栈，从而保护现场
            PUSH   DS                     ;DS=40H
            MOV    AX,DATA
            MOV    DS,AX                  ;重新定义用户数据段
            DEC    ICOUNT                 ;中断计数，每次减1
            JNZ    EXIT                   ;中断不满18次则跳转，退出中断服务子程序
            MOV    ICOUNT,18              ;中断满18次则重新给ICOUNT赋值18
            DEC    COUNT                  ;并且显示行数减1
            MOV    AH,9                   ;显示字符串
            LEA    DX,MESG
            INT    21H
    EXIT:   
            POP    DS                     ;恢复现场
            POPA
            IRET                          ;返回系统08H型终端服务子程序
SERVICE ENDP
    ;-----------------------------------------------
READ1C PROC                               ;转移系统1CH型中断向量
            MOV    AX,351CH
            INT    21H
            MOV    WORD PTR OLD1C,BX
            MOV    WORD PTR OLD1C+2,ES
            RET
READ1C ENDP
    ;-----------------------------------------------
WRITE1C PROC                              ;写入用户1CH型中断向量
            PUSH   DS                     ;将原先DATA段的地址压栈
            MOV    AX,CODE                ;将CODE段的地址赋给DS
            MOV    DS,AX
            MOV    DX,OFFSET SERVICE      ;将中断服务子程序入口的偏移地址赋给DX
            MOV    AX,251CH               ;DOS调用，写入中断向量
            INT    21H
            POP    DS                     ;将原先DATA段的地址重新赋给DS
            RET
WRITE1C ENDP
    ;-----------------------------------------------
RESET PROC                                ;恢复系统1CH型中断向量
            MOV    DX,WORD PTR OLD1C
            MOV    DS,WORD PTR OLD1C+2
            MOV    AX,251CH
            INT    21H
            RET
RESET ENDP
    ;-----------------------------------------------
CODE ENDS
END BEG