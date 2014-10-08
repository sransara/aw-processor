org 0x000
	ori $29, $0, 0xfffc	

	ori $2, $0, 0x0020
	ori $3, $0, 0x0005

	push $2
	push $3

	JAL mult
        lw $28, 0($29)
	halt
mult:
	pop $3
	pop $2
	ori $11, $0, 0x0001
	ori $10, $0, 0x0000
start:	beq $3, $0, finish
	subu $3, $3, $11
	addu $10, $10, $2
	J start
finish:
	push $10
	JR $31
