onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /caches_tb/PROG/nRST
add wave -noupdate /caches_tb/PROG/CLK
add wave -noupdate /caches_tb/CPUCLK
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/iwait
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/dwait
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/iREN
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/dREN
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/dWEN
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/iload
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/dload
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/dstore
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/iaddr
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/daddr
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ccwait
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ccinv
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ccwrite
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/cctrans
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ccsnoopaddr
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ramWEN
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ramREN
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ramstate
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ramaddr
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ramstore
add wave -noupdate -expand -group ccif /caches_tb/CC/ccif/ramload
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/halt
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/ihit
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/imemREN
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/imemload
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/imemaddr
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/dhit
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/datomic
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/dmemREN
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/dmemWEN
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/flushed
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/dmemload
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/dmemstore
add wave -noupdate -expand -group dcif /caches_tb/CC/dcif/dmemaddr
add wave -noupdate -group icache /caches_tb/CC/ICACHE/state
add wave -noupdate -group icache /caches_tb/CC/ICACHE/n_state
add wave -noupdate -group icache /caches_tb/CC/ICACHE/frame_tag
add wave -noupdate -group icache /caches_tb/CC/ICACHE/n_frame_tag
add wave -noupdate -group icache /caches_tb/CC/ICACHE/frame_value
add wave -noupdate -group icache /caches_tb/CC/ICACHE/n_frame_value
add wave -noupdate -group icache /caches_tb/CC/ICACHE/address
add wave -noupdate -group icache /caches_tb/CC/ICACHE/WEN
add wave -noupdate -group icache /caches_tb/CC/ICACHE/cache_hit
add wave -noupdate -group icache /caches_tb/CC/ICACHE/i
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/state
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/n_state
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/set_tag
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/frame_tag
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/n_frame_tag
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/wframe_tag
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/set_value
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/frame_value
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/n_frame_value
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/wframe_value
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/n_lru
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/WEN
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/cache_hit
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/way_select
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/way_wselect
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/dirty_wframe
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/address
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/i
add wave -noupdate -expand -group dcache /caches_tb/CC/DCACHE/j
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38138 ps} 0}
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
WaveRestoreZoom {0 ps} {120 ns}
