# point.asm contains functions for maintaing a Point struct
# struct Point { int x; int y; };

# EqualPoint subprogram checks if two (x, y) points are equal and returns 1 for true and 0 for false
# # Input: point 1 in $a0, point 2 in $a1
# # Output: true (1) or false (0) in $v0
.text
EqualPoint:
	# allocate space on the stack (push)
	addi $sp, $sp, -4		# move stack pointer 4 bytes to store return address
	sw $ra, 0($sp)			# save address in $ra to offset 0 from $sp
	
	# move first set of  point values in $a0 to $t0 and $t1 for computation
	lw $t0, 0($a0)			# $a0 -> $t0
	lw $t1, 4($a0)			# $a0 -> $t1
	
	# move second set of point values in $a1 to $t2 and $t3 for computation
	lw $t2, 0($a1)			# $a1 -> $t2 
	lw $t3, 4($a1)			# $a1 -> $t3
	
	# set initial return value
	li $v0, 0			# return value in $v0 is 0 in most cases
	
	# check x value equality
	bne $t0, $t2, endequalpoint 	# no need to check next point if the first isn't equal
	bne $t1, $t3, endequalpoint	# final check of y values in $t1 & $t3 registers
	li $v0, 1			# return value in $v0 set to 1 for equal
endequalpoint:
	# remove stack space (popping)
	lw $ra, 0($sp)			# get return address back from memory 
	addi $sp, $sp, 4		# return stack pointer to base position when EqualPoint "called"
	jr $ra				# return to "caller" at $ra address 

# FillPoint subprogram reads (x,y) data from keyboard and allocates heap memory
# # output: base address in $v0
.data
	xprompt: .asciiz "Enter value for x: "
	yprompt: .asciiz "Enter value for y: "	
.text
FillPoint:
	# allocate space on the stack (push)
	addi $sp, $sp, -4 		# we need 4 bytes to store return address
							# subtract 4 from current $sp
	sw $ra, 0($sp)			# save address in $ra to offset 0 from $sp
	# display x prompt
	li $v0, 4
	la $a0, xprompt
	syscall
	# read x integer from console and leave in $v0
	li $v0, 5 						
	syscall	
	move $t0, $v0 			# store x value in $t0
	# display y prompt
	li $v0, 4
	la $a0, yprompt
	syscall
	# read y integer from console and leave in $v0
	li $v0, 5 						
	syscall	
	move $t1, $v0 			# store y value in $t1
	
	# allocate 8 bytes on the heap
	li $v0, 9 				# load instruction 9 (allocate memory on heap)
 	li $a0, 8				# allocate 8 bytes 
 	syscall 				# start address of block on heap returned in $v0
 	# move x value into first 4 bytes
 	sw $t0, 0($v0)
 	# move y value into second 4 bytes
 	sw $t1, 4($v0)
 	
 	# remove space from the stack (pop)
	lw $ra, 0($sp) 			# load 4 bytes from offset 0 from $sp into $ra
	addi $sp, $sp, 4 		# add 4 to stack pointer
	jr $ra 					# jump back to caller

# DisplayPoint subprogram displays (x,y) data to console
# input:   base address in $a0
.data
	leftparen: .asciiz "("
	comma:     .asciiz ", "
	rightparen:.asciiz ")\n"
.text
DisplayPoint:
	# allocate space on the stack (push)
	addi $sp, $sp, -4 		# we need 4 bytes to store return address
						# subtract 4 from current $sp
	sw $ra, 0($sp)			# save address in $ra to offset 0 from $sp
	
	move $t0, $a0 			# move base address to keep safe
	
	# display left parenthesis
	li $v0, 4
	la $a0, leftparen
	syscall
	# display x integer 
	lw $t1, 0($t0)  		# load integer at 0 bytes from start address
	move $a0, $t1 			# move integer to arg reg $a0 in prep for syscall
	li $v0, 1 						
	syscall	 
	# display comma
	li $v0, 4
	la $a0, comma
	syscall
	# display y integer 
	lw $t1, 4($t0)  		# load integer at 4 byte offset from start address
	move $a0, $t1 			# move integer to arg reg $a0 in prep for syscall
	li $v0, 1 						
	syscall	 
	# display right parenthesis
	li $v0, 4
	la $a0, rightparen
	syscall
	
	# remove space from the stack (pop)
	lw $ra, 0($sp) 			# load 4 bytes from offset 0 from $sp into $ra
	addi $sp, $sp, 4 		# add 4 to stack pointer
	jr $ra 				    # jump back to caller
	
