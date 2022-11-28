;比较法将二进制数转化为十进制数显示在屏幕上
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
            MOV   AH,2
            INT   21H
ENDM

CODE SEGMENT USE16
         ASSUME  CS:CODE
    BEN  DB      174
    BEG: 
         CMPDISP 100
         CMPDISP 10
         CMPDISP 1
         MOV     AH,4CH
         INT     21H
CODE ENDS
END BEG