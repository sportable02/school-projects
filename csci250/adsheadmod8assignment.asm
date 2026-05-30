# Module 8 Assignment - Ethan Adshead
# CSCI 250 - Roberts

# This program is designed to prompt the user to guess an random integer in the range 1 to 10 using looping
# to continue until the user has successfully guessed it, all while giving them hints.

.data
	numberprompt:	.asciiz	"Enter number 1..10: "
	lowmsg:		.asciiz "Too low"
	highmsg:	.asciiz	"Too high"
	correctmsg:	.asciiz "You guessed it!"
	triesmsg:	.asciiz "Count of tries: "
	result:  .asciiz "Random number is "

.text

	# Generate random number and store in $s0
	li $v0, 30 				 # service call to get clock time
	syscall                  # $a0 will contain the 32 low order bits of system time
	move $t0, $a0            # move time to reg $t0

	li $v0, 40 				 # service call to set seed of random number generator
	li $a0, 0                # give an id to the generator (in case there were more than 1)
	move $a1, $t0            # move time to act as the seed to $a1
	syscall
	
	li $v0, 42				# service call to generate random integer in range 0..high
	li $a0, 0               # use the generator id
	li $a1, 9 				# set $a1 to the high value 9 
	syscall                 # random number is left in $a0
	move $s0, $a0 			# move the random number to save reg $t1
	addi $s0, $s0, 1        # add 1 to get the range 1..10
	
	# display the answer
	la $a0, result
	move $a1, $s0
	jal PrintInt
	jal PrintNewLine
	
	li $s1, 1			# initialize the a loop counter at $s0 to 1
start_loop:
	# Prompt user for number
	la $a0, numberprompt		# load address of string numberprompt in reg $a0
	jal PrintString			# print string
	# Read number from user
	li $v0, 5			# load instruction 5 (print integer)
	syscall				# read integer from user to store in $v0
	move $t0, $v0			# move integer in $v0 to reg $t0 
	# Compare number to 6
	seq $t1, $s0, $t0		# set $t1 equal to 1 if number is equal to 6 or 0 if not
	# End loop if number is 6
	bnez $t1, end_loop		# branch to end_loop if value in $t1 is equal to 1
	# Check number greater or less than 6
	slt $t2, $t0, $s0		# set $t2 to 1 if $t0 is less than 6 or 0 if greater
	beqz $t2, high			# branch to high subprogram if the answer is greater than 6
	
	# Code when number is lower than 6 
	la $a0, lowmsg			# load address of string lowmsg in reg $a0
	jal PrintString			# print string
	jal PrintNewLine		# print newline
	b continue			# branch to the end of the loop (continue subprogram)
	
high:
	# Code when number is greater than 6
	la $a0, highmsg			# load address of string highmsg in reg $a0
	jal PrintString			# print string
	jal PrintNewLine		# print newline
	
continue:
	# End of loop code 
	addi $s1, $s1, 1		# increment counter by 1
	b start_loop

end_loop:
	# Print success message
	la $a0, correctmsg		# load address of correctmsg string in reg $a0
	jal PrintString			# print string
	jal PrintNewLine		# print newline
	# Print # of tries taken	
	la $a0, triesmsg		# load address of triesmsg string in reg $a0
	move $a1, $s1			# move program counter to arg reg $a1 
	jal PrintInt			# print integer
	jal Exit

.include "utils.asm"