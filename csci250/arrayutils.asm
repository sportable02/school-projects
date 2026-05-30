# arrayutils.asm stores common array subroutines

# InputArray
# purpose: fill an int array from the keyboard
# input: $a0 stores base address, $a1 holds capacity
# output: none
.data
	elemprompt: .asciiz "Enter array element: "	
.text
InputArray:
	# push stack
	addi $sp, $sp, -12 		# store $ra, $a0, $a1
	sw $ra, 0($sp)				
	sw $a0, 4($sp)
	sw $a1, 8($sp)	
	# move args to temp registers for computations
	move $t0, $a0
	move $t1, $a1			
	# loop to fill the array up to capacity
	li $t2, 0       		# loop control is array index
topinputloop:
	slt $t3, $t2, $t1       # is loop control (index) < capacity?
	beqz $t3, endinputloop  # branch to end loop when done
	# ask user for element
	la $a0, elemprompt		
	li $v0, 4 				# display prompt
	syscall
	# read integer from console
	li $v0, 5 				# load instruction 5 (read integer)
	syscall		
	move $t4, $v0 			# move int read into temp reg $t4		
	# store this element into array at index determined by loop control var	
	mul $t5, $t2, 4			# compute index * size and store in $t5
	add $t5, $t0, $t5		# add index * size to base address and store back in $t5
	# store int read in $t4 into address $t5 at offset 0
	sw  $t4, 0($t5) 
	add $t2, $t2, 1			# add 1 to loop control 
	jal topinputloop
endinputloop:
	# pop stack
	lw $ra, 0($sp) 			
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12 		# add 12 to stack pointer
	jr $ra   				# jump back to caller

# OutputArray
# purpose: display int array on one line with blank separation 
# input: $a0 stores base address, $a1 holds capacity
# output: none	
.data
	blank: .asciiz " "
.text
OutputArray:
	# push stack
	addi $sp, $sp, -12 		# store $ra, $a0, $a1
	sw $ra, 0($sp)				
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	# move args to temp registers for computations
	move $t0, $a0
	move $t1, $a1			
	# loop to display elements
	li $t2, 0       		# loop control is array index
topoutputloop:
	slt $t3, $t2, $t1  		# is loop control (index) < capacity?
	beqz $t3, endoutputloop # branch to end loop when done
	# get element at index	
	mul $t4, $t2, 4			# compute index * size and store in $t4	
	add $t4, $t0, $t4		# add index * size to base address and store back to $t4
	# load word at $t4 into arg reg $a0 in prep for display
	lw $a0, 0($t4)      
	li $v0, 1         		# instruction 1 is print int 
	syscall
	# display blank
	la $a0, blank
	li $v0, 4               # print string
	syscall
	add $t2, $t2, 1			# add 1 to loop control 
	jal topoutputloop
endoutputloop:
	# pop stack
	lw $ra, 0($sp) 			
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12 		# add 12 to stack pointer
	jr $ra   				# jump back to caller

# SearchArray
# purpose: Find index of first occurence of target int in int array
# input: $a0 stores base address, $a1 holds capacity, $a2 holds target
# output: $v0 stores index of target if matches or -1 if no match
.text
SearchArray:
	# push stack
	addi $sp, $sp, -16		# move stack pointer down by 16
	sw $ra, 0($sp)			# store $ra at 0 offset from $sp
	sw $a0, 4($sp)			# store $a0 at 4 offset from $sp
	sw $a1, 8($sp)			# store $a1 at 8 offset from $sp
	sw $a2, 12($sp)			# store $a2 at 12 offset from $sp
	# args go to temp registers for computations
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	# set reg $t3 to 0 for use as loop counter
	li $t3, 0			# loop control is $t3
	# set initial state of output reg $v0 to -1
	li $v0, -1
searchloop:
	slt $t4, $t3, $t1		# is loop control less than capacity? store result in $t4
	beqz $t4, endsearchloop		# branch to end of loop if loop control is >= capacity
	# get element at current loop index in $t3	
	mul $t5, $t3, 4			# compute index * size and store in $t5	
	add $t5, $t0, $t5		# add index * size to base address and store back to $t5
	# load int (word) from address into $t6 for computation
	lw $t6, 0($t5) 			# load word at $t5 into arg reg $t6
	# check if return value in $t6 is the same as target
	bne $t6, $t2, continuesearchloop# continue looping if there's no match (branch to continue)
	# set return value to the match's index 
	move $v0, $t3
	# end loop to return and finish subprogram
	b endsearchloop			# branch to end of loop
continuesearchloop:
	addi $t3, $t3, 1		# add 1 to loop control
	jal searchloop			# loop
endsearchloop: 
	# pop stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 12		# return stack pointer to address before "call"
	jr $ra				# jump back to address after being called