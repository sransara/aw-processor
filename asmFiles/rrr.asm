org 0x0000
ori $2, $0, 0x4444
ori $5, $0, -10
ori $1, $0, 0x13375
ori $3, $0, 0x13375
slti $1, $1, 0x44445
sw $1, 0($2)
slti $1, $2, 0x13375
sw $1, 12($2)
slti $1, $2, -10
sw $1, 16($2)
slti $1, $5, 0x44445
sw $1, 20($2)
sltiu $1, $1, 0x44445
sw $1, 24($2)
sltiu $1, $2, 0x13375
sw $1, 28($2)
sltiu $1, $2, -10
sw $1, 32($2)
sltiu $1, $5, 0x44445
sw $1, 36($2)
beq $3, $1, comehere
ori $1, $0, 0xBAD2
ori $1, $0, 0xBAD3
comebackhere:
  jal jumpall
  lw $1, 8($2)
  j end

comehere:
  sw $1, 4($2)
  ori $1, $0, 0xBAD8
  bne $1, $3, comebackhere

jumpall:
  sw $1, 8($2)
  ori $1, $0, 0xBAD9
  jr $31

end:
  halt

org 0x4444
dumphere:
  cfw 0xBAD1
