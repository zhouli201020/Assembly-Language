;把键盘输入的一位十进制数(0～9),转换成等值二进数显示

.586

DATA SEGMENT USE16
      MESG1 DB 'Please Enter!',0DH,0AH,'$'
      MESG2 DB '-----Error!$'
DATA ENDS

CODE SEGMENT USE16
              ASSUME CS:CODE,DS:DATA
      BEG:    
              MOV    AX,DATA
              MOV    DS,AX
      LAST:   
              MOV    AH,9
              MOV    DX,OFFSET MESG1
              INT    21H                  ;显示操作提示信息MESG1
      INPUT:  
              MOV    AH,1
              INT    21H                  ;等待键入(有回显)
              CMP    AL,3AH
              JNC    ERROR                ;>9则输出错误信息
              CMP    AL,30H
              JC     ERROR                ;<0则输出错误信息
              SUB    AL,30H
              MOV    BL,AL                ;此时BL为0~9的二进制数
      DISPEQU:
              MOV    AH,2
              MOV    DL,'='
              INT    21H

              CALL   DISP                 ;调用DISP子程序用于显示BL中的二进制数
      DISPB:  
              MOV    AH,2
              MOV    DL,'B'
              INT    21H
              JMP    EXIT
      ERROR:  
              MOV    AH,9
              LEA    DX,MESG2
              INT    21H                  ;显示错误信息
              JMP    LAST
      EXIT:   
              MOV    AH,4CH
              INT    21H
      ;--------------------------------------------------
DISP PROC
              MOV    CX,8
      LAST1:  
              MOV    DL,'0'
              RCL    BL,1
              JNC    NEXT
              MOV    DL,'1'
      NEXT:   
              MOV    AH,2
              INT    21H
              LOOP   LAST1
              RET
DISP ENDP

CODE ENDS
END BEG