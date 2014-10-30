org 0x0000

ori   $1, $0, 0x3
come_back_here:
ori   $8, $8, 4
ori   $6, $6, 0x0F00
addiu  $1, $1, -1
beq   $1, $0, sss
j come_back_here

sss:
halt
