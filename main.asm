#Author: Rida Basit
#Four in a row multiplication game

# main.asm - Main program file
.text
.globl main

main:
    # Initialize board
    jal init_board
    jal draw_board

game_loop:
    # Player's turn
    jal player_move
    jal draw_board
    
    # Check for win or tie after player's move
    jal check_win
    beq $v0, 1, player_win  # Player won
    beq $v0, 3, game_tie    # Check for tie
    
    # Computer's turn - only if no win/tie yet
    jal computer_move
    jal draw_board
    
    # Check for win or tie after computer's move
    jal check_win
    beq $v0, 2, computer_win  # Computer won
    beq $v0, 3, game_tie      # Check for tie
    
    # Continue game loop
    j game_loop

player_win:
    li $v0, 4
    la $a0, win_message
    syscall
    j game_end

computer_win:
    li $v0, 4
    la $a0, lose_message
    syscall
    j game_end

game_tie:
    li $v0, 4
    la $a0, tie_message
    syscall
    
game_end:
    li $v0, 10              # Exit program
    syscall
