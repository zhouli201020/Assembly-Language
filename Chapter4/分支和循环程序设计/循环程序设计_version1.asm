;假设从BUF单元开始为一个ASCII码字符串,找出其中的最大数送屏幕显示
;采用循环计数器CX进行循环的判断

.586

DATA SEGMENT USE16
     BUF   DB  'QWERTYUIOP123'
     COUNT EQU $-BUF
     MAX   DB  'MAX=',?,0DH,0AH,'$'
DATA ENDS

CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA
     BEG: 
          MOV    AX,DATA
          MOV    DS,AX
     INIT:
          MOV    AL,0                ;无符号最小数0→AL
          LEA    BX,BUF              ;串首偏移量→BX
          MOV    CX,COUNT            ;串长度→CX
     LAST:
          CMP    [BX],AL
          JC     NEXT                ;若当前字符比AL小则转移
          MOV    AL,[BX]             ;否则将AL更新为大的字符
     NEXT:
          INC    BX
          LOOP   LAST
     DISP:
          MOV    MAX+4,AL            ;将MAX字符串的第5个单元修改为AL中的值
          MOV    AH,9                ;调用DOS9号共能显示字符串
          MOV    DX,OFFSET MAX
          INT    21H
     EXIT:
          MOV    AH,4CH
          INT    21H
CODE ENDS
END BEG