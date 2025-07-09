# board.asm - Board representation and drawing functions
.text
.globl init_board
.globl draw_board
.globl update_board
.globl is_board_full


# Initialize board (set all ownership to 0)
init_board:
    li $t0, 0              # index = 0
    la $t1, board_owner

init_loop:
    li $t2, 36
    bge $t0, $t2, init_done
    
    sll $t3, $t0, 2        # offset = index * 4
    add $t4, $t1, $t3      # address of board_owner[i]
    sw $zero, 0($t4)       # board_owner[i] = 0
    
    addi $t0, $t0, 1
    j init_loop
    
init_done:
    jr $ra

# Draw the game board
draw_board:
    # Save return address
    sub $sp, $sp, 4
    sw $ra, 0($sp)
    
    li $t0, 0              # index = 0
    
    # Print header
    li $v0, 4
    la $a0, board_header
    syscall

row_loop:
    li $t1, 0              # column counter = 0

col_loop:
    la $t2, products
    la $t3, board_owner

    sll $t4, $t0, 2        # offset = index * 4
    add $t5, $t2, $t4      # address of products[i]
    add $t6, $t3, $t4      # address of board_owner[i]

    lw $t7, 0($t5)         # product value
    lw $t8, 0($t6)         # ownership

    beq $t8, 1, print_X    # player owns it
    beq $t8, -1, print_O   # computer owns it

    # Print the number with proper spacing
    li $v0, 1              # syscall: print_int
    move $a0, $t7
    syscall
    
    # Format spacing based on number of digits
    li $t9, 10
    blt $t7, $t9, print_double_space    # 1 digit
    li $t9, 100
    blt $t7, $t9, print_single_space    # 2 digits
    j print_continue                     # 3 digits

print_X:
    li $v0, 4
    la $a0, player_symbol
    syscall
    j print_double_space

print_O:
    li $v0, 4
    la $a0, computer_symbol
    syscall
    j print_double_space

print_double_space:
    li $v0, 4
    la $a0, double_space
    syscall
    j print_continue

print_single_space:
    li $v0, 4
    la $a0, space
    syscall
    j print_continue

print_continue:
    addi $t0, $t0, 1       # index++
    addi $t1, $t1, 1       # col++
    li $t9, 6
    blt $t1, $t9, col_loop

    li $v0, 4
    la $a0, newline
    syscall

    li $t9, 36
    blt $t0, $t9, row_loop

    # Restore return address
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

# Update the board with a move
# Inputs:
#   $a0 = pointer 1 (1-9)
#   $a1 = pointer 2 (1-9)
#   $a2 = owner (1 for player, -1 for computer)
# Outputs:
#   $v0 = 1 if successful, 0 if invalid move (space occupied)
update_board:
    # Save return address and registers
    sub $sp, $sp, 16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    # Save parameters
    move $s0, $a0    # pointer 1
    move $s1, $a1    # pointer 2
    move $s2, $a2    # owner
    
    # Calculate product
    mul $t2, $s0, $s1
    
    # Debug output
    li $v0, 4
    la $a0, debug_msg1
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, and_msg
    syscall
    
    li $v0, 1
    move $a0, $s1
    syscall
    
    li $v0, 4
    la $a0, debug_msg2
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Find the product on the board
    li $t0, 0              # index = 0
    li $v0, 0              # default: invalid move

update_loop:
    li $t1, 36
    bge $t0, $t1, update_not_found

    la $t4, products
    sll $t5, $t0, 2
    add $t6, $t4, $t5
    lw $t7, 0($t6)         # product value

    bne $t2, $t7, update_next  # not the right product
    
    # Found the product, check if occupied
    la $t4, board_owner
    add $t6, $t4, $t5
    lw $t8, 0($t6)         # current owner
    
    bnez $t8, update_occupied   # already owned
    
    # Spot is free, update it
    sw $s2, 0($t6)         # set new owner
    li $v0, 1              # valid move
    
    # Debug message
    li $v0, 4
    la $a0, debug_msg3
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, debug_msg4
    syscall
    
    li $v0, 1
    move $a0, $s2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 1              # Return success
    j update_done

update_next:
    addi $t0, $t0, 1
    j update_loop

update_occupied:
    # Debug message for occupied spot
    li $v0, 4
    la $a0, debug_msg5
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, debug_msg6
    syscall
    
    li $v0, 1
    move $a0, $t8
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 0              # Return failure
    j update_done

update_not_found:
    # Debug message for product not found
    li $v0, 4
    la $a0, debug_msg7
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 0              # Return failure

update_done:
    # Restore registers and return address
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    add $sp, $sp, 16
    jr $ra

# Check if the board is full
# Output: $v0 = 1 if full, 0 if not full
is_board_full:
    li $t0, 0              # index = 0
    li $v0, 1              # assume full

check_full_loop:
    li $t1, 36
    bge $t0, $t1, check_full_done
    
    la $t2, board_owner
    sll $t3, $t0, 2
    add $t4, $t2, $t3
    lw $t5, 0($t4)         # owner value
    
    beqz $t5, found_empty  # found empty space
    
    addi $t0, $t0, 1
    j check_full_loop
    
found_empty:
    li $v0, 0              # not full
    
check_full_done:
    jr $ra

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
