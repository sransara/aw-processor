org 0x000
	ori $2, $0, 0x0020
	ori $3, $0, 0x0030
	ori $29, $0, 0xfffc
  sw $2, -8($29)
  sw $3, -8($29)
	halt
