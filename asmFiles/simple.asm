org 0x0000
ori $1, $0, 0x1337
ori $2, $0, 0x4444
bne $1, $1, dontcomehere
bne $2, $1, comehere
ori $1, $0, 0xBAD3
comebackhere:
  lw $1, 0($2)
  sw $1, 4($2)
  sw $1, 8($2)
  sw $1, 12($2)
  sw $1, -16($2)
  sw $1, -20($2)
  j end

comehere:
  nor $1, $2, $1
  sw $1, 0($2)
  ori $1, $0, 0xBAD8
  bne $1, $2, comebackhere
  sw $1, 0($2)

dontcomehere:
  ori $1, $0, 0xBAD1
  sw $1, 0($2)

end:
  halt

org 0x4444
dumphere:
  cfw 0xBAD1
