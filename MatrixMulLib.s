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



.data  // start of the data segment

row1: .short 0
row2: .short 0
row3: .short 0
row4: .short 0

rfrmt: .asciz "%5hu  %5hu  %5hu  %5hu"
          .align 4
          
pfrmt: .asciz "%5d  %5d  %5d  %5d\n"
          .align 4


.text  // start of the text segment (Code)

// declare the globally available functions here
.globl populateMatrix
.globl printMatrix
.globl multiplyMatrices

/*
populateMatrix
parameters:     X0,     address of matrix to load entries into
precondition:   the matrix exists and has space allocated for 16 short unsigned int entries
postcondition:  user entered values will be stored in the square matrix in X0
return:         N/A, no return value is defined 
*/
populateMatrix:
        push lr
        push x20
        push x21
                                                                                                            
        mov x20, #4
        mov x21, x0 
        
        readLoop:
        //load parameters for scanf
        ldr x0, =rfrmt
        ldr x1, =row1
        ldr x2, =row2
        ldr x3, =row3
        ldr x4, =row4
        
        //call scanf
        push x0
        push x1
        push x2
        push x3
        push x4
        bl scanf
        pop x4
        pop x3
        pop x2
        pop x1
        pop x0
        
        //load results from arguments
        ldrh w1, [x1]
        ldrh w2, [x2]
        ldrh w3, [x3]
        ldrh w4, [x4]
        
        //store results into array A
        strh w1, [x21], #2
        strh w2, [x21], #2
        strh w3, [x21], #2
        strh w4, [x21], #2
        
        sub w20, w20, #1
        cmp x20, 0
        b.ne readLoop

        pop x21
        pop x20
        pop lr
        
ret


/*
printMatrix 
parameters:     X0,     address of matrix
precondition:   the matrix exists and contains 16 short unsigned int entries
postcondition:  the text will be printed to stdout based on the size values 
return:         N/A, no return value is defined 
*/
printMatrix:
        push lr
        push x20
        push x21
                                                                                                            
        mov x20, #4
        mov x21, x0 
        
        printLoop:
        ldr x0, =pfrmt
        ldrh w1, [x21], #2
        ldrh w2, [x21, #6]
        ldrh w3, [x21, #14]
        ldrh w4, [x21, #22]
        bl printf
        sub w20, w20, #1
        cmp x20, 0
        b.ne printLoop
        
        pop x21
        pop x20
        pop lr
        
ret

/*
multiplyMatrices 
parameters:     X0,     address of matrix A
                X1,     address of matrix B
                X2,     address of matrix C
precondition:   all three matrices exist and contain 16 short unsigned int entries
postcondition:  matrix C is populated with the entries of the matrix product A*B
return:         N/A, no return value is defined 
citation:       This function is based on Listing 13-4 in Chapter 13 of 
                Programming with 64-Bit ARM Assembly Language by Stephen Smith
*/
multiplyMatrices:
        push lr
        
        //load matrix A into neon registers by column
        ldp d0, d1, [x0], #16
        ldp d2, d3, [x0]
        
        //load matrix B into neon registers by column
        ldp d4, d5, [x1], #16
        ldp d6, d7, [x1]
        
        .macro mulcol ccol bcol
                mul \ccol\().4H, v0.4H, \bcol\().4H[0]
                mla \ccol\().4H, v1.4H, \bcol\().4H[1]
                mla \ccol\().4H, v2.4H, \bcol\().4H[2]
                mla \ccol\().4H, v3.4H, \bcol\().4H[3]
        .endm
        
        mulcol v8, v4
        mulcol v9, v5
        mulcol v10, v6
        mulcol v11, v7
        
        stp d8, d9, [x2], #16
        stp d10, d11, [x2]
        
        pop lr
ret
