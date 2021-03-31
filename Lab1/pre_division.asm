.data
text1: .asciiz "Enter divided: "
text2: .asciiz "Enter divisor: "
text3: .asciiz "quotient: "
text4: .asciiz "remainder: "
newLine: .asciiz "\n"
.text 
  	.globl __start	

__start:
   la $a0,text1
   li $v0,4
   syscall
   
   li $v0,5
   syscall
   add $s0,$v0,$zero
   
   la $a0,text2
   li $v0,4
   syscall
   
   li $v0,5
   syscall
   add $s1,$v0,$zero
   addi $t0,$zero,0 #t0 is counter
   #substract divisor from dividend till divident becomes smaller  
   divide:   
   	blt $s0,$s1,done
   	sub $s0,$s0,$s1
   	addi $t0,$t0,1
   	j divide
   	done:
   la $a0,text3
   li $v0,4
   syscall	
   addi $a0,$t0,0
   li $v0,1
   syscall
   la $a0,newLine
   li $v0,4
   syscall
   la $a0,text4
   li $v0,4
   syscall
   addi $a0,$s0,0
   li $v0,1
   syscall
   
   li $v0,10  #terminate program
   syscall
   
   
   
   
