.data
arr:
        .word   34 #0 
        .word   57#1
        .word   85#2
        .word   57#3
        .word	11#4
.text
main:
  #li $29, 0x10011000
  lui $1, 0x1001
  nop
  nop
  nop

  ori $29, $1,0x1000
  nop
  nop
  nop

  addi	$29, $29, -32
  nop
  nop
  nop

  addi	$4, $29, 8
  addi	$5, $zero, 20
  nop
  nop
  nop

  sw	$5, 4($29)

  addi	$9, $zero, 5
  nop
  nop
  nop

  sw	$9, 0($4)
  
  addi	$9, $zero, 4
  nop
  nop
  nop

  sw	$9, 4($4)

  addi	$9, $zero, 3
  nop
  nop
  nop

  sw	$9, 8($4)
  addi	$9, $zero, 2
  nop
  nop
  nop

  sw	$9, 12($4)
  addi	$9, $zero, 1
  nop
  nop
  nop

  sw	$9, 16($4)
  addi	$9, $zero, 0

pos:
  nop
  nop
  nop
  addi  $24, $29, 8    
  addi  $15, $zero, 0   
  addi  $14, $zero, 4   

loop:
    nop
    nop
    nop
  slt   $25, $14, $5
  nop
  nop
  nop

  bne   $25, 1, swap
  lw	$8, 0($24)             
  lw	$9, 4($24)  
  nop
  nop
  nop           
  slt	$10, $9, $8
  nop
  nop
  nop
           
  bne	$10, 1, outer        	
  sw	$9, 0($24)             
  sw	$8, 4($24)             
  addi	$15, $zero, 1          
  j	outer                

outer:
  nop
  nop
  nop
  addi    $14, $14, 4           
  addi    $24, $24, 4     
      
  j       loop    
        
swap:
  nop
  nop
  nop

  beq	$15, 1, pos
  nop
  nop
  nop

while_exit:
  lw	$8, 0($4)
  lw	$9, 4($4)
  lw	$10, 8($4)
  lw	$11, 12($4)
  lw	$12, 16($4)
  halt
