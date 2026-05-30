# Assignment Module 5 by Ethan Adshead
# This program displays the ideal pressure (p) of a gas given the conditions a user inputs
# Conditions are moles of gas present (n), temperature in Kelvin (t), and volume (v)
# The equation for pressure is p = n * R * t / v 	where R is a constant 0.08206 
# 
# Float registers:
#  $f0 - $f3			value registers
#  $f4 - $f11			temporary registers
#  $f12 - $f15			argument registers
#  $f16 - $f19			temporary registers
#  $f20 - $f31			save registers

.data
	gas_constant: 				.double 0.08206
    name_prompt:		.asciiz "Enter gas name: "
    moles_prompt:		.asciiz "Enter moles: "
    temperature_prompt:		.asciiz "Enter temperature: "
    volume_prompt:		.asciiz "Enter volume: "
    pressure_value:		.asciiz "Ideal pressure: "
    input: 			.space 11
 inputSize: 			.word 10
           				
.text		
	# Prompt the user for the name of the gas and store in space input
	li $v0, 4			# load instruction 4 (print string)
	la $a0, name_prompt		# load address of name_prompt into reg $a0
	syscall 			# print name_prompt
	li $v0, 8			# load instruction 8 (read string)
	la $a0, input 			# load address of 11 bytes labelled input
	lw $a1, inputSize 		# load value 10 from label inputSize
	syscall				# store the string in input
	# Prompt the user for the moles and store in float reg $f12
	la $a0, moles_prompt		# load address of moles_prompt string in reg $a0
	jal PromptFloat			# jump to PromptFloat subprogram
	mov.s $f12, $f0			# move answer into float reg $f12
	# Prompt the user for the temperature and store in float reg $f13
	la $a0, temperature_prompt	# load address of temperature_prompt string in reg $a0
	jal PromptFloat			# jump to PromptFloat subprogram
	mov.s $f13, $f0			# move answer into float reg $f13
	# Prompt the user for the volume and store in float reg $f14
	la $a0, volume_prompt		# load address of volume_prompt string in reg $a0
	jal PromptFloat			# jump to PromptFloat subprogram
	mov.s $f14, $f0			# move answer into float reg $f14
	# Print newline
	jal PrintNewLine		# Jump to PrintNewLine subprogram
	# Display report header
	la $a0, input			# load address of input string into reg $a0
	jal ReportHeader		# jump to ReportHeader subprogram
	# Display ideal pressure value
	la $a0, pressure_value		# load address of pressure_value string in reg $a0
	jal IdealPressure		# jump to IdealPressure subprogram
	mov.s $f12, $f0			# move answer to float arg reg $f12
	jal PrintFloat			# jump to PrintFloat subprogram
	# Exit program
	jal Exit			# jump to Exit subprogram
	
	
# subprogram: IdealPressure
# purpose:  compute the ideal pressure of a gas at certain conditions
# input:    $f4 - gas constant value
# 	    $f12 - moles value
#	    $f13 - temperature value
#	    $f14 - volume value
# output:   $f0 - moles * gas constant * temperature / volume
IdealPressure:
	# 1. load address of double gas_constant into reg $f4
	l.d $f4, gas_constant	
	# 2. convert the double gas constant to a single float and store in reg $f4
	cvt.s.d $f4, $f4
	# 3. compute moles * temperature and store in temporary reg $f5
	mul.s $f5, $f12, $f13
	# 4. compute (moles * temperature) * gas constant and store in temporary reg $f6
	mul.s $f6, $f4, $f5
	# 5. compute ((moles * temperature) * gas constant) / volume and store in temporary reg $f7
	div.s $f7, $f6, $f14
	# 6. move result into value register $f0 to return
	mov.s $f0, $f7
	jr $ra
	
.include "utils.asm" 			# include utility file
	


