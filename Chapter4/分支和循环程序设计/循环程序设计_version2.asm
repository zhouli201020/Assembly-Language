;假设从BUF单元开始为一个ASCII码字符串,找出其中的最大数送屏幕显示
;采用条件转移指令进行循环的判断

.586

DATA SEGMENT USE16
    BUF  DB 'QWERTYUIOP123'
    FLAG DB -1                      ;设置串结束标志
    MAX  DB 'MAX=',?,0DH,0AH,'$'
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA
    BEG: 
         MOV    AX,DATA
         MOV    DS,AX
    INIT:                           ;初始化
         MOV    DL,'0'
         MOV    BX,OFFSET BUF
    LAST:
         CMP    BYTE PTR [BX],-1    ;判断字符串是否结束
         JE     DISP                ;若结束则跳转到DISP
         CMP    [BX],DL
         JC     NEXT
         MOV    DL,[BX]
    NEXT:
         INC    BX
         JMP    LAST
    DISP:
         MOV    MAX+4,DL
         MOV    DX,OFFSET MAX
         MOV    AH,9                ;DOS９号功能调用显示字符串
         INT    21H
    EXIT:
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG