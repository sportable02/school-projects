# Assignment 1 by Ethan Adshead
# Prompts for name and hours worked for 4 different weeks and reports back the total hours worked

.text
	# output name prompt
	li $v0, 4			# load instruction 4 (print string)
	la $a0, nameprompt		# load address of nameprompt string
	syscall 			# print string at address in reg $a0
	
	# read name string from keyboard
	li $v0, 8			# load instruction 8 (read string)
	la $a0, input 			# load address of 21 bytes labelled input
	lw $a1, inputSize 		# load value 20 from label inputSize
	syscall				# store the string read in into input
	
	# output work hours prompt
	li $v0, 4			# load instruction 4 (print string)
	la $a0, hoursprompt		# load address of hoursprompt string
	syscall 			# print string at address in reg $a0
	
	# read first integer and save in $s0
	li $v0, 5			# load instruction 5 (read int)
	syscall				# read integer and store in reg $v0
	move $s0, $v0			# move integer from reg $v0 to $s0
	
	# output work hours prompt
	li $v0, 4			# load instruction 4 (print string)
	la $a0, hoursprompt		# load address of hoursprompt string
	syscall 			# print string at address in reg $a0
	
	# read second integer and save in $s1
	li $v0, 5			# load instruction 5 (read int)
	syscall				# read integer and store in reg $v0
	move $s1, $v0			# move integer from reg $v0 to $s1
	
	# add first two integers together and store in reg $s2
	add $s2, $s0, $s1
	
	# output work hours prompt
	li $v0, 4			# load instruction 4 (print string)
	la $a0, hoursprompt		# load address of hoursprompt string
	syscall 			# print string at address in reg $a0
	
	# read third integer and save in $s0
	li $v0, 5			# load instruction 5 (read int)
	syscall				# read integer and store in reg $v0
	move $s0, $v0			# move integer from reg $v0 to $s0
	
	# output work hours prompt
	li $v0, 4			# load instruction 4 (print string)
	la $a0, hoursprompt		# load address of hoursprompt string
	syscall 			# print string at address in reg $a0
	
	# read fourth integer and save in $s1
	li $v0, 5			# load instruction 5 (read int)
	syscall				# read integer and store in reg $v0
	move $s1, $v0			# move integer from reg $v0 to $s1
	
	# add second two integers together and store in reg $s3
	add $s3, $s0, $s1
	
	# add both first two integers' sums and second two ingtegers' sums together and save in $s0
	add $s0, $s2, $s3
	
	# copy payrate from data segment, multiply it by the hours worked and save it in $s2
	lw $s1, payrate			# load payrate from data segment and store it in reg $s1
	mul $s2, $s0, $s1		# multiply payrate by hours worked and store it in reg $s2
	
	# output report header
	li $v0, 4			# load instruction 4 (print string)
	la $a0, reportheader		# load address of reportheader string
	syscall				# print string at address in reg $a0
	
	# output name (instruction doesn't change)
	la $a0, input			# load address of input string
	syscall				# print string at address in reg $a0
	
	# output total result string (instruction doesn't change)
	la $a0, totalresult		# load address of totalresult string
	syscall				# print string at address in reg $a0
	
	# output total hours worked integer
	li $v0, 1			# load instruction 1 (print integer)
	move $a0, $s0			# move integer stored in reg $s0 to $a0
	syscall				# print string at address in reg $a0
	
	# output pay result string
	li $v0, 4			# load instruction 4 (print string)
	la $a0, payresult 		# load address of payresult string
	syscall				# print string at address in reg $a0
	
	# output pay integer
	li $v0, 1			# load instruction 1 (print integer)
	move $a0, $s2			# move integer stored in reg $s2 to $a0
	syscall				# print string at address in reg $a0
	
	# halt program
	li $v0, 10			# Load instruction 10 (halt program)
	syscall				# end program

.data
 hoursprompt: .asciiz "Enter hours worked: "
 input: .space 21
 inputSize: .word 20
 nameprompt: .asciiz "Enter your name: "
 payrate: .word 28
 payresult: .asciiz "\nYour pay is $"
 reportheader: .asciiz "\nReport for "
 totalresult: .asciiz "Total hours worked: "