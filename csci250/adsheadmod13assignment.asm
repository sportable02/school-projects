# Ethan Adshead - Module 13 Assignment
# CSCI 250 - Carole Roberts

# This program prompts a user for a number, looping until they enter a valid number with the requirements
# of being non-negative and not overflowing. Subsequently, the number will be added to 2,000,000,000 and
# printed.

.data
	numberprompt:	.asciiz "Enter number: "
	summsg:		.asciiz "The sum is "
	twobillion:	.word	2000000000
.text
	lw $s0, twobillion		# load 2,000,000,000 into $s0 reg from memory for computation use
	
	li $t0, 0x7fffffff		# max int
	# User input validation loop
inputloop:
	li $v0, 4			# load instruction 4 (print string)
	la $a0, numberprompt		# load address of numberprompt string in arg reg $a0
	syscall				# print string
	li $v0, 5			# load instruction 5 (read integer)
	syscall				# read integer
	move $t1, $v0			# move value in $v0 to temp reg $t0 for calculation
	add $t2, $t1, $s0 		# add $t1 number to 2,000,000,000 and store in reg temp reg $t2
	b continueloop			# continue error checking and branch to next part of loop
	b inputloop			# iterate loop again (overflow exception returns here)
continueloop: 
	tlt $t1, $zero			# raise trap exception if input number < 0
	bltz $t1, inputloop		# if input value is < 0 branch to iterate loop again
	
	# Print sum output
	li $v0, 4			# load instruction 4 (print string)
	la $a0, summsg			# load address of summsg string in arg reg $a0
	syscall				# print string
	move $a0, $t2			# move sum into arg reg $a0 for printing
	li $v0, 1			# load instruction 1 (print integer)
	syscall				# print integer
	
	# Exit program
	li $v0, 10			# load instruction 10 (exit program)
	syscall				# exit program
.kdata
	negativemsg:	.asciiz "negative value error detected\n"
	overflowmsg:	.asciiz "arithmetic overflow error detected\n"
.ktext 0x80000180			# address of handler in kernel text is start of code
	
	# Identify exception
	mfc0 $k0, $13			# move contents of coproc reg $13 (cause reg) to reg $k0
	srl $k0, $k0, 2			# shift right logical on cause reg by 2 bits to remove 0..1
	andi $k0, $k0, 0x1F		# and $k0 with 0001 1111 to isolate 5 bits of exception code
	
	# Branch to handlers
	beq $k0, 13, negativehandler	# branch to negative number handler if cause code is 13 
	beq $k0, 12, overflowhandler	# branch to overflow handler if cause code is 12 
	eret				# return to user mode
negativehandler:
	
	# Print exception message
	li $v0, 4			# load instruction 4 (print string)
	la $a0, negativemsg		# load address of negativemsg string in $a0 arg reg
	syscall				# print string 
	
	# Calculate return address
	mfc0 $k0, $14			# move contents from epc reg to $k0
	addi $k0, $k0, 4		# add 4 bytes to get next line address
	mtc0 $k0, $14			# move contents of $k0 (new address) to epc reg
	eret				# return to user mode
overflowhandler:

	# Print exception message
	li $v0, 4			# load instruction 4 (print string)
	la $a0, overflowmsg		# load address of overflowmsg string in $a0 arg reg
	syscall				# print string
	
	# Calculate return address
	mfc0 $k0, $14			# move contents from epc reg to $k0
	addi $k0, $k0, 8		# add 8 bytes to get next line address
	mtc0 $k0, $14			# move contents of $k0 (new address) to epc reg
	eret				# return to user mode