# Module 7 Assignment by Ethan Adshead
# This program assess if someone will qualify for a loan based off 2 conditions: minimum salary ($30,000) 
# and minimum years worked (2 years)

# Pseudocode:
# Read salary
# Read years_worked

# if salary >= 30,000
# 	if years_worked >= 2
# 		display "You qualify for a loan"
#	else
#		display "Years is too low"
#		display "You do not qualify for a loan"
# else 
#	if years_worked >= 2
# 		display "Salary is too low"
#		display "You do not qualify for a loan"
#	else
#		display "Salary and years are both too low"
#		display "You do not qualify for a loan"

# Save registers used
# $s0 -	salary
# $s1 - years_worked
.data
	salary_prompt:	.asciiz "Enter salary: "
	years_worked_prompt: .asciiz "Enter years on job: "
	salary_low:	.asciiz "Salary is too low"
	years_low: 	.asciiz "Years is too low"
	both_low:	.asciiz "Salary and years are both too low"
	no_loan:	.asciiz "You do not qualify for a loan"
	yes_loan:	.asciiz "You qualify for a loan"
.text
	# Prompt the user for their salary
	la $a0, salary_prompt		# load address of salary_prompt in $a0 to prompt for integer
	jal PromptInt			# jump to PromptInt subprogram
	move $s0, $v0			# store result from PromptInt subprogram into save reg $s0 
	
	# Prompt the user for their years worked
	la $a0, years_worked_prompt	# load address of years_worked_prompt in $a0 to prompt for integer
	jal PromptInt			# jump to PromptInt subprogram
	move $s1, $v0			# store result from PromptInt subprogram into save reg $s1
	
	# is salary >= 30,000 ?
	sge $t0, $s0, 30000		# store result of boolean operation salary >= 30,000 in reg $t0
	# branch to else_below30000
	beqz $t0, else_below30000	# branch if value in $t0 == 0
	
	# is years_worked >= 2 ?
	sge $t1, $s1, 2			# store result of boolean operation years_worked >= 2 in reg $t1
	# branch to else_yearslow
	beqz $t1, else_yearslow		# branch if value in $t1 == 0
	
	# Print out when user qualifies for salary and years
	la $a0, yes_loan		# load address of yes_loan in $a0 to print string
	jal PrintString			# jump to PrintString subprogram
	b end_if				# branch to end program
else_yearslow:
	# Print out when user does not qualify for years
	la $a0, years_low		# load address of years_low in $a0 to print string
	jal PrintString			# jump to PrintString subprogram
	jal PrintNewLine		# print newline
	la $a0, no_loan			# load address of no_loan in $a0 to print string
	jal PrintString			# jump to PrintString subprogram
	b end_if			# branch to end program
else_below30000:
	# is years_worked >= 2 ?
	sge $t1, $s1, 2			# store result of boolean operation years_worked >= 2 in reg $t1
	# branch to else_bothlow
	beqz $t1, else_bothlow		# branch if value in $t1 == 0
	
	# Print out when user does not qualify for salary
	la $a0, salary_low		# load address of salary_low in $a0 to print string
	jal PrintString			# jump to PrintString subprogram
	jal PrintNewLine		# print newline
	la $a0, no_loan			# load address of no_loan in $a0 to print string
	jal PrintString			# jump to PrintString subprogram
	b end_if			# branch to end_program
else_bothlow:
	# Print out when user does not qualify for either salary or years
	la $a0, both_low		# load address of both_low in $a0 to print string
	jal PrintString			# jump to PrintString subprogram
	jal PrintNewLine		# print newline
	la $a0, no_loan			# load address of no_loan in $a0 to print string
	jal PrintString			# jump to PrintString subprogram
	b end_if			# branch to end program
end_if:
	jal Exit

.include "utils.asm"