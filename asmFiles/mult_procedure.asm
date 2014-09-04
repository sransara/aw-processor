org 0x4000
  ori $sp, $0, 0xFFFC
  lw  $15, DATA_LENGTH($0)
  ori $16, $0, 0x0    # indexer
  addi $5, $sp, -4    # store $sp for later

# register $4 will be used to store the values
FRUITY_LOOP:
  beq $16, $15, BUNTY_LOOP
    lw $4, LONG_DATA($16)
    push $4
    addi $16, $16, 0x4
  j FRUITY_LOOP

BUNTY_LOOP:
  beq $sp, $5, END_OF_THE_WORLD
    jal mult
  j BUNTY_LOOP

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
  addi $3, $3, -1
mult_even:
  sll $2, $2, 0x1
  srl $3, $3, 0x1
  j mult_start
mult_end:
  pop $11 # restore $11, $10
  push $20
  jr $31

org 0x8000
DATA_LENGTH:
  # data length * 4
  cfw 20
LONG_DATA:
  cfw 0x2
  cfw 0x2
  cfw 0x2
  cfw 0x2
  cfw 0x32
