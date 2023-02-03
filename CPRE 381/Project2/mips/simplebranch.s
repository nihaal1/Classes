main:
	ori $s0, $zero 0x1234
	j skip
	Nop
	Nop
	#li $s0 0xffffffff
	lui $s0, 0xffff
	Nop
	Nop
	Nop
	ori $s0, $s0, 0xffff
	Nop
	Nop

skip:
	ori $s1 $zero 0x1234
	Nop
	Nop
	Nop
	beq $s0 $s1 skip2  
	Nop              
	#li $s0 0xffffffff
	lui $s0, 0xffff
	Nop
	Nop
	Nop
	ori $s0, $s0, 0xffff
skip2:
	jal fun
	Nop
	ori $s3 $zero 0x1234
	
	beq $s0, $zero exit
	Nop
	ori $s4 $zero 0x1234
	j exit
	Nop
	Nop

fun:
	Nop
	Nop
	ori $s2 $zero 0x1234
	jr $ra
	Nop

exit:
	halt

