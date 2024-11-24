; *****************************************************
; Program: Number Classifier
; Author: Netiah Hafsah Siti
; Purpose: Classifies the input number as POSITIVE, NEGATIVE, or ZERO
; *****************************************************

; Jump Instructions Choice:

; I chose to use jg (jump if greater) and jl (jump if less) to handle the conditional branches because these instructions directly correspond to the flags set by the comparison (cmp).
; This allows for efficient decision-making based on whether the number is positive, negative, or zero.

; The unconditional jumps (jmp) are used for flow control after a message has been printed,skipping the rest of the code and ensuring the program finishes cleanly by exiting.

; How Each Jump Impacts the Program Flow:

; Conditional Jumps (jg, jl): These instructions allow the program to handle different branches based on the input number. Depending on the comparison result, the program will jump to the appropriate label for printing the corresponding message.

; Unconditional Jumps (jmp): These jumps ensure the program doesn't continue to execute unnecessary instructions after printing the result, and directly exits after the message is shown.

section .data
    msg_positive db "POSITIVE", 0
    msg_negative db "NEGATIVE", 0
    msg_zero db "ZERO", 0

section .bss
    num resb 4

section .text
    global _start

_start:
    ; Prompt user for input
    mov rdi, prompt_input
    call print_string

    ; Read the user input
    mov rsi, num
    call read_input

    ; Convert input from ASCII to integer
    mov rsi, num
    call atoi

    ; Compare the number with 0
    cmp rax, 0

    ; If greater than 0, jump to positive message
    jg positive

    ; If less than 0, jump to negative message
    jl negative

zero:
    ; Print "ZERO"
    mov rdi, msg_zero
    call print_string
    jmp done

positive:
    ; Print "POSITIVE"
    mov rdi, msg_positive
    call print_string
    jmp done

negative:
    ; Print "NEGATIVE"
    mov rdi, msg_negative
    call print_string
    jmp done

done:
    ; Exit the program
    mov rax, 60         ; syscall number for exit
    xor rdi, rdi        ; status 0
    syscall

; Function to print a string
print_string:
    mov rax, 0x1        ; syscall number for write
    mov rdi, 0x1        ; file descriptor (stdout)
    mov rdx, 100        ; maximum length of string
    syscall
    ret

; Function to read user input
read_input:
    mov rax, 0x0        ; syscall number for read
    mov rdi, 0x0        ; file descriptor (stdin)
    mov rdx, 100        ; maximum number of bytes to read
    syscall
    ret

; Function to convert ASCII string to integer (atoi)
atoi:
    xor rax, rax        ; Clear rax (for storing the result)
    xor rcx, rcx        ; Clear rcx (for digit processing)

atoi_loop:
    movzx rbx, byte [rsi + rcx]  ; Load the current byte of the string
    test  rbx, rbx                ; Check for null terminator
    jz    atoi_done               ; If null terminator, done
    sub   rbx, '0'                ; Convert ASCII to integer
    imul  rax, rax, 10           ; Multiply rax by 10 (shift left by one decimal place)
    add   rax, rbx                ; Add the current digit to rax
    inc   rcx                     ; Move to the next character
    jmp   atoi_loop               ; Repeat loop

atoi_done:
    ret

