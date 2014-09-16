org 0x4000
  ori $sp, $0, 0xFFFC

  ori $4, $0, 2014  # current year
  ori $5, $0, 8     # current month
  ori $6, $0, 28    # current day

  ori $7, $0, 365   # current yr mul
  ori $8, $0, 30    # current dy mul

  addiu $4, $4, -2000
  addiu $5, $5, -1

  push $7
  push $4
  jal mult
  pop $7

  push $8
  push $5
  jal mult
  pop $8

  addu $20, $7, $8
  addu $20, $20, $6

END_OF_THE_WORLD:
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
