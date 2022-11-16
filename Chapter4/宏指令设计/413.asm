;FILENAME:413.ASM
;求绝对值

.586

ABS MACRO VAR
         LOCAL NEXT
         CMP   VAR,0
         JGE   NEXT
         NEG   VAR
    NEXT:
ENDM

DATA SEGMENT USE16
    NUM  DB -1
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA
    BEG: 
         MOV    AX,DATA
         MOV    DS,AX
         MOV    BX,-1030
         ABS    BX                 ;求BX的绝对值
         ABS    NUM                ;求NUM的绝对值
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG