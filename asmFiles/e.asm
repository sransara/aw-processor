ori $2, $0, 0x4444
lui $1, 0xFFFF
sw $1, 0($2)
ori $1, $0, 0x1337
sw $1, 0($2)

end:
  halt

org 0x4444
dumphere:
  cfw 0xBAD1
