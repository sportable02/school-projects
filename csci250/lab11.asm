# Lab 11 by Ethan Adshead
# This lab illustrates array processing using the heap
.data 
	indexprompt:    .asciiz "Enter index: "
	errorprompt:    .asciiz "Invalid index"
.text
main:
	# create int array of capacity 5 on the heap
	li $s0, 5 			# array capacity is 5
	mul $s1, $s0, 4 	# total bytes needed is capacity * 4 
	li $v0, 9 			# load instruction 9 (allocate memory on heap)
 	move $a0, $s1		# load number of bytes to arg reg $a0 in prep for syscall
 	syscall 			# start address of block on heap returned in $v0
 	move $s2, $v0       # move start address of array in the heap to save reg $s2

	# input array
	move $a0, $s2 		# move base address of int array to $a0
	move $a1, $s0 		# move capacity to $a1
	jal InputArray
	
	# output array
	move $a0, $s2 		# move base address of int array to $a0
	move $a1, $s0 		# move capacity to $a1
	jal OutputArray
	jal PrintNewLine
	
	# Task 1
	# iterate over the array and count the number of positive numbers
	li $t0, 0 				# loop control variable
	li $t1, 0 				# counter of positive numbers
toploop:
	slt $t2, $t0, $s0 		# compare loop control variable to capacity
	beqz $t2, endloop   	# if false, loop is done
	# here we process a valid index
	# compute address of this element: base + index * 4	
	mul $t3, $t0, 4			# compute index * 4
	add $t3, $s2, $t3		# add to base address and store back to $t3	
	lw $t4, 0($t3)			# fetch the value at address in $t3
	# code to count positive numbers
	sgt $t5, $t4, $zero		# is this number > 0?
	beqz $t5, elsenotpos	# branch on false to else, no counting
	# here we know number is > 0 so we need to count it
	add $t1, $t1, 1
elsenotpos:	
	add $t0, $t0, 1			# add 1 to loop control variable
	b toploop
endloop:
	# display our counter
	li $v0, 1
	move $a0, $t1
	syscall
	jal PrintNewLine

   # TODO: Task 2
   # Ask the user for an index and report value at that index
   # Report error on invalid index out range
   # Read index from keyboard
   	la $a0, indexprompt		# load address of indexprompt in $a0 for printing
   	li $v0, 4			# load instruction 4 (print string)
   	syscall
   	li $v0, 5			# load instruction 5 (read int)
   	syscall
   	move $s3, $v0			# save return value in $v0 to reg $s3
   	 
   # compute address for this index and get value
   	slt $t0, $s3, $s0		# set $t0 to 0 if $s3 is greater or equal to capacity of array ($s0) or 1 if less than 
   # OR report error message if not valid
   	beqz $t0, invalidindex		# branch to invalidindex if the index is out of range
   	
   	mul $t1, $s3, 4			# compute index * 4
   	add $t1, $s2, $t1		# add to base address and store back to $t1
   	lw $t2, 0($t1)			# fetch the value at address in $t1
   # display this value
	move $a0, $t2			# move value from array in $t2 to $a0 for printing
	li $v0, 1			# load instruction 1 (print int)
	syscall
	
  	b endprogram			# branch to endprogram to skip invalidindex
 invalidindex:
  # report error message
  	la $a0, errorprompt		# load address of error prompt in arg reg $a0 for printing
  	jal PrintString			# jump to PrintString subprogram to print string at address in $a0
 endprogram:
   li $v0, 10
   syscall
  
.include "arrayutils.asm"
.include "utils.asm"


