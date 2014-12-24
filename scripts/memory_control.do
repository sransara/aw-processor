onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/nRST
add wave -noupdate /memory_control_tb/ccif/iwait
add wave -noupdate /memory_control_tb/ccif/dwait
add wave -noupdate /memory_control_tb/ccif/iREN
add wave -noupdate /memory_control_tb/ccif/dREN
add wave -noupdate /memory_control_tb/ccif/dWEN
add wave -noupdate /memory_control_tb/ccif/iload
add wave -noupdate /memory_control_tb/ccif/dload
add wave -noupdate /memory_control_tb/ccif/dstore
add wave -noupdate /memory_control_tb/ccif/iaddr
add wave -noupdate /memory_control_tb/ccif/daddr
add wave -noupdate /memory_control_tb/ccif/ramWEN
add wave -noupdate /memory_control_tb/ccif/ramREN
add wave -noupdate /memory_control_tb/ccif/ramstate
add wave -noupdate /memory_control_tb/ccif/ramaddr
add wave -noupdate /memory_control_tb/ccif/ramstore
add wave -noupdate /memory_control_tb/ccif/ramload
add wave -noupdate /memory_control_tb/CC/ccif/ramstore
add wave -noupdate /memory_control_tb/CC/ccif/ramstate
add wave -noupdate /memory_control_tb/CC/ccif/ramload
add wave -noupdate /memory_control_tb/CC/ccif/ramaddr
add wave -noupdate /memory_control_tb/CC/ccif/ramWEN
add wave -noupdate /memory_control_tb/CC/ccif/ramREN
add wave -noupdate /memory_control_tb/CC/ccif/iwait
add wave -noupdate /memory_control_tb/CC/ccif/iload
add wave -noupdate /memory_control_tb/CC/ccif/iaddr
add wave -noupdate /memory_control_tb/CC/ccif/iREN
add wave -noupdate /memory_control_tb/CC/ccif/dwait
add wave -noupdate /memory_control_tb/CC/ccif/dstore
add wave -noupdate /memory_control_tb/CC/ccif/dload
add wave -noupdate /memory_control_tb/CC/ccif/daddr
add wave -noupdate /memory_control_tb/CC/ccif/dWEN
add wave -noupdate /memory_control_tb/CC/ccif/dREN
add wave -noupdate /memory_control_tb/CC/ccif/ccwrite
add wave -noupdate /memory_control_tb/CC/ccif/ccwait
add wave -noupdate -expand /memory_control_tb/CC/ccif/cctrans
add wave -noupdate /memory_control_tb/CC/ccif/ccsnoopaddr
add wave -noupdate -expand /memory_control_tb/CC/ccif/ccinv
add wave -noupdate /memory_control_tb/CC/state
add wave -noupdate /memory_control_tb/CC/nstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2118300 ps} 0}
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
WaveRestoreZoom {0 ps} {12028386 ps}
bookmark add wave bookmark0 {{20067259 ps} {20218167 ps}} 0
