;FILENAME:861-2.ASM
;方法二：置换系统08H型中断向量，将其指向自定义的中断服务子程序

.586
DATA SEGMENT USE16
        MESG   DB 'HELLO!',0DH,0AH,'$'
        OLD08  DD ?
        ICOUNT DB 18
        COUNT  DB 10
DATA ENDS

CODE SEGMENT USE16
                ASSUME CS:CODE,DS:DATA
        BEG:    
                MOV    AX,DATA
                MOV    DS,AX
                CLI                               ;关中断
                CALL   READ08                     ;保存原来的08H型中断向量
                CALL   WRITE08                    ;置换08H型中断向量指向自定义的中断服务子程序
                STI                               ;开中断
        SCAN:   
                CMP    COUNT,0
                JNZ    SCAN                       ;是否显示了10行，否则继续扫描判断
                CLI
                CALL   RESET                      ;如果已经显示了10行，则关中断并且恢复系统08H型中断向量
                STI                               ;开中断
                MOV    AH,4CH
                INT    21H                        ;返回DOS

SERVICE PROC                                      ;中断服务子程序
                PUSHA
                PUSH   DS                         ;保护现场
                MOV    AX,DATA
                MOV    DS,AX
                DEC    ICOUNT                     ;计18次，18*55ms=990ms
                JNZ    EXIT
                MOV    ICOUNT,18
                DEC    COUNT                      ;显示行数减1
                MOV    AH,9                       ;显示字符串
                MOV    DX,OFFSET MESG
                INT    21H
        EXIT:   
                POP    DS
                POPA                              ;恢复现场
                JMP    OLD08                      ;转向原来的08H型中断服务子程序
SERVICE ENDP

READ08 PROC                                       ;保存原来系统的08H型中断向量
                MOV    AX,3508H
                INT    21H
                MOV    WORD PTR OLD08,BX
                MOV    WORD PTR OLD08+2,ES
                RET
READ08 ENDP

WRITE08 PROC                                      ;置换08H型中断向量指向自定义的中断服务子程序
                PUSH   DS
                MOV    AX,CODE
                MOV    DS,AX
                MOV    DX,OFFSET SERVICE
                MOV    AX,2508H
                INT    21H
                POP    DS
                RET
WRITE08 ENDP

RESET PROC                                        ;恢复系统08H型中断向量
                MOV    DX,WORD PTR OLD08          ;注意和后一条指令的先后顺序不可以改变
                MOV    DS,WORD PTR OLD08+2
                MOV    AX,2508H
                INT    21H
                RET
RESET ENDP

CODE ENDS
END BEG