; TASK 1

; Program: Number Classifier
; Description: Classifies the input number as POSITIVE, NEGATIVE, or ZERO


; Jump Instructions Choice:
; I chose to use jg (jump if greater) and jl (jump if less) to handle the conditional branches because these instructions directly correspond to the flags set by the comparison (cmp).
; This allows for efficient decision-making based on whether the number is positive, negative, or zero.
; The unconditional jumps (jmp) are used for flow control after a message has been printed, skipping the rest of the code and ensuring the program finishes cleanly by exiting.

; How Each Jump Impacts the Program Flow:
; Conditional Jumps (jg, jl): These instructions allow the program to handle different branches based on the input number. Depending on the comparison result, the program will jump to the appropriate label for printing the corresponding message.
; Unconditional Jumps (jmp): These jumps ensure the program doesn't continue to execute unnecessary instructions after printing the result, and directly exits after the message is shown.



section .bss
    user_input resb 10      ; Reserve space for user input (maximum 10 bytes)
section .data
    prompt db "Enter a number: ", 0  
    pos_msg db "POSITIVE", 0         ; Positive message
    neg_msg db "NEGATIVE", 0         ; Negative message
    zero_msg db "ZERO", 0           ; Zero message
    newline db 0x0A, 0              ; Newline character

section .text
    global _start

_start:
    ; Print the prompt asking the user for input
    mov rax, 1            ; syscall for sys_write (1)
    mov rdi, 1            ; file descriptor 1 (stdout)
    mov rsi, prompt       
    mov rdx, 15           ; message length
    syscall               

    ; Read the user input
    mov rax, 0            ; syscall for sys_read (0)
    mov rdi, 0            ; file descriptor 0 (stdin)
    mov rsi, user_input   ; buffer to store the user input
    mov rdx, 10           ; max input length
    syscall               

    ; Convert the input from ASCII to integer
    movzx rax, byte [user_input]  ; Load the input byte into rax (ASCII value)
    sub rax, '0'                ; Convert ASCII value to integer

    ; Compare the number to classify it
    cmp rax, 0            ; Compare the number with 0
    je zero_case          ; Jump to zero_case if the number is 0 (je = jump if equal)
    jg positive_case     ; Jump to positive_case if the number is greater than 0 (jg = jump if greater)
    jl negative_case     ; Jump to negative_case if the number is less than 0 (jl = jump if less)

positive_case:
    ; Print "POSITIVE"
    mov rax, 1            
    mov rdi, 1            
    mov rsi, pos_msg      ; message to print
    mov rdx, 8            ; message length
    syscall               
 ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline     
    mov rdx, 1            
    syscall
    jmp done               

negative_case:
    ; Print "NEGATIVE"
    mov rax, 1            
    mov rdi, 1            
    mov rsi, neg_msg    
    mov rdx, 8            
    syscall               
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline     
    mov rdx, 1            
    syscall
    jmp done              ; Jump to done to exit the program

zero_case:
    ; Print "ZERO"
    mov rax, 1            
    mov rdi, 1            
    mov rsi, zero_msg     
    mov rdx, 4            ; message length
    syscall               
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline     
    mov rdx, 1            
    syscall

done:
    ; Exit the program
    mov rax, 60           ; syscall for sys_exit (60)
    xor rdi, rdi          ; exit code 0
    syscall              

