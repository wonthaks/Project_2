.data
   buffer: .space 5 #store 5 bytes to accomodate for end of character array
.text
main:
   li $v0, 8		#load 8 in $v0 to read string input from user
   la $a0, buffer	#load buffer into $a0
   li $a1, 5		#5 in $a1 to store 5 bytes in buffer
   syscall		

   add $t0, $a0, $zero	#copy contents of $a0 to $t0
   li $t1, 1			#load 1 into $t1 to use as program counter
   li $t8, 5			#load 5 into $t8 to use to check whether loop has eded
   li $t7, 10			#load 10 into $t7 to use to check for Line Feed character
   
exit:
   li $v0, 10		#to end the script
   syscall
   