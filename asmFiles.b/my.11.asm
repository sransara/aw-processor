org 0x0000
  ori $sp, $0, 0xFFFC
  ori $3, $0, 0xBEEF
  ori $2, $0, 0x1337
  ori $1, $0, dump_here
  lui $4, 0xDEAD
  sw $3, 0($1)
  jal jump_here
  ori $5, $0, 0x1337
  or $5, $5, $4
  sw $5, 4($1)
  halt

jump_here:
  sw $2, 0($1)
  jr $31

dump_here:
  cfw 0xBAD1
