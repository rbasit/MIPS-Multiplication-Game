# win.asm - Win checking functionality
.text
.globl check_win

# Check if there's a winner or a tie
# Output: $v0 = 0 (no winner), 1 (player wins), 2 (computer wins), 3 (tie)
check_win:
    # Save return address
    sub $sp, $sp, 4
    sw $ra, 0($sp)
    
    li $t0, 0              # index = 0
    li $v0, 0              # default: no winner

check_loop:
    li $t1, 36
    bge $t0, $t1, check_tie  # if no win found, check for tie

    la $t2, board_owner
    sll $t3, $t0, 2
    add $t4, $t2, $t3
    lw $t5, 0($t4)         # owner at index

    beqz $t5, next_index   # skip if empty

    # row = t8 = index / 6
    # col = t9 = index % 6
    li $t6, 6
    div $t0, $t6
    mflo $t8               # row
    mfhi $t9               # col

    # === check horizontal (right)
    li $t6, 3
    ble $t9, $t6, check_right

check_right_done:
    # === check vertical (down)
    li $t6, 3
    ble $t8, $t6, check_down

check_down_done:
    # === check diagonal \ 
    li $t6, 3
    ble $t8, $t6, check_diag_r
    li $t6, 3
    ble $t9, $t6, check_diag_r

check_diag_r_done:
    # === check diagonal /
    li $t6, 3
    ble $t8, $t6, check_diag_l
    li $t6, 3
    bge $t9, $t6, check_diag_l

check_diag_l_done:
    j next_index

######## CHECK RIGHT ########
check_right:
    lw $a0, 0($t4)
    
    # Calculate the offset to the next position (4 bytes right)
    add $t6, $t4, 4
    lw $a1, 0($t6)
    
    # Calculate the offset to the next position (8 bytes right)
    add $t6, $t4, 8
    lw $a2, 0($t6)
    
    # Calculate the offset to the next position (12 bytes right)
    add $t6, $t4, 12
    lw $a3, 0($t6)

    beq $a0, $a1, cr2
    j check_right_done
cr2:
    beq $a0, $a2, cr3
    j check_right_done
cr3:
    beq $a0, $a3, win_found
    j check_right_done

######## CHECK DOWN ########
check_down:
    lw $a0, 0($t4)
    
    # Calculate the offset to the next position (6*4=24 bytes down)
    add $t6, $t4, 24
    lw $a1, 0($t6)
    
    # Calculate the offset to the next position (12*4=48 bytes down)
    add $t6, $t4, 48
    lw $a2, 0($t6)
    
    # Calculate the offset to the next position (18*4=72 bytes down)
    add $t6, $t4, 72
    lw $a3, 0($t6)

    beq $a0, $a1, cd2
    j check_down_done
cd2:
    beq $a0, $a2, cd3
    j check_down_done
cd3:
    beq $a0, $a3, win_found
    j check_down_done

######## CHECK DIAGONAL \ ########
check_diag_r:
    lw $a0, 0($t4)
    
    # Calculate the offset to the next position (7*4=28 bytes diagonal)
    add $t6, $t4, 28
    lw $a1, 0($t6)
    
    # Calculate the offset to the next position (14*4=56 bytes diagonal)
    add $t6, $t4, 56
    lw $a2, 0($t6)
    
    # Calculate the offset to the next position (21*4=84 bytes diagonal)
    add $t6, $t4, 84
    lw $a3, 0($t6)

    beq $a0, $a1, cdr2
    j check_diag_r_done
cdr2:
    beq $a0, $a2, cdr3
    j check_diag_r_done
cdr3:
    beq $a0, $a3, win_found
    j check_diag_r_done

######## CHECK DIAGONAL / ########
check_diag_l:
    lw $a0, 0($t4)
    
    # Calculate the offset to the next position (5*4=20 bytes diagonal)
    add $t6, $t4, 20
    lw $a1, 0($t6)
    
    # Calculate the offset to the next position (10*4=40 bytes diagonal)
    add $t6, $t4, 40
    lw $a2, 0($t6)
    
    # Calculate the offset to the next position (15*4=60 bytes diagonal)
    add $t6, $t4, 60
    lw $a3, 0($t6)

    beq $a0, $a1, cdl2
    j check_diag_l_done
cdl2:
    beq $a0, $a2, cdl3
    j check_diag_l_done
cdl3:
    beq $a0, $a3, win_found
    j check_diag_l_done

######## FOUND A WIN ########
win_found:
    # $a0 contains the owner value (1 for player, -1 for computer)
    bgtz $a0, player_wins
    li $v0, 2              # computer wins
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

player_wins:
    li $v0, 1              # player wins
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

######## CHECK FOR TIE ########
check_tie:
    jal is_board_full
    beqz $v0, no_winner    # if not full, no winner yet
    li $v0, 3              # tie game
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

######## CONTINUE LOOP ########
next_index:
    addi $t0, $t0, 1
    j check_loop

no_winner:
    li $v0, 0              # no winner
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra
