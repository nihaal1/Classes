.data
arr:
        .word   34 #0 
        .word   57#1
        .word   85#2
        .word   57#3
        .word	11#4
.text
main:
  li $sp, 0x10011000
  sub	$sp, $sp, 32
  addi	$a0, $sp, 8
  addi	$a1, $zero, 20
  sw	$a1, 4($sp)
  addi	$t1, $zero, 5
  sw	$t1, 0($a0)
  addi	$t1, $zero, 4
  sw	$t1, 4($a0)
  addi	$t1, $zero, 3
  sw	$t1, 8($a0)
  addi	$t1, $zero, 2
  sw	$t1, 12($a0)
  addi	$t1, $zero, 1
  sw	$t1, 16($a0)
  addi	$t1, $zero, 0
pos:
  addi  $t8, $sp, 8    
  addi  $t7, $zero, 0   
  addi  $t6, $zero, 4   

loop:
  slt   $t9, $t6, $a1
  bne   $t9, 1, swap
  lw	$t0, 0($t8)             
  lw	$t1, 4($t8)             
  slt	$t2, $t1, $t0           
  bne	$t2, 1, outer        	
  sw	$t1, 0($t8)             
  sw	$t0, 4($t8)             
  addi	$t7, $zero, 1          
  j	outer                

outer:
  addi    $t6, $t6, 4           
  addi    $t8, $t8, 4           
  j       loop            
swap:
  beq	$t7, 1, pos

while_exit:
  lw	$t0, 0($a0)
  lw	$t1, 4($a0)
  lw	$t2, 8($a0)
  lw	$t3, 12($a0)
  lw	$t4, 16($a0)
  halt
