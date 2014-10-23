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
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/pipe_stall
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/nRST
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/memwb_n
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/memwb
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/ifid_n
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/ifid_FLUSH
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/ifid
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/idex_n
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/idex_FLUSH
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/idex
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/exmem_n
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/exmem
add wave -noupdate -group piper /system_tb/DUT/CPU/DP/PIPER/CLK
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
add wave -noupdate -expand -group pcif /system_tb/DUT/CPU/DP/pcif/pc_plus
add wave -noupdate -expand -group pcif /system_tb/DUT/CPU/DP/pcif/npc
add wave -noupdate -expand -group pcif /system_tb/DUT/CPU/DP/pcif/cpc
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
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/state
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/n_state
add wave -noupdate -expand -group icache -expand /system_tb/DUT/CPU/CM/ICACHE/frame_tag
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/n_frame_tag
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/frame_value
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/n_frame_value
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/address
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/WEN
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/CM/ICACHE/cache_hit
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/state
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/n_state
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/lru
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/frame_tag
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/n_frame_tag
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/frame_value
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/n_frame_value
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/address
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/tag_WEN
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/WEN
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/dirty
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/waysel
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/new_way
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/pikachu
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/n_lru
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/i
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM/DCACHE/j
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/halt
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/ihit
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/imemREN
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/imemload
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/imemaddr
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/dhit
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/datomic
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/dmemREN
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/dmemWEN
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/flushed
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/dmemload
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/dmemstore
add wave -noupdate -expand -group dcif /system_tb/DUT/CPU/CM/dcif/dmemaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/iwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/dwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/iREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/dREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/dWEN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/iload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/dload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/dstore
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/iaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/daddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ccwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ccinv
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ccwrite
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/cctrans
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ccsnoopaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ramWEN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ramREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ramstate
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ramaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ramstore
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CM/ccif/ramload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13993 ps} 0}
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
WaveRestoreZoom {0 ps} {834932 ps}
