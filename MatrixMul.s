/*
push a register to the stack
parameters:  register, the register to be pushed onto the stack
precondition: none
postcondition: passed in registers value is added to the stack and the stack pointer is pointing to it
return:    n/a
citation: This macro is from the CS12 Macros assignment at SRJC written by John Stuart
*/
.macro push register
    str \register, [sp, #-16]!  // store the value in the memory location pointed to by sp and decrement by 16
.endm


/*
pop a register from the stack
parameters:  register, the register to be popped from the stack
precondition: the value has been pushed into the stack
postcondition: the passed in registers value copied from the stack and the stack pointer is pointing the next value on the stack
return:    n/a
citation: This macro is from the CS12 Macros assignment at SRJC written by John Stuart
*/
.macro pop register
    ldr \register, [sp], #16  // load the value in the memory location pointed to by sp and increment by 16
.endm


/*
cout, print an asciz string
parameters: string, the string to print
			stringSize, the size of the string to print
precondition: none 
postcondition: the string has been printed to stdout
return: none
*/
.MACRO cout str strSize
	push X0             
	push X1
	push X2
	push X8

	mov x0, #0           
	ldr x1, =\str      
	ldr x2, =\strSize   
	mov x8, #64           
	svc 0     

	pop X8                
	pop X2
	pop X1
	pop X0
.ENDM


.data  // start of the data segment

intro:
	.asciz "This program computes the matrix product of two 4x4 matrices entered by the user.\n"
introSize = .-intro

instruction:
	.asciz "Instructions:\nAll user entires must be non-negative integers less than 65535.\nNote: if an entry in the matrix product is greater than 65535 it will not be reported accurately.\n"
instructionSize = .-instruction

instruction2:
	.asciz "Input the matrices column by column with spaces between each entry, pressing enter after each column.\n\nFor example, user input of:\n1 2 3 4\n5 6 7 8\n9 10 11 12\n13 14 15 16\n\nwill produce the matrix:\n1 5 9 13\n2 6 10 14\n3 7 11 15\n4 8 12 16\n"
instruction2Size = .-instruction2

promptA: 
	.asciz "Please enter all entries of 4x4 matrix A:\n"
promptASize = .-promptA

displayA: 
	.asciz "A =\n"
displayASize = .-displayA

promptB: 
	.asciz "Please enter all entries of 4x4 matrix B:\n"
promptBSize = .-promptB

displayB: 
	.asciz "B =\n"
displayBSize = .-displayB

displayC: 
	.asciz "A*B = C = \n"
displayCSize = .-displayC

newLine: 
	.asciz "\n"
newLineSize = .-newLine

A: 	.fill 16, 2, 0
	
B: 	.fill 16, 2, 0
	
C:	.fill 16, 2, 0
	

.text  // start o the text segment (Code)

.global main // Linux Standard _start, similar to main in C/C++ 
main:

cout intro introSize
cout newLine newLineSize
cout instruction instructionSize
cout instruction2 instruction2Size
cout newLine newLineSize

cout promptA promptASize           

ldr x0, =A
push x0
bl populateMatrix
pop x0

cout displayA displayASize           

ldr x0, =A
push x0
bl printMatrix
pop x0

cout newLine newLineSize
cout promptB promptBSize  

ldr x0, =B
push x0
bl populateMatrix
pop x0

cout displayB displayBSize  

ldr x0, =B
push x0
bl printMatrix
pop x0

cout newLine newLineSize

//compute matrix product
ldr x0, =A
ldr x1, =B
ldr x2, =C
push x0
push x1
push x2
bl multiplyMatrices
pop x2
pop x1
pop x0

cout displayC displayCSize  

ldr x0, =C
push x0
bl printMatrix
pop x0

cout newLine newLineSize


// Exit to the OS, essentially this code does this in c
// return 0;
mov x0, #0          // return value
mov x8, #93         // Service call code
svc 0               // Linux service call






