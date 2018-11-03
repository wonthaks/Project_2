.text
main:
input:
   li $v0, 5		#load 5 in $v0 to read integer input from user
   syscall
   
   li $v0, 10		#to end the script
   syscall