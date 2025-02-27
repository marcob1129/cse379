        .text
        .global uart_init
        .global gpio_btn_and_LED_init
        .global output_character
        .global read_character
        .global read_string
        .global output_string
        .global read_from_push_btns
        .global illuminate_LEDs
        .global illuminate_RGB_LED
        .global read_tiva_push_button
        .global division
        .global multiplication




uart_init:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        MOV r4, #0xE618
        MOVT r4,#0x400F
        MOV r5, #1
        STR r5, [r4]
        MOV r4, #0xE608
        MOVT r4,#0x400F
        MOV r5, #1
        STR r5, [r4]
        MOV r4, #0xC030
        MOVT r4,#0x4000
        MOV r5, #0
        STR r5, [r4]
        MOV r4, #0xC024
        MOVT r4,#0x4000
        MOV r5, #8
        STR r5, [r4]
        MOV r4, #0xC028
        MOVT r4,#0x4000
        MOV r5, #44
        STR r5, [r4]
        MOV r4, #0xCFC8
        MOVT r4,#0x4000
        MOV r5, #0
        STR r5, [r4]
        MOV r4, #0xC02C
        MOVT r4,#0x4000
        MOV r5, #0x60
        STR r5, [r4]
        MOV r4, #0xC030
        MOVT r4,#0x4000
        MOV r5, #0x301
        STR r5, [r4]
        MOV r4, #0x451C
        MOVT r4,#0x4000
        LDR r5, [r4]
        ORR r5, r5, #0x03
        STR r5, [r4]
        MOV r4, #0x4420
        MOVT r4,#0x4000
        LDR r5, [r4]
        ORR r5, r5, #0x03
        STR r5, [r4]
        MOV r4, #0x452C
        MOVT r4,#0x4000
        LDR r5, [r4]
        ORR r5, r5, #0x11
        STR r5, [r4]
        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

gpio_btn_and_LED_init:
        PUSH {r4-r12,lr}        ; Spill registers to stack

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

        mov r1,#0x7400          ; port d input
        movt r1,#0x4000
        LDR r2,[r1]
        AND r2, r2, #0
        str r2,[r1]


        mov r1,#0x751C          ; Digital
        movt r1,#0x4000
        LDR r2,[r1]
        MOV r3, #0xF
        ORR r2, r2, r3
        str r2,[r1]

        mov r1,#0x5400          ; port b output
        movt r1,#0x4000
        LDR r2,[r1]
        ORR r2, r2, #0xF
        str r2,[r1]


        mov r1,#0x551C          ; Digital
        movt r1,#0x4000
        LDR r2,[r1]
        MOV r3, #0xF
        ORR r2, r2, r3
        str r2,[r1]

        mov r4,#0x5000
        movt r4,#0x4002
        LDR r1, [r4, #0x510]
        ORR r1, r1, #0x10
        STR r1, [r4, #0x510]


        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

output_character:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        MOV R1, #0xC018         ; store UART Flag register address
        MOVT R1, #0x4000
stall_out:
        LDRB R2, [R1]           ; load flag register
        AND R2, R2, #0x20       ; mask out unnecessary flags
        CMP R2, #0x20                     ; check flag
        BEQ stall_out           ; stall if needed
        SUB R1, R1, #0x18       ; store UART Data register address
        STRB R0, [R1]
        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

read_character:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        mov r1, #0xC018 ;Flag Register
        movt r1, #0x4000
        mov r2, #0xC000 ; Receive Register
        movt r2, #0x4000

loop:
        LDRB r3, [r1]   ;Load Flag into register
        and r3,r3,#0x10 ; Mask
        cmp r3, #0x00
        bne loop
        LDRB r0,[r2]    ; Load ASCII into Receive Register
        ; BL output_character
        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

read_string:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        mov r5, #0 ; Counter for String
                mov r4, r0 ; Buffer

read_string_loop:
        BL read_character
        cmp r0, #0x0D   ; Compare to Enter key
        BEQ end_read_string

        STRB r0,[r4,r5] ; Store character at buffer with offset
        add r5,r5,#1

        B read_string_loop

end_read_string:
        mov r0,#0x00    ; Move NULL character into r0
        STRB r0,[r4,r5] ; Store NULL character at end of string
        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

output_string:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        MOV r4, r0              ; move base address from r0 to r4
        MOV r5, #0              ; initialize offset to 0
load_character:
        LDRB r0, [r4, r5]       ; load character into r0
        CMP r0, #0x00           ; check if loaded character is NULL byte(end of string)
        BEQ stop_output_string

        BL output_character     ; output character if not NULL byte
        ADD r5, r5, #1          ; increment offset
        B load_character        ; load next character
stop_output_string:

        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

read_from_push_btns:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        mov r1,#0x7000
        movt r1,#0x4000         ; Port D address

        ;LDR r1,[r4,#0x510]
        ;ORR r1,r1,#0x10
        ;STR r1,[r4,#0x510]      ; Pull up resistor

        LDR r0,[r1,#0x3FC]      ; Data registor

        and r0,r0,#0xF          ; mask bottom 4 bits
        ;EOR r0,r0,#0xF          ; Invert bottom 4
        ;LSR r0,r0,#28          ; Rotate all the way around

        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

illuminate_LEDs:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        mov r1,#0x53FC
        movt r1,#0x4000

		LDR r2, [r1]
        BFI r2, r0, #0, #8
        STR r2, [r1]

        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

illuminate_RGB_LED:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        mov r1,#0x53FC
        movt r1,#0x4002

        LDR r2, [r1]
        BFI r2, r0, #0, #8
        STR r2, [r1]

        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

read_tiva_push_button:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
		mov r4,#0x5000
        movt r4,#0x4002
        LDR r1, [r4,#0x3FC]
        and r1,r1,#0x10

        cmp r1,#0       ; Check if pressed
        BEQ pushed
        mov r0, #0
        B end_read_btn
pushed:
        mov r0, #1

end_read_btn:
        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

division:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        mov r4, #15 ;Counter
        mov r5, #0 ;Quotient
        LSL r1,r1,#15
        mov r6,r0 ;Remainder

LOOP:
        SUB r6,r6,r1
        CMP r6,#0
        BLT NEXT

        LSL r5,r5,#1
        ORR r5,r5,#1
        B AFT

DEC:
        SUB r4,r4,#1
        B LOOP
NEXT:
        ADD r6,r6,r1
        LSL r5,r5,#1
AFT:
        LSR r1,r1,#1
        CMP r4,#0
        BGT DEC
DONE:
        mov r0,r5
        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr

multiplication:
        PUSH {r4-r12,lr}        ; Spill registers to stack

          ; Your code is placed here
        mov r4, #0 ;total
        mov r5, #0 ;counter

        CMP r0,#0
        BLE DON
        cmp r1,#0
        BLE DON
LOP:
        ADD r5,r5,#1
        ADD r4,r0,r4
        CMP r5,r1
        BLT LOP
DON:
        mov r0,r4
        POP {r4-r12,lr}         ; Restore registers from stack
        MOV pc, lr



        .end
