section .data
    prompt db "Enter water level (0-10): ", 0    ; Prompt message
    prompt_len equ $ - prompt                      ; Length of prompt message
    motor_status db 0                              ; Motor status: 0 = off, 1 = on
    alarm_status db 0                              ; Alarm status: 0 = no alarm, 1 = triggered
    threshold db 10                                ; Water level threshold for alarm (e.g., 10)
    moderate_threshold db 5                        ; Moderate water level threshold (e.g., 5)
    motor_on_msg db "Motor is ON", 0xA, 0
    motor_off_msg db "Motor is OFF", 0xA, 0
    alarm_triggered_msg db "ALARM! Water level too high!", 0xA, 0
    alarm_clear_msg db "No alarm. Water level is safe.", 0xA, 0
    sensor_value db 0                              ; Place to store the sensor value

section .bss
    input_buffer resb 2                             ; Buffer to store user input (1 byte + null terminator)

section .text
    global _start

_start:
    ; Step 1: Print prompt for user input
    mov eax, 4                                    ; sys_write system call
    mov ebx, 1                                    ; File descriptor for stdout (1)
    mov ecx, prompt                               ; Address of the prompt message
    mov edx, prompt_len                           ; Length of the prompt message
    int 0x80                                      ; Make the system call

    ; Step 2: Read user input (water level)
    mov eax, 3                                    ; sys_read system call
    mov ebx, 0                                    ; File descriptor for stdin (0)
    mov ecx, input_buffer                         ; Buffer to store input
    mov edx, 2                                    ; Read up to 2 bytes (including newline)
    int 0x80                                      ; Make the system call

    ; Step 3: Convert ASCII to integer (assuming input is a single digit between 0-9)
    mov al, byte [input_buffer]                   ; Load the first byte of input into AL
    sub al, '0'                                   ; Convert ASCII to integer (e.g., '5' -> 5)
    mov [sensor_value], al                        ; Store the sensor value in the sensor_value variable

    ; Step 4: Compare the sensor value with the threshold to determine actions
    cmp al, [threshold]                           ; Compare sensor value with the threshold (e.g., 10)
    jg high_water_level                           ; If the value is greater than the threshold, jump to high_water_level

    ; Step 5: Check if water level is below the moderate threshold (less than 5)
    cmp al, [moderate_threshold]                  ; Compare the sensor value with the moderate threshold (e.g., 5)
    jl low_water_level                            ; If the value is less than the moderate threshold, jump to low_water_level

    ; Step 6: Moderate water level (5 <= sensor <= 10) - Stop motor, no alarm
    mov byte [motor_status], 0                    ; Turn off the motor by setting motor_status to 0
    mov byte [alarm_status], 0                    ; Ensure the alarm is off
    jmp end_program                               ; Jump to end to display messages

high_water_level:
    ; Step 7: High water level (sensor > 10) - Trigger alarm, turn off motor
    mov byte [alarm_status], 1                    ; Set alarm status to 1 (trigger alarm)
    mov byte [motor_status], 0                    ; Turn off the motor by setting motor_status to 0
    jmp end_program                               ; Jump to end to display messages

low_water_level:
    ; Step 8: Low water level (sensor < 5) - Turn on motor, no alarm
    mov byte [motor_status], 1                    ; Turn on the motor by setting motor_status to 1
    mov byte [alarm_status], 0                    ; Ensure alarm is off
    jmp end_program                               ; Jump to end to display messages

end_program:
    ; Step 9: Display motor status message
    mov al, [motor_status]                        ; Load motor status into AL register
    cmp al, 1                                     ; Compare motor status with 1 (on)
    je motor_on                                   ; If motor is on, jump to motor_on label
    mov ecx, motor_off_msg                        ; Set message to "Motor is OFF"
    jmp print_message                             ; Print the message

motor_on:
    mov ecx, motor_on_msg                         ; Set message to "Motor is ON"

print_message:
    ; Step 10: Display motor status message using sys_write
    mov eax, 4                                    ; sys_write system call
    mov ebx, 1                                    ; File descriptor for stdout (1)
    mov edx, 14                                   ; Length of message
    int 0x80                                      ; Make the system call

    ; Step 11: Display alarm status message
    mov al, [alarm_status]                        ; Load alarm status
    cmp al, 1                                     ; Compare alarm status with 1 (triggered)
    je alarm_triggered                            ; If alarm is triggered, jump to alarm_triggered label
    mov ecx, alarm_clear_msg                      ; Set message to "No alarm"
    jmp print_alarm_message                       ; Print the alarm message

alarm_triggered:
    mov ecx, alarm_triggered_msg                  ; Set message to "ALARM! Water level too high!"

print_alarm_message:
    ; Step 12: Display alarm status message using sys_write
    mov eax, 4                                    ; sys_write system call
    mov ebx, 1                                    ; File descriptor for stdout (1)
    mov edx, 30                                   ; Length of message
    int 0x80                                      ; Make the system call

    ; Step 13: Exit program
    mov eax, 1                                    ; sys_exit system call
    xor ebx, ebx                                  ; Return 0
    int 0x80                                      ; Exit the program

