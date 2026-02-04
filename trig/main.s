.data
memo: .zero 4000
        
.text
.globl main
main:
#    jal ra, memo_init
    
    li a0 4
    jal ra, tri_num_mul
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    
    li a0 8
    jal ra, tri_num_loop
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    
    li a0 13
    jal ra, tri_num_rec
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    
    li a0 6
    jal ra, tri_num_mem
    li a7, 1
    ecall
    li a0 10
    li a7, 11
    ecall
    
    li a0 4
    jal ra, tri_num_mem
    li a7, 1
    ecall
    li a0 10
    li a7, 11
    ecall
    
    li a0 10
    jal ra, tri_num_mem
    li a7, 1
    ecall
    li a0 10
    li a7, 11
    ecall
    
    li a7 10
    ecall
# direct multiplication
tri_num_mul:
    addi t0, a0, 1
    mul  t1, a0, t0
    li   t2, 2
    div  a0, t1, t2
    ret
#loop based
tri_num_loop:
    li t0 0
    li t1 1
    loop:
        bgt t1, a0, end
        add t0, t0, t1
        addi t1, t1, 1
        j loop
    end:
        mv a0 t0
        ret
#recursive   
tri_num_rec:
    addi sp sp -8
    sw ra 4(sp)
    sw a0 0(sp)
    li t0 0
    bne a0 t0 rec
    li a0 0
    addi sp sp 8
    ret 
rec:
    addi a0 a0 -1
    
    jal ra tri_num_rec
    lw t1 0(sp)
    lw ra 4(sp)
    addi sp sp 8
    add a0 t1 a0
    ret
#memoised  
tri_num_mem:
    slli t0 a0 2
    la t1 memo
    li t2 -1
    add t0 t0 t1
    lw t4 0(t0)
    beq zero a0 base
    beq zero t4 lp
    mv a0 t4
    ret
lp:
    mv t3 a0
    addi sp sp -8
    sw ra 4(sp)
    sw t3 0(sp)
    addi a0 a0 -1
    jal ra tri_num_mem
    lw t3 0(sp)
    lw ra 4(sp)
    addi sp sp 8
    slli t0 t3 2
    la t1 memo
    add t0 t1 t0
    add t3 t3 a0
    sw t3 0(t0)
    mv a0 t3
    ret
    
base:
    li a0 0
    ret