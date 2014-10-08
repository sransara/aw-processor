org 0x000
  ori $17, $0, dump_here
	ori $29, $0, 0xfffc
	ori $3, $0, 0x0003
  ori $11, $0, 1
	beq $0, $0, finish
finish:
  addi $3, $3, 1
  sw $3, 0($17)
	halt

dump_here:
