;设N1=1122H,N2=3344H,N3=5566H,用子程序调用的方法实现3个数的累加和,并用二进制格式显示在屏幕上
;使用寄存器传递参数

.586

DATA SEGMENT USE16
    NUM  DW 1122H
         DW 3344H
         DW 5566H
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
    INIT:   
            MOV    SI,OFFSET NUM      ;参数指针→SI
            CALL   COMPUTE
            CALL   DISP
    EXIT:   
            MOV    AH,4CH
            INT    21H
    ;----------------------------------
COMPUTE PROC
            MOV    BX,0               ;BX用于存放累加和
            ADD    BX,[SI]
            ADD    BX,[SI+2]
            ADD    BX,[SI+4]
            RET
COMPUTE ENDP
    ;----------------------------------
DISP PROC
            MOV    CX,16
    LAST:   
            MOV    DL,'0'
            RCL    BX,1
            JNC    NEXT               ;C=0转移
            MOV    DL,'1'
    NEXT:   
            MOV    AH,2               ;DOS2号功能调用显示一个字符
            INT    21H
            LOOP   LAST
            RET
DISP ENDP
CODE ENDS
END BEG