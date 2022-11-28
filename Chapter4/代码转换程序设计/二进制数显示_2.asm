;键盘输入的一位十六进制ASCII码→二进制数显示
;显示的格式要求如下：
;Please Enter：A=00001010B

.586

DATA SEGMENT USE16
    MESG DB 'Please Enter!',0DH,0AH,'$'
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    BEG:    
            MOV    AX,DATA
            MOV    DS,AX
    PROMPT:                           ;显示操作提示信息
            MOV    AH,9
            MOV    DX,OFFSET MESG
            INT    21H
    INPUT:  
            MOV    AH,1
            INT    21H
            CMP    AL,3AH
            JC     NEXT
            SUB    AL,7H
    NEXT:   
            SUB    AL,30H
            MOV    BL,AL              ;此处将AL移入BL是为了保护AL的数据（因为之后调用DOS2号功能会破坏AL中的内容）
    DISPEQU:                          ;显示等号＝
            MOV    AH,2
            MOV    DL,'='
            INT    21H
            CALL   DISP
    DISPB:                            ;显示B
            MOV    AH,2
            MOV    DL,'B'
            INT    21H
    EXIT:   
            MOV    AH,4CH
            INT    21H
    ;-------------------------------------
DISP PROC
            MOV    CX,8
    LAST:   
            MOV    DL,'0'
            RCL    BL,1
            JNC    NEXT1
            MOV    DL,'1'
    NEXT1:  
            MOV    AH,2
            INT    21H
            LOOP   LAST
            RET
DISP ENDP

CODE ENDS
END BEG