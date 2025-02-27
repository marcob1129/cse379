	.data

	.global prompt
	.global mydata

prompt:	.cstring "\n\rPress 'g' to start the game"
howtoplay_prompt:	.cstring "\n\rFirst person to press space/button after green lights up wins"

space_prompt: .cstring "\n\rSpace wins: "
button_prompt: .cstring "\n\rButton wins: "
quit_prompt:	.cstring "\n\rPress 'q' to quit or any other key to continue:"
mydata:	.byte	0x00000000	; This is where you can store data.
			; The .byte assembler directive stores a byte
			; (initialized to 0x20 in this case) at the label
			; mydata.  Halfwords & Words can be stored using the
			; directives .half & .word

	.text

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global simple_read_character	; read_character modified for interrupts
	.global output_character	; This is from your Lab #4 Library
	.global read_string		; This is from your Lab #4 Library
	.global output_string		; This is from your Lab #4 Library
	.global uart_init		; This is from your Lab #4 Library
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global lab5

ptr_to_prompt:		.word prompt
ptr_to_mydata:		.word mydata
ptr_to_button_prompt:	.word button_prompt
ptr_to_space_prompt:	.word space_prompt
ptr_to_quit_prompt:	.word quit_prompt
ptr_to_howtoplay_prompt:	.word howtoplay_prompt
lab5:				; This is your main routine which is called from
				; your C wrapper.
	PUSH {r4-r12,lr}   	; Preserve registers to adhere to the AAPCS
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata

 	bl uart_init
	bl uart_interrupt_init
	bl gpio_interrupt_init

	; This is where you should implement a loop, waiting for the user to
	; indicate if they want to end the program.
	ldr r0,ptr_to_prompt
	BL output_string	; Printing prompt to play

	mov r11,#0x30	; Counters
	mov r12,#0x30

loop_lab5:
	ldr r5,ptr_to_mydata

   	cmp r5,#1	;Checking if mydata is 1 for space
	BEQ space_wins

	cmp r5,#2	; Checking if mydata is 2 for button
	BEQ button_wins

	B loop_lab5

space_wins:
	add r11,r11,#1	; Update win counter

	mov r0,#5	; Update color to yellow
	BL illuminate_RGB_LED
	cmp r0,#0x71
	BEQ quit

	B lab5
button_wins:
	add r12,r12,#1 ; Update win counter

	mov r0,#8	;Update color to blue
	BL illuminate_RGB_LED
	cmp r0,#0x71
	BEQ quit

	B lab5

quit:


	POP {lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr



uart_interrupt_init:

	; Your code to initialize the UART0 interrupt goes here
	mov r0, #0xC038
	movt r0,#0x4000
	ldr r1,[r0]
	ORR r1,r1,#0x10
	str r1,[r0]

	mov r0, #0xE100
	movt r0,#0xE000
	ldr r1,[r0]
	ORR r1,r1,#0x20
	str r1,[r0]


	MOV pc, lr


gpio_interrupt_init:

	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.
	; Your code is placed here
	; Enable clock for GPIO port F, B, D
	MOV r1, #0xE608
	MOVT r1, #0x400F
	LDR r2, [r1]
	MOV r3, #0x2A
	ORR r2, r2, r3
	STR r2, [r1]

	; Set GPIO pins 1-3 on port F to output and 4 to input
	MOV r1, #0x5400
	MOVT r1, #0x4002
	LDR r2, [r1]
	MOV r3, #0x7
	BFI r2, r3, #1, #4
	STR r2, [r1]

	; Set GPIO pins 1-4 on port F to digital
	MOV r1, #0x551C
	MOVT r1, #0x4002
	LDR r2, [r1]
	MOV r3, #0x1E
	ORR r2, r2, r3
	STR r2, [r1]

	mov r0, #0x5000
	movt r0,#0x4002
	ldr r1,[r0,#0x404]
	and r1,r1,#0x0
	str r1,[r0,#0x404]

	mov r0, #0x5410
	movt r0,#0x4002
	ldr r1,[r0]
	ORR r1,r1,#0x10
	str r1,[r0]



	ldr r1,[r0,#0x408]
	and r1,r1,#0x0
	str r1,[r0,#0x408]

	ldr r1,[r0,#0x40C]
	and r1,r1,#0x0
	str r1,[r0,#0x40C]

	mov r0,#0xE100
	movt r0,#0xE000
	ldr r1,[r0]
	ORR r1,r1,#0x40000000
	str r1,[r0]



	MOV pc, lr

UART0_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r12,lr}   	; Preserve registers to adhere to the AAPCS

	ldr r0,ptr_to_howtoplay_prompt
	BL output_string

	mov r4,#0xC044
	movt r4,#0x4000
	ldr r5,[r4]
	ORR r5,r5,#0x10
	str r5,[r4]

	PUSH {r0}   	; Preserve registers to adhere to the AAPCS

	mov r0,r5
	BL simple_read_character

	cmp r0,#0x20
	BEQ space_press

	cmp r0,#0x67
	BEQ start_game


	POP {r0}   	; Preserve registers to adhere to the AAPCS

space_press:
	mov r9,#0x53FC
	movt r9,#0x4002
	ldr r10,[r9]
	cmp r10,#0x4
	BNE loop_lab5

	ldr r6,ptr_to_mydata
	ldr r7,[r6]
	and r7,r7,#0
	orr r7,r7,#0x1
	str r7,[r6]
	B space_wins

start_game:
	PUSH {r0}   	; Preserve registers to adhere to the AAPCS
	mov r0,#0
	BL illuminate_RGB_LED

	mov r8,#0
loop_start_game:

	add r8,r8,#1
	cmp r8,#1000	; Loop 1 second

	BLE loop_start_game

	mov r0, #0x8
	BL illuminate_RGB_LED
	POP {r0}
end_UART_handler:
	POP {r0, r4-r12,lr}   	; Preserve registers to adhere to the AAPCS

	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r12,lr}   	; Preserve registers to adhere to the AAPCS

	mov r4,#0x541C
	movt r4,#0x4002

	ldr r5,[r4]
	ORR r5,r5,#0x10
	str r5,[r4]
	BL read_tiva_push_button

	mov r9,#0x53FC
	movt r9,#0x4002
	ldr r10,[r9]
	cmp r10,#0x4
	BNE loop_lab5

	ldr r6,ptr_to_mydata
	ldr r7,[r6]
	and r7,r7,#0
	orr r7,r7,#0x2
	str r7,[r6]
	B button_wins

	POP {r4-r12,lr}   	; Preserve registers to adhere to the AAPCS

	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed for
	; Lab #5, but will be used in Lab #6.  It is referenced here because
	; the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	BX lr       	; Return


simple_read_character:


        mov r2, #0xC000 ; Receive Register
        movt r2, #0x4000
        LDRB r0,[r2]    ; Load ASCII into Receive Register
	MOV pc, lr	; Return

	.end
