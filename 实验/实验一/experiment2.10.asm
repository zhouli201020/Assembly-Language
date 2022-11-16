;从数据段NUM单元开始存有9个有符号数，编写一个程序实现：
;找出最小值存放到数据段MIN单元，并将负数的个数以十进制数的形式显示在屏幕上。
;最小值显示出来 MIN=-25

.586

DATA SEGMENT USE16
        MESG DB 0DH,0AH,'MIN=','$'
        NUM  DB 12,5,-25,9,-2,35,-18,0,-9
        MIN  DB ?
        
DATA ENDS

CODE SEGMENT USE16
                ASSUME CS:CODE,DS:DATA
        START:  
                MOV    AX,DATA
                MOV    DS,AX
                MOV    SI,OFFSET NUM          ;NUM串首偏移地址→SI
                MOV    CX,9                   ;循环计数用
                MOV    DL,0                   ;DL存放负数的个数
                MOV    AL,[SI]                ;AL存放最小值（假设第一个数就是最小的）
        LAST:   
                CMP    [SI],AL                ;AL依次和这些数比较大小
                JGE    NEXT                   ;如果AL比其他数小则跳转到NEXT
                MOV    AL,[SI]                ;否则将AL更新为较小的数
        NEXT:   
                CMP    [SI],0                 ;判断当前的数是否小于0
                JGE    NEXT1                  ;如果不小于0则跳转
                INC    DL                     ;否则将负数数量增1
        NEXT1:  
                INC    SI                     ;NUM串首偏移地址增1
                LOOP   LAST                   ;继续循环
                MOV    MIN,AL                 ;循环结束后，将最小值AL放置在MIN单元
        DISPNUM:
                ADD    DL,30H                 ;将负数的个数DL转化为相应的ASCII码
                MOV    AH,2                   ;调用DOS2号功能显示负数的个数DL
                INT    21H
        DISPMIN:
                MOV    AH,9                   ;显示提示信息"MIN="
                MOV    DX,OFFSET MESG
                INT    21H

                CMP    MIN,0                  ;判断最小值是否小于0
                JGE    AGAIN                  ;如果大于0跳转
                MOV    AH,02H                 ;否则先输出负号(-)
                MOV    DL,2DH
                INT    21H
                NEG    MIN                    ;同时将最小值取反，得到其绝对值
                MOV    AX,WORD PTR MIN        ;将最小值送入AX寄存器中，以便后面AX作为被除数运算
                MOV    BX,10                  ;BX寄存器存放除数10
                MOV    CX,0                   ;判断最小值是几位数
        WORDDIV:
                MOV    DX,0
                DIV    BX                     ;进行字除法，默认商送入寄存器AX中，余数送入DX寄存器中
                PUSH   DX                     ;将余数DX压入堆栈
                INC    CX                     ;位数加1
                CMP    AX,0                   ;判断商是否为0
                JNZ    WORDDIV                ;商不为0则继续进行除法
        AGAIN:  
                POP    DX                     ;将余数DX从堆栈中弹出
                ADD    DL,30H                 ;将余数转换为对应的ASCII码
                MOV    AH,2                   ;调用DOS2号功能显示余数（即最小值AL的每一位）
                INT    21H
                LOOP   AGAIN
        EXIT:   
                MOV    AH,4CH
                INT    21H
CODE ENDS
END START