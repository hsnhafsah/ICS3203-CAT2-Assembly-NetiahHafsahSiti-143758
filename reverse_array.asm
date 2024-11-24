section .data
    prompt db "Please enter 5 single-digit numbers (0-9) one by one to be reversed: ", 0 
    prompt_len equ $ - prompt
    digit_prompt db "Enter a digit: ", 0           ; Prompt for each digit
    digit_prompt_len equ $ - digit_prompt
    invalid_input_msg db "Invalid input! Please enter a digit (0-9).", 0
    invalid_input_len equ $ - invalid_input_msg
    newline db 10         ; Newline character

section .bss
    array resb 5          ; Reserve 5 bytes for the array where digits will be stored
    input resb 2          ; Buffer for the input character and newline

section .text
    global _start

_start:
    ; Display an overall prompt to instruct the user to enter 5 digits
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, prompt         ; prompt message
    mov rdx, prompt_len     ; length of prompt
    syscall                 ; display prompt once

  ;Print a new line after the overall prompt
    mov rax, 1              
    mov rdi, 1              
    mov rsi, newline        ; newline after the prompt
    mov rdx, 1              
    syscall

    ; Initialize array index to store digits in the array
    xor r12, r12   ; r12 will track the array position (0 to 4)

input_loop:
    ;Display an "Enter a Digit:" prompt
    mov rax, 1              
    mov rdi, 1              
    mov rsi, digit_prompt   
    mov rdx, digit_prompt_len ; length 
    syscall                 ; display prompt

    ; Read character from user input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, input          ; input buffer
    mov rdx, 2              ; read 2 bytes (character + newline)
    syscall                 ; read input

    ; check if the input is between '0' and '9'
    mov al, [input]         ; Load input character
    cmp al, '0'
    jl invalid_input        ; If less than '0', jump to invalid input
    cmp al, '9'
    jg invalid_input        ; If greater than '9', jump to invalid input

    ; Store valid digit in the array and increment index
    mov [array + r12], al   ; Store input digit in array
    inc r12                 ; Move to the next array index

    ; Check if we need more input (This program expects 5 digits)
    cmp r12, 5
    jl input_loop           ; If less than 5, repeat input loop

    ; Print a newline after input is done 
    mov rax, 1              
    mov rdi, 1              
    mov rsi, newline        
    mov rdx, 1              
    syscall

    ; REVERSAL PROCESS
    ;Start by Initializing the two pointers for reversal
 
    mov r12, 0              ; Initialize left index (r12) to 0 (Start of the array)

    mov r13, 4              ; Initialize right index (r13) to 4 (Last element)

reverse_loop:
; Compare the left index (r12) with the right index (r13)
    cmp r12, r13
    jge print_array         ; If left >= right exit the loop and jump to print_array

    ; Swap elements at r12 (left index) and r13 (right index)
    mov al, [array + r12]   ; Load left element
    mov bl, [array + r13]   ; Load right element
    mov [array + r12], bl   ; Swap right to left
    mov [array + r13], al   ; Swap left to right

    ; Move indices towards the center
    inc r12 ; Increment ; Increment left index (r12) to move it towards the right

    dec r13 ; Decrement right index (r13) to move it towards the left

; Jump back to the beginning of the loop to check if reversal should continue
    jmp reverse_loop

print_array:
    ; Output the reversed array
    mov r12, 0

; CHALLENGES WITH HANDLING MEMORY DIRECTLY


print_loop:
    mov al, [array + r12]   ; Load each character from the array
    mov [input], al         ; Store in input buffer for printing

    ; Print the character
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, input          ; input buffer
    mov rdx, 1              ; print 1 character
    syscall

    ; Print newline after each character, but not after the last one
    inc r12
    cmp r12, 5
    je print_exit           ; If all characters are printed, exit the loop

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    jmp print_loop

print_exit:
    ; skip a line after the output is printed
    mov rax, 1              
    mov rdi, 1             
    mov rsi, newline        
    mov rdx, 1              
    syscall

    ; Exit the program
    mov rax, 60             ; sys_exit
    xor rdi, rdi            ; exit status 0
    syscall

invalid_input:
    ; Print invalid input message
    mov rax, 1
    mov rdi, 1
    mov rsi, invalid_input_msg
    mov rdx, invalid_input_len
    syscall
    jmp input_loop          ; Restart input loop after invalid input

