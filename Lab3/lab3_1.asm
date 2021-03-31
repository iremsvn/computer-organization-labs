.data 

number: .asciiz  "10000111101101000101000101101000"
number2: .asciiz  "0000000000000000000000000000000"
pattern: .asciiz "1"
space: .asciiz " "
line: .asciiz "\n"
notsametxt: .asciiz "not same pattern"
sametxt: .asciiz "same pattern"

.text

 .globl _start
 
 _start:
 
 size:
	lbu $s1,pattern($s0) #s0: string lenght
	beq $s1,$zero,done
	addi $s0,$s0,1
	j size
	done:
 
 
 la $a1,number
 la $a0,pattern
 add $a2,$zero,$s0 #enter n here
jal checkpattern
 
 li $v0,10
 syscall
 
 ################################
 
 checkpattern:
 
 
 	addi $t2,$zero,0 #index
	addi $t1,$zero,0 #counter
	addi $t3,$zero,31
	
	reverse:
		beq $t1,32,out #t2 i t1 size
		lbu  $t0,number($t3)
	        sb $t0,number2($t2)
	       addi $t2,$t2,1  
	       addi $t3,$t3,-1
	       addi $t1,$t1,1   #counter
	   j reverse
	   
	  out:
	  
	  
	addi $t0,$zero,1
 	addi $t1,$zero,0
 	addi $t2,$zero,0
 	addi $t3,$zero,0
 	addi $t9,$zero,32
 	div $t9,$a2
 	mflo $t9
 	addi $t9,$t9,1
	mfhi $t8
 	
 outerwhile:
 	beq $t9,$t0,exitouter	
	mul $t2,$t0,$a2
	addi $t2,$t2,-1
 	while: 
 		beq $t1,$a2,exit #if equal to n 
 		lbu  $t3,number2($t2)
 		lbu  $t4,pattern($t1)
 		bne $t4,$t3,notsame
 		
 		j same
 		notsame:
		addi $t7,$zero,1
		same:
 		
 		addi $a0,$t3,0
 		li $v0,11
 		syscall	
 		
 		
 		addi $t2,$t2,-1
 		addi $t1,$t1,1	
 		
 		j while
 		
 		exit:
 		
 		la $a0,space
 		li $v0,4
 		syscall
 		
 		beq $t7,$zero,sametext
 		###farklý
 		la $a0,notsametxt
 		li $v0,4
 		syscall
 		j notsametext
 		sametext:
 		####ayný
 		la $a0,sametxt
 		li $v0,4
 		syscall
 		notsametext:
 			
 		la $a0,line
 		li $v0,4
		syscall
		
 		addi $t0,$t0,1
 		addi $t1,$zero,0 #reset internal index 
 		addi $t7,$zero,0

 		j outerwhile
 		exitouter:
 		
 		
 		beq $t8,$zero,passthis
 		addi $t0,$zero,31
 		sub $t8,$t0,$t8
 		 lastelements:
 		 	beq $t8,$t0,passthis
 		 	lbu $t3,number2($t0)
 		 	addi $a0,$t3,0
 			li $v0,11
 			syscall
 		 	
 		 	addi $t0,$t0,-1
 		 	
 		 	j lastelements
 		 
 		passthis:
 		
  		jr $ra
 	
 	
 	
