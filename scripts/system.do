onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/DUT/CPU/DP/exmem.aluout
add wave -noupdate /system_tb/DUT/CPU/DP/idex.funct
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
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/idex_DataRead
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/idex_rt
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/ifid_rs
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/ifid_rt
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/dpif_ihit
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/dpif_dhit
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/idex_Halt
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/npipe_stall
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/ifid_FLUSH
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/idex_FLUSH
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/exmem_FLUSH
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/memwb_FLUSH
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/flushes
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/exmem_datarequest
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/no_stall
add wave -noupdate -expand -group huif /system_tb/DUT/CPU/DP/HUZ/huif/curr_pipe_stall
add wave -noupdate -expand -group pcif /system_tb/DUT/CPU/DP/pcif/pc_plus
add wave -noupdate -expand -group pcif /system_tb/DUT/CPU/DP/pcif/npc
add wave -noupdate -expand -group pcif /system_tb/DUT/CPU/DP/pcif/cpc
add wave -noupdate -expand -group pcif /system_tb/DUT/CPU/DP/pcif/npc_change
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate /system_tb/DUT/CPU/DP/ifid
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/load
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/opcode
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/funct
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/rs
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/rd
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/rt
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/addr
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/imm
add wave -noupdate -group ifid_instruction /system_tb/DUT/CPU/DP/instruction/shamt
add wave -noupdate -expand -group forwards /system_tb/DUT/CPU/DP/forward_a
add wave -noupdate -expand -group forwards /system_tb/DUT/CPU/DP/forward_b
add wave -noupdate -expand -group forwards /system_tb/DUT/CPU/DP/forward_a_data
add wave -noupdate -expand -group forwards /system_tb/DUT/CPU/DP/forward_b_data
add wave -noupdate -childformat {{/system_tb/DUT/CPU/DP/idex.rs -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {/system_tb/DUT/CPU/DP/idex.rt -radix unsigned}} -subitemconfig {/system_tb/DUT/CPU/DP/idex.rs {-height 17 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {/system_tb/DUT/CPU/DP/idex.rs[4]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[3]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[2]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[1]} {-radix unsigned} {/system_tb/DUT/CPU/DP/idex.rs[0]} {-radix unsigned} /system_tb/DUT/CPU/DP/idex.rt {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/idex
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/aluop
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/port_b
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/out
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/negative
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/overflow
add wave -noupdate -group alu /system_tb/DUT/CPU/DP/aluif/zero
add wave -noupdate /system_tb/DUT/CPU/DP/exmem
add wave -noupdate -childformat {{/system_tb/DUT/CPU/DP/memwb.wsel -radix unsigned}} -subitemconfig {/system_tb/DUT/CPU/DP/memwb.wsel {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/memwb
add wave -noupdate /system_tb/DUT/CPU/DP/RFU/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {278017 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 98
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
WaveRestoreZoom {77645 ps} {420285 ps}
