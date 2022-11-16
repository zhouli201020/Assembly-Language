;FILENAME:42_1.ASM
;询问用户姓名并等待用户输入，用户输入姓名后按Enter键，程序再把输入的姓名复制显示在屏幕上

.586

DATA SEGMENT USE16
        MESG DB 'What is your name?$'
        BUF  DB 30
             DB ?
             DB 30 DUP(?)
DATA ENDS

CODE SEGMENT USE16
              ASSUME CS:CODE,DS:DATA

        BEG:  MOV    AX,DATA
              MOV    DS,AX

        AGAIN:MOV    AH,9                        ;显示询问姓名字符串
              MOV    DX,OFFSET MESG
              INT    21H

              MOV    AH,0AH                      ;用户输入字符串
              MOV    DX,OFFSET BUF
              INT    21H
        
              MOV    AH,2                        ;换行
              MOV    DL,0AH
              INT    21H

              MOV    BL,BUF+1                    ;实际输入的字符个数送给BX
              MOV    BH,0
              MOV    SI,OFFSET BUF+2
              MOV    BYTE PTR [BX+SI],'$'

              MOV    AH,9                        ;复制用户输入的字符串
              MOV    DX,OFFSET BUF+2
              INT    21H

              MOV    AH,4CH                      ;返回DOS
              INT    21H
CODE ENDS
        END BEG