.data
sizeText: .asciiz "Enter size: "
elementText: .asciiz "Enter element: "
space: .asciiz " "
newLine: .asciiz "\n"
.text
	.globl _start
_start:
addi $sp,$sp,-20
sw $t0,0($sp)
sw $t1,4($sp)
sw $t2,8($sp)
sw $t3,12($sp)
sw $t4,16($sp)
jal readArray
addi $s0,$v0,0  #base address of array
addi $s1,$v1,0  #size of array
lw $t0,0($sp)
lw $t1,4($sp)
lw $t2,8($sp)
lw $t3,12($sp)
lw $t4,16($sp)
addi $sp,$sp,20

addi $sp,$sp,-20
sw $t0,0($sp)
sw $t1,4($sp)
sw $t2,8($sp)
sw $t3,12($sp)
sw $t4,16($sp)
addi $a0,$s0,0
addi $a1,$s1,0
jal ThirdMinMax
lw $t0,0($sp)
lw $t1,4($sp)
lw $t2,8($sp)
lw $t3,12($sp)
lw $t4,16($sp)
addi $sp,$sp,20

addi $a0,$v0,0
li $v0,1
syscall

la $a0,newLine
li $v0,4
syscall

addi $a0,$v1,0
li $v0,1
syscall

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
	li $v0, 9      # now, $v0 has the address of allocated memory
	syscall
	addi $t0,$v0,0      # $t0 : address of array to be returned
	addi $t4,$t0,0      # $t4 : address of array to be used for index
	addi $t3,$zero,0    #index for loop
	create:
		beq $t3,$t1,d_create
		la $a0,elementText
		li $v0,4	
		syscall

		li $v0,5
		syscall
		sw $v0,0($t4)
	
		addi $t4,$t4,4
		addi $t3,$t3,1
	j create
	d_create:
	
	addi $v0,$t0,0  #return the base address of array
	addi $v1,$t1,0  #return the size 
	jr $ra
	
	
ThirdMinMax:
  	addi $t1,$zero,32767 #first min
  	addi $t2,$zero,32767 #second min
  	addi $t3,$zero,32767 #third min
	min:
		beq $a1,$zero,d_min
		lw $t0,0($a0) #array[i]
		blt $t0,$t1,swap1
		blt $t0,$t2,swap2
		blt $t0,$t3,swap3
		j pass
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
		pass:
		
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
	
	jr $ra