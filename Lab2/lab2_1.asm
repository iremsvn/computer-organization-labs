.data
sizeText: .asciiz "Enter size: "
elementText: .asciiz "Enter element: "
space: .asciiz " "
newLine: .asciiz "\n"
.text
	.globl _start
_start:

jal readArray
#jal print

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

print:
	beq $t1,$s0,printed
	lw $t2,0($t0)
	addi $a0,$t2,0
	li $v0,1
	syscall
	la $a0,space
	li $v0,4
	syscall
	addi $t0,$t0,4
	addi $t1,$t1,1
	j print
	printed:
	
	jr $ra