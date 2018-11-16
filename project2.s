.data
	empty: .asciiz "Input is empty."
	long: .asciiz "Input is too long."
	invalid: .asciiz "Invalid base-N number."
	buffer: .space 1000 #store 1000 bytes to accomodate for end of character array
.text
main:
	li $v0, 8		#load 8 in $v0 to read string input from user
	la $a0, buffer	#load buffer into $a0
	li $a1, 1000		#5 in $a1 to store 1000 bytes in buffer
	syscall
	
	add $s0, $a0, $zero	#copy contents of $a0 to $s0
	li $t9, 10			#load 10 into $t9 to use to check for Line Feed character
	li $t8, 0			#load 0 to initialize length of string
	li $t7, 0			#load 0 to use to check whether a space character is between the input string or not (0 indicates string has not started yet, while > 0 means the string has)
	li $t6, 0			#$t6 will be used to calculate the output sum after
	li $t5, 1			#$t5 currently holds the max exponent to use in calculation
	li $t4, 0			#register used to count invalids (and space if string started)
	li $t3, 0			#register to track whether spaces were found between characters
	li $s2, 0			#register to track space invalids
	li $s3, 0			#register to track whether space was found between characters
	
	
   add $t0, $a0, $zero	#copy contents of $a0 to $t0
   li $t1, 1			#load 1 into $t1 to use as program counter
   li $t8, 5			#load 5 into $t8 to use to check whether loop has eded
   li $t7, 10			#load 10 into $t7 to use to check for Line Feed character
   
exit:
   li $v0, 10		#to end the script
   syscall
   