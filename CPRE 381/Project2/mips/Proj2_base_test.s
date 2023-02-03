.data
.text


begin:
	add    $t1,  $0,  $0
    nop
    nop
    nop
	addi   $t1,  $0,  0x0001
    nop
    nop
    nop
	addu   $t1,  $0,  $t1
    nop
    nop
    nop
	and    $t1,  $0,  $t1
	andi   $t2,  $0,  0x0001
    nop
    nop
	addiu  $t1,  $0,  0xFFFF0010
    nop
    nop
    nop
	beq    $t1,  $t2,  next 
    nop
    nop
	j      next

next:
	sw      $t2, 0($t1)
	lui     $t3, 0x1010
	lw      $t7, 0($t1)
    nop
    nop
    nop
	nor     $t7,  $0,  $t1
    nop
    nop
    nop
	xor     $t4,  $0,  $t7
	xori    $t4,  $0,  0x0001
	or      $t4,  $0,  $t1
	ori     $t4,  $0,  0x0001
	slt     $t4,  $0,  $t1
	slti    $t4,  $0,  0x0001
	sll     $t4,  $0,  0x0002
	srl     $t4,  $0,  0x0002
	sra     $t4,  $0,  0x0001
	sub     $t4,  $t0,  $t1     
	jal     end
	halt      

end:
	repl.qb $t5,  0x01
	movn    $t6,  $t2,  $t1
	bne     $t1,  $t4,  begin
	jr      $ra
	
	halt 

