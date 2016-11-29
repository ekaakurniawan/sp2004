DI
JMP _declaration:
DI
JMP _int1:
DI
JMP _int2:
_declaration:
EI
ADIU R01, R00, #0001h
ADD R06, R00, R00
ADIU R02, R00, #8000h
ADIU R05, R00, #0001h
LUI R03, #0000h
ADIU R03, R03, #7FFFh
ADIU R07, R00, #0080h
ADIU R08, R00, #0081h
_start:
ADD R04, R00, R00
_left_step_print:
SB R07, R01
SLR R06, R01, #0008h
SB R08, R06
ADD R04, R04, R05
BE R04, R03, _next_1:
JMP _left_step_print:
_next_1:
SLL R01, R01, #0001h
BH R01, R02, _right_step_print:
JMP _start:
_right_step_print:
ADD R04, R00, R00
SLR R01, R01, #0001h
_right_loop:
SB R07, R01
SLR R06, R01, #0008h
SB R08, R06
ADD R04, R04, R05
BE R04, R03, _next_2:
JMP _right_loop:
_next_2:
BE R01, R05, _start:
JMP _right_step_print:
_int1:
ADIU R11, R00, #0001h
ADIU R13, R00, #8000h
ADIU R14, R00, #0001h
LUI R15, #0000h
ADIU R15, R15, #FFFFh
ADIU R22, R00, #002Dh
ADIU R23, R00, #002Eh
ADIU R24, R00, #0000h
ADIU R25, R00, #0000h
ADIU R26, R00, #0000h
_running_loop:
ADD R17, R00, R00
_delay_loop:
OR R24, R25, R11
SB R07, R24
SLR R26, R24, #0008h
SB R08, R26
ADD R17, R17, R14
BE R17, R15, _next_3:
JR R23
_next_3:
BE R13, R11, _next_4:
SLL R11, R11, #0001h
JR R22
_next_4:
ADIU R11, R00, #0001h
OR R25, R25, R13
SLR R13, R13, #0001h
BE R13, R14, _next_5:
JR R22
_next_5:
EI
JR R30
_int2:
LB R27, R07
LUI R15, #000Fh
ADIU R15, R15, #FFFFh
SB R07, R27
ADD R17, R00, R00
_print_loop:
ADI R17, R17, #0001h
BE R17, R15, _next_6:
JMP _print_loop:
_next_6:
EI
JR R30
