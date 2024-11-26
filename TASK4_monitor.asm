
; TASK 4

; Program: Water Level Control System
; Description: This program simulates a water level control system using sensor input. It determines the appropriate action to take (e.g., turning the motor ON/OFF or triggering an alarm) based on the sensor value provided by the user. The program uses predefined thresholds to classify water levels into three categories: low, moderate, and high.

; 1. Input Handling:
;    - The user is prompted to enter a sensor value.
;    - The program reads the input, validates it, and converts the ASCII representation to an integer.
;    - If the input is invalid (e.g., contains non-numeric characters or is out of the range 0-99),
;      the program displays an "Invalid input" error message and exits.
;
; 2. Threshold Classification:
;    - Low Water Level (Sensor < 5): 
;        * Motor is turned ON (motor_status set to 1).
;        * Alarm remains OFF (alarm_status set to 0).
;    - Moderate Water Level (5 <= Sensor <= 10): 
;        * Motor remains OFF (motor_status set to 0).
;        * Alarm remains OFF (alarm_status set to 0).
;    - High Water Level (Sensor > 10): 
;        * Alarm is triggered (alarm_status set to 1).
;        * Motor remains OFF (motor_status set to 0).
;
; 3. Memory Usage:
;    - sensor_value: Stores the water level as a single byte.
;    - motor_status: Represents the state of the motor (1 = ON, 0 = OFF).
;    - alarm_status: Represents the state of the alarm (1 = Triggered, 0 = Clear).
;
; 4. Output Messages:
;    - Displays the motor's state (ON/OFF) and the alarm's state (Triggered/Clear) 
;      based on the current water level.
;    - If the input is invalid, displays "Invalid input" and exits.
;
; 5. Ports and Memory Updates:
;    - The program uses memory locations `motor_status` and `alarm_status` to represent the states of the motor and alarm, respectively.
;    - These values are manipulated based on the sensor input and are used to determine the messages displayed to the usei


section .data
    prompt db "  - Below 5 (LOW): Motor will turn ON, no alarm.", 0xA, \
            "  - 5 to 10 (MODERATE): Motor will stay OFF, no alarm.", 0xA, \
            "  - 10 - 99 (HIGH): Alarm will trigger due to high water level.", 0xA, 0xA, \
            "Enter Sensor Value: ", 0
    prompt_len equ $ - prompt
    motor_status db 0
    alarm_status db 0
    threshold db 10
    moderate_threshold db 5
    motor_on_msg db "Motor is ON", 0
    motor_off_msg db "Motor is OFF", 0
    alarm_triggered_msg db "ALARM! Water level too high", 0
    alarm_clear_msg db "No alarm. Water level is safe.", 0
    invalid_input_msg db "Invalid input. Exiting Program...", 0
    newline db 0xA, 0      

section .bss
    input_buffer resb 4 
    sensor_value resb 1      

section .text
    global _start

_start:
    ; Print the prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Read input
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 4
    syscall

    ; Validate and convert input
    movzx rax, byte [input_buffer]  ; Load first character of input
    cmp rax, '0'
    jl invalid_input                ; If less than '0', invalid input
    cmp rax, '9'
    jg invalid_input                ; If greater than '9', invalid input
    sub rax, '0'                    ; Convert ASCII to integeri

    movzx rcx, byte [input_buffer + 1] ; Check second character
    cmp rcx, 0xA                    ; Is it a newline? (valid single-digit input)
    je valid_input                  ; If yes, continue processing
    cmp rcx, '0'
    jl invalid_input                ; If less than '0', invalid input
    cmp rcx, '9'
    jg invalid_input                ; If greater than '9', invalid input
    sub rcx, '0'                    ; Convert second character to integer
    imul rax, 10                    ; Multiply first digit by 10
    add rax, rcx                    ; Add second digit
    movzx rcx, byte [input_buffer + 2]
    cmp rcx, 0xA                    ; Ensure third character is newline
    jne invalid_input               ; If not newline, invalid input

valid_input:
    ; Store sensor value
    mov [sensor_value], al

    ; Check water level and take actions
    cmp al, [threshold]
    jg high_water_level            ; If above 10, high water level

    cmp al, [moderate_threshold]
    jl low_water_level             ; If below 5, low water level

    ; Moderate water level (5 to 10)
    mov byte [motor_status], 0
    mov byte [alarm_status], 0
    jmp display_status

high_water_level:
    mov byte [alarm_status], 1
    mov byte [motor_status], 0
    jmp display_status

low_water_level:
    mov byte [motor_status], 1
    mov byte [alarm_status], 0
    jmp display_status

   invalid_input:
    ; Print invalid input message
    mov rax, 1
    mov rdi, 1
    mov rsi, invalid_input_msg
    mov rdx, 33                    ; Length of "Invalid input. Exiting program."
    syscall

    ; Print a newline after the message
    mov rsi, newline
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

display_status:
    ; Display motor status
    mov al, [motor_status]
    cmp al, 1
    je motor_on
    mov rsi, motor_off_msg
    mov rdx, 13                   ; Length of "Motor is OFF"
    jmp print_motor_status

motor_on:
    mov rsi, motor_on_msg
    mov rdx, 12                   ; Length of "Motor is ON"

print_motor_status:
    mov rax, 1
    mov rdi, 1
    syscall

    ; Print a newline after the motor status message
    mov rsi, newline
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall

    ; Display alarm status
    mov al, [alarm_status]
    cmp al, 1
    je alarm_on
    mov rsi, alarm_clear_msg
    mov rdx, 31                 
    jmp print_and_exit

alarm_on:
    mov rsi, alarm_triggered_msg
    mov rdx, 27                  

print_and_exit:
    ; Print the current message
    mov rax, 1
    mov rdi, 1
    syscall

    ; Print a newline after the message
    mov rsi, newline
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

