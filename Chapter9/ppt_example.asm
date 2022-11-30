;对主串口进行外环自动测试，将下列测试电文10行，
;经主串口发出，通过外环短路线接收，显示在屏幕上，测试电文如下：
;THE QUICK BROWN FOX JUMPS OVER LAZY DOG
.586
DATA SEGMENT USE16
    TEXT  DB  'THE QUICK BROWN FOX JUMPS OVER LAZY DOG'
          DB  0DH,0AH
    LLL   EQU $-TEXT
    ERROR DB  'COM1 BAD!',0DH,0AH,'$'
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
            CALL   I8250
            MOV    CH,10              ;10行送CH
    AGAIN:  
            MOV    CL,LLL
            MOV    BX,OFFSET TEXT
    TSCAN:  
            MOV    DX,3FDH
            IN     AL,DX
            TEST   AL,20H
            JZ     TSCAN
            MOV    AL,[BX]
    SEND:   
            MOV    DX,3F8H
            OUT    DX,AL
            MOV    SI,0
    RSCAN:  
            MOV    DX,3FDH
            IN     AL,DX
            TEST   AL,01H
            JNZ    RECEIVE
            DEC    SI
            JNZ    RSCAN
            JMP    DISPERR
    RECEIVE:
            MOV    DX,3F8H
            IN     AL,DX
            AND    AL,7FH
    DISP:   
            MOV    AH,2
            MOV    DL,AL
            INT    21H
            INC    BX
            DEC    CL
            JNZ    TSCAN
            DEC    CH
            JNZ    AGAIN
            JMP    RETURN
    DISPERR:
            MOV    AH,9
            MOV    DX,OFFSET ERROR
            INT    21H
    RETURN: 
            MOV    AH,4CH
            INT    21H

I8250 PROC                            ;主串口初始化子程序
            MOV    DX,3FBH
            MOV    AL,80H
            OUT    DX,AL
            MOV    DX,3F9H
            MOV    AL,00H
            OUT    DX,AL
            MOV    DX,3F8H
            MOV    AL,60H
            OUT    DX,AL
            MOV    DX,3FBH
            MOV    AL,03H             ;无校验传送，8位数据
            OUT    DX,AL
            MOV    DX,3F9H
            MOV    AL,00H             ;禁止8250内部中断
            OUT    DX,AL
            MOV    DX,3FCH
            MOV    AL,00H             ;8250收发方式，禁止中断
            OUT    DX,AL
            RET
I8250 ENDP

CODE ENDS
END BEG