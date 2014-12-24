org 0x0000
  ori $sp, $0, 0xFFFC
  ori $1, $0, dump_here
  ori $2, $0, 0x1337
  sw $2, 4($1)
  lw $3, 4($1)
  sw $3, 8($1)
  beq $1, $1, jump_here
end:
  halt

jump_here:
  sw $2, 0($1)
  j end

dump_here:
  cfw 0xBAD1
