;某科室9人，统计月收入在2000-4000的人数，并用十进制数显示统计结果

.586

DATA SEGMENT USE16
     NUM  DW 1000,23232,2300,4895,2999,1299,8769,4545,9990
DATA ENDS

CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA
     BEG: MOV    AX,DATA
          MOV    DS,AX
     
     INIT:MOV    BX,OFFSET NUM
          MOV    CX,9
          MOV    DL,0                   ;DL存放统计人数(后续调用DOS2号功能显示字符，入口参数为DL)

     LAST:CMP    WORD PTR [BX],2000
          JC     NEXT                   ;<2000转到NEXT指令
          CMP    WORD PTR [BX],4000
          JA     NEXT                   ;>4000转到NEXT指令
          INC    DL                     ;只有收入在2000-4000之间时才将人数加1

     NEXT:INC    BX
          INC    BX
          LOOP   LAST
     
     DISP:ADD    DL,30H
          MOV    AH,2                   ;DOS2号功能显示字符
          INT    21H
     
     EXIT:MOV    AH,4CH
          INT    21H
CODE ENDS
END BEG