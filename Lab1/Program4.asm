.data
textA: .asciiz "enter A: "
textB: .asciiz "enter B: "
textC: .asciiz "enter C: "
textD: .asciiz "enter D: "
textE: .asciiz "enter E: "
newLine: .asciiz "\n"

.text
  .globl _start
 _start:
 	
 	la $a0,textA
 	li $v0,4
 	syscall
 	
 	li $v0,5
 	syscall
 	addi $s0,$v0,0
 	
 	la $a0,newLine
 	li $v0,4
 	syscall
 	
 	la $a0,textB
 	li $v0,4
 	syscall
 
 	li $v0,5
 	syscall
 	addi $s1,$v0,0
 	
 	la $a0,newLine
 	li $v0,4
 	syscall
 	
 	la $a0,textC
 	li $v0,4
 	syscall
 
 	li $v0,5
 	syscall
 	addi $s2,$v0,0
 	
 	la $a0,newLine
 	li $v0,4
 	syscall
 	
 	la $a0,textD
 	li $v0,4
 	syscall
 
 	li $v0,5
 	syscall
 	addi $s3,$v0,0
 	
 	la $a0,newLine
 	li $v0,4
 	syscall
 	
 	la $a0,textE
 	li $v0,4
 	syscall
 
 	li $v0,5
 	syscall
 	addi $s4,$v0,0
 	
 	la $a0,newLine
 	li $v0,4
 	syscall
 	
 	addi $t0,$zero,0 #t0 is result
 	
 	mul $t0,$s0,$s1
 	div $t0,$s2
 	mfhi $t0
 	sub $t1,$s4,$s3
 	mul $t0,$t0,$t1
 	
 	addi $a0,$t0,0
 	li $v0,1
 	syscall
 	
 	li $v0,10
 	syscall
 	
 	
 	