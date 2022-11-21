;实验指导书例6.1
;编程实现将8243/8253的定时器0设为工作方式3（方波方式）
;从发光二极管观察计数器的输出
.MODEL SMALL
.586
CODE SEGMENT USE16
             ASSUME CS:CODE
    BEG:     
             JMP    START
    CCONPORT EQU    213H           ;控制口地址
    CCONBIT1 EQU    00010110B      ;0号计数器初始化控制字
    CDPORT1  EQU    210H           ;0号计数器口地址
    CHDBIT1  EQU    00H            ;计数器初值为0，实际计数值为65536
    START:   
             NOP                   ;启动延时
             MOV    DX,CCONPORT    ;写入控制字（计数器0）
             MOV    AL,CCONBIT1
             OUT    DX,AL
             MOV    DX,CDPORT1     ;写入初值（计数器0）
             MOV    AL,CHDBIT1
             OUT    DX,AL
    WT:      
             NOP
             JMP    WT
CODE ENDS
END BEG