;FILENAME:412.ASM
;用宏汇编实现显示彩色字符串（对比例4.3）

.586

DISP1 MACRO VAR                ;定义宏指令，实现在屏幕左上角显示黑白字符串VAR
          MOV AH,9
          MOV DX,OFFSET VAR
          INT 21H              ;DOS9号功能调用
ENDM

DISP2 MACRO Y,X,VAR,LENGTH,COLOR        ;定义宏指令，实现在屏幕中央显示彩色字符串VAR
          MOV AH,13H
          MOV AL,1
          MOV BH,0             ;选择0页显示屏
          MOV BL,COLOR         ;属性字（颜色值）→BL
          MOV CX,LENGTH        ;串长度→CX
          MOV DH,Y             ;行号→DH
          MOV DL,X             ;列号→DL
          MOV BP,OFFSET VAR    ;串首字符偏移地址→BP
          INT 10H              ;BIOS13H号功能调用
ENDM

DATA SEGMENT USE16
    MESG1 DB  'HELLO$'
    MESG2 DB  'WELCOME'
    LL    EQU $-MESG2
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA,ES:DATA
    BEG: 
         MOV    AX,DATA
         MOV    DS,AX
         MOV    ES,AX
         MOV    AX,0003H
         INT    10H                                ;设置80列25行彩色显示方式

         DISP1  MESG1
         DISP2  12,(80-LL)/2,MESG2,LL,01001111B

         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG