.data
	space_prompt: 	.asciiz "Enter space between plants: "
	number_prompt:	.asciiz "Enter number of plants: "
	newline:	.asciiz "\n"
	row_float_output: .asciiz "Number of plants in a row (single): "
	row_int_output:	.asciiz "Number of plants in a row (integer): "
	full_row_output: .asciiz "Number of full rows: "
	partial_row_output: .asciiz "Partial row contains: "
	row_length:	.float	20.0

.text
	# Print user prompt for space between plants
	
	li $v0, 4		# load instruction 4 (print string)
	la $a0, space_prompt	# load address of string in reg $a0
	syscall			# print string at address in reg $a0
	
	# Read user input for space between plants as a float
	
	li $v0, 6		# load instruction 6 (read float)
	syscall			# get user input
	
	# Compute number of plants in a row as a float (single)
	
	l.s $f5, row_length	# load float row_length into float reg $f5
	div.s $f6, $f5, $f0	# divide row_length by the space between between plants and store at reg $f6
	
	# Print user prompt for number of plants
	
	li $v0, 4		# load instruction 4 (print string)
	la $a0, number_prompt	# load address of string in reg $a0
	syscall			# print string at address in reg $a0
	
	# Read user input for number of plants as an integer
	
	li $v0, 5		# load instruction 5 (read integer)
	syscall			# get user input
	move $s0, $v0		# move integer from reg $v0 to reg $s0
	
	# Print number of plants in a row as a float
	
	li $v0, 4		# load instruction 4 (print string)
	la $a0, row_float_output # load address of row_float_output string
	syscall			# print string at address in reg $a0
	mov.s $f12, $f6		# move float at reg $f6 to reg $f12 for printing
	li $v0, 2		# load instruction 2 (print single)
	syscall			# print float in reg $f12
	
	# Print newline
	
	li $v0, 4		# load instruction 4 (print string)
	la $a0, newline		# load address of string in reg $a0
	syscall			# print string at address in reg $a0
	
	# Convert float number of plants in a row to integer
	
	cvt.w.s $f6, $f6	# convert float to word (32-bit integer)
	mfc1 $s1, $f6		# move integer in float register $f6 to general purpose save reg $s1
	
	# Print number of plants in a row as an integer
	
	li $v0, 4 		# load instruction 4 (print string)
	la $a0, row_int_output	# load address of row_int_output string
	syscall			# print string at address in reg $a0
	move $a0, $s1		# move integer in reg $s1 to reg $a0 for printing
	li $v0, 1		# load instruction 1 (print integer)
	syscall			# print integer stored at reg $a0
	
	# Print newline
	
	li $v0, 4		# load instruction 4 (print string)
	la $a0, newline		# load address of string in reg $a0
	syscall			# print string at address in reg $a0
	
	# Compute number of full rows
	
	div $t1, $s0, $s1	# divide number of plants by number of plants in a row and store in reg $t1
	
	# Print number of full rows
	
	li $v0, 4 		# load instruction 4 (print string)
	la $a0, full_row_output	# load address of full_row_output string
	syscall			# print string at address in reg $a0
	mflo $a0		# move division quotient into $a0 for printing
	li $v0, 1		# load instruction 1 (print integer)
	syscall			# print integer in reg $a0
	
	# Print newline
	
	li $v0, 4		# load instruction 4 (print string)
	la $a0, newline		# load address of string in reg $a0
	syscall			# print string at address in reg $a0
	
	# Print number of plants in last partial row
	
	li $v0, 4 		# load instruction 4 (print string)
	la $a0, partial_row_output # load address of partial_row_output string
	syscall			# print string at address in reg $a0
	mfhi $a0		# move division remainder into $a0 for printing
	li $v0, 1		# load instruction 1 (print integer)
	syscall			# print integer in reg $a0
	
	# End program
	
	li $v0, 10		# load instruction 10 (halt program)
	syscall			# end program