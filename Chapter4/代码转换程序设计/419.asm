;FILENAME:419.ASM
;用比较法实现二进制数转换成十进制数显示

.586

CMPDISP MACRO NN
            LOCAL LAST,NEXT
            MOV   DL,0
    LAST:   
            CMP   BEN,NN
            JC    NEXT
            INC   DL
            SUB   BEN,NN
            JMP   LAST
    NEXT:   
            ADD   DL,30H
ENDM

DATA SEGMENT USE16
    BEN   DW  1287H                  ;4743
    TAB   DW  10000,1000,100,10,1
    COUNT EQU ($-TAB)/2
    BUF   DB  COUNT DUP(?),'$'
DATA ENDS

CODE SEGMENT USE16
         ASSUME  CS:CODE,DS:DATA
    BEG: 
         MOV     AX,DATA
         MOV     DS,AX
    INIT:
         MOV     CX,COUNT
         MOV     BX,OFFSET TAB
         MOV     SI,OFFSET BUF
    AGA: 
         MOV     AX,[BX]
         CMPDISP AX
         MOV     [SI],DL
         ADD     BX,2
         INC     SI
         LOOP    AGA
         MOV     SI,OFFSET BUF        ;输出缓冲区地址重新→BUF
    NOSP:
         CMP     BYTE PTR [SI],30H
         JNZ     DISP
         INC     SI
         JMP     NOSP
    DISP:
         MOV     AH,9
         MOV     DX,SI
         INT     21H
    EXIT:
         MOV     AH,4CH
         INT     21H
CODE ENDS
END BEG