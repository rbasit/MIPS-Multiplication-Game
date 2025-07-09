.globl player_symbol
.globl prompt1
.globl player_ptr1
.globl prompt2
.globl player_ptr2
.globl newline
.globl computer_symbol
.globl products
.globl board_owner
.globl computer_ptr1
.globl computer_ptr2
.globl win_message
.globl lose_message
.globl space
.globl invalid_pointer_msg
.globl invalid_move_msg
.globl board_header
.globl double_space
.globl tie_message
.globl computer_move_msg
.globl and_msg
.globl player_move_msg
.globl debug_msg1
.globl debug_msg2
.globl debug_msg3
.globl debug_msg4
.globl debug_msg5
.globl debug_msg6
.globl debug_msg7
.globl debug_header
.globl debug_separator
.globl comp_winning_msg
.globl comp_blocking_msg



# data.asm - Game data and strings
.data
# Board products (6x6)
products: .word 1,2,3,4,5,6, 7,8,9,10,12,14, 15,16,18,20,21,24, 25,27,28,30,32,35, 36,40,42,45,48,49, 54,56,63,64,72,81

# Ownership of board positions: 0 = empty, 1 = player, -1 = computer
board_owner: .space 144    # 36 words (4 bytes each)

# Game messages
win_message: .asciiz "\nCongratulations, you won!\n"
lose_message: .asciiz "\nComputer wins! Better luck next time!\n"
tie_message: .asciiz "\nGame ends in a tie!\n"

# ASCII characters for moves
player_symbol: .asciiz "X"
computer_symbol: .asciiz "O"

# Pointer storage
player_ptr1: .word 1
player_ptr2: .word 1
computer_ptr1: .word 1
computer_ptr2: .word 1

# Prompts and messages
prompt1: .asciiz "Enter pointer 1 (1-9): "
prompt2: .asciiz "Enter pointer 2 (1-9): "
invalid_pointer_msg: .asciiz "Invalid pointer! Please enter a number between 1 and 9.\n"
invalid_move_msg: .asciiz "That spot is already taken! Try different pointers.\n"
player_move_msg: .asciiz "Player chooses pointers: "
computer_move_msg: .asciiz "Computer chooses pointers: "
and_msg: .asciiz " and "
comp_winning_msg: .asciiz " (making a winning move!)\n"
comp_blocking_msg: .asciiz " (blocking your win after 3 moves!)\n"
board_header: .asciiz "\n===== MULTIPLICATION GAME BOARD =====\n"
newline: .asciiz "\n"
space: .asciiz "  "
double_space: .asciiz "   "
debug_header: .asciiz "\n----- DEBUG BOARD STATE -----\n"
debug_separator: .asciiz " : "

# Debug messages
debug_msg1: .asciiz "\nDEBUG: Updating board with pointers "
debug_msg2: .asciiz " (product: "
debug_msg3: .asciiz "DEBUG: Setting board position "
debug_msg4: .asciiz " to owner "
debug_msg5: .asciiz "DEBUG: Position "
debug_msg6: .asciiz " already owned by "
debug_msg7: .asciiz "DEBUG: Product not found on board: "