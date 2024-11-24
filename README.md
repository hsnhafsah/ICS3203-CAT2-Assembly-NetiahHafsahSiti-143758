# ICS3203-CAT2-Assembly-NetiahHafsahSiti-143758

# 1. Number Classifier Program (number_classifier.asm)

- **Purpose**: This program classifies a user-input number as **POSITIVE**, **NEGATIVE**, or **ZERO** using control flow and conditional jumps.
- **Description**: The program prompts the user for an input number, and then it uses conditional jumps (`jg`, `jl`, and `jmp`) to classify the number and print the corresponding message. It demonstrates the use of conditional and unconditional jumps in assembly.
  
## Compiling and Running Task 1
1. **Assemble the program using the following command:**

    ```bash
   nasm -f elf64 number_classifier.asm -o number_classifier.o
   ```
2. **Link the object file:**

   ```bash
   ld -s -o number_classifier number_classifier.o
   ```
3. **Run the Program:**
   ```bash
   ./number_classifier
   ```
   


### 2. **Array Manipulation and Reversal**

- **Purpose**: This program accepts an array of integers and reverses it in place without using additional memory.
- **Description**: The program uses a loop to iterate through the array and swap elements in place, effectively reversing the array. It demonstrates how to manipulate arrays and perform in-place operations in Assembly.

### 3. **Factorial Calculation (factorial.asm)**

- **Purpose**: Computes the factorial of a number using a subroutine.
- **Description**: The program calculates the factorial of a given number by calling a subroutine that performs the recursive calculation. It also demonstrates stack management by saving and restoring registers during the recursive calls.

### 4. **Data Monitoring and Control Using Port-Based Simulation**

- **Purpose**: Simulates a control system that reads sensor values and controls a motor or triggers an alarm based on the sensor input.
- **Description**: The program reads a simulated water level sensor value and performs actions such as turning on a motor or triggering an alarm. It demonstrates memory manipulation using ports for monitoring and control purposes.

## Instructions

### Prerequisites
1. **Assembler**: The program is written in **x86-64 Assembly** and requires an assembler such as `nasm` to assemble the code.
2. **Linker**: You will need `ld` to link the object files into executables.

### Compiling and Running the Code

To compile and run the code, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/hsnhafsah/ICS3203-CAT2-Assembly-NetiahHafsahSiti-143758.git
   cd ICS3203-CAT2-Assembly-NetiahHafsahSiti-143758
# ICS3203-CAT2-Assembly-NetiahHafsahSiti-143758
