.data
array: .word 0:20
array2: .word 0:20
invalidless: .asciiz "size should be more than 0"
invalidmore: .asciiz "size should be max 20"
prompt:	.asciiz "Enter size: "
getNum:	.asciiz "enter number:  "
space: .asciiz " "
newLine: .asciiz "\n"

.text		
	.globl __start	

__start:
	la $a0,prompt	
	li $v0,4	
	syscall

	li $v0, 5	
	syscall
	add $s0,$v0,$zero #s0 : size of array
	addi $t0,$zero,1 
	addi $t1,$zero,0
	addi $t0,$zero,0  #to:index	
	loop:
		beq $t0,$s0,done #t2 i t1 size
               la $a0,getNum  #print to get number
	       li $v0,4
	       syscall
	       li $v0,5		#get element from user
	       syscall
		sw  $v0,array($t1) #store element into array
	       la $a0,newLine
	       li $v0,4
	       syscall
	       addi $t1,$t1,4 #increment by 4 adress of sp
	       addi $t0,$t0,1 #increment index
	       j loop
	       
	       done:
	       
        addi $t1,$zero,0 #array address is 0  print 
        addi $a1,$zero,0 #a1:index to print
        
	jal print
	mul $t3,$s0,4 #index
	addi $t3,$t3,-4
	addi $t2,$zero,0 #index
	addi $t4,$zero,0 #counter
	
	reverse:
		beq $t4,$s0,out #t2 i t1 size
		lw  $s1,array($t3)
	       sw $s1,array2($t2)
	       addi $t2,$t2,4  
	       addi $t3,$t3,-4  
	       addi $t4,$t4,1   #counter
	   j reverse
	   
	  out:
	  
	addi $t2,$zero,0 #index
	addi $t3,$zero,0
	  goback:  #puts elements back to the original array 
		beq $t3,$s0,out1 #t2 i t1 size
		lw  $s1,array2($t2)
	       sw $s1,array($t2)
	       addi $t2,$t2,4 
	       addi $t3,$t3,1
	       j goback
	       
	 out1:
 	la $a0,newLine
 	li $v0,4
 	syscall
 	
 	addi $t1,$zero,0 #array index t1 now its zero to print 
	addi $a1,$zero,0  
 	jal print
	
	li $v0,10   #terminate program
	syscall
	
		print:
	       beq $a1,$s0,exit #t2 i t1 size
		lw $t9,array($t1)
		add $a0,$t9,$zero
	        li $v0,1	
	       syscall
	       la $a0,space
	       li $v0,4
	       syscall
	       addi $t1,$t1,4
	       addi $a1,$a1,1
	       j print
	       
	       exit: 
	       
	       jr $ra  