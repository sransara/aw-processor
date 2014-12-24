org 0x0000
ori $1, $0, 111
sw $1, data1($0)
sw $1, data2($0)
lw $3, data3($0)
ori $4, $3, 0
sw $4, data4($0)
halt

org 0x300
data1:
cfw 81
cfw 51

org 0x400
data2:
cfw 81
cfw 51

org 0x500
data3:
cfw 81
cfw 51

org 0x600
data4:
cfw 81
cfw 51
