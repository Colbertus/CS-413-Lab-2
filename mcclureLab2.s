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
    ldr r3, [r1] @ Load r1 with the contents of the input 
    cmp r3, #4 @ Compare r1 with 4
    bgt beginPrompt @ Loop back to the beginning if r1 is greater than 4
    cmp r3, #1 @ Compare r1 with 1
    blt beginPrompt @ Loop back to the beginning if r1 is less than 1 
    b operandCheck @ Branch to the next label if everything checks out 

@ This label will take the operands in as input and check for validity 
@**********
operandCheck:
@**********

    ldr r0, =numPrompt @ Load the operand instruction message 
    bl printf @ Print the message 
    b exit @ TODO: MOVE THIS 


@ This label is for incorrect input and it branches back to the prompt 
@**********
readError:
@**********

	ldr r0, =strInputPattern
	ldr r1, =strInputError
	bl scanf
	b beginPrompt

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
options: .asciz "Add [1] Subtract [2] Multiply [3] Divide [4] \n" 

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
numPrompt: .asciz "Please enter your two operands one at a time: \n"

