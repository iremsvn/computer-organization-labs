.data

enterj: .asciiz "Enter j(column)\n"
enteri: .asciiz "Enter i(row)\n"
enterVal: .asciiz "Enter the value of "
endl: .asciiz "\n"
space: .asciiz " "
msgMenu: .asciiz "1)Create Matrix\n2)Display Element\n3)Sum row by row\n4)Sum column by column\n5)display given row and col\n"
msgSize: .asciiz "Size: "

.text

 main:
	
	jal Menu
	
	li $v0,10
	syscall




####################################
Menu:
	la $a0, msgMenu
	li $v0, 4
	syscall # Enter the size of Matrix and write values one by one
	
	li $v0, 5
	syscall
	
	addi $s7,$v0,0 #S7 ÝS CHOÝCE 
	
	case1: #CREATE
	 addi $s6,$zero,1
	 bne $s7,$s6,case2
	 
	 jal createMatrix
	 addi $s0,$v0,0 #s0 is n
	 j Menu
	 
	case2: #display element
	 addi $s6,$zero,2
	 bne $s7,$s6,case3
	 
	jal display
	j Menu
	 
	case3: #row sum
	 addi $s6,$zero,3
	 bne $s7,$s6,case4
	 
	jal rowSum
	j Menu
	 
	case4: #col sum
	 addi $s6,$zero,4
	 bne $s7,$s6,case5
	 
	jal colSum
	j Menu
	 
	case5: #row col display
	 addi $s6,$zero,5
	 bne $s7,$s6,default
	 
	jal rowcol
	j Menu
	 
	default: 
	
	  jal Menu
	
##################################

createMatrix:
	
	la $a0, msgSize
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	addi $t0, $v0,0 #N
	
	mul $t1,$t0,$t0 #t1 : size
	
	la $a0,($t1)   #allocate space as size
	li $v0, 9      # now, $v0 has the address of allocated memory
	syscall
	
	addi $t9,$v0,0 #t9 has base address
	addi $s1,$t9,0 #s1 will hold base adress in whole program
	 
	addi $t2,$0,0 #col
	addi $t3,$0,0 #row
	addi $t7,$0,1
	
	loopcol:
		beq $t2,$t0,coldone

		looprow:
			beq $t3,$t0,rowdone			
			
		        sw $t7,0($t9)
		        
		        addi $t9,$t9,4
		        addi $t3,$t3,1
		        
		        addi $t7,$t7,1
		        
		        j looprow
		    rowdone:
		    addi $t3,$0,0
		    addi $t2,$t2,1
		    
		    addi $t7,$t7,1
		    j loopcol
		coldone:
		
		addi $v0,$t0,0 #n
		jr $ra
################################################	
display:
	#i
	la $a0, enteri
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	addi $t0, $v0,0
	 
	#j
	la $a0, enterj
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	addi $t1, $v0,0
	
	#calculate index 
	addi $t1, $t1, -1
	mul $t1, $t1, $s0
	mul $t1, $t1, 4
	addi $t0, $t0, -1
	mul $t0, $t0, 4
	add $t1, $t0, $t1
	
	
	add $t0, $s1, $t1
	
	lw $t2, 0($t0)
	
	## display the element
	addi $a0, $t2, 0
	li $v0, 1
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall 
		
	jr $ra
	
#########################################
rowSum:
	addi $t9,$0,0
	
	addi $t0, $zero, 1 #i 
	addi $t1, $zero, 1 #j
	
	addi $t8, $zero, 0
looprow2: bgt $t0, $s0, outrow2
loopcol2: bgt $t1, $s0, outcol2

	#calculate index of matrix
	addi $t3, $t1, -1
	mul $t3, $t3, $s0
	mul $t3, $t3, 4
	addi $t4, $t0, -1
	mul $t4, $t4, 4
	add $t3, $t4, $t3 
	
	# add index to beginning of the array
	add $t4, $s1, $t3 # t4 is the address of element
	
	
	lw $t5, 0($t4)
	
	add $t8, $t8, $t5
	
	addi $t1, $t1, 1
	
	j loopcol2
outcol2:
 	
	
	addi $t1, $zero, 1
	addi $t0, $t0, 1
	
	add $t9,$t9,$t8 #t9 is total sum
	
	addi $t8, $zero, 0

	j looprow2
	
outrow2:
	
	addi $a0, $t9,0	  #gives total sum
	li $v0, 1
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	jr $ra

##########################################

colSum:

	addi $t9,$0,0

	addi $t0, $zero, 1 #i 
	addi $t1, $zero, 1 #j
	addi $t8, $zero, 0
	
loopcol3: 
	bgt $t0, $s0, outcol3
	
looprow3: 
	bgt $t1, $s0, outrow3

	#calculate index 
	addi $t3, $t0, -1
	mul $t3, $t3, $s0
	mul $t3, $t3, 4
	addi $t4, $t1, -1
	mul $t4, $t4, 4
	add $t3, $t4, $t3 
	
	# add index to beginning of the array
	add $t4, $s1, $t3 
	
	# take element from mem
	lw $t5, 0($t4)
	
	add $t8, $t8, $t5
	
	addi $t1, $t1, 1
	
	j looprow3
outrow3:

	add $t9,$t9,$t8 #t9 is total sum
	
	addi $t1, $zero, 1
	addi $t0, $t0, 1
	addi $t8, $zero, 0
	
	j loopcol3
	
outcol3:
	
	addi $a0, $t9,0	  #gives total sum
	li $v0, 1
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall 
	
	jr $ra

#########################################

rowcol:

	la $a0, endl
	li $v0, 4
	syscall 

	la $a0, enteri
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	addi $t1, $v0,0 #row i
	
	addi $t0,$0,1  #col
		
looprow4: 
	bgt $t0, $s0, outrow4

	#calculate index 
	addi $t3, $t0, -1
	mul $t3, $t3, $s0
	mul $t3, $t3, 4
	addi $t4, $t1, -1
	mul $t4, $t4, 4
	add $t3, $t4, $t3 
	
	# add index to beginning of the array
	add $t4, $s1, $t3 
	
	# take element from mem
	lw $t5, 0($t4)
	
	addi $a0, $t5,0
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall 
	
	addi $t0, $t0, 1
	
	j looprow4	
	
outrow4:

	la $a0, endl
	li $v0, 4
	syscall 
 
 	##

	la $a0, enterj
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	addi $t0, $v0,0 #col j
	
	addi $t1,$0,1  #row
		
loopcol4: 
	bgt $t1, $s0, outcol4

	#calculate index 
	addi $t3, $t0, -1
	mul $t3, $t3, $s0
	mul $t3, $t3, 4
	addi $t4, $t1, -1
	mul $t4, $t4, 4
	add $t3, $t4, $t3 
	
	# add index to beginning of the array
	add $t4, $s1, $t3 
	
	# take element from mem
	lw $t5, 0($t4)
	
	addi $a0, $t5,0
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall 
	
	addi $t1, $t1, 1
	
	j loopcol4	
	
outcol4:

	la $a0, endl
	li $v0, 4
	syscall 
		
	jr $ra
		
	
	






