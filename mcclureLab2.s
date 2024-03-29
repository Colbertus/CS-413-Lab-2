@ File: mcclureLab2.s 

@ Author: Colby McClure

@ Email: ctm0026@uah.edu

@ CS 413-01 Spring 2024

@ Purpose: implemented a simple four function integer calculator using Assembly

@ The comments below are to assemble, link, run, and debug the program
@ as -o mcclureLab2.o mcclureLab2.s
@ gcc -o mcclureLab2 mcclureLab2.o 
@ ./mcclureLab2
@ gdb --args ./mcclureLab2

@ Registers and their uses: 
@ r4: Operand 1 for the input 
@ r5: Operand 2 for the input 
@ r6: Operand 1 for the subroutine 
@ r7: Operand 2 for the subroutine 
@ r8: Used to push the result of the operation 
@ r9: Used to pop the result of the operation for printing 
@ r10: Used for storing the operand choice that the user desires/Used to pop the remainder for division  
@ r11: Used as a flag in case an overflow occured
@ 

.equ READERROR, 0
.global main 
.text

main: 

@ This label prints out the welcoming message and asks the user to choose which operation to use 
@**********
beginPrompt: 
@**********

    ldr r0, =prompt @ Load the welcome message
    bl printf @ Print the welcome message 

    ldr r0, =options @ Load the options message
    bl printf @ Print the operation options 

@ This label is for receiving the user input for what operation and checking to make sure its valid 
@**********
optionCheck:
@**********

    ldr r0, =numInputPattern @ Load the integer input pattern
    ldr r1, =input @ Load the input variable 
    bl scanf @ Scan for input 
    cmp r0, #READERROR @ Compare r0 to the variable READERROR
    beq readError @ Branch to readError if equal 

    ldr r1, =input @ Load r1 with the address of the input  
    ldr r10, [r1] @ Load r10 with the contents of the input 
    cmp r10, #4 @ Compare r1 with 4
    bgt beginPrompt @ Loop back to the beginning if r1 is greater than 4
    cmp r10, #1 @ Compare r1 with 1
    blt beginPrompt @ Loop back to the beginning if r1 is less than 1 
    b operandCheck @ Branch to the next label if everything checks out 

@ This label will take the operands in as input and check for validity 
@**********
operandCheck:
@**********

    ldr r0, =numPrompt @ Load the operand instruction message 
    bl printf @ Print the message 
    
    ldr r0, =numInputPattern @ Load the integer input pattern 
    ldr r1, =input @ Load the input variable 
    bl scanf @ Scan for input 

    ldr r1, =input @ Load r1 with the address of the input 
    ldr r4, [r1] @ Load r4 with the contents of the input 

    cmp r4, #0 @ Compare the contents of r4 with 1
    blt operandCheck @ If r4 is less than 1, then loop back to operandCheck 

    ldr r0, =numInputPattern @ Load the integer input pattern 
    ldr r1, =input @ Load the input variable 
    bl scanf @ Scan for input 

    ldr r1, =input @ Load r1 with the address of the input 
    ldr r5, [r1] @ Load r5 with the contents of the input 

    cmp r5, #0 @ Compare the contents of r5 with 1
    blt operandCheck @ If r5 is less than 1, then loop back to operandCheck

    cmp r5, #0 @ Compare the contents of r5 with 1
    beq divValid @ If r5 equals 0, then branch to the label that checks if the operation is division

    b operationCall  @ Branch to the operationCall label by default if there are no errors 

@ This label checks if the operation is division if the second operand is 0
@**********
divValid:
@**********

    cmp r10, #4 @ Compare r10 to 4 in case the current operation is division
    beq notValid @ Branch to the error message label if the operation is division
    b operationCall @ If division is not the operation then proceed 

@ This label is in case the operation is division and the divisor is a 0
@**********
notValid:
@**********

    ldr r0, =divideError @ Load r0 with the rejection message 
    bl printf @ Print the error message 
    b beginPrompt @ Branch back to the beginning of the program 
    

@ This branch checks and sees what subroutine is needed for what operation based on what the user input 
@**********
operationCall:
@**********

    push {r4, r5} @ Push the operands onto the stack 

    cmp r10, #1 @ Check to see if the user wanted to add
    bleq addRoutine @ Branch to subroutine if that's what user wanted 

    cmp r10, #2 @ Check to see if the user wanted to subtract 
    bleq subRoutine @ Branch to subroutine if that's what user wanted 

    cmp r10, #3 @ Check to see if user wanted to multiply 
    bleq mulRoutine @ Branch to subroutine if that's what user wanted 

    cmp r10, #4 @ Check to see if user wanted to divide 
    bleq divRoutine @ Branch to subroutine if that's what user wanted 

    b opResult @ Branch to the label that will print out the operation result

@ This label is for outputting the result of the operation
@**********
opResult: 
@**********
    cmp r10, #4 @ Compare r10 to 4 
    beq opResultDiv @ If equal then that means that the remainder also needs to be printed 
    cmp r11, #1 @ Compare r11 to 1 
    beq overflow @ Branch to overflow label if the overflow flag (r11) is set to 1 

@ This label is for executing the division loop 
@**********
opResult2:
@**********

    pop {r9} @ Pop the result of the operation into r9
    ldr r0, =result @ Load r0 with the result prompt
    mov r1, r9 @ Move the result into r1 for printing 
    bl printf @ Print the result 
    b choice @ Branch to the choice label 

@ This branch is for displaying the the results of the division operattion
@**********
opResultDiv:
@**********

    pop {r9, r10} @ Pop the answer and remainder into r9 and r10
    ldr r0, =result @ Load r0 with the results message 
    mov r1, r10 @ Move the result into r1 for printing 
    bl printf @ Print the result 

    ldr r0, =remainder @ Load r0 with the remainder message
    mov r1, r9 @ Move the remainder into r1 
    bl printf @ Print the remainder message along with the remainder 
    b choice @ Branch to the choice label 

