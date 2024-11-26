# ICS3203-CAT2-Assembly-NetiahHafsahSiti-143758

## Instructions for Compiling and Running the Code
1. Use the commands below to install the necessary tools: nasm (assembler) and gcc (C compiler)
 ```bash
sudo apt update
sudo apt install nasm gcc
   ```
2. Clone the repository:
 ```bash
git clone https://github.com/hsnhafsah/ICS3203-CAT2-Assembly NetiahHafsahSiti-143758.git
cd ICS3203-CAT2-Assembly-NetiahHafsahSiti-143758
   ```
   

# TASK 1 - Number Classifier Program 
## Overview

- **Purpose**: This program classifies a user-input number as **POSITIVE**, **NEGATIVE**, or **ZERO** using control flow and conditional jumps.
- **Description**: The program prompts the user for an input number, and then it uses conditional jumps (`jg`, `jl`, and `jmp`) to classify the number and print the corresponding message. It demonstrates the use of conditional and unconditional jumps in assembly.
  
## Compiling and Running Task 1

1. **Assemble the program using the following command:**
   
    ```bash
    nasm -f elf64 TASK1_number_classifier.asm -o TASK1_number_classifier.o
   ```
2. **Link the object file:**

   ```bash
   ld TASK1_number_classifier.o -o TASK1_number_classifier
   ```
3. **Run the Program:**
   ```bash
   ./TASK1_number_classifier
   ```

## Insights and Challenges
   
# TASK 2 - Array Manipulation with Looping and Reversal Program
## Overview
This program accepts five single-digit numbers from the user, stores them in an array, and reverses the array in place using a two-pointer technique. The reversed digits are then printed to the screen. The program ensures that the user input is validated to only allow digits between 0 and 9, and does not use any additional memory to store the reversed array.

## Compiling and Running Task 2
1. **Assemble the program using the following command:**

    ```bash
   nasm -f elf64 -o TASK2_reverse_array.o TASK2_reverse_array.asm
   ```
2. **Link the object file:**

   ```bash
   ld TASK2_reverse_array.o -o TASK2_reverse_array
   ```
3. **Run the Program:**
   ```bash
   ./TASK2_reverse_array
   ```

## Requirements Met
### 1. **Avoid Using Additional Memory to Store the Reversed Array:**
The code avoids using additional memory to store the reversed array by reversing the array in place. This is done by swapping elements within the same array buffer. No extra array or buffer is created for storing the reversed sequence.

This can be seen in the code below:
```bash
reverse_loop:
    cmp r12, r13
    jge print_array         ; Exit loop if left >= right

    ; Swap elements at r12 (left index) and r13 (right index)
    mov al, [array + r12]   ; Load left element
    mov bl, [array + r13]   ; Load right element
    mov [array + r12], bl   ; Swap right to left
    mov [array + r13], al   ; Swap left to right

    ; Move indices towards the center
    inc r12
    dec r13
    jmp reverse_loop

```
Two pointers, r12 and r13, are used to track indices for swapping:

- r12 starts at the leftmost element (index 0).
- r13 starts at the rightmost element (index 4).

The elements are swapped directly within the array buffer. Specifically:
- The value at [array + r12] is exchanged with the value at [array + r13].
  
This modifies the array in place without creating additional storage.


### 2.  **Use Loops to Perform the Reversal:**
A loop is used to traverse the array and perform the swapping operation. The loop continues until the left index (r12) meets or crosses the right index (r13), ensuring all elements are swapped.

This can be seen in the code below:
``` bash
reverse_loop:
    cmp r12, r13
    jge print_array         ; Exit loop if left >= right

    ; Swap elements at r12 (left index) and r13 (right index)
    mov al, [array + r12]   ; Load left element
    mov bl, [array + r13]   ; Load right element
    mov [array + r12], bl   ; Swap right to left
    mov [array + r13], al   ; Swap left to right

    ; Update pointers
    inc r12
    dec r13
    jmp reverse_loop
```
The loop compares the indices `r12` and `r13` to check if they should continue swapping. Each iteration swaps a pair of elements and moves the indices closer to the center (`r12` increments, `r13` decrements). The loop ends when all elements are reversed, signaled by the condition `jge print_array`.

## Insights and Challenges




# TASK 3 - Factorial Calculator Program
## Overview
This program calculates the factorial of a number entered by the user. It demonstrates modular programming by using subroutines for factorial calculation and number-to-string conversion. The stack is utilized to preserve registers during subroutine calls.

## Compiling and Running Task 3
1. **Assemble the program using the following command:**
    ```bash
   nasm -f elf64 TASK3_factorial.asm -o TASK3_factorial.o
   ```
2. **Link the object file:**
   ```bash
   ld TASK3_factorial.o -o TASK3_factorial
   ```
3. **Run the Program:**
   ```bash
   ./TASK3_factorial
   ```
## Insights and Challenges

# TASK 4 - 

- **Purpose**: Simulates a control system that reads sensor values and controls a motor or triggers an alarm based on the sensor input.
- **Description**: The program reads a simulated water level sensor value and performs actions such as turning on a motor or triggering an alarm. It demonstrates memory manipulation using ports for monitoring and control purposes.

# ICS3203-CAT2-Assembly-NetiahHafsahSiti-143758
