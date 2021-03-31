.data
sizeText: .asciiz "Enter size: "
elementText: .asciiz "Enter element: "
space: .asciiz " "
newLine: .asciiz "\n"
.text
	.globl _start
_start:

jal readArray
addi $s0,$v0,0 #load base adress
addi $s1,$v1,0 #load size

addi $t0,$zero,0 
addi $t1,$zero,0 
addi $t2,$zero,0 
addi $t3,$zero,0 

addi $a0,$s0,0 #pass base adress
addi $a1,$s1,0 #pass size
jal bubblesort

li $v0,10
syscall


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
	addi $t3,$t0,0      # $t4 : address of array to be used for index
	addi $t2,$zero,0    #index for loop
	create:
		beq $t2,$t1,done
		la $a0,elementText
		li $v0,4	
		syscall

		li $v0,5
		syscall
		sw $v0,0($t3)
	
		addi $t3,$t3,4
		addi $t2,$t2,1
	j create
	done:
	
	addi $v0,$t0,0  #return the base address of array
	addi $v1,$t1,0  #return the size 
	jr $ra


bubblesort:
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
			jr $ra

