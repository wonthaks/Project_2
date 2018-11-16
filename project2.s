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
	li $s4, 0			#register to track whether invalids were found
	addi $s0, $s0, -1	#decrement stack pointer by 1 to account for loop after
	add $s1, $s0, $zero	#copy contents from $s0 into $s1 to use to calculate output later on

loopOne:
	addi $s0, $s0, 1	#add 1 to $s0 to increment stack pointer
	lb $t2, 0($s0)		#load byte from stack (character) into $t2

	li $t0, 97			#load 97 into $t7 to use to compare for valid character (uppercase)
	bge $t2, $t0, checkValidLower	#branch to checkValidLower if  $t2 >= $t0
	
	
exit:
    li $v0, 10		#to end the script
    syscall
   