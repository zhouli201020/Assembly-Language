;编写程序，使PC机8254的计数器产生800Hz的方波，经滤波后送至扬声器发声，当按键盘任意键时声音停止
;FILENAME:EXA113.ASM
.586
CODE SEGMENT USE16
               ASSUME CS:CODE
    BEG:       
               IN     AL,61H
               OR     AL,03H
               OUT    61H,AL
    WORDDIV:   
               MOV    DX,12H
               MOV    AX,34DEH
               MOV    CX,800
               DIV    CX
    WRITEVALUE:
               OUT    42H,AL
               MOV    AL,AH
               OUT    42H,AL
    SCAN:      
               MOV    AH,1
               INT    16H
               JZ     SCAN
    CLOSE:     
               IN     AL,61H
               AND    AL,0FCH
               OUT    61H,AL
    EXIT:      
               MOV    AH,4CH
               INT    21H
CODE ENDS
END BEG