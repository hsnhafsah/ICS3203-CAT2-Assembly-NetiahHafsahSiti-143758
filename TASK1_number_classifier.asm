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
    invalid_msg db "Invalid input. Please enter a valid number.", 0
    pos_msg db "POSITIVE", 0         ; Positive message
    neg_msg db "NEGATIVE", 0         ; Negative message
    zero_msg db "ZERO", 0            ; Zero message
    newline db 0x0A, 0               ; Newline character

section .text
    global _start

_start:
input_loop:
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

    ; Convert the input string to an integer
    mov rsi, user_input   ; Pointer to the input buffer
    call string_to_int    ; Call the string-to-integer conversion function
    ; Result of the conversion will be in RAX

    ; Check for invalid input
    cmp rdx, -1           ; If rdx = -1, invalid input was detected
    je invalid_input

    ; Compare the number to classify it
    cmp rax, 0            ; Compare the number with 0
    je zero_case          ; Jump to zero_case if the number is 0 (je = jump if equal)
    jg positive_case      ; Jump to positive_case if the number is greater than 0 (jg = jump if greater)
    jl negative_case      ; Jump to negative_case if the number is less than 0 (jl = jump if less)

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
    jmp done              ; Jump to done to exit the program

invalid_input:
    ; Print "Invalid input. Please enter a valid number."
    mov rax, 1            
    mov rdi, 1            
    mov rsi, invalid_msg  
    mov rdx, 38           ; message length
    syscall               
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline     
    mov rdx, 1            
    syscall
    jmp input_loop         ; Go back to prompt for input again

done:
    ; Exit the program
    mov rax, 60           ; syscall for sys_exit (60)
    xor rdi, rdi          ; exit code 0
    syscall               

; Helper Function: Convert string to signed integer
; Input: RSI = pointer to input string
; Output: RAX = signed integer value, RDX = -1 for invalid input
string_to_int:
    xor rax, rax          ; Clear RAX (result)
    xor rbx, rbx          ; Clear RBX (sign flag)
    mov rcx, 0            ; Initialize loop counter

parse_sign:
    mov bl, byte [rsi+rcx] ; Read the current byte
    cmp bl, '-'            ; Check if it is a negative sign
    jne parse_digits       ; If not, move to parsing digits
    inc rcx                ; Move to the next character
    mov rbx, -1            ; Set sign flag to indicate negative

parse_digits:
    mov bl, byte [rsi+rcx] ; Read the current byte
    cmp bl, 0xA            ; Check for newline (end of input)
    je apply_sign          ; If newline, go to apply_sign
    cmp bl, 0              ; Check for null terminator
    je apply_sign          ; If null, go to apply_sign
    cmp bl, '0'            ; Check if character is a digit
    jl invalid_number      ; If less, input is invalid
    cmp bl, '9'            
    jg invalid_number      ; If greater, input is invalid

    sub bl, '0'            ; Convert ASCII digit to integer
    imul rax, rax, 10      ; Multiply current result by 10
    add rax, rbx           ; Add the digit to the result
    inc rcx                ; Move to the next character
    jmp parse_digits       ; Repeat the process

apply_sign:
    ; If sign is negative (rbx == -1), apply negation to result
    cmp rbx, -1            ; Check if the number is negative
    jne valid_input        ; If not, skip applying the sign
    neg rax                ; Make the result negative

valid_input:
    xor rdx, rdx           ; Clear RDX to indicate valid input
    ret                    ; Return to the caller

invalid_number:
    mov rdx, -1            ; Set RDX to -1 to indicate invalid input
    ret                    ; Return to the caller

