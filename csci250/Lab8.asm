# Module 8 Lab by Ethan Adshead
# This program simulated do loop logic to do data validation on hours worked 1..40
# and compute pay at $25 per hour

# Algorithm:
# do {
#     prompt for hours in range 1..40
#     read integer hours
#     if bad data, display error message
# } while hours < 1 or hours > 40

.data
	prompt:		.asciiz "Enter hours 1..40: "
	payresult:  .asciiz "Your pay is "
	errormsg:   .asciiz "Invalid data not in range 1..40"
	triesmsg:   .asciiz "Tries to get good data: "
.text
	li $s0, 1 				# low value
	li $s1, 40  			# high value
	li $s4, 0			# loop counter value
start_loop: 				# body goes first in a do loop
	la $a0, prompt
	jal PromptInt
	move $s2, $v0 			# number entered by user is in $s2
	sge $t0, $s2, $s0       # is number >= 1?
	sle $t1, $s2, $s1       # is number <= 40?
	# both must be true (1) for good data
	and $t3, $t0, $t1
	# if $t3 == 0, display error message and go to top of loop
	# else continue to pay label to do the pay display
	bnez $t3, pay
	la $a0, errormsg
	jal PrintString
	jal PrintNewLine
	addi $s4, $s4, 1
	b start_loop
	# branch to top of loop on false (0) for bad data
	 beqz $t3, start_loop
		
pay:	
    # compute the pay
    li $s3, 25 				# hourly pay rate is $35
    mul $t4, $s2, $s3
    la $a0, payresult
    move $a1, $t4
    jal PrintInt
    jal PrintNewLine
    la $a0, triesmsg
    move $a1, $s4
    jal PrintInt
    jal Exit

.include "utils.asm"
	
	

	
