.data
octalNo: .asciiz "20"

.text
	.globl _start
_start:

#this part calculates the lenght of the string
size:
	lbu $s1,octalNo($s0) #s0: string lenght
	beq $s1,$zero,done
	addi $s0,$s0,1
	j size
	done:

addi $s1,$zero,0 #s1: result
la $a0,octalNo	  #a0: adress of octalNo
jal convertToDec
add $a0,$v0,$zero
li $v0,1
syscall

li $v0,10
syscall

convertToDec:
	addi $sp,$sp,-8 #allocating space from stack
	sw $s1,4($sp)   #saving result
	sw $s0,0($sp)   #saving lenght
	addi $t2,$s0,0 
	addi $t3,$s0,0
	loop:
		beq $t0,$t2,exit
		lbu $t1,0($a0)
		addi $t1,$t1,-48 #convert ascii to decimal
	octal:
		beq $s0,1,octaldone
		mul $t1,$t1,8
		addi $s0,$s0,-1
		j octal
	octaldone:
	add $s1,$s1,$t1
	addi $a0,$a0,1
	addi $t0,$t0,1 
	addi $t3,$t3,-1
	addi $s0,$t3,0
	j loop
	exit:
	addi $v0,$s1,0
	lw $s0,0($sp)
	lw $s1,4($sp) 
	addi $sp,$sp,8 #deallocating space
	jr $ra

