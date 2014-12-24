org 0x0000
  ori $1, $0, dump_here
  ori $2, $0, 0x1337
  ori $3, $0, 0xBEEF
  beq $0, $0, jump_here
  sw $3, 0($1)
end:
  halt

jump_here:
  sw $2, 0($1)
  j end

dump_here:
  cfw 0xBAD1
