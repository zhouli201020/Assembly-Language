.586
DATA SEGMENT USE16
    OLD0B DD ?    ;存储系统0BH中断向量
    FLAG  DB 0    ;标志位
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    MOV    AX,DATA
            MOV    DS,AX
            CLI                           ;关中断
            CALL   I8250                  ;辅串口初始化
            CALL   I8259                  ;开放8259A辅串口中断
            CALL   RD0B                   ;保存0BH中断向量
            CALL   WR0B                   ;置换0BH中断向量
            STI                           ;开中断
    SCANT:  
            CMP    FLAG,-1                ;测试是否收到结束字符
            JE     RETURN                 ;接收到回车则结束程序
            MOV    DX,2FDH                ;查询发送保持寄存器
            IN     AL,DX
            TEST   AL,20H                 ;查询D5位发送保持寄存器空闲标志位
            JZ     SCANT
	 
            MOV    AH,1                   ;查询键盘缓冲区
            INT    16H
            JZ     SCANT
            MOV    AH,0                   ;读取键盘缓冲区的内容 ASCII->AL
            INT    16H
            AND    AL,7FH                 ;屏蔽最高位，使用AND指令满足ASCII7位的要求
            MOV    DX,2F8H
            OUT    DX,AL
	
    ;JMP SCANT
            CMP    AL,0DH                 ;判断是否是回车,回车对应的ASCII是0DH
            JNE    SCANT                  ;若题目要求发送方输入回车结束程序运行，则将这两行代码注释去掉，然后注释上面的JMP SCANT
    TWAIT:  
            MOV    DX,2FDH
            IN     AL,DX
            TEST   AL,40H                 ;测试一帧是否发送完
            JZ     TWAIT
    RETURN:                               ;当一帧发送完则执行结束程序
            CALL   RESET                  ;恢复系统0BH中断向量
            MOV    AH,4CH
            INT    21H
	 


    ;接收中断服务子程序
RECEIVE PROC
            PUSH   AX
            PUSH   DX
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            MOV    DX,2F8H                ;读取接收缓冲区的内容
            IN     AL,DX
            AND    AL,7FH
            CMP    AL,0DH                 ;判断是否是回车
            JE     NEXT
            MOV    AH,2                   ;不是回车,显示字符在屏幕上
            MOV    DL,AL
            INT    21H
            JMP    EXIT
    NEXT:   MOV    FLAG,-1
    EXIT:   MOV    AL,20H
            OUT    20H,AL
            POP    DS
            POP    DX
            POP    AX
            IRET                          ;中断返回
RECEIVE ENDP


    ;初始化8250
I8250 PROC
            MOV    DX,2FBH                ;寻址为置1
            MOV    AL,80H
            OUT    DX,AL
            MOV    DX,2F9H                ;写除数寄存器高8位
            MOV    AL,0
            OUT    DX,AL
            MOV    DX,2F8H                ;写除数寄存器低8位,波特率为1200
            MOV    AL,60H
            OUT    DX,AL
            MOV    DX,2FBH                ;写帧数据格式:8数据位,1停止位,无校验位
            MOV    AL,03H
            OUT    DX,AL
            MOV    DX,2F9H                ;允许8250内部提出中断
            MOV    AL,01H
            OUT    DX,AL
            MOV    DX,2FCH
            MOV    AL,00011000B           ;D4=1内环自检,   D3=1开放中断, D4=0正常通信
            OUT    DX,AL
            RET                           ;段内返回
I8250 ENDP



    ;开放主8259辅串口中断  D3位
I8259 PROC
            IN     AL,21H
            AND    AL,11110111B
            OUT    21H,AL
            RET                           ;段内返回
I8259 ENDP


RD0B PROC
            MOV    AX,350BH
            INT    21H
            MOV    WORD PTR OLD0B,BX
            MOV    WORD PTR OLD0B+2,ES
            RET                           ;段内返回
RD0B ENDP

WR0B PROC
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET RECEIVE
            MOV    AX,250BH
            INT    21H
            POP    DS
            RET                           ;段内返回
WR0B ENDP
	 
	 
RESET PROC
            IN     AL,21H
            OR     AL,00001000B           ;将中断屏蔽寄存器的辅串口中断屏蔽字置1，关闭8259辅串口中断
            OUT    21H,AL
            MOV    AX,250BH
            MOV    DX,WORD PTR OLD0B
            MOV    DS,WORD PTR OLD0B+2
            INT    21H
            RET                           ;段内返回
RESET ENDP

CODE ENDS
	 END BEG
