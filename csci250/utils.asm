# File: utils.asm
# Contains Exit, PrintNewLine, PrintString, PrintInt, PromptInt, PrintFloat, PromptFloat

# subprogram: Exit
# purpose: 	use syscall 10 to exit a program
# input: 	none
# output: 	none
# side effects: program ends
.text
Exit:
	li $v0, 10
	syscall

# subprogram: PrintNewLine
# purpose: 	output newline to console
# input: 	none
# returns: 	none
# side effects: newline displays
.text
PrintNewLine:
	li $v0, 4 					# load instruction 4 (print string with address in $a0)
	la $a0, __PNL__newline 		# load address of label newline into $a0
	syscall	
	jr $ra	 					# think of this as return statement					
.data 							# data uses __ convention so this subprogram can be reused
	__PNL__newline: .asciiz "\n"
	
# subprogram: PrintString
# purpose: 	display user string 
# input: 	$a0 - address of string
# returns: 	none
# side effects: string displays on console
.text
PrintString:
	li $v0, 4 					# load instruction 4 (print string with address in $a0)
	syscall	
	jr $ra	 					# return 			

# subprogram: PrintInt
# purpose: 	display user string and integer
# input: 	$a0 - address of string
#        	$a1 - integer 
# return: 	none
# side effects: string displays on console followed by integer
.text
PrintInt:
	li $v0, 4 					# load instruction 4 (print string with address in $a0)
	syscall	
	move $a0, $a1 				# move the integer from reg $a1 to reg $a0
	li $v0, 1 					# load instruction 1 (print int found in $a0)
	syscall
	jr $ra	 					# return 	

# subprogram: PromptInt
# purpose: 		prompt user for integer and return to main
# input: 		$a0 - address of prompt string
# returns: 		$v0 - integer read from console 
.text
PromptInt:
	# display prompt string
	la $a0, __PI__enterstringprompt	# load address of prompt label into reg $a0
	li $v0, 4 						# load instruction 4 (print string) for string address in $a0
	syscall	
	# read integer from console
	li $v0, 5 						# load instruction 5 (input integer)
	syscall					
	# when instruction 5 ends, the integer read is stored in reg $v0
	# return to caller
	jr $ra 							# return			
.data
	__PI__enterstringprompt:  .asciiz "Enter an integer: "
	
# subprogram: PromptFloat
# purpose: 		prompt user for float and return to main
# input: 		$a0 - address of prompt string
# return: 		$f0 - float read from console 
.text
PromptFloat:
	# display prompt string
	li $v0, 4 						# load instruction 4 (print string) for string address in $a0
	syscall	
	# read float from console
	li $v0, 6 						# load instruction 6 (read float) leaves number in $f0
	syscall					
	jr $ra 							# return			

# subprogram: PrintFloat
# purpose: 	display user string and float value
# input: 	$a0 - address of string
#        	$f12 - float  
# return: 	none
.text
PrintFloat:
	li $v0, 4 					# load instruction 4 (print string with address in $a0)
	syscall	
	li $v0, 2 					# load instruction 2 (print float found in $f12)
	syscall
	jr $ra	 					# return 	


