# computer.asm - Computer AI and move functionality
.text
.globl computer_move

# Handle computer move with improved AI strategy
computer_move:
    # Save return address
    sub $sp, $sp, 4
    sw $ra, 0($sp)
    
    # For simplicity, just make a random valid move for now
    jal make_random_move
    
    # Restore return address and return
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

# Make a random valid move
# Output: Directly updates the board
make_random_move:
    # Save return address
    sub $sp, $sp, 4
    sw $ra, 0($sp)

random_retry:
    # Generate random pointer 1 (1-9)
    li $v0, 42     # random int
    li $a0, 0      # seed
    li $a1, 9      # upper bound
    syscall
    addi $t0, $a0, 1
    
    # Generate random pointer 2 (1-9)
    li $v0, 42
    li $a0, 0
    li $a1, 9
    syscall
    addi $t1, $a0, 1
    
    # Print computer's move
    li $v0, 4
    la $a0, computer_move_msg
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, and_msg
    syscall
    
    li $v0, 1
    move $a0, $t1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Update the board with the computer's move
    move $a0, $t0         # pointer 1
    move $a1, $t1         # pointer 2
    li $a2, -1            # owner = computer (-1)
    jal update_board
    
    # If move was invalid, try again
    beqz $v0, random_retry
    
    # Store pointers
    la $t2, computer_ptr1
    sw $t0, 0($t2)
    la $t2, computer_ptr2
    sw $t1, 0($t2)
    
    # Restore return address and return
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra