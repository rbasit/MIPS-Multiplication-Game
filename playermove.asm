# player.asm - Player move functionality
.text
.globl player_move
.globl validate_move

# Handle player move
player_move:
    # Save return address and saved registers
    sub $sp, $sp, 12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

player_move_retry:
    # Prompt for first pointer
    li $v0, 4
    la $a0, prompt1
    syscall
    
    li $v0, 5              # read integer
    syscall
    move $s0, $v0          # store pointer1 in s0
    
    # Validate pointer1
    move $a0, $s0
    jal validate_move
    beqz $v0, invalid_ptr  # if not valid, retry
    
    # Prompt for second pointer
    li $v0, 4
    la $a0, prompt2
    syscall
    
    li $v0, 5              # read integer
    syscall
    move $s1, $v0          # store pointer2 in s1 (using saved register)
    
    # Validate pointer2
    move $a0, $s1
    jal validate_move
    beqz $v0, invalid_ptr  # if not valid, retry
    
    # Print player's move for confirmation
    li $v0, 4
    la $a0, player_move_msg
    syscall
    
    li $v0, 1
    move $a0, $s0          # use s0 for pointer1
    syscall
    
    li $v0, 4
    la $a0, and_msg
    syscall
    
    li $v0, 1
    move $a0, $s1          # use s1 for pointer2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Update board using the new interface
    move $a0, $s0          # pointer 1 from s0
    move $a1, $s1          # pointer 2 from s1
    li $a2, 1              # owner = player
    jal update_board
    
    beqz $v0, invalid_move # if move is invalid, retry
    
    # Store pointers (for potential use by computer AI)
    la $t4, player_ptr1
    sw $s0, 0($t4)         # s0 for pointer1
    la $t4, player_ptr2
    sw $s1, 0($t4)         # s1 for pointer2
    
    # Restore saved registers and return address
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    add $sp, $sp, 12
    jr $ra

invalid_ptr:
    li $v0, 4
    la $a0, invalid_pointer_msg
    syscall
    j player_move_retry

invalid_move:
    li $v0, 4
    la $a0, invalid_move_msg
    syscall
    j player_move_retry

# Validate a move (check if pointer is within valid range)
# Input: $a0 (pointer value), Output: $v0 = 1 (valid) or 0 (invalid)
validate_move:
    li $v0, 1          # assume valid
    li $t0, 1
    li $t1, 9
    blt $a0, $t0, invalid_pointer
    bgt $a0, $t1, invalid_pointer
    jr $ra

invalid_pointer:
    li $v0, 0
    jr $ra
