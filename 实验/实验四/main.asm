;运用微机系统串行口知识进行微机系统串行口的测试
;要求：
;1.编写程序对微机系统的串口进行自发自收外环测试——数据发送从键盘键入，接收数据屏幕显示
;2.发送要求采用查询方式，接收采用中断方式
;3.假设通信双方约定的波特率为2400波特，数据位7位，停止位1位，奇校验
.586
DATA SEGMENT USE16
        OLD0B DD ?        ;存储系统0BH型中断向量
        FLAG  DB 0        ;标志位：当输入回车时FLAG为-1
DATA ENDS

CODE SEGMENT USE16
                ASSUME CS:CODE,DS:DATA
        BEG:    
                MOV    AX,DATA
                MOV    DS,AX
                CLI                               ;关中断
                CALL   I8250                      ;8250辅串口初始化
                CALL   I8259                      ;开放主8259A辅串口中断
                CALL   RD0B                       ;读取0BH型中断向量
                CALL   WR0B                       ;置换0BH型中断向量
                STI                               ;开中断
        SCANT:  
                CMP    FLAG,-1
                JZ     RETURN                     ;接收到回车则程序结束
                MOV    DX,2FDH
                IN     AL,DX
                TEST   AL,20H                     ;查询发送保持寄存器是否空闲，D5=1说明空闲
                JZ     SCANT
                MOV    AH,1
                INT    16H
                JZ     SCANT                      ;BIOS 1号功能调用，查询键盘缓冲区是否为空，如果为空则继续扫描
                MOV    AH,0                       ;调用BIOS 0号功能，将键盘缓冲区的内容送入AL
                INT    16H
                AND    AL,7FH                     ;屏蔽最高位
                MOV    DX,2F8H
                OUT    DX,AL                      ;向发送保持寄存器传入键盘输入的字符
                CMP    AL,0DH                     ;如果未输入回车，则继续发送下一个字符
                JNZ    SCANT
        RETURN: 
                CALL   RESET
                MOV    AH,4CH
                INT    21H

RECEIVE PROC
                PUSH   AX
                PUSH   DX
                PUSH   DS
                MOV    AX,DATA
                MOV    DS,AX
                MOV    DX,2F8H
                IN     AL,DX
                AND    AL,7FH                     ;读取接收缓冲区的内容，并屏蔽最高位
                CMP    AL,0DH                     ;判断键盘输入的是否是回车
                JZ     NEXT                       ;如果输入了回车，则将FLAG设为-1
                MOV    AH,2                       ;如果不是回车，调用DOS2号功能将接收到的字符显示在屏幕上
                MOV    DL,AL
                INT    21H
                JMP    EXIT
        NEXT:   
                MOV    FLAG,-1
        EXIT:   
                MOV    AL,20H                     ;向主8259A写中断结束命令字20H
                OUT    20H,AL                     ;20H为主8259A接收中断结束命令的寄存器的口地址
                POP    DS
                POP    DX
                POP    AX
                IRET
RECEIVE ENDP

I8250 PROC
                MOV    DX,2FBH
                MOV    AL,80H
                OUT    DX,AL                      ;寻址位置1
                MOV    DX,2F9H
                MOV    AL,0
                OUT    DX,AL                      ;写除数寄存器高8位
                MOV    DX,2F8H
                MOV    AL,30H
                OUT    DX,AL                      ;写除数寄存器低8位
                MOV    DX,2FBH
                MOV    AL,0AH
                OUT    DX,AL                      ;写数据帧格式
                MOV    DX,2F9H
                MOV    AL,01H
                OUT    DX,AL                      ;允许8250接收到一帧数据后，内部提出“接收中断请求“
                MOV    DX,2FCH
                MOV    AL,18H                     ;8250工作在内环自检方式，允许8250送出中断请求
                OUT    DX,AL
                RET
I8250 ENDP

I8259 PROC
                IN     AL,21H                     ;21H为主8259A中断屏蔽寄存器口地址
                AND    AL,11110111B               ;开放主8259A的IR3辅串口中断请求
                OUT    21H,AL
                RET
I8259 ENDP

RD0B PROC
                MOV    AX,350BH                   ;INT 21H的35号子功能，读取系统0BH型中断向量
                INT    21H
                MOV    WORD PTR OLD0B,BX
                MOV    WORD PTR OLD0B+2,ES
                RET
RD0B ENDP

WR0B PROC
                PUSH   DS
                MOV    AX,CODE
                MOV    DS,AX
                MOV    DX,OFFSET RECEIVE
                MOV    AX,250BH                   ;INT 21H的25号子功能，写入新的0BH型中断向量
                INT    21H
                POP    DS
                RET
WR0B ENDP

RESET PROC
                IN     AL,21H                     ;21H为主8259A中断屏蔽寄存器口地址
                OR     AL,00001000B               ;关闭8259A的IR3辅串口中断
                OUT    21H,AL
                MOV    AX,250BH                   ;INT 21H的25号子功能，恢复系统原来的0BH型中断向量
                MOV    DX,WORD PTR OLD0B
                MOV    DS,WORD PTR OLD0B+2
                INT    21H
                RET
RESET ENDP

CODE ENDS
END BEG