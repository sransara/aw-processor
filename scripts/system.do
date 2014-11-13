onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -expand -group ccif -label ramq /system_tb/DUT/RAM/q
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CC/state
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CC/nstate
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -expand -group ccif -expand /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -expand -group ccif -expand /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/CPUS
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/shamzeroes
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/pc_npc_branch
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/pc_npc_addr
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/nRST
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/memwb_wdat
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/memwb_n
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/memwb
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/jtype
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/immwzeroes
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/ifid_n
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/ifid
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/idex_wsel
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/idex_n
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/idex
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/forward_b_data
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/forward_a_data
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/exmem_wdat
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/exmem_n
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/exmem
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/equals
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/PC_INIT
add wave -noupdate -group dp0 /system_tb/DUT/CPU/DP0/CLK
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/shamzeroes
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/pc_npc_branch
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/pc_npc_addr
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/nRST
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/memwb_wdat
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/memwb_n
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/memwb
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/jtype
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/immwzeroes
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/ifid_n
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/ifid
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/idex_wsel
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/idex_n
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/idex
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/forward_b_data
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/forward_a_data
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/exmem_wdat
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/exmem_n
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/exmem
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/equals
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/PC_INIT
add wave -noupdate -expand -group dp1 /system_tb/DUT/CPU/DP1/CLK
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/state
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/set_values
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/set_tags
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/n_state
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/n_frame_value
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/n_frame_tag
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/nRST
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/imemload
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/i
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/frame_value
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/frame_tag
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/cache_hit
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/address
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/WEN
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/NSETS
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/CPUID
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/CLK
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/state
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/set_values
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/set_tags
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/n_state
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/n_frame_value
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/n_frame_tag
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/nRST
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/imemload
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/i
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/frame_value
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/frame_tag
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/cache_hit
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/address
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/WEN
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/NSETS
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/CPUID
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/CLK
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/way_select
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/way_count
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/w_way_select
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/w_frame_value
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/w_frame_tag
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/w_dirty_frame
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/value_WEN
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/tag_WEN
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/set_values
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/set_value
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/set_tags
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/set_tag
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/set_count
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_way_count
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_state
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_set_count
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_lru
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_frame_value
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_frame_tag
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nRST
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/lrus
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/j
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/i
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/frame_value
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/frame_tag
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/flush_wait
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/cache_hit
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/address
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/NWORDS
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/NWAYS
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/NSETS
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/CPUID
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/CLK
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/way_select
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/way_count
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/w_way_select
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/w_frame_value
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/w_frame_tag
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/w_dirty_frame
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/value_WEN
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/tag_WEN
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/set_values
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/set_value
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/set_tags
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/set_tag
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/set_count
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_way_count
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_state
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_set_count
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_lru
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_frame_value
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_frame_tag
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nRST
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/lrus
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/j
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/i
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/frame_value
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/frame_tag
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/flush_wait
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/cache_hit
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/address
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/NWORDS
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/NWAYS
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/NSETS
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/CPUID
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/CLK
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/CLK
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/nRST
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/pipe_stall
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/ifid_FLUSH
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/idex_FLUSH
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/ifid_n
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/idex_n
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/exmem_n
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/memwb_n
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/ifid
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/idex
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/exmem
add wave -noupdate -group pipe0 /system_tb/DUT/CPU/DP0/PIPER/memwb
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/CLK
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/nRST
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/pipe_stall
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/ifid_FLUSH
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/idex_FLUSH
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/ifid_n
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/idex_n
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/exmem_n
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/memwb_n
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/ifid
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/idex
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/exmem
add wave -noupdate -group pipe1 /system_tb/DUT/CPU/DP1/PIPER/memwb
add wave -noupdate -label rf0 /system_tb/DUT/CPU/DP0/RFU/register
add wave -noupdate -label rf1 /system_tb/DUT/CPU/DP1/RFU/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {700000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
configure wave -valuecolwidth 227
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
WaveRestoreZoom {463909 ps} {936091 ps}
bookmark add wave bookmark0 {{20067259 ps} {20218167 ps}} 0
