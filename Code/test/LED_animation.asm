;******************************************************************************
; Copyright (C) 2004-2010 by Eka A. Kurniawan
; eka.a.kurniawan(ta)gmail(tod)com
;
; This program is free software; you can redistribute it and/or modify 
; it under the terms of the GNU General Public License as published by 
; the Free Software Foundation; version 2 of the License.
;
; This program is distributed in the hope that it will be useful, 
; but WITHOUT ANY WARRANTY; without even the implied warranty of 
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License 
; along with this program; if not, write to the 
; Free Software Foundation, Inc., 
; 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;
;
;	File Name : LED_animation.asm
;	LED Animation
;
;	LED total is 16
;	Use interrupt to changing the animation.
;	Main Program : Running LED
;	Interrupt 1 : Stacking LED
;	Interrupt 2 : Sending the setting of switch to RISC Processor
******************************************************************************;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Interrupt Vector Table
DI		  ;; No nested Interrupt.
JMP _declaration: ;; If RESET, restart the program (jump to Declaration Label).
DI
JMP _int1:        ;; Jump to Interrupt 1 program.
DI
JMP _int2:        ;; Jump to Interrupt 2 program.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Main Program
_declaration:
EI			;; Interrupt Enable
ADIU R01, R00, #0001h	;; R01 content of value for 8-bits LED LSB
ADD R06, R00, R00	;; R06 content of value for 8-bits LED MSB
ADIU R02, R00, #8000h	;; R02 left side boundary
ADIU R05, R00, #0001h	;; R05 right side boundary
LUI R03, #0000h		;; R03 Maximum Delay (MaxDelay) = 0000 7FFFh
ADIU R03, R03, #7FFFh

ADIU R07, R00, #0080h	;; R07 is Address that point 8-bits LED LSB
ADIU R08, R00, #0081h	;; R08 is Address that point 8-bits LED MSB

_start:
ADD R04, R00, R00	;; Clear the Delay Counter (R04)

_left_step_print:
SB R07, R01		;; put 8-bits of R01 LSB to LED LSB
SLR R06, R01, #0008h	;; Shift right R01 8 times and put it at R06
SB R08, R06		;; put 8-bits of R06 LSB to LED MSB
ADD R04, R04, R05	;; Increase the Delay Counter
BE R04, R03, _next_1:	;; Jump to _next_1: if Counter = MaxDelay
JMP _left_step_print:	;; else Jump to _left_step_print: label
_next_1:
SLL R01, R01, #0001h	;; Shift the LED to left
BH R01, R02, _right_step_print:	;; jump to _right_step_print: if LED value \
                                ;; bigger than 'left side boundary'.
JMP _start:		;; else Jump to _start: label

_right_step_print:
ADD R04, R00, R00	;; Clear the Delay Counter
SLR R01, R01, #0001h	;; Shift LED to the right
_right_loop:
SB R07, R01		;; Show the LED value
SLR R06, R01, #0008h
SB R08, R06
ADD R04, R04, R05	;; Increase the Delay Counter
BE R04, R03, _next_2:	;; Jump to _next_2: if Counter = MaxDelay
JMP _right_loop:	;; else Jump to _rignt_loop: label
_next_2:
BE R01, R05, _start:	;; jump to _start: label if LED value less than \
			;; 'right side boundary'.
JMP _right_step_print:	;; else Jump to _right_step_print:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Interrupt 1
_int1:
ADIU R11, R00, #0001h	;; R11 running LED
ADIU R13, R00, #8000h	;; R13 left side boundary
ADIU R14, R00, #0001h	;; R14 Content of 1 for increase counter

LUI R15, #0000h		;; R15 Maximum Delay (MaxDelay) = 0000 FFFFh
ADIU R15, R15, #FFFFh

ADIU R22, R00, #002Dh	;; Instruction Address for 'running_loop' label
ADIU R23, R00, #002Eh	;; Instruction Address for 'delay_loop' label

ADIU R24, R00, #0000h	;; R24 content of value for 8-bits LED LSB
ADIU R25, R00, #0000h	;; R25 LED stack
ADIU R26, R00, #0000h	;; R26 content of value for 8-bits LED MSB

_running_loop:
ADD R17, R00, R00	;; R17 Clear Delay Counter

_delay_loop:
OR R24, R25, R11	;; Combine (OR) of Stacking LED with running LED
SB R07, R24		;; Show the LED value
SLR R26, R24, #0008h
SB R08, R26

ADD R17, R17, R14	;; Increase Counter
BE R17, R15, _next_3:	;; Jump to _next_3: if Counter = MaxDelay
JR R23			;; else jump to 'delay_loop' label

_next_3:
BE R31, R11, _next_4:	;; Jump to _next_4: if running LED = Left boundary.
SLL R11, R11, #0001h	;; Shift Left one step the running LED

JR R22			;; else Jump to 'running_loop' label

_next_4:
ADIU R11, R00, #0001h	;; Reset the Running LED
OR R25, R25, R13	;; Stacking process
SLR R13, R13, #0001h	;; Shift to left the right boundary
BE R13, R00, _next_5:	;; Jump to _next_5: if Left Boundary = Zero.
JR R22			;; else Jump to 'running loop'

_next_5:
EI			;; Enable Interrupt
JR R30			;; Interrupt Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Interrupt 2
_int2:
LB R27, R07		;; R27 Data from I/O Modul

LUI R15, #000Fh		;; R15 Maximum Delay (MaxDelay) = 000F FFFFh
ADIU R15, R15, #FFFFh

SB R07, R27		;; Shoe the LED value
ADD R17, R00, R00	;; R17 Delay Counter

_print_loop:
ADI R17, R17, #0001h	;; Increase Counter
BE R17, R15, _next_6:	;; Jump to _next_6: if Counter = MaxDelay
JMP #FFFFFFDh		;; else Jump to 'print_loop' label

_next_6:
EI			;; Enable Interrupt
JR R30			;; Interrupt Return
