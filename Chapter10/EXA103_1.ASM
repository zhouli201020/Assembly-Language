;FILENAME:EXA103_1.ASM
.586
DATA SEGMENT USE16
    MESG DB '8255A READY...',0DH,0AH,'$'
    TAB  DB 11111110B
         DB 11111101B
         DB 11111011B
         DB 11110111B
         DB 11101111B
         DB 11011111B
         DB 10111111B
         DB 01111111B
DATA ENDS

CODE SEGMENT USE16
           ASSUME CS:CODE,DS:DATA
    BEG:   
           MOV    AX,DATA
           MOV    DS,AX
           CALL   I8255A
           MOV    AH,9
           MOV    DX,OFFSET MESG
           INT    21H
    SCAN:  
           MOV    AH,1
           INT    16H
           JNZ    RETURN
           MOV    DX,212H
           IN     AL,DX
           TEST   AL,2
           JZ     SCAN
           MOV    DX,211H
           IN     AL,DX
           AND    AL,07H
           MOV    BX,OFFSET TAB
           MOV    AH,0
           MOV    SI,AX
           MOV    AL,[BX+SI]
           MOV    DX,210H
           OUT    DX,AL
           JMP    SCAN
    RETURN:
           MOV    AH,4CH
           INT    21H

I8255A PROC
           MOV    DX,213H
           MOV    AL,86H
           OUT    DX,AL
           MOV    AL,04H
           OUT    DX,AL
           MOV    DX,210H
           MOV    AL,0FFH
           OUT    DX,AL
           RET
I8255A ENDP

CODE ENDS
END BEG