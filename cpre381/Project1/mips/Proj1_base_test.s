.data
.text


begin:
	add    $t1,  $0,  $0
	addi   $t1,  $0,  0x0001
	addu   $t1,  $0,  $t1
	and    $t1,  $0,  $t1
	andi   $t2,  $0,  0x0001
	addiu  $t1,  $0,  0xFFFF0010
	bne    $t1,  $t2,  next 
	j      next

next:
	sw      $t2, 0($t1)
	lui     $t3, 0x1010
	lw      $t7, 0($t1)
	nor     $t7,  $0,  $t1
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
	beq     $t1,  $t4,  begin
	jr      $ra
	
