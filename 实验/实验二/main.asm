.586

DATA SEGMENT USE16
    MESG1    DB  'Please Enter The Password:',0DH,0AH,'$'
    MESG2    DB  'WELCOME!'
    MM       EQU $-MESG2
    MESG3    DB  0DH,0AH,'Wrong password! Please re-enter:',0DH,0AH,'$'
    PASSWORD DB  '123456'
    LL       EQU $-PASSWORD
    INPUT    DB  30 DUP(?)                        ;用来存放用户输入的密码，预置了30个字节的空间
DATA ENDS

CODE SEGMENT USE16
                ASSUME CS:CODE,DS:DATA,ES:DATA
    BEG:        
                MOV    AX,DATA
                MOV    DS,AX
                MOV    ES,AX
                MOV    BX,OFFSET INPUT            ;INPUT串首偏移地址→BX
                MOV    BP,0                       ;BP用于统计实际输入的密码的长度
    DISPMESG1:  
                MOV    AX,0003H                   ;设置80列25行彩色文本显示方式
                INT    10H
                MOV    AH,9                       ;DOS9号功能调用（会破坏AL）
                MOV    DX,OFFSET MESG1
                INT    21H
    SCAN:       
                MOV    AH,7                       ;DOS7号功能调用，等待从键盘键入一个字符（无回显）
                INT    21H
                CMP    AL,0DH                     ;判断用户是否输入了回车0DH
                JZ     JUDGE
                MOV    [BX],AL                    ;将用户输入的密码送入INPUT中
                MOV    AH,2                       ;DOS2号功能调用，显示*（会破坏AL）
                MOV    DL,'*'
                INT    21H
                INC    BX                         ;BX+1→BX
                INC    BP                         ;BP+1→BP
                JMP    SCAN
    JUDGE:      
                MOV    CX,LL                      ;正确密码的长度→CX
                CMP    BP,CX                      ;比较实际键入的密码长度和正确的密码长度是否相等
                JNZ    NEXT
                MOV    SI,OFFSET PASSWORD
                MOV    DI,OFFSET INPUT
                CLD
                REPE   CMPSB                      ;串比较指令
                JZ     DISPWELCOME
    NEXT:       
                MOV    AH,9                       ;输出错误信息
                MOV    DX,OFFSET MESG3
                INT    21H
                MOV    BX,OFFSET INPUT            ;BX重新指向INPUT串首
                MOV    BP,0                       ;将BP重新归零
                JMP    SCAN
    DISPWELCOME:
                MOV    AX,1301H
                MOV    BH,0
                MOV    BL,01001111B
                MOV    CX,MM
                MOV    DH,12
                MOV    DL,(80-MM)/2
                MOV    BP,OFFSET MESG2
                INT    10H
    EXIT:       
                MOV    AH,4CH
                INT    21H
CODE ENDS
END BEG