;要求甲乙两台微型计算机之间通过RSC-232C接口进行短距离的单工串行通信（不使用联络线），甲机作为发送端从主串口将一串字符逐个发送
;乙机作为接收端在辅串口进行字符接收并显示在屏幕上，其中甲机发送字符串时以'ETX'字符（ASCII码：03H）作为结束标志字符
;通信双方约定波特率为2400波特，数据位7位，停止位1位，奇校验，甲机发送采用查询方式，乙机接收采用中断方式

;乙机接收程序
;FILENAME:EXA92_2.ASM
.586
DATA SEGMENT USE16
    OLD0B DD ?
    FLAG  DB 0
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
            CLI                           ;关中断
            CALL   I8250                  ;辅串口初始化
            CALL   I8259                  ;开放主8259A辅串口中断
            CALL   RD0B                   ;读0BH型中断向量
            CALL   WR0B                   ;写0BH型中断向量
            STI                           ;开中断
    SCANT:  
            CMP    FLAG,1                 ;测试是否收到结束字符
            JNZ    SCANT
            CALL   RESET                  ;若接收已经结束，则将0BH型中断向量恢复
    EXIT1:  
            MOV    AH,4CH
            INT    21H
        
RECEIVE PROC
            PUSH   AX
            PUSH   DX
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            MOV    DX,2F8H
            IN     AL,DX                  ;读取接收缓冲区的内容
            AND    AL,7FH                 ;因为数据位7位，所以将最高位抹去
            CMP    AL,03H                 ;判断是否接收到了停止字符
            JZ     NEXT
            MOV    AH,2
            MOV    DL,AL
            INT    21H
            JMP    EXIT
    NEXT:   
            MOV    FLAG,1
    EXIT:   
            MOV    AL,20H                 ;20H为中断结束命令字
            OUT    20H,AL                 ;20H为主8259A接收中断结束命令的寄存器口地址
            POP    DS
            POP    DX
            POP    AX
            IRET
RECEIVE ENDP

I8250 PROC
            MOV    DX,2FBH
            MOV    AL,80H
            OUT    DX,AL                  ;寻址位置1
            MOV    DX,2F9H
            MOV    AL,0
            OUT    DX,AL                  ;写除数寄存器高8位
            MOV    DX,2F8H
            MOV    AL,30H
            OUT    DX,AL                  ;写除数寄存器低8位
            MOV    DX,2FBH
            MOV    AL,0AH
            OUT    DX,AL                  ;写数据帧格式
            MOV    DX,2F9H
            MOV    AL,01H
            OUT    DX,AL                  ;允许8250内部提出接收中断
            MOV    DX,2FCH
            MOV    AL,08H
            OUT    DX,AL                  ;8250正常收、发方式并允许送出中断请求
            RET
I8250 ENDP

I8259 PROC
            IN     AL,21H                 ;21H为主8259A中断屏蔽寄存器口地址
            AND    AL,11110111B           ;开放主8259A的IR3辅串口中断请求
            OUT    21H,AL
            RET
I8259 ENDP

RD0B PROC
            MOV    AX,350BH
            INT    21H                    ;调用INT21H的35H号子功能读取0BH型中断向量
            MOV    WORD PTR OLD0B,BX
            MOV    WORD PTR OLD0B,ENDS
            RET
RD0B ENDP

WR0B PROC
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET RECEIVE
            MOV    AX,250BH
            INT    21H                    ;调用INT21H的25H号子功能写入新的0BH型中断向量
            POP    DS
            RET
WR0B ENDP

RESET PROC
            IN     AL,21H                 ;21H为主8259A中断屏蔽寄存器口地址
            OR     AL,00001000B           ;关闭主8259A的IR3辅串口中断请求
            OUT    21H,AL
            MOV    AX,250BH               ;调用INT21H的25H号子功能将原先的0BH型中断向量重新写入
            MOV    DX,WORD PTR OLD0B
            MOV    DS,WORD PTR OLD0B+2
            INT    21H
            RET
RESET ENDP

CODE ENDS
END BEG