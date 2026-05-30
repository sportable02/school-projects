# Ethan Adshead - Module 15 Assignment
# CSCI 250 - Carol Roberts

# This program asks a user for the x and y values for 3 points in 2D space and checks if they make
# a triangle. For them to form a triangle they must all be unique points.

.data
	firstpointsmsg:	.asciiz "Points 1 and 2 contain:\n"
	secondpointsmsg:.asciiz "Points 2 and 3 contain:\n"
	trianglemsg:	.asciiz "We have a triangle!"
.text
	# retrieve point 1 user values
	jal FillPoint			# jump to FillPoint subprogram
	move $s0, $v0			# save return value in $v0 to $s0
	
	# retrieve point 2 user values
	jal FillPoint			# jump to FillPoint subprogram
	move $s1, $v0			# save return value in $v0 to $s1
	
	# retrieve point 3 user values
	jal FillPoint			# jump to FillPoint subprogram
	move $s2, $v0			# save return value in $v0 to $s2
	
	# print points 1 & 2 messages
	li $v0, 4			# load instruction 4 (print string)
	la $a0, firstpointsmsg		# load address of firstpointsmsg in $a0 reg
	syscall				# print string
	move $a0, $s0			# add first point value to $a0 arg reg for displaying
	jal DisplayPoint		# jump to DisplayPoint subprogram
	move $a0, $s1			# add second point value to $a0 arg reg for display
	jal DisplayPoint		# jump to DisplayPoint subprogram
	
	# test point equality
	move $a0, $s0			# move $s0 point to arg reg $a0 for equality test
	move $a1, $s1			# move $s1 point to arg reg $a1 for equality test
	jal EqualPoint			# jump to EqualPoint
	move $t0, $v0			# move return value in $v0 to $t0 for computation
	teqi $t0, 1 			# test equality and throw exception if points are equal
	bnez $t0, Exit			# end program if point 1 and 2 are equal
	
	# print points 2 & 3 messages
	li $v0, 4			# loads instruction 4 (print string)
	la $a0, secondpointsmsg		# load address of secondpointsmsg in $a0 reg
	syscall				# print string
	move $a0, $s1			# add third point value to $a0 arg reg for displaying
	jal DisplayPoint		# jump to DisplayPoint subprogram
	move $a0, $s2			# add fourth point value to $a0 arg reg for display
	jal DisplayPoint		# jump to DisplayPoint subprogram
	
	# test point equality
	move $a0, $s1			# move $s1 point to arg reg $a0 for equality test
	move $a1, $s2			# move $s2 point to arg reg $a1 for equality test
	jal EqualPoint			# jump to EqualPoint
	move $t0, $v0			# move return value in $v0 to $t0 for computation
	teqi $t0, 1 			# test equality and throw exception if points are equal
	bnez $t0, Exit			# end program if point 1 and 2 are equal
	
	# print success message
	li $v0, 4			# load instruction 4 (print string)
	la $a0, trianglemsg		# load address of trianglemsg string in $a0 reg
	syscall				# print string
Exit:
	# Exit program
	li $v0, 10			# load instruction 10 (Exit program)
	syscall
.kdata
	errormsg:	.asciiz "Equal points is a fatal error"
.ktext 0x80000180			# address of handler in kernel text is start of code
	
	# Identify exception
	mfc0 $k0, $13			# move contents of coproc reg $13 (cause reg) to reg $k0
	srl $k0, $k0, 2			# shift right logical on cause reg by 2 bits to remove 0..1
	andi $k0, $k0, 0x1F		# and $k0 with 0001 1111 to isolate 5 bits of exception code
	
	# Branch to handlers
	beq $k0, 13, equalityhandler	# branch to negative number handler if cause code is 13
	eret				# return to user mode
	
equalityhandler:
	# Print exception message
	li $v0, 4			# load instruction 4 (print string)
	la $a0, errormsg		# load address of errormsg string in $a0 arg reg
	syscall	
	
	# Calculate return address
	mfc0 $k0, $14			# move contents from epc reg to $k0
	addi $k0, $k0, 4		# add 4 bytes to get next line address
	mtc0 $k0, $14			# move contents of $k0 (new address) to epc reg
	eret

.include "point.asm"