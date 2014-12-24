org 0x0000
ori $1, $0, data
ori $11, $0, sorted
ori $2, $0, 22
sll $2, $2, 2
ori $4, $0, 0
ori $5, $0, 0
comeback:
beq $4, $2, comeback2
lw $9, data($4)
sw $5, data2($4)
addu $5, $9, $5
addiu $4, $4, 4
j comeback
comeback2:
ori $4, $0, 0
comeback3:
beq $4, $2, end
lw $9, data2($4)
sw $5, data($4)
addu $5, $9, $5
addiu $4, $4, 4
j comeback3

end:
sw $5, 0($11)
halt

org 0x500
data:
cfw 81
cfw 51

org 0x600
data2:
cfw 81
cfw 51

org 0x700
sorted:
