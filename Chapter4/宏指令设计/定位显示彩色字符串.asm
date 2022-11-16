;定位显示彩色字符串
;要求置显示器为彩色文本方式，并在：
;0行5列 显示 黑底绿色 HELLO
;12行36列 显示 黑底红色 WELCOME！
;24行66列 显示 黑底黄色 BYE_BYE

.586

DISP MACRO Y,X,VAR,LENGTH,COLOR
         MOV AH,13H
         MOV AL,1
         MOV BH,0
         MOV BL,COLOR
         MOV CX,LENGTH
         MOV DH,Y
         MOV DL,X
         MOV BP,OFFSET VAR
         INT 10H
ENDM

DATA SEGMENT USE16
    SS1  DB 'HELLO'
    SS2  DB 'WELCOME!'
    SS3  DB 'BYE_BYE'
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,ES:DATA
    BGE: 
         MOV    AX,DATA
         MOV    ES,AX
    SET: 
         MOV    AX,3
         INT    10H
    NEXT:
         DISP   0,5,SS1,5,2        ;0行5列显示绿色HELLO
         DISP   12,36,SS2,8,4      ;12行36列显示红色WELCOME
         DISP   24,66,SS3,7,0EH    ;24行66列显示黄色BYE_BYE
    SCAN:
         MOV    AH,1
         INT    16H
         JZ     SCAN               ;等待用户键入,无键入转
    REC: 
         MOV    AX,2               ;恢复80×25黑白文本方式
         INT    10H
    EXIT:
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BGE