org 0x0000
  ori $1, $0, dump_here
  sw $1, 0($1)
  lw $2, 0($1)
  addi $2, $2, 1
  sw $2, 4($1)
  halt

dump_here:
