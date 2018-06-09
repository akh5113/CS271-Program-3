TITLE  Program 3    (Program3.asm)

; Author: Anne Harris	harranne@oregonstate.edu
; Course / Project ID: CS 271-400 / Program 3                 Date: 2/11/2018
; Description: Greet a user and get their name, have the user enter negative integers
;	between -100 and -1 until they'd like to stop, then calculate the sum and rounded average

INCLUDE Irvine32.inc

;constant, lowest number limit
LOW_LIM = -100

.data
;inital messages
prgm_title	BYTE	"Integer Accumulator by Anne Harris",0
greeting	BYTE	"Please tell me your name ",0
hello		BYTE	"Nice to meet you, ",0
instruction	BYTE	"Please enter numbers from -100 to -1, enter a ",0dh,0ah
			BYTE	"non-negative number when you are finished. I will",0dh,0ah
			BYTE	"tell you the sum and average of your entered numbers",0
enterPrompt	BYTE	"Enter Number: ",0
invalid		BYTE	"Invalid number, please enter a number [-100, -1] or a non-negative",0dh,0ah
			BYTE	"number to end the program",0
inputHelp	BYTE	"> ",0
extra		BYTE	"**EC: 1. Number the lines during user input",0

;summary messages
noNums		BYTE	"You didn't enter any valid numbers",0
endTotal1	BYTE	"You entered ",0
endTotal2	BYTE	" valid numbers.",0
endSum		BYTE	"The sum of your vaid numbers is ",0
endAvg		BYTE	"The rounded average of your valid numbers is ",0
goodbye		BYTE	"Thanks for playing the Integer Accumulator! Have a great day, ",0

;variables
userName	BYTE	33 DUP(0)	;user name
userNum		SDWORD	?			;user entered signed integers
count		DWORD	0			;number of vaid user enteries
sumNums		SDWORD	0			;sum of valid enteries (signed int)
average		SDWORD	?			;average of valid enteries
inputCount	DWORD	1			;user input count (for extra credit)


.code
main PROC

;display program title and programmers name
	mov		edx, OFFSET prgm_title
	call	WriteString
	call	Crlf
	mov		edx, OFFSET extra
	call	WriteString
	call	Crlf
	call	Crlf

;get users name, greet user
	mov		edx, OFFSET greeting
	call	WriteString
	call	Crlf
	mov		eax, inputCount
	call	WriteDec
	mov		edx, OFFSET inputHelp
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf
	call	Crlf

;display instructions
	mov		edx, OFFSET instruction
	call	WriteString
	call	Crlf

;prompt user to get number
prompt:
	mov		eax, inputCount
	inc		eax
	call	WriteDec
	mov		inputCount, eax
	mov		edx, OFFSET inputHelp
	call	WriteString
	mov		edx, OFFSET enterPrompt
	call	WriteString
	call	ReadInt
	mov		userNum, eax
	jmp		valLow
;validate input
error_msg:							;display error message and jump back to prompt
	mov		edx, OFFSET invalid
	call	WriteString
	call	Crlf
	jmp		prompt
;validate number is greater than or equal to -100
valLow:		
	mov		eax, userNum
	cmp		eax, LOW_LIM
	jl		error_msg
;validate that the number is not a postive number
;if it is jump to the summary lines
valHigh:
	;move user num in to register to do math to set the sign flag
	mov		eax, userNum
	add		eax, 0
	jns		summarize		;if sign flag is not set jump to the summary

;calculate sum and count
calcs:
	;increase count
	mov		eax, count
	inc		eax
	mov		count, eax
	;calculate sum
	mov		eax, sumNums
	add		eax, userNum
	mov		sumNums, eax
	jmp		prompt

;calculate average
summarize:
	;check to see if no numbers were entered
	mov		eax, count
	cmp		eax, 0
	je		noInput
	;if count is greater than 0 continue with calculations
	mov		eax, sumNums
	cdq
	mov		ebx, count
	idiv	ebx
	;compare the remainder to 5
	
	cmp		edx, 5
	jg		round
	;if no rounding up is needed, continue to display
	mov		average, eax
	jmp		display

;round the average if needed
round:
	dec		eax
	mov		average, eax

;display results
display:
	;display text
	mov		edx, OFFSET endTotal1
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET endTotal2
	call	WriteString
	call	Crlf

	;display sum
	mov		edx, OFFSET endSum
	call	WriteString
	mov		eax, sumNums
	call	WriteInt
	call	Crlf

	;display average
	mov		edx, OFFSET endAvg
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	Crlf
	jmp		gbMsg

;message for if no valid input was added
noInput:
	mov		edx, OFFSET noNums
	call	WriteString
	call	Crlf

;goodbye message
gbMsg:
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

END main
