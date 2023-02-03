.data
array:.word   0 : 7         # "array" of words to contain values
size: .word  7             # size of "array" (agrees with array declaration)
space:.asciiz  ", "          # space to insert between numbers
message: .asciiz  "2^n in a row starting with n = 0:\n"
.text
      la   $s0, array        # load address of array
      la   $s5, size        # load address of size variable
      lw   $s5, 0($s5)      # load array size

      
      li   $s2, 1           # 1 is the known value of 2^0
      sw   $s2, 0($s0)      # F[0] = 1
      addi $s2, $s2, 1
      sw   $s2, 4($s0)      
      addi $s1, $s5, -2     
      
      
loop: lw   $s4, 4($s0)      
      add  $s2, $s4, $s4    
      sw   $s2, 8($s0)      
      addi $s0, $s0, 4      
      addi $s1, $s1, -1     
      bne $s1, $zero, loop  
      
      # Print.
      la   $a0, array        
      add  $a1, $zero, $s5  
      jal  print             

      # The program is finished. Exit.
      halt
      j die 
		

print:add  $t0, $zero, $a0  
      add  $t1, $zero, $a1  
      la   $a0, message        
      addi  $v0, $zero , 4           
      syscall               
      
printarray:  lw   $a0, 0($t0)     
      addi  $v0, $zero , 1           
      syscall               
      
      la   $a0, space       
      addi  $v0, $zero , 4           
      syscall               
      
      addi $t0, $t0, 4      
      addi $t1, $t1, -1     
      bne $t1, $zero , printarray        
      
      jr   $ra              
      
die:
# End of subroutine
