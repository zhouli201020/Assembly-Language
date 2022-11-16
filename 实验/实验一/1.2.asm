;FILENAME: EXA131.ASM

.486
DATA SEGMENT  USE16
      SUM  DB ?,?
      MESG DB '25+9='
           DB 0,0,'$'
      N1   DB 9,0F0H       ;N1存放被加数9
      N2   DB 25           ;N2存放加数25
DATA ENDS

CODE SEGMENT	USE16
            ASSUME CS:CODE,DS:DATA
      BEG:  MOV    AX,DATA
            MOV    DS,AX                ;DS初始化
            MOV    BX,OFFSET SUM        ;SUM串首地址→BX
            MOV    AH,N1
            MOV    AL,N2
            ADD    AH,AL                ;进行25+9的运算并将结果存入AH中
            MOV    [BX],AH              ;将相加后的结果34存入SUM首地址单元中
            CALL   CHANG                ;子程序调用
            MOV    AH,9                 ;DOS9号功能调用，在屏幕上显示一个字符串
            MOV    DX,OFFSET MESG       ;MESG串首地址→DX
            INT    21H
            MOV    AH,4CH               ;返回DOS
            INT    21H
CHANG PROC
      LAST: CMP    [BX],10              ;判断SUM是否>10
            JC     NEXT                 ;如果<10则跳转
            SUB    [BX],10              ;否则将SUM-10
            INC    BYTE PTR[BX+7]      ;BX+7单元增1（最后存放的就是结果的十位上的数字3，同时SUM等于个位上的数字4）
            JMP    LAST                 ;继续进行上面的判断

      NEXT: MOV    AL,SUM
            MOV    [BX+8],AL            ;将个位数字存入BX+8单元
            ADD    [BX+7],30H           ;将数字转化为对应的ASCII码
            ADD    [BX+8],30H
            RET
CHANG ENDP
CODE ENDS
		END	BEG