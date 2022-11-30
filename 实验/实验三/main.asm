;采用8254的3个计数器分别对发光二级管进行控制，要求发光二级管的亮灭各不相同，达到流光效果
.MODEL SMALL
.486
CODE SEGMENT USE16
             ASSUME CS:CODE
    BEG:     
             JMP    START
    CCONPORT EQU    213H           ;控制口地址
    CCONBIT1 EQU    00010110B      ;0号计数器初始化控制字
    CCONBIT2 EQU    01010110B      ;1号计数器初始化控制字
    CCONBIT3 EQU    10010110B      ;2号计数器初始化控制字
    CDPORT1  EQU    210H           ;0号计数器口地址
    CDPORT2  EQU    211H           ;1号计数器口地址
    CDPORT3  EQU    212H           ;2号计数器口地址
    CHDBIT1  EQU    00H            ;0号计数器初值——100kHz/65536=1.5Hz
    CHDBIT2  EQU    250            ;1号计数器初值——10kHz/250=40Hz
    CHDBIT3  EQU    100            ;2号计数器初值——1kHz/100=10Hz
    START:   
             NOP                   ;启动延时

             MOV    DX,CCONPORT
             MOV    AL,CCONBIT1
             OUT    DX,AL
             MOV    AL,CHDBIT1
             MOV    DX,CDPORT1
             OUT    DX,AL

             MOV    DX,CCONPORT
             MOV    AL,CCONBIT2
             OUT    DX,AL
             MOV    AL,CHDBIT2
             MOV    DX,CDPORT2
             OUT    DX,AL

             MOV    DX,CCONPORT
             MOV    AL,CCONBIT3
             OUT    DX,AL
             MOV    AL,CHDBIT3
             MOV    DX,CDPORT3
             OUT    DX,AL

    WT:      
             NOP
             JMP    WT
CODE ENDS
END BEG