@ This branch is in case the user wants to perform another operation or wants to exit the program
@**********
choice: 
@**********
    ldr r0, =tryAgain @ Load the prompt that asks the user if they want to try again 
    bl printf @ Print the message
    ldr r0, =options2 @ Load the options that the user has 
    bl printf @ Print the message 

    ldr r0, =numInputPattern @ Load r0 with the integer input pattern
    ldr r1, =input @ Load the input variable into r1
    bl scanf @ Scan for input 
    
    ldr r1, =input @ Reload r1 with the address for the input
    ldr r1, [r1] @ Load r1 with the contents of the addresss
    cmp r1, #1 @ Compare the contents of r1 with 1
    beq beginPrompt @ If equal that means user wants to perform another calculation
    cmp r1, #2 @ Compare the contents of r2 with 2
    beq exit @ If equal that means the user does not want to perform another calculation
    b exit @ If the user doesn't enter a 1 or 2 then exit the program 

@ This subroutine is for performing the addition operation for the two operands 
@**********
addRoutine:
@**********

    pop {r6, r7} @ Pop the operands into r6 and r7
    adds r8, r6, r7 @ Add r6 and r7 and store it in r8 
    movvs r11, #1 @ Set the flag in r11 if overflow occurred 
    push {r8} @ Push the result onto the stack 
    mov pc, lr @ Transfer the return address to the program counter

@ This subroutine is for subtraction 
@**********
subRoutine:
@**********
    pop {r6, r7} @ Pop the operands into r6 and r7
    subs r8, r6, r7 @ Subtract r6 and r7 and store it in r8
    push {r8} @ Push the result onto the stack
    mov pc, lr @ Transfer the return address to the program counter

@ This is the subroutine for multiplication
@**********
mulRoutine:
@**********

    pop {r6, r7} @ Pop the operands into r6 and r7
    umull r8, r1, r6, r7 @ Multiply r6 and r7 and store it in r8
    cmp r1, #0 @ Compare r1 to 0 to check for overflow 
    movne r11, #1 @ Check for overflow by using r11 as a flag for overflow 
    push {r8} @ Push the result onto the stack
    mov pc, lr @ Transfer the return address to the program counter

@ This label is the beginning of the division routine 
@**********
divRoutine: 
@**********
    pop {r6, r7} @ Pop the operands into r6 and r7
    mov r8, #0 @ Set the counter in r8 

    cmp r6, r7 @ Compare r6 and r7 
    bgt divRoutine2 @ If r6 is greater than branch to the loop 

    cmp r6, r7 @ Compare r6 and r7 
    movlt r8, #0 @ If r6 is less than r7, then move 0 to r8 

    cmp r6, r7 @ Compare r6 and r7 
    blt divRoutine3 @ If r6 is less than r7 then branch to the end of the division 
    
    cmp r6, r7 @ Compare r6 and r7 
    moveq r6, #0 @ If they are equal then set r6 equal to 0 
    
    mov r8, #1 @ Set r8 equal to 1
    b divRoutine3 @ Branch to the end of the division routine 

@ This label is part of the division subroutine and is used for the division loop
@**********
divRoutine2:
@**********
    subs r6, r6, r7 @ Subtract r6 from r7 and put the answer in r6
    add r8, r8, #1 @ Increment the counter by 1 

    cmp r6, r7 @ Compare r6 and r7
    bgt divRoutine2 @ If the dividend is bigger than the divisor then loop back 

    cmp r6, r7 @ Compare r6 and r7
    beq divRoutine2 @ If the dividend is equal to the divisor then perform the loop one more time
    
    b divRoutine3 @ Branch to the end of subroutine

@ This label is the last part of the division subroutine
@**********
divRoutine3:
@**********

    push {r6, r8} @ Push the contents of r6 and r8 
    mov pc, lr @ Move the link register to the program counter 

@ This label is for notifiying the user when an overflow occurs 
@**********
overflow:
@**********
    ldr r0, =overflowPrompt @ Load r0 with the overflow prompt 
    bl printf @ Make the print call 
    b opResult2 @ Branch to opResult2


@ This label is for incorrect input and it branches back to the prompt 
@**********
readError:
@**********

	ldr r0, =strInputPattern @ Load r0 with the string input pattern
	ldr r1, =strInputError @ Load r1 with the input error 
	bl scanf @ Scan for input 
	b beginPrompt @ Branch back to the beginning prompt 

@ This label ends the program 
@**********
exit:
@**********

	mov r7, #0x01 
	svc 0



.data

.balign 4 
prompt: .asciz "Hello, please enter in the number that corresponds to the operation you would like to use: \n"

.balign 4
options: .asciz "[1] Add [2] Subtract [3] Multiply [4] Divide \n" 

.balign 4 
numInputPattern: .asciz "%d"

.balign 4
input: .word 0

.balign 4
strInputPattern: .asciz "%[^\n]"

.balign 4
strInputError: .skip 100*4

.balign 4
op1: .word 0

.balign 4
op2: .word 0

.balign 4
numPrompt: .asciz "Please enter your two postive integers/or zero operands one at a time in order: \n"

.balign 4
divideError: .asciz "You cannot divide a number by zero, please try again \n" 

.balign 4
tryAgain: .asciz "Would you like to perform another operation? \n"

.balign 4
options2: .asciz "[1] Yes [2] No \n"

.balign 4 
result: .asciz "The result of your operation is: %d \n" 

.balign 4 
remainder: .asciz "The remainder is: %d \n" 

.balign 4
overflowPrompt: .asciz "Overflow occured while performing your operation \n"

