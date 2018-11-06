.data
   buffer: .space 5 #store 5 bytes to accomodate for end of character array
.text
main:
   li $v0, 8		#load 8 in $v0 to read string input from user
   la $a0, buffer	#load buffer into $a0
   li $a1, 5		#5 in $a1 to store 5 bytes in buffer
   syscall			
exit:
   li $v0, 10		#to end the script
   syscall