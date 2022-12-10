;FILENAME:103_2.ASM
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
            CLI
            CALL   I8255A
            CALL   WRITE0A
            CALL   I8259
            MOV    AH,9
            MOV    DX,OFFSET MESG
            INT    21H
            STI
    SCAN:   
            MOV    AH,1
            INT    21H
            JZ     SCAN
            IN     AL,0A1H
            OR     AL,00000010B
            OUT    0A1H,AL
            MOV    AH,4CH
            INT    21H

SERVICE PROC
            PUSH   AX
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            MOV    DX,211H
            IN     AL,DX
            AND    AL,07H
            MOV    BX,OFFSET TAB
            MOV    AH,0
            MOV    SI,AX
            MOV    AL,[BX+SI]
            MOV    DX,210H
            OUT    DX,AL
            MOV    AL,20H
            OUT    20H,AL
            POP    DS
            POP    AX
            IRET
SERVICE ENDP

I8255A PROC
            MOV    DX,213H
            MOV    AL,86H
            OUT    DX,AL
            MOV    AL,05H
            OUT    DX,AL
            MOV    DX,210H
            MOV    AL,0FFH
            OUT    DX,AL
            RET
I8255A ENDP

WRITE0A PROC
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET SERVICE
            MOV    AX,250AH
            INT    21H
            POP    DS
            RET
WRITE0A ENDP

I8259 PROC
            IN     AL,21H
            AND    AL,11111011B
            OUT    21H,AL
            IN     AL,0A1H
            AND    AL,11111101B
            OUT    0A1H,AL
            RET
I8259 ENDP

CODE ENDS
END BEG