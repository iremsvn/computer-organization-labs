.data
invalidless: .asciiz "size should be more than 0"
invalidmore: .asciiz "size should be max 20"
prompt:	.asciiz "Enter size: "
getNum:	.asciiz "enter number:  "
space: .asciiz " "
newLine: .asciiz "\n"
isPalindrome: .asciiz "It is a Palindrome"
notPalindrome: .asciiz "It is not a Palindrome"
.text		
	.globl __start	

__start:
	la $a0,prompt	
	li $v0,4	
	syscall

	li $v0, 5	
	syscall
	add $s0,$v0,$zero #s0 : size of array
	
	addi $t0,$zero,20 #invalid if more than 20 elements
	bgt $s0,$t0,invalid1
	addi $t0,$zero,1 #invalid if less than 1 element
	blt $s0,$t0,invalid2
	
	
	mul $s1,$s0,4	  # 4 bytes 
	sub $s1,$zero,$s1 # allocating space from stack as size number
	add $sp,$sp,$s1   # allocating space 
	addi $t0,$zero,0  #to:index	
	add $t1,$sp,$zero #array address in t1
	loop:
		beq $t0,$s0,done #t2 i t1 size
               la $a0,getNum  #print to get number
	       li $v0,4
	       syscall
	       li $v0,5		#get element from user
	       syscall
		sw  $v0,0($t1) #store element into array
	       la $a0,newLine
	       li $v0,4
	       syscall
	       addi $t1,$t1,4 #increment by 4 adress of sp
	       addi $t0,$t0,1 #increment index
	       j loop
	       
	       done:
	 #t1 cuurently holds the address of the last element in array      
        add $a1,$sp,$zero #array address in a1 now its zero to print 
        addi $a2,$zero,0 #a2:index
	jal print
	
	la $a0,newLine
	li $v0,4
	syscall
	addi $t3,$zero,1
	beq $s0,$t3,palindrome
	addi $t1,$t1,-4
	addi $t0,$zero,0  #to:index
	addi $t0,$sp,0 #t0 holds index from beginning 
	addi $t2,$t1,0 #t2 holds index from last
	addi $t3,$zero,2
	div $s0,$t3 #s0 is size of array
	mfhi $t4
	beq $t4,$zero,even
	#t5 is counter for terminate palindrome loop	
	divu $t5,$s0,$t3
	addi $t5,$t5,-1
	j else
	even:
	divu $t5,$s0,$t3	
	else:
	#stop loop when t5 = 0
	palindromeloop:
		lw $s2,0($t0) #s2 holds number from begining 
		lw $s3,0($t2) #s3 holds number from last
		bne $s2,$s3,notpalindrome
		addi $t0,$t0,4
		addi $t2,$t2,-4
		beq $t5,$zero,palindrome
		addi $t5,$t5,-1 #decrement the counter
		j palindromeloop
		
		palindrome:
		la $a0,isPalindrome
		li $v0,4
		syscall
		j else2 
		notpalindrome:
		la $a0,notPalindrome
		li $v0,4
		syscall
		else2:
		
	 j eror1   #if user enters more than 20 elements 
        invalid1:
           la $a0, invalidmore
           li $v0,4
           syscall
           
        eror1:     
        
        j eror2  #if user enters less than 1 elements 
        invalid2:
           la $a0, invalidless
           li $v0,4
           syscall
           
        eror2: 
          
	li $v0,10   #terminate program
	syscall
		 	
	
	print:
	       beq $a2,$s0,exit #t2 i t1 size
		lw $t9,0($a1)
		add $a0,$t9,$zero
	        li $v0,1	
	       syscall
	       la $a0,space
	       li $v0,4
	       syscall
	       addi $a1,$a1,4
	       addi $a2,$a2,1
	       j print
	       
	       exit: 
	       
	       jr $ra   
	              
