.data
sizeText: .asciiz "Enter size: "
elementText: .asciiz "Enter element: "
menuText: .asciiz "1)bubble sort 2)Third min max\n3)Mode 0)Exit\nEnter Option: "
invalidText: .asciiz "\n*Invalid Value Entered*"
space: .asciiz " "
newLine: .asciiz "\n"
.text
	.globl _start
_start:

jal monitor

li $v0,10
syscall

####################
monitor:	#s7 is choice
	addi $sp,$sp,-4
	sw $ra,0($sp)
	menu:
	 la $a0,newLine
	 li $v0,4
	 syscall

	 addi $t0,$zero,0
	 addi $t1,$zero,0
	 addi $t2,$zero,0
	 addi $t3,$zero,0
	 addi $t4,$zero,0
	 jal readArray
	 addi $s0,$v0,0
	 addi $s1,$v1,0
	 addi $t0,$zero,0
	 addi $t1,$zero,0
	 addi $t2,$zero,0
	 addi $t3,$zero,0
	 addi $t4,$zero,0
	 addi $a0,$s0,0
	 addi $a1,$s1,0
	 jal print
	 
	la $a0,newLine
	li $v0,4
	syscall
	la $a0,menuText
	li $v0,4
	syscall
	li $v0,5
	syscall
	addi $s7,$v0,0 #s7 is choice

	case1: #bubble sort
	 addi $s6,$zero,1
	 bne $s7,$s6,case2
	 
	 addi $t0,$zero,0 
	 addi $t1,$zero,0 
	 addi $t2,$zero,0 
	 addi $t3,$zero,0 
	 addi $t4,$zero,0
	 addi $a0,$s0,0 #pass base adress
	 addi $a1,$s1,0 #pass size
	 jal bubblesort
	 addi $t0,$zero,0
	 addi $t1,$zero,0
	 addi $t2,$zero,0
	 addi $t3,$zero,0
	 addi $t4,$zero,0
	 addi $a0,$s0,0
	 addi $a1,$s1,0
	 jal print
	 
	 j menu
	
	case2: #third min max
	 addi $s6,$zero,2
	 bne $s7,$s6,case3
	
	 blt $s1,1,invalideror
	 addi $t0,$zero,0 
	 addi $t1,$zero,0 
	 addi $t2,$zero,0 
	 addi $t3,$zero,0 
	 addi $t4,$zero,0
	 addi $a0,$s0,0 #pass base adress
	 addi $a1,$s1,0 #pass size
	 jal thirdMinMax
	 addi $a0,$v0,0
	 li $v0,1
	 syscall

	la $a0,newLine
	li $v0,4
	syscall

	addi $a0,$v1,0
	li $v0,1
	syscall
	 
	j menu 
	 
	case3: #mode
	 addi $s6,$zero,3
	 bne $s7,$s6,case0
	 
	 blt $s1,1,invalideror
	 addi $t0,$zero,0 
	 addi $t1,$zero,0 
	 addi $t2,$zero,0 
	 addi $t3,$zero,0 
	 addi $t4,$zero,0
	 addi $t5,$zero,0
	 addi $t6,$zero,0
	 addi $a0,$s0,0 #pass base adress
	 addi $a1,$s1,0 #pass size
	 jal mode
	 addi $t0,$zero,0
	 addi $t1,$zero,0
	 addi $t2,$zero,0
	 addi $t3,$zero,0
	 addi $t4,$zero,0
	 addi $t5,$zero,0
	 addi $t6,$zero,0
	 addi $a0,$v0,0 #return most frequent
	 li $v0,1
	 syscall

	la $a0,newLine
	li $v0,4
	syscall
	 
	j menu
	 
	case0:
	 beq $s7,$zero,exit
	 #invalid case
	 invalideror:
	 la $a0,invalidText
	 li $v0,4
	 syscall
	 j menu

	 exit:
	 lw $ra,0($sp)
	 addi $sp,$sp,4
	 jr $ra
	 
	
######################
readArray:
	la $a0,sizeText
	li $v0,4
	syscall

	li $v0,5
	syscall
	addi $t1,$v0,0 #t1 : size
	la $a0,($t1)   #allocate space as size
	li $v0, 9           # now, $v0 has the address of allocated memory
	syscall
	addi $t0,$v0,0      # $t0 : address of array to be returned
	addi $t4,$t0,0      # $t4 : address of array to be used for index
	addi $t3,$zero,0    #index for loop
	create:
		beq $t3,$t1,done
		la $a0,elementText
		li $v0,4	
		syscall

		li $v0,5
		syscall
		sw $v0,0($t4)
	
		addi $t4,$t4,4
		addi $t3,$t3,1
	j create
	done:
	
	addi $v0,$t0,0  #return the base address of array
	addi $v1,$t1,0  #return the size 
	jr $ra



##########################
print:
	addi $t0,$a0,0
	printloop:
	beq $t1,$s1,printed
	lw $t2,0($t0)
	addi $a0,$t2,0
	li $v0,1
	syscall
	la $a0,space
	li $v0,4
	syscall
	addi $t0,$t0,4
	addi $t1,$t1,1
	j printloop
	printed:
	
	jr $ra
#########################

