;要求甲乙两台微型计算机之间通过RSC-232C接口进行短距离的单工串行通信（不使用联络线），甲机作为发送端从主串口将一串字符逐个发送
;乙机作为接收端在辅串口进行字符接收并显示在屏幕上，其中甲机发送字符串时以'ETX'字符（ASCII码：03H）作为结束标志字符
;通信双方约定波特率为2400波特，数据位7位，停止位1位，奇校验，甲机发送采用查询方式，乙机接收采用中断方式

;甲机发送程序
;FILENAME:EXA92_1.ASM
.586
DATA SEGMENT USE16
    BUF  DB  'Hello',03H
    LENS EQU $-BUF
DATA ENDS

CODE SEGMENT USE16
          ASSUME CS:CODE,DS,DATA
    BEG:  
          MOV    AX,DATA
          MOV    DS,AX
          CALL   I8250              ;主串口初始化
          LEA    BX,BUF
          MOV    CX,LENS
    SCAN: 
          MOV    DX,3FDH
          IN     AL,DX
          TEST   AL,20H             ;发送保持寄存器是否为空
          JZ     SCAN
          MOV    DX,3F8H
          MOV    AL,[BX]            ;取字符
          OUT    DX,AL              ;送入主串口发送保持寄存器
          INC    BX
          LOOP   SCAN
    LAST: 
          MOV    DX,3FDH
          IN     AL,DX
          TEST   AL,40H             ;发送移位寄存器是否为空
          JZ     LAST               ;程序结束之前需要确保最后一个字符发送完成
          MOV    AH,4CH
          INT    21H

I8250 PROC
          MOV    DX,3FBH
          MOV    AL,80H
          OUT    DX,AL              ;寻址位置1
          MOV    DX,3F9H
          MOV    AL,0
          OUT    DX,AL              ;写除数寄存器高8位
          MOV    DX,3F8H
          MOV    AL,30H
          OUT    DX,AL              ;写除数寄存器低8位
          MOV    DX,3FBH
          MOV    AL,0AH
          OUT    DX,AL              ;写数据帧格式
          MOV    DX,3F9H
          MOV    AL,0
          OUT    DX,AL              ;禁止8250内部中断
          MOV    DX,3FCH
          MOV    AL,0
          OUT    DX,AL              ;8250正常收、发方式，禁止中断
          RET
I8250 ENDP

CODE ENDS
END BEG