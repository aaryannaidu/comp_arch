ASSIGNMENT 1: TRIANGULAR NUMBERS IN RISC-V

U Aarya Vardhan Naidu - 2024CS50484
Kashvi Khurana        - 2024CS10559

Example Input/Output and Test Cases:

Enter n (or 0 to exit): 40
Closed formula: 820
Iterative: 820
Recursive: 820
Memoized: 820

Enter n (or 0 to exit): 847
Closed formula: 359128
Iterative: 359128
Recursive: 359128
Memoized: 359128

Enter n (or 0 to exit): 121
Closed formula: 7381
Iterative: 7381
Recursive: 7381
Memoized: 7381

Enter n (or 0 to exit): 0
Program exited with code: 0 

LIMITATIONS :
Maximum Correct Input (n):
The maximum value of 'n' for which the program yields a correct 32-bit output is 65535.
- Why: The triangular number formula is n(n+1)/2. For the closed-form calculation, 
  the product n*(n+1) must fit within a 32-bit register before division by 2.
  At n = 65535, n*(n+1) = 65535 * 65536 = 4,294,901,760, which is just under the 
  limit of a 32-bit unsigned integer (2^32 - 1 = 4,294,967,295).
- Register Constraints: Since RISC-V registers (RV32) are 32 bits wide, any 
  intermediate result exceeding 2^32-1 will cause overflow, leading to incorrect 
  results for higher values of 'n'.

CODE INFORMATION : 

Program Overview:
This program calculates the n-th triangular number (sum of 1 to n) using four 
distinct methods: closed-form multiplication, an iterative loop, simple 
recursion, and memoized recursion.

Data Storage:
- Memo Array (262,144 bytes): A large zero-initialized array that stores 
  precomputed triangular numbers. Each entry is 4 bytes (1 word). The size 
  corresponds to storing results for n up to 65,535 (65536 * 4 bytes).
- Buffer Array (128 bytes): Used to store the raw input string from the console 
  before conversion to an integer.

System Calls (ECALL):
- 1  : print_int    (To display the calculated triangular number)
- 4  : print_string (To display prompts and labels)
- 10 : exit         (To terminate the program)
- 11 : print_char   (To print newlines/characters)
- 63 : read_string  (To capture user input from the console)

FUNCTIONS :

main_loop:
    The driver function that manages the execution flow. it prints the input prompt, 
    reads input using 'get_int', checks for the exit condition (n=0), and calls 
    each calculation function in sequence, printing their respective results.

get_int & convert:
    'get_int' reads a string from standard input into the buffer. 'convert' 
    then iterates through the string character-by-character, subtracting the 
    ASCII offset for '0' (48) and multiplying by 10 to build the integer value 
    in register s0.

tri_num_mul (Closed Formula):
    Efficiently calculates the result using the direct formula: n*(n+1)/2.
    Specifically: 
    1. t0 = a0 + 1
    2. t0 = a0 * t0
    3. a0 = t0 / 2

tri_num_loop (Iterative):
    Uses a standard 'for' loop logic. It initializes a counter at 1 and 
    accumulates sums until the counter exceeds 'n'.

tri_num_rec (Recursive):
    Implements a classic recursive approach: f(n) = n + f(n-1) with f(0) = 0.
    It manages the stack (sp) to save the return address (ra) and the current 
    value of 'n' at each depth.

tri_num_mem (Memoized Recursion):
    An optimized recursive approach. Before performing a recursive call, it 
    checks the 'memo' array at the offset corresponding to 'n'.
    - If the value is non-zero (already computed), it returns it immediately.
    - If zero, it recurses to find the value, then saves the result in the 
      memo array before returning to ensure future calls are O(1).
