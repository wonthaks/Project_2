.data
   buffer: .space 5 #store 5 bytes to accomodate for end of character array
.text
main:
   li $v0, 8		#load 8 in $v0 to read string input from user
   li $v0, 10		#to end the script
   
   syscall