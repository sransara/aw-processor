org 0x0000
ori $2, $0, 0x4444
beq $2, $1, comehere
ori $1, $0, 0x1337
ori $3, $0, 0x1337
sw $1, 0($2)
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
