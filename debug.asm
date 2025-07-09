# debug.asm - Debugging functions
.text


# Print the current state of the board for debugging
print_board_state:
    li $t0, 0              # index = 0
    
    li $v0, 4
    la $a0, debug_header
    syscall

debug_loop:
    li $t1, 36
    bge $t0, $t1, debug_end
    
    # Print index
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, debug_separator
    syscall
    
    # Print product
    la $t2, products
    sll $t3, $t0, 2
    add $t4, $t2, $t3
    lw $t5, 0($t4)
    
    li $v0, 1
    move $a0, $t5
    syscall
    
    li $v0, 4
    la $a0, debug_separator
    syscall
    
    # Print owner
    la $t2, board_owner
    add $t4, $t2, $t3
    lw $t5, 0($t4)
    
    li $v0, 1
    move $a0, $t5
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    addi $t0, $t0, 1
    j debug_loop
    
debug_end:
    jr $ra