;将BX寄存器中的内容以二进制数格式显示在屏幕上

.586

CODE SEGMENT USE16
         ASSUME CS:CODE
    BEG: MOV    BX,5678H
         MOV    CX,16
    LAST:MOV    AL,'0'
         ROL    BX,1
         JNC    NEXT        ;这两行也可以写成ADC AL,0
         MOV    AL,'1'      ;
    NEXT:MOV    AH,0EH
         INT    10H
         LOOP   LAST
         MOV    AH,4CH
         INT    21H
CODE ENDS
END BEG