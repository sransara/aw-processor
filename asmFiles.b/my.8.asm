org 0x0000
  ori $1, $0, dump_here
  ori $3, $0, 0xBEEF
  sw $3, 0($1)
  nop
  nop
  halt

dump_here:
  cfw 0xBAD1
