;比较从键盘输入的字符串STR1，和数据段中定义的字符串STR2是否相等，若相等，则将FLAG设为'Y'，否则设为'N'
;FILENAME:423_1.ASM

.586

DATA SEGMENT USE16
    STR1 DB 30,?,30 DUP(?)    ;输入字符串缓冲区
    FLAG DB 'N'               ;存放比较结果，初始为'N'
DATA ENDS

EXTRA SEGMENT USE16
    STR2  DB  'WELCOME'
    COUNT EQU $-STR2       ;统计串长度
EXTRA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA,ES:EXTRA
    BEG: 
         MOV    AX,DATA                     ;DS初始化
         MOV    DS,AX
         MOV    AX,EXTRA                    ;ES初始化
         MOV    ES,AX
         MOV    CX,COUNT
         MOV    AH,0AH                      ;从键盘输入字符串STR1
         MOV    DX,OFFSET STR1
         INT    21H
         MOV    CL,STR1+1                   ;输入字符串长度→CX
         MOV    CH,0
         CMP    CX,COUNT                    ;比较STR1和STR2的长度是否相等
         JNZ    EXIT                        ;如果不相等则跳转
         MOV    SI,OFFSET STR1+2            ;源串首地址→SI
         MOV    DI,OFFSET STR2              ;目标串首地址→DI
         CLD                                ;D标志为0，增址型
    LOAD:
         REPE   CMPSB                       ;两字符串比较
         JNZ    EXIT                        ;字符串比较不相等则跳转
         MOV    FLAG,'Y'                    ;字符串比较则设置FLAG标志为'Y'
    EXIT:
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG