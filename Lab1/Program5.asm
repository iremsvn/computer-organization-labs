.data
sizeText: .asciiz "Enter size: "
elementText: .asciiz "Enter element: "
menuText: .asciiz "1)sum of numbers less than, 2)sum of numbers out of range\n3)num of occurance division, 0)Exit\nEnter Option: "
invalidText: .asciiz "\n*Invalid Choice Entered*"
shouldgreaterText: .asciiz "\n*Second number must be greater than the first number*\n"
space: .asciiz " "
newLine: .asciiz "\n"
.text
	.globl _start
_start:

la $a0,sizeText
li $v0,4
syscall

li $v0,5
syscall
addi $s0,$v0,0 #s0 : size
addi $t0,$s0,0 
mul $t0, $v0, 4     # int is 4 bytes
addi $a0, $t0,0     # allocate the size of the array in the heap
li $v0, 9           # now, $v0 has the address of allocated memory
syscall
addi $s1,$v0,0      # $s1 : address of array to be stored
addi $t0,$s1,0      # $t0 : address of array to be used
addi $t1,$zero,0 #index
create:
	beq $t1,$s0,done
	la $a0,elementText
	li $v0,4
	syscall

	li $v0,5
	syscall
	sw $v0,0($t0)
	
	addi $t0,$t0,4
	addi $t1,$t1,1
	j create
	
	done:
	
addi $t0,$s1,0
addi $t1,$zero,0 #index
jal print

####################
menu:	#s3 is choice
	la $a0,newLine
	li $v0,4
	syscall
	la $a0,menuText
	li $v0,4
	syscall
	li $v0,5
	syscall
	addi $s3,$v0,0

	case1: #sum of elements less than given number
	 addi $t2,$zero,1
	 bne $s3,$t2,case2
	 
	 la $a0,elementText
	 li $v0,4
	 syscall
	 li $v0,5
	 syscall
	 addi $a2,$v0,0 #entered number
	 addi $a1,$s1,0 #a1 hold first address in array
	 jal func1
	 addi $a0,$v0,0
	 li $v0,1
	 syscall
	j menu
	
	case2:
	 addi $t2,$zero,2
	 bne $s3,$t2,case3
	 
	 la $a0,elementText
	 li $v0,4
	 syscall
	 li $v0,5
	 syscall
	 addi $a2,$v0,0 #entered number
	 j pass
	 eror2:
	 la $a0,shouldgreaterText
	 li $v0,4
	 syscall
	 pass:
	 la $a0,elementText
	 li $v0,4
	 syscall
	 li $v0,5
	 syscall
	 addi $a3,$v0,0 #entered number
	 blt $a3,$a2,eror2
	 addi $a1,$s1,0 #a1 hold first address in array
	 jal func2	
	 addi $a0,$v0,0
	 li $v0,1
	 syscall
	 
	j menu
	 
	case3: #divisible
	 addi $t2,$zero,3
	 bne $s3,$t2,case0
	 
	 la $a0,elementText
	 li $v0,4
	 syscall
	 li $v0,5
	 syscall
	 addi $a2,$v0,0 #entered number
	 beq $a2,$zero,case3
	 addi $a1,$s1,0 #a1 hold first address in array
	 jal func3
	 addi $a0,$v0,0
	 li $v0,1
	 syscall
	 
	j menu
	 
	case0:
	 beq $s3,$zero,exit
	 #invalid case
	 la $a0,invalidText
	 li $v0,4
	 syscall
	 j menu

	 exit:
######################
	 

li $v0,10
syscall 

#####################
func1:
	addi $t0,$zero,0 #t0 : sum
	addi $t1,$zero,0 #t1 : index
	addi $a2,$a2,-1 #if equal not add it 
	sum:
		beq $t1,$s0,done1 #if index equals size of array
		lw $t2,0($a1)
		bgt $t2,$a2,bigger
		add $t0,$t0,$t2	
		bigger:	
		addi $a1,$a1,4 #increment address
		addi $t1,$t1,1	
		j sum
		done1:
		addi $v0,$t0,0	
	jr $ra

####################
func2:
	addi $t0,$zero,0 #t0 : sum
	addi $t1,$zero,0 #t1 : index
	sum2:
	beq $t1,$s0,done2 #if index equals size of array
	lw $t2,0($a1)
	blt $t2,$a2,outrange
	bgt $t2,$a3,outrange
	j a
	outrange:	
	add $t0,$t0,$t2	
	a:
	addi $a1,$a1,4 #increment address
	addi $t1,$t1,1	
	j sum2
	done2:
	addi $v0,$t0,0	
	
	jr $ra
#################### 	

func3:
	addi $t0,$zero,0 #t0 : occurance
	addi $t1,$zero,0 #t1 : index
	divisible:
		beq $t1,$s0,done3 #if index equals size of array
		lw $t2,0($a1)
		div $t2,$a2
		mfhi $t3 #remainder 
		bne $t3,$zero,notdivisible
		addi $t0,$t0,1
		notdivisible:	
		addi $a1,$a1,4 #increment address
		addi $t1,$t1,1	
		j divisible
		done3:
		addi $v0,$t0,0	
	jr $ra
####################
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
	
	
	


	
	

