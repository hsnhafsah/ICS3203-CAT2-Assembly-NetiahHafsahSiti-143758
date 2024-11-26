section .data
    prompt db "Enter a number between 1-9: ", 0
    prompt_len equ $ - prompt
    result_msg db "Factorial is: ", 0
    result_len equ $ - result_msg
    newline db 10, 0

section .bss
    input resb 2
    result_str resb 32

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 2
    syscall

    movzx rax, byte [input]
    sub rax, '0'

    call factorial

    push rax

    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_len
    syscall

    pop rax
    call number_to_string

    mov rax, 60
    xor rdi, rdi
    syscall

factorial:
    push rbx
    push rcx
    push rdx

    mov rbx, rax
    cmp rax, 0
    je factorial_zero
    cmp rax, 1
    je factorial_done

factorial_loop:
    dec rbx
    cmp rbx, 1
    jle factorial_done
    mul rbx
    jmp factorial_loop

factorial_zero:
    mov rax, 1
    jmp factorial_done

factorial_done:
    pop rdx
    pop rcx
    pop rbx
    ret

number_to_string:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi

    mov rsi, result_str
    add rsi, 31
    mov byte [rsi], 0
    mov rbx, 10

convert_loop:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz convert_loop

    mov rax, 1
    mov rdi, 1
    mov rsi, rsi
    mov rdx, result_str
    add rdx, 31
    sub rdx, rsi
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

