onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/DUT/CPU/DP/exmem.aluout
add wave -noupdate /system_tb/DUT/CPU/DP/idex.funct
add wave -noupdate /system_tb/DUT/CPU/DP/HUZ/huif/pipe_stall
add wave -noupdate /system_tb/DUT/CPU/DP/HUZ/huif/ifid_FLUSH
add wave -noupdate /system_tb/DUT/CPU/DP/memwb.dmemload
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate /system_tb/DUT/CPU/DP/CU/opcode
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate /system_tb/DUT/CPU/DP/memwb.DataRead
add wave -noupdate /system_tb/DUT/CPU/DP/exmem.DataWrite
add wave -noupdate /system_tb/DUT/CPU/DP/memwb.RegWr
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
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
add wave -noupdate -expand /system_tb/DUT/CPU/DP/ifid
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/idex_DataRead
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/idex_rt
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/ifid_rs
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/ifid_rt
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/dpif_ihit
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/dpif_dhit
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/idex_Halt
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/pc_WEN
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/pipe_stall
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/ifid_FLUSH
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/idex_FLUSH
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/exmem_FLUSH
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/huif/memwb_FLUSH
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/load
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/opcode
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/funct
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/rs
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/rd
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/rt
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/addr
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/imm
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/shamt
add wave -noupdate -childformat {{/system_tb/DUT/CPU/DP/idex.rs -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {/system_tb/DUT/CPU/DP/idex.rt -radix unsigned}} -subitemconfig {/system_tb/DUT/CPU/DP/idex.rs {-height 17 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {/system_tb/DUT/CPU/DP/idex.rs[4]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[3]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[2]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[1]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[0]} {-radix unsigned} /system_tb/DUT/CPU/DP/idex.rt {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/idex
add wave -noupdate /system_tb/DUT/CPU/DP/exmem
add wave -noupdate /system_tb/DUT/CPU/DP/memwb
add wave -noupdate /system_tb/DUT/CPU/DP/RFU/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {340000 ps} 0}
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
WaveRestoreZoom {3140 ps} {676860 ps}
