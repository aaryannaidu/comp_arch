.data
memo: .zero 262144 # because n(n+1) must be handles in one int and this max n is 65,535
buffer: .zero 128
prompt_input: .string "\nEnter n (or 0 to exit): "
prompt_mul: .string "Closed formula: "
prompt_loop: .string "Iterative: "
prompt_rec: .string "Recursive: "
prompt_mem: .string "Memoized: "
newline: .string "\n"
        
.text
.globl main_loop

main_loop:
    # print prompt
    li a7, 4
    la a0, prompt_input
    ecall
    
    # read integer from console
    jal ra, get_int
    
    # check if input is 0 (exit condition)
    li t0, 0
    beq s0, t0, exit_program
    
    # call tri_num_mul
    li a7, 4
    la a0, prompt_mul
    ecall
    mv a0, s0
    jal ra, tri_num_mul
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    
    # call tri_num_loop
    li a7, 4
    la a0, prompt_loop
    ecall
    mv a0, s0
    jal ra, tri_num_loop
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    
    # call tri_num_rec
    li a7, 4
    la a0, prompt_rec
    ecall
    mv a0, s0
    jal ra, tri_num_rec
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    
    # call tri_num_mem
    li a7, 4
    la a0, prompt_mem
    ecall
    mv a0, s0
    jal ra, tri_num_mem
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    
    # loop back for next input
    j main_loop
    
exit_program:
    li a7, 10
    ecall

# loop to take input and convert to integer
get_int:
    li a7, 63             
    li a0, 0   
    la a1, buffer    
    li a2, 128 
    ecall
    
    li s0, 0 
    mv t2, a1   
    
# actual loop that converts the number character wise into integer, saves in s0
convert:
    lb t0 0(t2)
    li t1 10 # checks for character that specifies enter
    beq t0 t1 finish_convert
    li t1 48
    sub t0 t0 t1 # subtracts by ascii of 0 to make int
    li t3 10 # 
    mul s0 s0 t3 # multiplies number stored so far by 10 
    add s0 s0 t0 # adds current digit
    
    addi t2, t2, 1  # iterator jumps 1 byte forward
    j convert
    
finish_convert:    
    ret
    
# direct multiplication
tri_num_mul:
    addi t0, a0, 1
    mul  t0, a0, t0 # saves n*(n+1) into t0
    li   t2, 2
    div  a0, t0, t2 # divides by 2
    ret
    
#loop based
tri_num_loop:
    li t0 0
    li t1 1
    loop:
        bgt t1, a0, end # if t1 > a0, break loop
        add t0, t0, t1 # add current number into current sum
        addi t1, t1, 1 # increment iterator
        j loop
    end:
        mv a0 t0 # put accumulated sum into a0
        ret
        
#recursive   
tri_num_rec:
    addi sp sp -8 # make space in stack
    sw ra 4(sp) # save return address in stack
    sw a0 0(sp) # save current number in stack
    li t0 0
    bne a0 t0 rec # if a0 is not zero calls rec
    li a0 0 # base case
    addi sp sp 8 # pop stack in the base case
    ret 
rec:
    addi a0 a0 -1 # decrement current n
    jal ra tri_num_rec # calls tri_num_rec for recursion
    lw t1 0(sp) # loads current num from stack
    lw ra 4(sp) # loads return address from stack
    addi sp sp 8 # pop stack after recursive step is finished
    add a0 t1 a0 # add current number to accumulating sum
    ret
    
#memoised  
tri_num_mem:
    slli t0 a0 2 # multiply a0 by 4 because that is the offset we need in the memo
    la t1 memo # load address of memo
    li t2 -1 
    add t0 t0 t1 # add offset to address
    lw t4 0(t0) # load num at current address in the memo
    beq zero a0 base # if a0 is 0, we are at base case, jump to base
    beq zero t4 lp # since the others are also initialised to be zero, this is the other branch to call the loop
    mv a0 t4 # move loaded number to a0 (if the last two steps do not branch away, we get the largest precomputed number)
    ret
lp:
    mv t3 a0
    addi sp sp -8 # make space in stack
    sw ra 4(sp) # save return address in stack
    sw t3 0(sp) # save current number to stack
    addi a0 a0 -1 # decrement a0
    jal ra tri_num_mem # recurse
    lw t3 0(sp) # load current number to t3 (this step begins after reaching the last computed number or 0)
    lw ra 4(sp) # load return address from stack
    addi sp sp 8 # pop stack
    slli t0 t3 2 # multiply current num by 4 to find offset
    la t1 memo # load address of memo
    add t0 t1 t0 # add offset to address
    add t3 t3 a0 # add current num to accumulating sum
    sw t3 0(t0) # save accumulating sum till current number to its required location in memo
    mv a0 t3 # move current sum to a0
    ret
    
base:
    li a0 0
    ret