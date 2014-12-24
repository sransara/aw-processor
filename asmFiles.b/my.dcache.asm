org 0x0000
  ori $1, $0, dump_here
  ori $2, $0, 0x1337
  sw $2, 4($1)
  lw $3, 4($1)
  sw $3, 8($1)
end:
  halt

dump_here:
