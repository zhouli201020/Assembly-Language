; 8位二进制数→十进制数，比较法
;比较法的关键：判断某二进制数(假设为BEN单元的内容)包含几个100，几个10，几个1

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
    BEN  DB      10101110B    ;=174
    BEG: 
         CMPDISP 100
         CMPDISP 10
         CMPDISP 1

         MOV     AH,4CH
         INT     21H
CODE ENDS
END BEG