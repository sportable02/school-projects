# this program displays 5 random number in range 1..10

.data
   result:  .asciiz "Random number is "
.text
	li $v0, 30 				 # service call to get clock time
	syscall                  # $a0 will contain the 32 low order bits of system time
	move $t0, $a0            # move time to reg $t0

	li $v0, 40 				 # service call to set seed of random number generator
	li $a0, 0                # give an id to the generator (in case there were more than 1)
	move $a1, $t0            # move time to act as the seed to $a1
	syscall

	li $s1, 0 				# loop control variable for "for loop"
	li $s2, 5 				# final value of the for loop
start_loop:
	# branch out of loop if loop control variable reaches 5
	slt $t0, $s1, $s2 		# is loop control < 5?
	beqz $t0, end_loop 		# branch to end of loop on false
	
	li $v0, 42				# service call to generate random integer in range 0..high
	li $a0, 0               # use the generator id
	li $a1, 9 				# set $a1 to the high value 9 
	syscall                 # random number is left in $a0
	move $t1, $a0 			# move the random number to save reg $t1
	addi $t1, $t1, 1        # add 1 to get the range 1..10

	# display the answer
	la $a0, result
	move $a1, $t1
	jal PrintInt
	jal PrintNewLine
	
	addi $s1, $s1 1 		# add 1 to loop control variable
	b start_loop 			# return to top of loop
end_loop:
	jal Exit
.include "utils.asm"