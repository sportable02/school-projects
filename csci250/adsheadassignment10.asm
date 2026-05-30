# Ethan Adshead - Module 10 Assignment
# CSCI 250 - Carole Roberts

# This program is designed to do a sequential search over an array. The first index in the array that matches
# will be returned otherwise the program returns -1 if no match is found
.data 	
	targetprompt:	.asciiz	"Enter target: "
	foundmsg:	.asciiz "Found"
	notfoundmsg:	.asciiz "Not found"
	ninetynine:	.word 99
.text
main:
	# Allocate an integer array to hold 5 integers on the heap
	li $s0, 5 			# array capacity is 5
	mul $s1, $s0, 4 		# total bytes needed is capacity * 4 
	li $v0, 9 			# load instruction 9 (allocate memory on heap)
 	move $a0, $s1			# load number of bytes to arg reg $a0 in prep for syscall
 	syscall 			# start address of block on heap returned in $v0
 	move $s2, $v0       		# move start address of array in the heap to save reg $s2 
	
	# Call InputArray to fill the array with values from the keyboard.
	move $a0, $s2			# move base address into reg $a0 for use in InputArray subprogram
	move $a1, $s0			# move array capacity into reg $a1 for use in InputArray subprogram
	jal InputArray			# jump to InputArray subprogram
	
	# Call OutputArray to display the array.
	move $a0, $s2			# move base address into reg $a0 for use in OutputArray subprogram
	move $a1, $s0			# move array capacity into reg $a1 for use in OutputArray subprogram
	jal OutputArray			# jump to OutputArray subprogram
	jal PrintNewLine		# jump to PrintNewLine subprogram
	
	# Present a prompt and read a target from the keyboard.
	la $a0, targetprompt		# load address of targetprompt string into reg $a0 for printing
	li $v0, 4			# load instruction 4 (print string)
	syscall
	li $v0, 5 			# load instruction 5 (read int)
	syscall
	move $s3, $v0			# save target value from $v0 in $s3
	
	# Use the SearchArray subprogram with this target.
	move $a0, $s2			# move base address into reg $a0 for use in SearchArray subprogram
	move $a1, $s0			# move array capcity into reg $a1 for use in SearchArray subprogram
	move $a2, $s3			# move target value into reg $a2 for use in SearchArray subprogram
	jal SearchArray			# jump to SearchArray subprogram
	
	# Use the return value of the SearchArray subprogram to display one of two messages "Found" or "Not Found"	
	move $s4, $v0			# save the return value of SearchArray from $v0 to $s4
	bltz $s4, notfound		# if return value of SearchArray in $s4 is -1, display "Not found"			
	# If the target is found, replace that value with integer 99 and call OutputArray to display the updated array.
	# Display found message
	la $a0, foundmsg		# load address of foundmsg in $a0 for printing
	jal PrintString			# jump to PrintString subprogram
	jal PrintNewLine		# jump to PrintNewLine subprogram
	# Replace the matching value at the index that SearchArray returned with 99
	mul $t0, $s4, 4			# calculate index * size of elements (4)
	add $t0, $s2, $t0		# update $t0 to be distance from base address ($s2)
	lw $t1, ninetynine		# load word ninetynine from static memory to reg $t1
	sw $t1, 0($t0)			# store int (word) 99 at mem address in $t0 in array
	# Output update array
	move $a0, $s2			# move base address into reg $a0 for use in OutputArray subprogram
	move $a1, $s0			# move array capacity into reg $a1 for use in OutputArray subprogram
	jal OutputArray			# jump to OutputArray subprogram			 
	
	b exit
notfound:
	# Display not found message
	la $a0, notfoundmsg		# load address of notfoundmsg in $a0 for printing
	jal PrintString			# jump to PrintString subprogram 
exit:
	# Exit the program
	jal Exit			# jump to Exit subprogram	
				
.include "utils.asm"
.include "arrayutils.asm"