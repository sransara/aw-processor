org 0x0000
  ori $sp, $0, 0xFFFC
  ori $4, $0, 6
  ori $5, $0, 5
  push $4
  push $5
  jal mult
  halt

mult: # regs $2 $3 $20 will be modified
  pop $3
  pop $2
  push $11 # Used for LSB result
  ori $20, $0, 0x0 # Store result in $20
mult_start:
  beq $3, $0, mult_end
  andi $11, $3, 0x1
  beq $11, $0, mult_even
mult_odd:
  addu $20, $2, $20
  addiu $3, $3, -1
mult_even:
  sll $2, $2, 0x1
  srl $3, $3, 0x1
  j mult_start
mult_end:
  pop $11 # restore $11, $10
  push $20
  jr $31
