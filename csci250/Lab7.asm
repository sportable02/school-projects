# Lab Module 7 by Ethan Adshead
# This program displays costs for different mobile service plans

.data
	plan_prompt:	.asciiz "Enter plan A, B: "
	giga_prompt:    .asciiz "Enter gigabtyes used: "
	A:              .byte 0x41 			# hex for character A (ASCII 65)
	B: 				.byte 0x42 			# hex for character B (ASCII 66)
	error_result:   .asciiz "Invalid plan"
	cost_result:    .asciiz "Your plan costs $"

#  List of save registers used
#  $s0   	plan entered by user A, B
#  $s1      character A
#  $s2      character B
#  $s3      integer gigabytes used
#  $s4      integer base cost for Plan A (40)
#  $s5	    integer base cost for Plan B (60)
		
.text
	# move the bytes for A, B into registers
	lb $s1, A
	lb $s2, B

	#ask user for plan A, B and read character as byte
	la $a0, plan_prompt
	li $v0, 4
	syscall
	# read the next byte into save reg $s0
	li $v0, 12
	syscall
	move $s0, $v0  
	jal PrintNewLine
	
	# ask for gigabytes and read integer
	la $a0, giga_prompt
	jal PrintString	
	# read the integer into save reg $s3
	li $v0, 5 						
	syscall	
	move $s3, $v0    
	
	# does plan == A?
	seq $t0, $s0, $s1		
	# branch on false to code that processes plan B 
	beqz $t0, else_B
	
	# code for plan A 
	# is gigabytes <= 4?
	sle $t1, $s3, 4
	# branch on false to else_over4
	beqz $t1, else_over4
	
	# compute cost as 40 for gigabytes <= 4
	li $s4, 40
	# display cost
	la $a0, cost_result
	move $a1, $s4
	jal PrintInt
	b end_if 				# branch to end_if
	
else_over4:
	# compute gigabytes - 4
	subi $t3, $s3, 4
	# compute (gigabytes - 4) * 10
	mul $t4, $t3, 10
	# compute 40 + (gigabtyes - 4) * 10
	addi $t5, $t4, 40
	# display cost
	la $a0, cost_result
	move $a1, $t5
	jal PrintInt
	b end_if 				# branch to end_if
	
else_B:
	# this code processes plan B
	# does plan == B?
	seq $t0, $s0, $s2
	# branch on false to code that processes errors 
	beqz $t0, else_error

	# code for plan B
	# is gigabytes <= 8 ?
	sle $t1, $s3, 8
	# branch on false to else_over8
	beqz $t1, else_over8
	
	# compute cost as 60 for gigabytes <= 8
	li $s5, 60
	# display cost
	la $a0, cost_result
	move $a1, $s5
	jal PrintInt
	b end_if				# branch to end_if
else_over8:
	# compute gigabytes - 8
	subi $t3, $s3, 8
	# compute (gigabytes - 8) * 5
	mul $t4, $t3, 5
	# compute 60 + (gigabytes - 8) * 5
	addi $t5, $t4, 60
	# display cost
	la $a0, cost_result
	move $a1, $t5
	jal PrintInt
	b end_if				# branch to end_if	

else_error:
	la $a0, error_result
	jal PrintString
	b end_if
	
end_if:
	jal Exit
	
.include "utils.asm"
	
	 
