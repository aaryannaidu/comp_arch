.data
memo: .space 4000
        
.text
.globl main
main:
    
    li a0 4
    jal ra, tri_num_loop
    li a7, 1
    ecall
    li a7, 10
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
    
memo_init:
    la t1 memo
    sw x0 0(t1)
    li t0 -1
    li t2 4000
    add t2 t1 t2
    addi t1 t1 4
    loops:
        beq t1 t2 stop
        sw t0 0(t1)
        addi t1 t1 4
        j loops
    stop:
        la t1 memo
        ret  

tri_num_mem:
    slli t0 a0 2
    la t1 memo
    li t2 -1
    add t6 t0 t1
    lw t4 0(t6)
    beq t2 t4 lp
    mv a0 t4
    ret
lp:
    mv t3 a0
    addi a0 a0 -1
    jal ra tri_num_mem
    add t3 t3 a0
    sw t3 0(t6)
    mv a0 t3
    ret
         
        
