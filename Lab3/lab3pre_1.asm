.data
string: .asciiz "12045"

.text
	.globl _start
_start:

#this part calculates the lenght of the string
size:
	lbu $s1,string($s0) #s0: string lenght
	beq $s1,$zero,done #if its null terminator
	addi $s0,$s0,1
	j size
	done:
	
la $a0,string
add $s0,$s0,$a0

la $a0,string
jal recursive

add $a0,$v0,$zero
li $v0,1
syscall

li $v0,10
syscall

recursive:
	addi $sp,$sp,-8
	sw $t0,0($sp) #saving to stack since its value shouldnt change during execution (recursive returning)
	sw $ra,4($sp)
	
	beq $a0,$s0,donef
	
	#Do job
	move $t0,$a0
	addi $a0,$a0,1
	jal recursive
	lbu $t1,0($t0)
	addi $t1,$t1,-48 #convert ascii to decimal
	add $v0,$v0,$t1
	
	donef:
		lw $t0,0($sp)
		lw $ra,4($sp)
		addi $sp,$sp,8
		addi $v0,$v0,0
		jr $ra
	
