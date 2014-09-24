onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/DUT/CPU/DP/memwb.dmemload
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/CU/opcode
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate /system_tb/DUT/CPU/DP/memwb.DataRead
add wave -noupdate /system_tb/DUT/CPU/DP/exmem.DataWrite
add wave -noupdate /system_tb/DUT/CPU/DP/memwb.RegWr
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/pcif/cpc
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/pcif/npc
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/pcif/pc_plus
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/wen
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate /system_tb/DUT/CPU/DP/ifid
add wave -noupdate /system_tb/DUT/CPU/DP/idex
add wave -noupdate /system_tb/DUT/CPU/DP/exmem
add wave -noupdate /system_tb/DUT/CPU/DP/memwb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {219980 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {336032 ps}