bubblesort:
	addi $sp,$sp,-8
	sw $s2,0($sp)
	sw $s3,4($sp)
	addi $t0,$zero,0 #i
	addi $t1,$zero,0 #j
	beq $a1,$zero,done1
	addi $t2,$a1,-1 #size - 1
	while1:
		beq $t0,$t2,done1
		sub $t3,$t2,$t0 #size-1-i
		while2:
			beq $t1,$t3,done2
			lw $t4,0($a0) #arr[j]
			lw $t5,4($a0) #arr[j+1]
			#calculate absolutes
	       		ori $s2, $t4, 0     #copy 
        		slt $t7, $t4, $zero      #is value < 0 ?
        		beq $t7, $zero, foobar1  #if positive, skip next inst
        		sub $s2, $zero, $t4     
			foobar1:
              		ori $s3, $t5, 0     #copy
        		slt $t8, $t5, $zero      #is value < 0 ?
        		beq $t8, $zero, foobar2 #if positive, skip next inst
        		sub $s3, $zero, $t5     
			foobar2:
			blt $s2,$s3,swap
			j pass
			swap:
				addi $t6,$t4,0 #temp: arr[j]
				addi $t4,$t5,0 #arr[j] = arr[j+1]
				addi $t5,$t6,0 #arr[j+1] = temp
				#store as signed
				sw $t4,0($a0)
				sw $t5,4($a0)
				addi $a0,$a0,4
				addi $t1,$t1,1
				j while2
			pass:
			addi $a0,$a0,4
			addi $t1,$t1,1
			j while2
			done2:
			addi $a0,$s0,0
			addi $t0,$t0,1
			addi $t1,$zero,0
			j while1
			done1:
			lw $s2,0($sp)
			lw $s3,4($sp)
			addi $sp,$sp,8
			jr $ra
###################################
thirdMinMax:
        beq $s1,1,sizeone
  	addi $t1,$zero,32767 #first min
  	addi $t2,$zero,32767 #second min
  	addi $t3,$zero,32767 #third min
	min:
		beq $a1,$zero,d_min
		lw $t0,0($a0) #array[i]
		blt $t0,$t1,swap1
		blt $t0,$t2,swap2
		blt $t0,$t3,swap3
		j pass4
		j pass1
		    swap1:
			addi $t3,$t2,0
			addi $t2,$t1,0
			addi $t1,$t0,0
		pass1:
		
		j pass2
		     swap2:
			addi $t3,$t2,0
			addi $t2,$t0,0
		pass2:
		
		j pass3
		     swap3:
			addi $t3,$t0,0
		pass3:
		pass4:
		
		addi $a1,$a1,-1
		addi $a0,$a0,4
	j min
	d_min:
	addi $v0,$t3,0
	
	addi $a0,$s0,0
  	addi $a1,$s1,0
  	addi $t1,$zero,-32768 #first max
  	addi $t2,$zero,-32768 #second max
  	addi $t3,$zero,-32768 #third max
	max:
		beq $a1,$zero,d_max
		lw $t0,0($a0) #array[i]
		bgt $t0,$t1,swap1max
		bgt $t0,$t2,swap2max
		bgt $t0,$t3,swap3max
		j passmax
		j pass1max
		    swap1max:
			addi $t3,$t2,0
			addi $t2,$t1,0
			addi $t1,$t0,0
		pass1max:
		
		j pass2max
		     swap2max:
			addi $t3,$t2,0
			addi $t2,$t0,0
		pass2max:
		
		j pass3max
		     swap3max:
			addi $t3,$t0,0
		pass3max:
		passmax:
		
		addi $a1,$a1,-1
		addi $a0,$a0,4
	j max
	d_max:
	addi $v1,$t3,0
	j not_one
	sizeone:
	lw $t0,0($a0)
	addi $v0,$t0,0
	addi $v1,$t0,0
	not_one:
	
	jr $ra
#################################
mode:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	jal sort
	lw $a1,8($sp)
	lw $a0,4($sp)
	
	lw $t0,0($a0) #most frequent
	addi $t1,$zero,1 #max
	addi $t2,$zero,1 #count
	addi $t3,$zero,1 #i
	frequency:
		beq $t3,$s1,d_frequency
		lw $t8,4($a0) #arr[i]
		lw $t9,0($a0) #arr[i-1]
		beq $t8,$t9,increment
		j p_increment
		increment:
		addi $t2,$t2,1
		j a
		p_increment:
		beq $t2,$t1,p_else
		blt $t2,$t1,p_else
		addi $t1,$t2,0
		addi $t0,$t9,0
		p_else:
		addi $t2,$zero,1
		a:
		addi $t3,$t3,1
		addi $a0,$a0,4
		j frequency
		d_frequency:
		
		#if last element is most frequent
		beq $t2,$t1,p_last
		blt $t2,$t1,p_last
		addi $t1,$t2,0
		addi $t4,$s1,-1
		mul $t4,$t4,4
		add $a0,$s0,$t4
		lw $t0,0($a0)
		p_last:
		addi $v0,$t0,0 #return most freaquent 
		lw $ra,0($sp)
		addi $sp,$sp,8
		jr $ra

sort:
	addi $t0,$zero,0 #i
	addi $t1,$zero,0 #j
	addi $t2,$a1,-1 #size - 1
	sortwhile1:
		beq $t0,$t2,sortdone1
		sub $t3,$t2,$t0 #size-1-i
		sortwhile2:
			beq $t1,$t3,sortdone2
			lw $t4,0($a0)
			lw $t5,4($a0)
			bgt $t4,$t5,sortswap
			j sortpass
			sortswap:
				addi $t6,$t4,0 #temp: arr[j]
				addi $t4,$t5,0 #arr[j] = arr[j+1]
				addi $t5,$t6,0 #arr[j+1] = temp
				sw $t4,0($a0)
				sw $t5,4($a0)
				addi $a0,$a0,4
				addi $t1,$t1,1
				j sortwhile2
			sortpass:
			addi $a0,$a0,4
			addi $t1,$t1,1
			j sortwhile2
			sortdone2:
			addi $a0,$s0,0
			addi $t0,$t0,1
			addi $t1,$zero,0
			j sortwhile1
			sortdone1:
			jr $ra