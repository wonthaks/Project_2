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
	
	li $t0, 65			#if previous statement did not execute, load 65 into $t0
	bge $t2, $t0, checkValidUpper	#branch to checkValidUpper if  $t2 >= $t0
	
	li $t0, 48			#if again previous statement did not execute, load 48 into $t0
	bge $t2, $t0, checkValidInteger	#branch to checkValidInteger if  $t2 >= $t0
	
	li $t0, 32			#load 32 into $t0 to use to compare for space character
	beq $t2, $t0, checkSpaceBetween	#if $t2 contains a space character, branch to check whether it is okay to skip or not
	
	beq $t2, $t9, checkLength	#if the char is LineFeed, then input has ended (so branch to checkLength)
	addi $t4, $t4, 1	#else, increment the invalid count
	li $t7, 1			#indicate string has started	
	add $t8, $t8, $s2	#add invalid space length to total length
	li $s2, 0			#reload 0 into invalid space length
	li $s4, 1			#load 1 to $s4 to keep track of invalidity
	jal loopOne			#and loop again

checkSpaceBetween:
	li $t0, 0			#load 0 into $t0 to compare with value stored in $t7 to see whether space is valid to skip or not
	bgt $t7, $t0, incrementSpaceInvalid	#if value in $t7 is greater than 0, then branch to incrementSpaceInvalid
	jal loopOne			#else, go back to original loop (space character skipped)

incrementSpaceInvalid:
	addi $s2, $s2, 1	#add 1 to invalid space length tracker
	li $t3, 1			#load 1 into $t3 to keep track of whether the space was between characters
	jal loopOne			#jump back to main loop

checkLength:
	add $t8, $t8, $t4	#add invalid length to real length
	li $t0, 4			#load 4 into $t0 to check for length of string
	bgt $t8, $t0, handleLonger		#if length is longer than 4, branch to handleLonger
	li $t0, 0			#load 0 into $t0 this time to check if string is empty
	beq $t8, $t0, handleEmpty		#if string is empty, branch to handleEmpty
	li $t0, 1			#load 1 into $t0 to check for invalidity
	beq $s4, $t0, handleInvalid		#if string is invalid, jump to handleInvalid
	li $t0, 1			#load 1 into $t0 to check if spaces were in between characters (since length was less than 4 and more than 0)
	beq $s3, $t0, handleInvalid		#if spaces were between characters and length is less than 4, branch to handleInvalid
	jal calculateExponent			#else, jump to calculateExponent (which redirects to calculateOutput)

checkValidLower:
	li $t0, 4			#load 4 into $t0 to check for length of string
	bgt $t8, $t0, handleLonger		#if length is longer than 4, branch to handleLonger
	li $t0, 114			#load 114 into $t0 to check for valid lowercase letter
	ble $t2, $t0, incrementLength	#if char is within range, branch to incrementLength
	addi $t4, $t4, 1	#else, increment invalid count
	li $s4, 1			#keep track of invalidity
	jal loopOne			#then, go back to loop

checkValidUpper:
	li $t0, 4			#load 4 into $t0 to check for length of string
	bgt $t8, $t0, handleLonger		#if length is longer than 4, branch to handleLonger
	li $t0, 82			#load 82 into $t0 to check for valid uppercase letter
	ble $t2, $t0, incrementLength	#if char is within range, branch to incrementLength
	addi $t4, $t4, 1	#else, increment invalid count
	li $s4, 1			#keep track of invalidity
	jal loopOne			#then, go back to loop

checkValidInteger:
	li $t0, 4			#load 4 into $t0 to check for length of string
	bgt $t8, $t0, handleLonger		#if length is longer than 4, branch to handleLonger
	li $t0, 57			#load 82 into $t0 to check for valid integer
	ble $t2, $t0, incrementLength	#if char is within range, branch to incrementLength
	addi $t4, $t4, 1	#else, increment invalid count
	li $s4, 1			#keep track of invalidity
	jal loopOne			#then, go back to loop

incrementLength:
	addi $t8, $t8, 1		#increment length by 1
	li $t7, 1				#load 1 into $t7 to keep track of whether string has started or not (to check for space character validity)
	li $t0, 0				#load 0 into $t0 to check whether spaces were found between characters
	bgt $s2, $t0, invalidSpace	#if invalid spaces were found, branch to invalidSpace
incrementLengthPart2:
	add $t8, $t8, $s2		#add invalid lengths to length of string
	li $s2, 0				#reinitialize invalid space lengths to 0 again
	jal loopOne				#go back to loopOne

