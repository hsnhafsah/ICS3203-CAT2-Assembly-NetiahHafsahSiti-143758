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

## Challenges
1. **Handling Negative Numbers:** Initially, negative numbers were incorrectly classified as positive. I fixed this by adjusting the conversion logic to properly detect and apply the negative sign when parsing the input.

2. **Converting Input to Integer:** Converting the input string to an integer was tricky. I had to manually check each character to build the integer, which I resolved by improving the string-to-integer conversion.

3. **Invalid Input Handling:** The program needed to handle non-numeric inputs. I added checks to detect invalid characters and prompt the user to re-enter a valid number.

4. **Program Flow Control:** I had issues with the program not jumping to the correct sections for positive, negative, or zero numbers. I fixed this by refining the conditional jumps based on the converted value.

## Insights
1. **Assembly Requires Attention to Detail:**  This task taught me how much attention to detail is needed when working in assembly language. Unlike higher-level programming languages, every small step—such as handling each byte of data and performing manual checks—requires careful consideration.
   
2. **Input Validation is Key:** The process made me realize how critical input validation is, especially when you're dealing with raw data like strings. Without proper validation, even a small mistake (like entering a letter instead of a number) can lead to errors or unexpected behavior.
   
3. **Debugging is Harder in Assembly:** Debugging assembly code requires manually stepping through the logic, which taught me a lot about problem-solving.

   
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

## Challenges
1. **Managing Pointer Logic:**
Problem: Ensuring the two pointers (r12 and r13) moved correctly towards the center without skipping or repeating elements.
Solution: Incremented the left pointer and decremented the right pointer after each swap operation. Ensured the loop exited when the pointers met or crossed.

2. **Avoiding Overwriting During Swaps:**
Problem: Overwriting one of the values during the swap operation could result in data loss.
Solution: Utilized registers (al and bl) to temporarily store values from the array during the swap, ensuring data integrity.

4. **Loop Conditions:**
Problem: Creating the correct termination condition for the reversal loop. Errors in this logic led to infinite loops or missed elements.
Solution: The loop was structured to exit when the pointers (r12 and r13) met or crossed, using cmp r12, r13 followed by the appropriate jump instruction.

5. **Handling User Input:**
Problem: Invalid inputs such as characters outside the range '0'-'9' required careful handling to avoid crashes or incorrect behavior.
Solution: Implemented a validation step that checks if the input is within the ASCII range for digits and provides an error message if not, prompting the user to retry.

6. **Adding Multi-Digit Input Handling:**
Accepting and processing multi-digit inputs proved especially difficult. I struggled to read the entire input without splitting it incorrectly, which prevented me from properly interpreting multi-digit numbers.

## Insights
**In-Place Reversal Logic:**
Using two pointers (one starting at the beginning and the other at the end of the array) is an efficient and memory-saving approach for reversing an array. This method ensures that no additional memory is used while adhering to the requirement of in-place operations.




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
## Challenges
1. **Handling Input and Output:**
Converting user input (ASCII) into an integer and then converting the factorial result back into a string for display involved multiple conversions.

2. **Error Handling and Edge Cases:**
Ensuring correct behavior for edge cases like 0! = 1 and 1! = 1 required additional checks within the factorial subroutine.

3. **Stack Management:**
Mismanagement of the stack (e.g., forgetting to restore registers) caused incorrect outputs and crashes. Debugging these issues required careful review of push and pop pairs.

4. **String Construction in Reverse:**
Building the number string in reverse order (from least significant digit to most) in number_to_string added complexity.

## Insights
1. **Importance of Modularity:**
Modular programming using subroutines (factorial and number_to_string) made the code more structured and easier to debug. Each subroutine had a clear purpose, improving readability and reusability.

2. **Stack Utilization for Context Switching:**
Proper stack usage enabled seamless transitions between subroutines without impacting global state. This reinforced the importance of saving/restoring registers to maintain program integrity.

3. **Subroutine Reusability:**
The number_to_string subroutine can be reused in other programs requiring number-to-string conversion, demonstrating the value of designing reusable components.

4. **Edge Case Handling:**
Addressing edge cases early in the execution flow (e.g., 0! = 1) improved the program’s robustness and reduced unnecessary computations.

5. **Systematic Debugging:**
Debugging challenges, particularly with register mismanagement or incorrect stack operations, highlighted the value of a systematic approach to analyzing the flow of data through registers and the stack.

# TASK 4 - Water Level Control System Program
## Overview

This program simulates a water level control system, where a sensor value is input by the user to represent the current water level. Based on this sensor value, the system takes different actions:

1. **Low Water Level (< 5):** The motor turns ON, and no alarm is triggered.
2. **Moderate Water Level (5-10):** The motor remains OFF, and no alarm is triggered, since the water level is moderate.
3. **High Water Level (10 - 99):** The motor stays OFF, and an alarm is triggered.

The program also ensures that invalid inputs (non-numeric or out-of-range values) are rejected, with an appropriate error message displayed.

## Compiling and Running Task 4
1. **Assemble the program using the following command:**
    ```bash
   nasm -f elf64 TASK4_monitor.asm -o TASK4_monitor.o
   ```
2. **Link the object file:**
   ```bash
   ld TASK4_monitor.o -o TASK4_monitor
   ```
3. **Run the Program:**
   ```bash
   ./TASK4_monitor
   ```
## Insights and Challenges
1. **Input Validation**
One challenge I encountered in this task was ensuring that the user input was correctly validated and converted into an integer. This involved checking the input for invalid characters, such as non-numeric values, and handling inputs that were too long or out of the acceptable range.

2. **Threshold Classification**
The logic for comparing the sensor value to predefined thresholds (low, moderate, and high) was straightforward. However, I had to ensure that edge cases, such as values exactly at 5 or 10, were handled correctly. To achieve this, I used comparison instructions like cmp and conditional jumps (jl, jg, je).

3. **Output Formatting:**
Another challenge was managing the output messages effectively. The program needed to display different messages depending on whether the motor was on or off, and whether an alarm was triggered. This involved using jump instructions (jmp) to conditionally print appropriate messages.

4. **Error Handling:**
The error handling for invalid input was implemented by checking whether the entered characters were numeric and in the appropriate range (0-99). If not, the program would exit after printing an error message. This esures that users cannot enter data that could cause the program to behave unexpectedly.

