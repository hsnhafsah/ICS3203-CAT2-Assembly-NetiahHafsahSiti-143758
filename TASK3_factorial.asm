; TASK 3

; Program: Factorial Calculator
; Description: This program calculates the factorial of a number entered by the user.
; It demonstrates modular programming by using subroutines for factorial calculation and number-to-string conversion.
; The stack is utilized for preserving registers to ensure values are not lost during subroutine calls.

; Functionality:
; 1. Prompts the user to enter a number between 1-9.
; 2. Calculates the factorial of the input number using the `factorial` subroutine.
; 3. Converts the factorial result into a string using the `number_to_string` subroutine.
; 4. Outputs the result.

; Modular Programming:
; - The program is broken into separate, reusable subroutines (`factorial` and `number_to_string`).
; - Each subroutine performs a specific task and ensures no side effects by managing registers properly.

; Stack Usage:
; - The stack is used to preserve register values across subroutine calls.
; - The factorial result is then temporarily stored on the stack before being processed by the`number_to_string` subroutine.

; Register Management:
; 1. `factorial` Subroutine:
;    - Preserved Registers: `rbx`, `rcx`, `rdx`
;    - The program pushes these registers onto the stack at the start of the factorial subroutine and pops them before returning the subroutine to the caller.
;    - `rax` is used to store the result of the factorial.

; 2. `number_to_string` Subroutine:
;    - Preserved Registers: `rax`, `rbx`, `rcx`, `rdx`, `rsi`
;    - The program pushes these registers onto the stack at the start and pops them before returning the subroutine to the caller.
;    - Uses `rsi` to build the string representation of the number.


section .data
    prompt db "Enter a number between 1-9: ", 0 ; Prompt to ask user for input
    prompt_len equ $ - prompt
    result_msg db "Factorial is: ", 0 ; Message to display the result
    result_len equ $ - result_msg
    newline db 10, 0 ; Newline character

section .bss
    input resb 2 ; Buffer to store user input
    result_str resb 32 ; Buffer to store the resulting number as a string

section .text
    global _start

; Entry point of the program
_start:
    ; Display the prompt
    mov rax, 1         ; syscall: write
    mov rdi, 1         ; file descriptor: stdout
    mov rsi, prompt    ; address of the prompt string
    mov rdx, prompt_len; length of the prompt string
    syscall

    ; Read user input
    mov rax, 0         ; syscall: read
    mov rdi, 0         ; file descriptor: stdin
    mov rsi, input     ; buffer to store input
    mov rdx, 2         ; number of bytes to read
    syscall

    ; Convert input from ASCII to integer
    movzx rax, byte [input] ; Zero-extend the input byte to rax
    sub rax, '0'            ; Convert ASCII character to integer

    ; Call factorial subroutine
    call factorial

    ; Store the result in the stack temporarily
    push rax

    ; Display the result message
    mov rax, 1         ; syscall: write
    mov rdi, 1         ; file descriptor: stdout
    mov rsi, result_msg; address of the result message string
    mov rdx, result_len; length of the result message string
    syscall

    ; Retrieve the result and convert it to a string
    pop rax
    call number_to_string

    ; Exit the program
    mov rax, 60        ; syscall: exit
    xor rdi, rdi       ; exit code: 0
    syscall

; Subroutine: factorial
; Calculates the factorial of a number stored in rax
; Returns the result in rax
factorial:
    ; Preserve registers
    push rbx          ; Save rbx
    push rcx          ; Save rcx
    push rdx          ; Save rdx

    mov rbx, rax      ; Copy input number to rbx
    cmp rax, 0        ; Check if the input is 0
    je factorial_zero ; If 0, jump to factorial_zero
    cmp rax, 1        ; Check if the input is 1
    je factorial_done ; If 1, jump to factorial_done

factorial_loop:
    dec rbx           ; Decrement rbx
    cmp rbx, 1        ; Check if rbx <= 1
    jle factorial_done; If so, exit loop
    mul rbx           ; Multiply rax by rbx
    jmp factorial_loop; Repeat loop

factorial_zero:
    mov rax, 1        ; Factorial of 0 is 1

factorial_done:
    ; Restore registers
    pop rdx           ; Restore rdx
    pop rcx           ; Restore rcx
    pop rbx           ; Restore rbx
    ret               ; Return to caller

; Subroutine: number_to_string
; Converts the number in rax to a string and prints it
number_to_string:
    ; Preserve registers
    push rax          ; Save rax
    push rbx          ; Save rbx
    push rcx          ; Save rcx
    push rdx          ; Save rdx
    push rsi          ; Save rsi

    mov rsi, result_str ; Address of the result buffer
    add rsi, 31         ; Point to the end of the buffer
    mov byte [rsi], 0   ; Null-terminate the string
    mov rbx, 10         ; Divisor for converting to base 10

convert_loop:
    dec rsi            ; Move back in the buffer
    xor rdx, rdx       ; Clear rdx
    div rbx            ; Divide rax by 10
    add dl, '0'        ; Convert remainder to ASCII
    mov [rsi], dl      ; Store the ASCII character
    test rax, rax      ; Check if quotient is 0
    jnz convert_loop   ; If not, continue loop

    ; Write the resulting string
    mov rax, 1         ; syscall: write
    mov rdi, 1         ; file descriptor: stdout
    mov rsi, rsi       ; Address of the resulting string
    mov rdx, result_str
    add rdx, 31        ; Length of the string
    sub rdx, rsi
    syscall

    ; Print newline
    mov rax, 1         ; syscall: write
    mov rdi, 1         ; file descriptor: stdout
    mov rsi, newline   ; Address of the newline character
    mov rdx, 1         ; Length: 1 byte
    syscall

    ; Restore registers
    pop rsi            ; Restore rsi
    pop rdx            ; Restore rdx
    pop rcx            ; Restore rcx
    pop rbx            ; Restore rbx
    pop rax            ; Restore rax
    ret                ; Return to caller

