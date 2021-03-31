.data
array: .asciiz "123456"
array2: .asciiz "abcdef"
space: .asciiz " "
newLine: .asciiz "\n"

.text		
	.globl __start	

__start:

	size:
	lbu $s1,array($s0) #s0: string lenght
	beq $s1,$zero,done
	addi $s0,$s0,1
	j size
	done:      
	
	 #s0 size 
	 
	 la $a0,array    
	 la $a1,array2
	 add $a0,$a0,$s0
	 addi $a0,$a0,-1
	 jal reverseString	  
 	
 	addi $t1,$zero,0 #array index t1 now its zero to print 
	addi $a1,$zero,0  
 	jal print
	
	li $v0,10   #terminate program
	syscall
	
reverseString: 
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	
	beq $t1,$s0,out
	
	#do job
		
	addi $a1,$a1,1  
	addi $a0,$a0,-1
	addi $t1,$t1,1 
	       
	jal reverseString
	lw $a0,4($sp)
	lw $a1,8($sp)
	lbu  $t0,($a0)
	sb $t0,($a1)
	
	out: #base case
  	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	addi $sp,$sp,12
	  
	jr $ra
	  
	  
	  
	  ################################
	
		print:
	       beq $a1,$s0,exit #t2 i t1 size
		lbu $t0,array2($t1)
		add $a0,$t0,$zero
	        li $v0,11	
	       syscall
	       la $a0,space
	       li $v0,4
	       syscall
	       addi $t1,$t1,1
	       addi $a1,$a1,1
	       j print
	       
	       exit: 
	       
	       jr $ra  
