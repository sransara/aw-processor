org 0x0000
ori $1, $0, dumphere
jal mmm
ori $2, $0, 1111
j end

mmm:
  sw $31, 0($1)
  jr $31

end:
  halt

org 0x4444
dumphere:
  cfw 0xBAD1
