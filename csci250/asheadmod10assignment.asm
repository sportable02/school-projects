# Ethan Adshead - Module 10 Assignment
# CSCI 250 - Roberts

# This program is designed to prompt the user for two numbers, find which one is the maximum and display
# that amount of stars

.data
	max:	  	.asciiz "Max is "
	star:		.asciiz "*"
.text
	# Prompt user for integer 1
	jal PromptInt		# jump to PromptInt subprogram
	move $s0, $v0		# move returned value in $v0 to arg reg $s0
	# Prompt user for integer 2
	jal PromptInt		# jump to PrompInt subrprogram
	move $a1, $v0		# move return value in $v0 to arg reg $a1
	# Move first int to arg reg $a0 for use in Max subprogram
	move $a0, $s0		# move $s0 to arg reg $a0
	
	# Call Max subprogram and print returned value in $v0
	jal Max			# "call" Max function
	move $s1, $v0		# move value in $v0 to reg $s1 to save
	la $a0, max		# load address of string max in reg $a0
	move $a1, $s1		# move value in $s0 to reg $a0 for printing
	jal PrintInt		# jump to PrintInt subprogram
	jal PrintNewLine
	
	# Print Stars
	move $a0, $s1		# move value in $s1 to $a0 for use in PrintStars function
	jal PrintStars		# "call" PrintStars function
	
	# Exit Program
	jal Exit
	
# Subroutine Max returns max of $a0 and $a1
# Input:	$a0 stores first number, $a1 stores second number
# Output:	$v0 stores result (maximum number)
Max:	
	# move values in $a0 and $a1 to $t0 and $t1 for computation
	move $t0, $a0
	move $t1, $a1
	
	# check which value is higher
	blt $t0, $t1, first_less# branch to FirstLess
	move $v0, $t0 		# move $t0 to return value $v0
	b end_max
first_less:
	move $v0, $t1		# move $t1 to return value $v0
end_max:
	jr $ra			# jump back to caller return address

# Subroutine PrintStars prints given amount of stars in input
# Input:	$a0 stores the amount of stars to print
# Output: 	none
PrintStars:
	# allocate 8 bytes for return address and input argument
	addi $sp, $sp, -8	# allocate 8 bytes on the call stack
	sw $ra 0($sp)		# save address in $ra to offset 0 from $sp
	sw $a0 4($sp)		# save amount of stars in $a0 to offset 4 from $sp
	
	# base case
	beqz $a0, end_if	 # branch to end_if to end the recursion
	
	# Print a star
	la $a0, star		# load address of star string in $a0
	jal PrintString		# jump to PrintString subprogram
	
	# Recursive case
	lw $a0, 4($sp)		# get the amount of stars from the stack into $a0
	addi $a0, $a0, -1	# decrease amount of stars to print by 1
	jal PrintStars		# "call" PrintStars again
	
end_if:				# pop the stack
	lw $ra, 0($sp)		# load return address from the stack back into $ra
	addi $sp, $sp, 8	# set stack pointer $sp back to where it was when function was called
	jr $ra			# return to line after most recent jal PrintStars
	
.include "utils.asm"
