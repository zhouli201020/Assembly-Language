;FILENAME:EXA114.ASM
.486
DATA SEGMENT USE16
    MESG    DB 'HELLO!',0DH,0AH,'$'
    ICOUNT1 DB 200
    ICOUNT2 DB 11
    COUNT   DB 10
    OLD08   DD ?
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
            CLI
            CALL   I8254
            CALL   READ08
            CALL   WRITE08
            STI
    SCAN:   
            CMP    COUNT,0
            JNZ    SCAN
            CLI
            CALL   RESET
            STI
            MOV    AH,4CH
            INT    21H
            
SERVICE PROC
            PUSHA
            PUSH   DS
            DEC    ICOUNT1
            JNZ    NEXT
            MOV    ICOUNT1,200
            DEC    COUNT
            MOV    AH,9
            MOV    DX,OFFSET MESG
            INT    21H
    NEXT:   
            DEC    ICOUNT2
            JNZ    EXIT
            MOV    ICOUNT2,11
            POP    DS
            POPA
            JMP    OLD08
    EXIT:   
            MOV    AL,20H
            OUT    20H,AL
            POP    DS
            POPA
            IRET
SERVICE ENDP

READ08 PROC
            MOV    AX,3508H
            INT    21H
            MOV    WORD PTR OLD08,BX
            MOV    WORD PTR OLD08+2,ES
            RET
READ08 ENDP

WRITE08 PROC
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET SERVICE
            MOV    AX,2508H
            INT    21H
            POP    DS
            RET
WRITE08 ENDP

I8254 PROC
            MOV    AL,00110110B
            OUT    43H,AL
            MOV    AX,5966
            OUT    40H,AL
            MOV    AL,AH
            OUT    40H,AL
            RET
I8254 ENDP

RESET PROC
            MOV    DX,WORD PTR OLD08
            MOV    DS,WORD PTR OLD08+2
            MOV    AX,2508H
            INT    21H
            RET
RESET ENDP

CODE ENDS
END BEG