invalidSpace:
	li $s3, 1				#load 1 into $s3 to keep track of invalidity due to space
	jal incrementLengthPart2		#jump back to incrementLengthPart2

handleLonger:
	li $v0, 4				#load 4 into $v0 to print out string
	la $a0, long			#load address of string message into $a0
	syscall					#print out string message
	jal exit				#jump to exit

handleInvalid:
	li $v0, 4				#load 4 into $v0 to print out string
	la $a0, invalid			#load address of string message into $a0
	syscall					#print out string message
	jal exit				#jump to exit

handleEmpty:
	li $v0, 4				#load 4 into $v0 to print out string
	la $a0, empty			#load address of string message into $a0
	syscall					#print out string message
	jal exit				#jump to exit

calculateExponent:
	li $t0, 1				#load 1 into $t0 to check whether length of string is one
	beq $t8, $t0, calculateOutput		#if length of string is one, jump to calculateOutput
	li $t0, 28				#load base-N number to $t0 to calculate exponent (in this case base-28)
	mult $t5, $t0			#multiply current exponent ($t5) with $t0 to get next
	mflo $t5	#move whatever is stored now in special register $LO into $t5 (exponent holder register)
	addi $t8, $t8, -1			#decrement value in $t8
	li $t0, 1					#load 0 into $t0 to use to compare with $t8 (length holder register)
	bgt $t8, $t0, calculateExponent	#if $t8 is still greater than 0, loop again to calculate max exponent
	jal calculateOutput

calculateLowerCase:
	addi $t2, $t2, -87	#subtract 87 from $t2 to make it so that lowercase a is equivalent to 10
	mult $t2, $t5		#multiply value in $t2 by exponent
	mflo $t0	#add contents of special register $LO to $t0 
	add $t6, $t6, $t0	#add value of $t0 to sum register ($t6)
	li $t0, 28			#load 28 into $t0 to use to divide exponent
	div $t5, $t0		#divide exponent by 28 ($t5 / $t0)
	mflo $t5	#then, move contents of $LO (quotient) into $t5
	jal calculateOutput	#then, jump back to calculateOutput loop

calculateUpperCase:
	addi $t2, $t2, -55	#subtract 55 from $t2 to make it so that uppercase A is equivalent to 10
	mult $t2, $t5		#multiply value in $t2 by exponent
	mflo $t0	#add contents of special register $LO to $t0 
	add $t6, $t6, $t0	#add value of $t0 to sum register ($t6)
	li $t0, 28			#load 28 into $t0 to use to divide exponent
	div $t5, $t0		#divide exponent by 28 ($t5 / $t0)
	mflo $t5	#then, move contents of $LO (quotient) into $t5
	jal calculateOutput	#then, jump back to calculateOutput loop

calculateInteger:
	addi $t2, $t2, -48	#subtract 48 from $t2 to make it so that integer 0 is equivalent to 0
	mult $t2, $t5		#multiply value in $t2 by exponent
	mflo $t0	#add contents of special register $LO to $t0 
	add $t6, $t6, $t0	#add value of $t0 to sum register ($t6)
	li $t0, 28			#load 28 into $t0 to use to divide exponent
	div $t5, $t0		#divide exponent by 28 ($t5 / $t0)
	mflo $t5	#then, move contents of $LO (quotient) into $t5
	jal calculateOutput	#then, jump back to calculateOutput loop

calculateOutput:
	addi $s1, $s1, 1		#increment stack pointer in $s1 
	lb $t2, 0($s1)			#load byte from stack (character) into $t2
	li $t0, 32			#load 32 into $t0 to use to compare for space character
	beq $t2, $t0, calculateOutput	#if $t2 contains a space character, go back to beginning of this loop
	
	li $t0, 97			#load 97 into $t7 to use to compare for valid character (uppercase)
	bge $t2, $t0, calculateLowerCase	#branch to calculateLowerCase if  $t2 > $t0
	li $t0, 65			#if previous statement did not execute, load 65 into $t0
	bge $t2, $t0, calculateUpperCase	#branch to calculateUpperCase if  $t2 > $t0
	li $t0, 48			#if again previous statement did not execute, load 48 into $t0
	bge $t2, $t0, calculateInteger	#branch to calculateInteger if  $t2 > $t0
	
	beq $t2, $t9, outputSum		#if value in $t2 is 10, it is LineFeed so we can now branch to outputSum

outputSum:
	li $v0, 1		#to print out integer
	add $a0, $t6, $zero		#move contents of sum register to $a0 to print sum after
	syscall
	jal exit		#jump to exit
	
exit:
    li $v0, 10		#to end the script
    syscall
   