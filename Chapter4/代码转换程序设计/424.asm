;从BUF单元开始存有一字符串，找出其中ASCII码最小和最大的字符，并发送到屏幕显示
;FILENAME:424.ASM

.586

DATA SEGMENT USE16
    BUF   DB  'DLSIEFLIEFAWOKFADL'
    COUNT EQU $-BUF
    MAX   DB  'MAX=',?,0DH,0AH,'$'
    MIN   DB  'MIN=',?,'$'
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA
    BEG: 
         MOV    AX,DATA
         MOV    DS,AX
         MOV    AL,BUF
         MOV    MAX+4,AL           ;假设第一个数是最大数
         MOV    MIN+4,AL           ;假设第一个数是最小数
         MOV    BX,OFFSET BUF+1
         MOV    CX,COUNT-1         ;比较次数
    LAST:
         MOV    AL,[BX]            ;比较最大数
         CMP    AL,MAX+4
         JNA    LESS
         MOV    MAX+4,AL           ;大数→MAX+4
    LESS:
         CMP    AL,MIN+4           ;比较最小数
         JNC    NEXT
         MOV    MIN+4,AL           ;小数→MIN+4
    NEXT:
         INC    BX
         LOOP   LAST
    DISP:
         MOV    AH,9
         MOV    DX,OFFSET MAX
         INT    21H
         MOV    AH,9
         MOV    DX,OFFSET MIN
         INT    21H
    EXIT:
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG