.data
	displayAddress:	.word	0x10040000
	max: .word 0
	youwin: .asciiz "Yow win!"
	youlose: .asciiz "you lose!"
	prompt: .asciiz "Enter a number(1-4)"
	newline: .asciiz "\n"
	invalid: .asciiz "Invalid Input!\n"
.text
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xff0000	# $t1 stores the red colour code
	li $t2, 0x00ff00	# $t2 stores the green colour code
	li $t3, 0x0000ff	# $t3 stores the blue colour code
	li $t4, 0xffff00 	# $t4 stores the yellow color
	la $t5, max # store the max value
	li $t7, 0 #default displayed index
	li $t8, 32

	#sw $t1, 0($t0)	 # paint the first (top-left) unit red. 
	#sw $t2, 4($t0)	 # paint the second unit on the first row green. Why $t0+4?
	#sw $t3, 128($t0) # paint the first unit on the second row blue. Why +128?
	#sw $t4, 132($t0) # paint the first unit on the second row blue. Why +128?
	#addi $t0, $t0, 4
	#sw $t4, 0($t0) # paint the first unit on the second row blue. Why +128?
	j loopstart

blink:
	li $t9, 1 # store the random numbers comparator	
	beq $t6, $t9, blink1
	add $t9, $t9, 1
	beq $t6, $t9, blink2
	add $t9, $t9, 1
	beq $t6, $t9, blink3
	add $t9, $t9, 1
	beq $t6, $t9, blink4
	
	#print invalid blink
	la $a0, invalid
	li $v0, 4
	syscall
	j Exit
blink1:
	sw $t1, 0($t0) # paint the first unit on the second row blue. Why +128?
	j readinput
blink2:
	sw $t2, 0($t0) # paint the first unit on the second row blue. Why +128?
	j readinput
blink3:
	sw $t3, 0($t0) # paint the first unit on the second row blue. Why +128?
	j readinput
blink4:
	sw $t4, 0($t0) # paint the first unit on the second row blue. Why +128?
	j readinput
loopstart:
	j random

loop:
	#sw $t4, 0($t0) # paint the first unit on the second row blue. Why +128?
	addi $t0, $t0, 4 # increment position by 1 cell
	add $t7,$t7, 1 #increment index
	j compare

compare:

	#compare value read and the last value displayed
	bne $t6, $s0, lose
	bge $t7, $t8, maxreached
	
	j loopstart # continue with program
	
random: 
	li $a1, 4 #set the max -1 of the numbers
   	li $v0, 42  #generates the random number.
    	syscall  
    	
    	add $a0, $a0, 1 # add 1 so that the numbers are now (1-4) instead of (0-3)
    	move $t6, $a0 # store in our local variable the random number
    		
    	#print random number
    	li $v0, 1
    	syscall
    	
    	
    	
    	la $a0, newline
    	li $v0, 4 #print new line
    	syscall
    	
    	j blink
 

readinput:
	
	la $a0, prompt
    	#addi $v0, $0, 4 #19
    	li $v0, 4
    	syscall #print prompt
    	
	li $v0,5 # 12 # 12 for single number 5 for number
    	syscall
    	move $s0, $v0
    	la $a0, newline
    	li $v0, 4 #print new line
    	syscall
    	j loop #call loop
lose:
	#print lose message
	la $a0, youlose
	li $v0, 4
	syscall
	j Exit
win:
	#print win message
	la $a0, youwin
	li $v0, 4
	syscall
	j Exit
maxreached:
	bne $s0, $t6, lose
	j win
	#print won
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
        
